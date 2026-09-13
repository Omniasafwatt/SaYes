/// One parsed page of a list endpoint response, tolerant of the couple of
/// shapes a Nest API tends to return: `{items|data: [...], meta: {page,
/// totalPages, ...}}`, or a bare JSON array for endpoints that were never
/// paginated to begin with (in which case there's simply no next page).
class ParsedPage {
  const ParsedPage({required this.items, required this.hasMore});

  final List<dynamic> items;
  final bool hasMore;
}

ParsedPage parsePage(dynamic data, {required int requestedPage}) {
  if (data is Map) {
    final items = (data['items'] ?? data['data'] ?? const []) as List;
    final meta = data['meta'] as Map<String, dynamic>?;
    final page = (meta?['page'] as num?)?.toInt() ?? requestedPage;
    final totalPages = (meta?['totalPages'] as num?)?.toInt();
    final total = (meta?['total'] as num?)?.toInt();
    final hasMore = totalPages != null
        ? page < totalPages
        : total != null
            ? (page * items.length) < total && items.isNotEmpty
            : false;
    return ParsedPage(items: items, hasMore: hasMore);
  }
  if (data is List) {
    return ParsedPage(items: data, hasMore: false);
  }
  return const ParsedPage(items: [], hasMore: false);
}
