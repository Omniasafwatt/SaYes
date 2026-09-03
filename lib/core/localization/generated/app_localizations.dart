import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SayYes'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'The Luxury Wedding Planner'**
  String get appTagline;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Crafting unforgettable Egyptian celebrations, beautifully planned.'**
  String get splashSubtitle;

  /// No description provided for @splashCities.
  ///
  /// In en, this message translates to:
  /// **'Cairo · Alexandria · El Gouna'**
  String get splashCities;

  /// No description provided for @showcaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Design System'**
  String get showcaseTitle;

  /// No description provided for @showcaseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every foundation piece for the premium SayYes experience.'**
  String get showcaseSubtitle;

  /// No description provided for @sectionColors.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get sectionColors;

  /// No description provided for @sectionTypography.
  ///
  /// In en, this message translates to:
  /// **'Typography'**
  String get sectionTypography;

  /// No description provided for @sectionButtons.
  ///
  /// In en, this message translates to:
  /// **'Buttons'**
  String get sectionButtons;

  /// No description provided for @sectionInputs.
  ///
  /// In en, this message translates to:
  /// **'Text Fields'**
  String get sectionInputs;

  /// No description provided for @sectionChips.
  ///
  /// In en, this message translates to:
  /// **'Category Chips'**
  String get sectionChips;

  /// No description provided for @sectionCards.
  ///
  /// In en, this message translates to:
  /// **'Vendor Cards'**
  String get sectionCards;

  /// No description provided for @sectionBadges.
  ///
  /// In en, this message translates to:
  /// **'Badges & Status'**
  String get sectionBadges;

  /// No description provided for @sectionRating.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get sectionRating;

  /// No description provided for @sectionStates.
  ///
  /// In en, this message translates to:
  /// **'Empty / Error / Success'**
  String get sectionStates;

  /// No description provided for @sectionLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading & Skeletons'**
  String get sectionLoading;

  /// No description provided for @primaryButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Request Booking'**
  String get primaryButtonLabel;

  /// No description provided for @secondaryButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'View Portfolio'**
  String get secondaryButtonLabel;

  /// No description provided for @textButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get textButtonLabel;

  /// No description provided for @loadingButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get loadingButtonLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @categoryPhotography.
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get categoryPhotography;

  /// No description provided for @categoryMakeup.
  ///
  /// In en, this message translates to:
  /// **'Makeup Artist'**
  String get categoryMakeup;

  /// No description provided for @categoryHalls.
  ///
  /// In en, this message translates to:
  /// **'Wedding Halls'**
  String get categoryHalls;

  /// No description provided for @categoryPlanning.
  ///
  /// In en, this message translates to:
  /// **'Wedding Planners'**
  String get categoryPlanning;

  /// No description provided for @vendorSampleName.
  ///
  /// In en, this message translates to:
  /// **'Nour Al Sham Wedding Hall'**
  String get vendorSampleName;

  /// No description provided for @vendorSampleCity.
  ///
  /// In en, this message translates to:
  /// **'Zamalek, Cairo'**
  String get vendorSampleCity;

  /// No description provided for @vendorSamplePrice.
  ///
  /// In en, this message translates to:
  /// **'From EGP 45,000'**
  String get vendorSamplePrice;

  /// No description provided for @vendorSampleReviews.
  ///
  /// In en, this message translates to:
  /// **'(120)'**
  String get vendorSampleReviews;

  /// No description provided for @verifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verifiedLabel;

  /// No description provided for @featuredLabel.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featuredLabel;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get statusAccepted;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @ratingReviewsLabel.
  ///
  /// In en, this message translates to:
  /// **'120 reviews'**
  String get ratingReviewsLabel;

  /// No description provided for @emptyFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your favorite vendors\nwill appear here.'**
  String get emptyFavoritesTitle;

  /// No description provided for @emptyFavoritesMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on any vendor to save them for later.'**
  String get emptyFavoritesMessage;

  /// No description provided for @emptyFavoritesAction.
  ///
  /// In en, this message translates to:
  /// **'Start exploring'**
  String get emptyFavoritesAction;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load this right now. Please try again.'**
  String get errorMessage;

  /// No description provided for @errorAction.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get errorAction;

  /// No description provided for @successTitle.
  ///
  /// In en, this message translates to:
  /// **'Your request has been sent!'**
  String get successTitle;

  /// No description provided for @successMessage.
  ///
  /// In en, this message translates to:
  /// **'The vendor has received your booking request. We\'ll keep you updated.'**
  String get successMessage;

  /// No description provided for @successAction.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get successAction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
