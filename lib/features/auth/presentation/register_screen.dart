import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/animations/app_motion.dart';
import '../../../core/animations/pressable_scale.dart';
import '../../../core/localization/generated/app_localizations.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../application/auth_controller.dart';
import '../data/auth_models.dart';
import 'widgets/auth_hero_scaffold.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  UserRole _role = UserRole.customer;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = await ref.read(authControllerProvider.notifier).register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          role: _role,
        );
    if (!mounted) return;
    if (success) {
      context.go(AppRoutes.showcase);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.authRegisterError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final loading = ref.watch(authControllerProvider).isLoading;
    final t = context.typography;

    return AuthHeroScaffold(
      imagePath: 'assets/images/rings_bouquet_avatar.png',
      title: l10n.authRegisterTitle,
      subtitle: l10n.authRegisterSubtitle,
      showBack: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _RoleCard(
              selected: _role == UserRole.customer,
              icon: Icons.favorite_rounded,
              title: l10n.authRoleCustomerTitle,
              subtitle: l10n.authRoleCustomerSubtitle,
              tags: [l10n.authRoleCustomerTag1, l10n.authRoleCustomerTag2, l10n.authRoleCustomerTag3],
              onTap: () => setState(() => _role = UserRole.customer),
            ),
            const SizedBox(height: AppSpacing.md),
            _RoleCard(
              selected: _role == UserRole.vendor,
              icon: Icons.storefront_rounded,
              title: l10n.authRoleVendorTitle,
              subtitle: l10n.authRoleVendorSubtitle,
              tags: [l10n.authRoleVendorTag1, l10n.authRoleVendorTag2, l10n.authRoleVendorTag3],
              onTap: () => setState(() => _role = UserRole.vendor),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppTextField(
              label: l10n.authNameLabel,
              hint: l10n.authNameHint,
              controller: _nameController,
              prefixIcon: Icons.person_outline_rounded,
              validator: Validators.name(l10n),
            ),
            const SizedBox(height: AppSpacing.lg),
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
            AppButton(label: l10n.authCreateAccountButton, loading: loading, onPressed: () => _submit(l10n)),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.authTermsNotice, textAlign: TextAlign.center, style: t.caption),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.authHaveAccount, style: t.bodyMd),
                TextButton(onPressed: () => context.pop(), child: Text(l10n.authSignIn)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> tags;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.typography;
    return PressableScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.medium,
        padding: const EdgeInsets.all(AppSpacing.cardPaddingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.xlRadius,
          border: Border.all(color: selected ? AppColors.primary : AppColors.outlineRose, width: selected ? 2 : 1),
          boxShadow: selected ? AppShadows.glow : AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: AppColors.surfaceBlush, borderRadius: AppRadius.lgRadius),
                  child: Icon(icon, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Text(title, style: t.titleMd)),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.primary : Colors.transparent,
                    border: Border.all(color: selected ? Colors.transparent : AppColors.outlineNeutral),
                  ),
                  child: selected ? const Icon(Icons.check_rounded, size: 16, color: Colors.white) : null,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(subtitle, style: t.bodyMd),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [for (final tag in tags) _Tag(label: tag)],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceBlush,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: AppColors.outlineNeutral),
      ),
      child: Text(label, style: context.typography.metadata),
    );
  }
}
