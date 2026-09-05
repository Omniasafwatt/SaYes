import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/animations/entrance.dart';
import '../../core/animations/floating_petals.dart';
import '../../core/animations/success_check.dart';
import '../../core/localization/generated/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/widgets.dart';

enum _StatePreview { empty, error, success }

/// Phase 1 deliverable: a single screen exercising every design-system
/// primitive so the whole foundation can be checked visually — in both
/// languages — before any real feature screen gets built on top of it.
/// Doubles as the placeholder "signed-in" destination until Home (Phase 5)
/// exists, hence the dev-only Log Out affordance in its header.
class DesignSystemShowcaseScreen extends ConsumerStatefulWidget {
  const DesignSystemShowcaseScreen({super.key});

  @override
  ConsumerState<DesignSystemShowcaseScreen> createState() => _DesignSystemShowcaseScreenState();
}

class _DesignSystemShowcaseScreenState extends ConsumerState<DesignSystemShowcaseScreen> {
  int _selectedChip = 0;
  bool _buttonLoading = false;
  final Set<int> _favorites = {1};
  _StatePreview _statePreview = _StatePreview.empty;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final t = context.typography;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.ivory, AppColors.ivoryEnd],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.sectionGap * 2),
            children: [
              _buildHeader(context, l10n, t),
              const SizedBox(height: AppSpacing.sectionGap),
              ..._section(title: l10n.sectionColors, child: _buildColors(), delay: 0),
              ..._section(title: l10n.sectionTypography, child: _buildTypography(t), delay: 60),
              ..._section(title: l10n.sectionButtons, child: _buildButtons(l10n), delay: 120),
              ..._section(title: l10n.sectionInputs, child: _buildInputs(l10n), delay: 180),
              ..._section(title: l10n.sectionChips, child: _buildChips(l10n), delay: 240),
              ..._section(title: l10n.sectionCards, child: _buildVendorCards(l10n), delay: 300, edgeToEdge: true),
              ..._section(title: l10n.sectionBadges, child: _buildBadgesAndRating(l10n), delay: 360),
              ..._section(title: l10n.sectionLoading, child: _buildLoading(l10n), delay: 420),
              ..._section(title: l10n.sectionStates, child: _buildStates(l10n), delay: 480),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, AppTypographyExtension t) {
    return Stack(
      children: [
        const Positioned.fill(child: FloatingPetals(petalCount: 6)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      await ref.read(secureStorageServiceProvider).clearSession();
                      if (context.mounted) context.go(AppRoutes.onboarding);
                    },
                    icon: const Icon(Icons.logout_rounded, size: 16),
                    label: const Text('Log out (dev)'),
                  ),
                  const LanguageSwitcher(),
                ],
              ),
              const SizedBox(height: 20),
              FadeSlideIn(
                child: Text(l10n.appName, style: t.displayLg),
              ),
              const SizedBox(height: 4),
              FadeSlideIn(
                delay: const Duration(milliseconds: 60),
                child: Text(l10n.appTagline, style: t.bodyLg.copyWith(color: AppColors.roseGold, fontStyle: FontStyle.italic)),
              ),
              const SizedBox(height: 20),
              FadeSlideIn(
                delay: const Duration(milliseconds: 120),
                child: Text(l10n.showcaseTitle, style: t.headlineLg),
              ),
              const SizedBox(height: 4),
              FadeSlideIn(
                delay: const Duration(milliseconds: 160),
                child: Text(l10n.showcaseSubtitle, style: t.bodyMd),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _section({required String title, required Widget child, required int delay, bool edgeToEdge = false}) {
    return [
      FadeSlideIn(
        delay: Duration(milliseconds: delay),
        child: SectionHeader(title: title),
      ),
      const SizedBox(height: AppSpacing.lg),
      FadeSlideIn(
        delay: Duration(milliseconds: delay + 40),
        child: Padding(
          padding: edgeToEdge ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
          child: child,
        ),
      ),
      const SizedBox(height: AppSpacing.sectionGap),
    ];
  }

  Widget _buildColors() {
    final swatches = <(String, Color)>[
      ('primary', AppColors.primary),
      ('primaryDeep', AppColors.primaryDeep),
      ('primaryLight', AppColors.primaryLight),
      ('gold', AppColors.gold),
      ('roseGold', AppColors.roseGold),
      ('champagne', AppColors.champagne),
      ('surface', AppColors.surface),
      ('textPrimary', AppColors.textPrimary),
      ('success', AppColors.success),
      ('pending', AppColors.pending),
      ('error', AppColors.error),
    ];
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        for (final (label, color) in swatches)
          Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: AppShadows.card),
              ),
              const SizedBox(height: 6),
              Text(label, style: context.typography.metadata),
            ],
          ),
      ],
    );
  }

  Widget _buildTypography(AppTypographyExtension t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Wedding Dream', style: t.displayLg),
        _tokenLabel('displayLg'),
        Text('Plan your day', style: t.headlineLg),
        _tokenLabel('headlineLg'),
        Text('Featured Vendors', style: t.titleLg),
        _tokenLabel('titleLg'),
        Text('Cairo · Alexandria · El Gouna', style: t.bodyLg),
        _tokenLabel('bodyLg'),
        Text('From EGP 45,000', style: t.price),
        _tokenLabel('price'),
        Text('120 REVIEWS', style: t.labelSm),
        _tokenLabel('labelSm'),
      ],
    );
  }

  Widget _tokenLabel(String name) => Padding(
        padding: const EdgeInsets.only(bottom: 14, top: 2),
        child: Text(name, style: context.typography.metadata),
      );

  Widget _buildButtons(AppLocalizations l10n) {
    return Column(
      children: [
        AppButton(
          label: _buttonLoading ? l10n.loadingButtonLabel : l10n.primaryButtonLabel,
          loading: _buttonLoading,
          onPressed: () async {
            setState(() => _buttonLoading = true);
            await Future.delayed(const Duration(seconds: 2));
            if (mounted) setState(() => _buttonLoading = false);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(label: l10n.secondaryButtonLabel, variant: AppButtonVariant.secondary, onPressed: () {}),
        const SizedBox(height: AppSpacing.md),
        AppButton(label: l10n.textButtonLabel, variant: AppButtonVariant.text, onPressed: () {}),
      ],
    );
  }

  Widget _buildInputs(AppLocalizations l10n) {
    return Column(
      children: [
        AppTextField(label: l10n.emailLabel, hint: l10n.emailHint, prefixIcon: Icons.mail_outline_rounded),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(label: l10n.passwordLabel, hint: l10n.passwordHint, obscureText: true, prefixIcon: Icons.lock_outline_rounded),
      ],
    );
  }

  Widget _buildChips(AppLocalizations l10n) {
    final labels = [l10n.categoryPhotography, l10n.categoryMakeup, l10n.categoryHalls, l10n.categoryPlanning];
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final (i, label) in labels.indexed)
          AppChip(label: label, selected: _selectedChip == i, onTap: () => setState(() => _selectedChip = i)),
      ],
    );
  }

  Widget _buildVendorCards(AppLocalizations l10n) {
    final images = ['wedding_hall_zamalek', 'makeup_artist_portfolio', 'bridal_dress_couture'];
    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
        itemCount: images.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, i) {
          return VendorCard(
            imageUrl: 'assets/images/${images[i]}.png',
            isAssetImage: true,
            name: l10n.vendorSampleName,
            city: l10n.vendorSampleCity,
            rating: 4.9,
            reviewCountLabel: l10n.vendorSampleReviews,
            startingPriceLabel: l10n.vendorSamplePrice,
            isVerified: i == 0,
            verifiedLabel: l10n.verifiedLabel,
            isFeatured: i == 1,
            featuredLabel: l10n.featuredLabel,
            isFavorite: _favorites.contains(i),
            onFavoriteToggle: () => setState(() {
              _favorites.contains(i) ? _favorites.remove(i) : _favorites.add(i);
            }),
            onTap: () {},
          );
        },
      ),
    );
  }

  Widget _buildBadgesAndRating(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            VerifiedBadge(label: l10n.verifiedLabel),
            FeaturedBadge(label: l10n.featuredLabel),
            BookingStatusBadge(status: BookingStatus.pending, label: l10n.statusPending),
            BookingStatusBadge(status: BookingStatus.accepted, label: l10n.statusAccepted),
            BookingStatusBadge(status: BookingStatus.rejected, label: l10n.statusRejected),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        RatingSummary(rating: 4.9, reviewsLabel: l10n.ratingReviewsLabel),
      ],
    );
  }

  Widget _buildLoading(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppLoadingIndicator(),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: const [
            SkeletonVendorCard(width: 160),
            SizedBox(width: AppSpacing.md),
            SkeletonVendorCard(width: 160),
          ],
        ),
      ],
    );
  }

  Widget _buildStates(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            AppChip(label: 'Empty', selected: _statePreview == _StatePreview.empty, onTap: () => setState(() => _statePreview = _StatePreview.empty)),
            AppChip(label: 'Error', selected: _statePreview == _StatePreview.error, onTap: () => setState(() => _statePreview = _StatePreview.error)),
            AppChip(label: 'Success', selected: _statePreview == _StatePreview.success, onTap: () => setState(() => _statePreview = _StatePreview.success)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sectionGap),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.xlRadius,
            boxShadow: AppShadows.card,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: KeyedSubtree(
              key: ValueKey(_statePreview),
              child: switch (_statePreview) {
                _StatePreview.empty => AppStateView(
                    icon: Icons.favorite_border_rounded,
                    title: l10n.emptyFavoritesTitle,
                    message: l10n.emptyFavoritesMessage,
                    actionLabel: l10n.emptyFavoritesAction,
                    onAction: () {},
                  ),
                _StatePreview.error => AppStateView(
                    icon: Icons.wifi_off_rounded,
                    title: l10n.errorTitle,
                    message: l10n.errorMessage,
                    actionLabel: l10n.errorAction,
                    iconColor: AppColors.error,
                    iconBackground: AppColors.errorContainer,
                    onAction: () {},
                  ),
                _StatePreview.success => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SuccessCheck(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            Text(l10n.successTitle, style: context.typography.headlineSm, textAlign: TextAlign.center),
                            const SizedBox(height: 8),
                            Text(l10n.successMessage, style: context.typography.bodyMd, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ],
                  ),
              },
            ),
          ),
        ),
      ],
    );
  }
}
