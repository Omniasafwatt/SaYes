import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage_service.dart';
import 'api_exception.dart';

const _kApiBaseUrl = 'https://e-commerse-app-0wox.onrender.com/api';

/// Thin wrapper around one configured [Dio] instance — every repository
/// talks to the backend through this, never through `Dio`/`http` directly.
/// Handles: attaching the bearer token, unwrapping the backend's
/// `{success, data}` envelope, mapping failures to [ApiException], and
/// transparently refreshing an expired access token once before giving up.
///
/// Render's free tier spins the server down when idle, so the very first
/// request after a while can take 30-60s to get a cold-start response —
/// callers should show their normal loading state, not assume something's
/// broken if a first call is slow.
class ApiClient {
  ApiClient(this._secureStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: _kApiBaseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.readAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final isRefreshCall = error.requestOptions.path == '/auth/refresh';
          if (error.response?.statusCode == 401 && !isRefreshCall && !_hasRetried(error.requestOptions)) {
            final refreshed = await _refreshAccessToken();
            if (refreshed) {
              try {
                final retried = await _dio.fetch(_markRetried(error.requestOptions));
                return handler.resolve(retried);
              } on DioException catch (retryError) {
                return handler.next(retryError);
              }
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  final SecureStorageService _secureStorage;
  late final Dio _dio;
  Future<bool>? _refreshInFlight;

  bool _hasRetried(RequestOptions options) => options.extra['sayyes_retried'] == true;
  RequestOptions _markRetried(RequestOptions options) => options..extra['sayyes_retried'] = true;

  /// Only one refresh call in flight at a time — concurrent 401s from
  /// several parallel requests all await the same attempt.
  Future<bool> _refreshAccessToken() {
    return _refreshInFlight ??= _doRefresh().whenComplete(() => _refreshInFlight = null);
  }

  Future<bool> _doRefresh() async {
    final refreshToken = await _secureStorage.readRefreshToken();
    if (refreshToken == null) return false;
    try {
      final response = await Dio(BaseOptions(baseUrl: _kApiBaseUrl)).post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      final accessToken = data?['accessToken'] as String?;
      final newRefreshToken = data?['refreshToken'] as String?;
      if (accessToken == null) return false;
      await _secureStorage.saveSession(accessToken: accessToken, refreshToken: newRefreshToken ?? refreshToken);
      return true;
    } catch (_) {
      await _secureStorage.clearSession();
      return false;
    }
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) {
    return _unwrap(_dio.get<dynamic>(path, queryParameters: query));
  }

  Future<dynamic> post(String path, {dynamic data}) {
    return _unwrap(_dio.post<dynamic>(path, data: data));
  }

  Future<dynamic> patch(String path, {dynamic data}) {
    return _unwrap(_dio.patch<dynamic>(path, data: data));
  }

  Future<dynamic> delete(String path) {
    return _unwrap(_dio.delete<dynamic>(path));
  }

  Future<dynamic> postMultipart(String path, FormData data) {
    return _unwrap(_dio.post<dynamic>(path, data: data));
  }

  Future<dynamic> _unwrap(Future<Response<dynamic>> future) async {
    try {
      final response = await future;
      final body = response.data;
      if (body is Map && body.containsKey('data')) return body['data'];
      return body;
    } on DioException catch (error) {
      throw _mapError(error);
    }
  }

  ApiException _mapError(DioException error) {
    final data = error.response?.data;
    final statusCode = error.response?.statusCode;
    if (data is Map) {
      final message = data['message'];
      if (message is String) return ApiException(message, statusCode: statusCode);
      if (message is List && message.isNotEmpty) {
        return ApiException(message.first.toString(), statusCode: statusCode);
      }
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException('The server is taking a while to respond. Please try again.');
      case DioExceptionType.connectionError:
        return const ApiException('No internet connection. Please check your network and try again.');
      default:
        return ApiException('Something went wrong. Please try again.', statusCode: statusCode);
    }
  }
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient(ref.watch(secureStorageServiceProvider)));
