import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_hero_scaffold.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _sent = false;
  String? _devToken;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final result = await ref.read(authControllerProvider.notifier).sendPasswordReset(email: _emailController.text.trim());
    if (!mounted) return;
    if (result != null) {
      setState(() {
        _sent = true;
        _devToken = result.isEmpty ? null : result;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.authForgotError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final loading = ref.watch(authControllerProvider).isLoading;

    return AuthFormScaffold(
      title: l10n.authForgotTitle,
      subtitle: l10n.authForgotSubtitle,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _sent
            ? Column(
                key: const ValueKey('sent'),
                children: [
                  AppStateView(
                    icon: Icons.mark_email_read_outlined,
                    title: l10n.authForgotSuccessTitle,
                    message: l10n.authForgotSuccessMessage(_emailController.text.trim()),
                    actionLabel: l10n.authEnterCodeButton,
                    onAction: () => context.push(AppRoutes.resetPassword, extra: _emailController.text.trim()),
                  ),
                  if (_devToken != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceBlush,
                        borderRadius: AppRadius.lgRadius,
                        border: Border.all(color: AppColors.outlineRose),
                      ),
                      child: Column(
                        children: [
                          Text(
                            l10n.authForgotDevTokenNotice,
                            textAlign: TextAlign.center,
                            style: context.typography.caption,
                          ),
                          const SizedBox(height: 6),
                          SelectableText(
                            _devToken!,
                            textAlign: TextAlign.center,
                            style: context.typography.titleLg.copyWith(color: AppColors.primary, letterSpacing: 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  TextButton(onPressed: () => context.pop(), child: Text(l10n.authBackToLogin)),
                ],
              )
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: l10n.emailLabel,
                      hint: l10n.emailHint,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.mail_outline_rounded,
                      validator: Validators.email(l10n),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppButton(label: l10n.authSendCodeButton, loading: loading, onPressed: () => _submit(l10n)),
                  ],
                ),
              ),
      ),
    );
  }
}
