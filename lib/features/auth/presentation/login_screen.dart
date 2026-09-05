import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_hero_scaffold.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = await ref.read(authControllerProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (!mounted) return;
    if (success) {
      context.go(AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.authLoginError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final loading = ref.watch(authControllerProvider).isLoading;

    return AuthHeroScaffold(
      imagePath: 'assets/images/bride_editorial_portrait.png',
      title: l10n.authLoginTitle,
      subtitle: l10n.authLoginSubtitle,
      child: Form(
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
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.passwordLabel,
              hint: l10n.passwordHint,
              controller: _passwordController,
              obscureText: true,
              prefixIcon: Icons.lock_outline_rounded,
              validator: Validators.password(l10n),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => context.push(AppRoutes.forgotPassword),
                child: Text(l10n.authForgotPassword),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(label: l10n.authSignInButton, loading: loading, onPressed: () => _submit(l10n)),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.authNoAccount, style: context.typography.bodyMd),
                TextButton(
                  onPressed: () => context.push(AppRoutes.register),
                  child: Text(l10n.authCreateAccount),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
