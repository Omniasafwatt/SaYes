import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_hero_scaffold.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _done = false;

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = await ref.read(authControllerProvider.notifier).resetPassword(
          email: widget.email,
          code: _codeController.text.trim(),
          newPassword: _passwordController.text,
        );
    if (!mounted) return;
    if (success) {
      setState(() => _done = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.authResetError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final loading = ref.watch(authControllerProvider).isLoading;

    return AuthFormScaffold(
      title: l10n.authResetTitle,
      subtitle: l10n.authResetSubtitle,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _done
            ? Column(
                key: const ValueKey('done'),
                children: [
                  AppStateView(
                    icon: Icons.check_circle_outline_rounded,
                    iconColor: AppColors.success,
                    iconBackground: AppColors.successContainer,
                    title: l10n.authResetSuccessTitle,
                    message: l10n.authResetSuccessMessage,
                    actionLabel: l10n.authResetSuccessButton,
                    onAction: () => context.go(AppRoutes.login),
                  ),
                ],
              )
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: l10n.authCodeLabel,
                      hint: l10n.authCodeHint,
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.pin_outlined,
                      validator: Validators.code(l10n),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: l10n.authNewPasswordLabel,
                      hint: l10n.authNewPasswordHint,
                      controller: _passwordController,
                      obscureText: true,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: Validators.password(l10n),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: l10n.authConfirmPasswordLabel,
                      hint: l10n.authConfirmPasswordHint,
                      controller: _confirmController,
                      obscureText: true,
                      prefixIcon: Icons.lock_outline_rounded,
                      validator: Validators.confirmPassword(l10n, () => _passwordController.text),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppButton(label: l10n.authResetButton, loading: loading, onPressed: () => _submit(l10n)),
                  ],
                ),
              ),
      ),
    );
  }
}
