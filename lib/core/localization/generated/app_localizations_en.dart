// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SayYes';

  @override
  String get appTagline => 'The Luxury Wedding Planner';

  @override
  String get showcaseTitle => 'Design System';

  @override
  String get showcaseSubtitle =>
      'Every foundation piece for the premium SayYes experience.';

  @override
  String get sectionColors => 'Colors';

  @override
  String get sectionTypography => 'Typography';

  @override
  String get sectionButtons => 'Buttons';

  @override
  String get sectionInputs => 'Text Fields';

  @override
  String get sectionChips => 'Category Chips';

  @override
  String get sectionCards => 'Vendor Cards';

  @override
  String get sectionBadges => 'Badges & Status';

  @override
  String get sectionRating => 'Ratings';

  @override
  String get sectionStates => 'Empty / Error / Success';

  @override
  String get sectionLoading => 'Loading & Skeletons';

  @override
  String get primaryButtonLabel => 'Request Booking';

  @override
  String get secondaryButtonLabel => 'View Portfolio';

  @override
  String get textButtonLabel => 'Skip for now';

  @override
  String get loadingButtonLabel => 'Sending';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get categoryPhotography => 'Photography';

  @override
  String get categoryMakeup => 'Makeup Artist';

  @override
  String get categoryHalls => 'Wedding Halls';

  @override
  String get categoryPlanning => 'Wedding Planners';

  @override
  String get vendorSampleName => 'Nour Al Sham Wedding Hall';

  @override
  String get vendorSampleCity => 'Zamalek, Cairo';

  @override
  String get vendorSamplePrice => 'From EGP 45,000';

  @override
  String get vendorSampleReviews => '(120)';

  @override
  String get verifiedLabel => 'Verified';

  @override
  String get featuredLabel => 'Featured';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusAccepted => 'Accepted';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get ratingReviewsLabel => '120 reviews';

  @override
  String get emptyFavoritesTitle => 'Your favorite vendors\nwill appear here.';

  @override
  String get emptyFavoritesMessage =>
      'Tap the heart on any vendor to save them for later.';

  @override
  String get emptyFavoritesAction => 'Start exploring';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorMessage =>
      'We couldn\'t load this right now. Please try again.';

  @override
  String get errorAction => 'Retry';

  @override
  String get successTitle => 'Your request has been sent!';

  @override
  String get successMessage =>
      'The vendor has received your booking request. We\'ll keep you updated.';

  @override
  String get successAction => 'Back to Home';
}
