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

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingStep.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingStep(int current, int total);

  /// No description provided for @onboarding1Headline.
  ///
  /// In en, this message translates to:
  /// **'Your dream wedding\nstarts here.'**
  String get onboarding1Headline;

  /// No description provided for @onboarding1Body.
  ///
  /// In en, this message translates to:
  /// **'Discover breathtaking venues, talented photographers, and everything you need for the celebration you\'ve always imagined.'**
  String get onboarding1Body;

  /// No description provided for @onboarding2Headline.
  ///
  /// In en, this message translates to:
  /// **'Find vendors\nyou can trust.'**
  String get onboarding2Headline;

  /// No description provided for @onboarding2Body.
  ///
  /// In en, this message translates to:
  /// **'Every vendor is verified — real reviews, transparent pricing, and portfolios you can browse before you book.'**
  String get onboarding2Body;

  /// No description provided for @onboarding3Headline.
  ///
  /// In en, this message translates to:
  /// **'Plan everything\nin one place.'**
  String get onboarding3Headline;

  /// No description provided for @onboarding3Body.
  ///
  /// In en, this message translates to:
  /// **'From discovery to booking, manage your entire wedding journey in one beautifully simple app.'**
  String get onboarding3Body;

  /// No description provided for @onboarding3Vendors.
  ///
  /// In en, this message translates to:
  /// **'Vendors'**
  String get onboarding3Vendors;

  /// No description provided for @onboarding3Bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get onboarding3Bookings;

  /// No description provided for @onboarding3Favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get onboarding3Favorites;

  /// No description provided for @onboarding3Reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get onboarding3Reviews;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue planning your dream day.'**
  String get authLoginSubtitle;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignInButton;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authNoAccount;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccount;

  /// No description provided for @authLoginError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t sign you in. Please check your details and try again.'**
  String get authLoginError;

  /// No description provided for @authRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get authRegisterTitle;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us a little about yourself to get started.'**
  String get authRegisterSubtitle;

  /// No description provided for @authRoleCustomerTitle.
  ///
  /// In en, this message translates to:
  /// **'I\'m planning my wedding'**
  String get authRoleCustomerTitle;

  /// No description provided for @authRoleCustomerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover vendors, save favorites, and book with confidence.'**
  String get authRoleCustomerSubtitle;

  /// No description provided for @authRoleCustomerTag1.
  ///
  /// In en, this message translates to:
  /// **'Browse Vendors'**
  String get authRoleCustomerTag1;

  /// No description provided for @authRoleCustomerTag2.
  ///
  /// In en, this message translates to:
  /// **'Save Favorites'**
  String get authRoleCustomerTag2;

  /// No description provided for @authRoleCustomerTag3.
  ///
  /// In en, this message translates to:
  /// **'Easy Booking'**
  String get authRoleCustomerTag3;

  /// No description provided for @authRoleVendorTitle.
  ///
  /// In en, this message translates to:
  /// **'I\'m a wedding professional'**
  String get authRoleVendorTitle;

  /// No description provided for @authRoleVendorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Showcase your work and receive booking requests from couples.'**
  String get authRoleVendorSubtitle;

  /// No description provided for @authRoleVendorTag1.
  ///
  /// In en, this message translates to:
  /// **'Showcase Portfolio'**
  String get authRoleVendorTag1;

  /// No description provided for @authRoleVendorTag2.
  ///
  /// In en, this message translates to:
  /// **'Get Bookings'**
  String get authRoleVendorTag2;

  /// No description provided for @authRoleVendorTag3.
  ///
  /// In en, this message translates to:
  /// **'Grow Your Business'**
  String get authRoleVendorTag3;

  /// No description provided for @authNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authNameLabel;

  /// No description provided for @authNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get authNameHint;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get authConfirmPasswordHint;

  /// No description provided for @authCreateAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccountButton;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authHaveAccount;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// No description provided for @authTermsNotice.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to SayYes\'s Terms of Service and Privacy Policy.'**
  String get authTermsNotice;

  /// No description provided for @authRegisterError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t create your account. Please try again.'**
  String get authRegisterError;

  /// No description provided for @authForgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get authForgotTitle;

  /// No description provided for @authForgotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a code to reset your password.'**
  String get authForgotSubtitle;

  /// No description provided for @authSendCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Code'**
  String get authSendCodeButton;

  /// No description provided for @authForgotSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get authForgotSuccessTitle;

  /// No description provided for @authForgotSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a reset code to {email}. Enter it on the next screen to choose a new password.'**
  String authForgotSuccessMessage(String email);

  /// No description provided for @authEnterCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Enter Reset Code'**
  String get authEnterCodeButton;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get authBackToLogin;

  /// No description provided for @authForgotError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t send that reset code. Please try again.'**
  String get authForgotError;

  /// No description provided for @authResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set new password'**
  String get authResetTitle;

  /// No description provided for @authResetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we sent you and choose a new password.'**
  String get authResetSubtitle;

  /// No description provided for @authCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Reset Code'**
  String get authCodeLabel;

  /// No description provided for @authCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get authCodeHint;

  /// No description provided for @authNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get authNewPasswordLabel;

  /// No description provided for @authNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a new password'**
  String get authNewPasswordHint;

  /// No description provided for @authResetButton.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetButton;

  /// No description provided for @authResetSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get authResetSuccessTitle;

  /// No description provided for @authResetSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your password has been changed. You can now sign in with your new password.'**
  String get authResetSuccessMessage;

  /// No description provided for @authResetSuccessButton.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get authResetSuccessButton;

  /// No description provided for @authResetError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t reset your password. Please try again.'**
  String get authResetError;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get validationPasswordTooShort;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get validationPasswordMismatch;

  /// No description provided for @validationNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get validationNameTooShort;

  /// No description provided for @validationCodeTooShort.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we sent you'**
  String get validationCodeTooShort;

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

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @comingSoonExploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore is on its way'**
  String get comingSoonExploreTitle;

  /// No description provided for @comingSoonExploreMessage.
  ///
  /// In en, this message translates to:
  /// **'Full category browsing and search land in the next phase.'**
  String get comingSoonExploreMessage;

  /// No description provided for @comingSoonFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites is on its way'**
  String get comingSoonFavoritesTitle;

  /// No description provided for @comingSoonFavoritesMessage.
  ///
  /// In en, this message translates to:
  /// **'Saving vendors you love lands in a later phase.'**
  String get comingSoonFavoritesMessage;

  /// No description provided for @comingSoonBookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookings is on its way'**
  String get comingSoonBookingsTitle;

  /// No description provided for @comingSoonBookingsMessage.
  ///
  /// In en, this message translates to:
  /// **'Tracking your booking requests lands in a later phase.'**
  String get comingSoonBookingsMessage;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileMoreComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Full profile management — editing your details, notifications, and settings — lands in a later phase.'**
  String get profileMoreComingSoon;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogOut;

  /// No description provided for @profileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditProfile;

  /// No description provided for @profileAccountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileAccountSection;

  /// No description provided for @profilePreferencesSection.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profilePreferencesSection;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileName;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhone;

  /// No description provided for @profilePhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Add a phone number'**
  String get profilePhoneHint;

  /// No description provided for @profileNoPhone.
  ///
  /// In en, this message translates to:
  /// **'Not added'**
  String get profileNoPhone;

  /// No description provided for @profileSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get profileSaveChanges;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profileBookingUpdates.
  ///
  /// In en, this message translates to:
  /// **'Booking updates'**
  String get profileBookingUpdates;

  /// No description provided for @profileBookingUpdatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Status changes on your requests'**
  String get profileBookingUpdatesSubtitle;

  /// No description provided for @profilePromotions.
  ///
  /// In en, this message translates to:
  /// **'Promotions & offers'**
  String get profilePromotions;

  /// No description provided for @profilePromotionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Occasional vendor deals and offers'**
  String get profilePromotionsSubtitle;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGreetingEvening;

  /// No description provided for @homeGreetingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s plan something beautiful today.'**
  String get homeGreetingSubtitle;

  /// No description provided for @homeHeroHeadline.
  ///
  /// In en, this message translates to:
  /// **'Plan the wedding\nyou\'ve always dreamed of.'**
  String get homeHeroHeadline;

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'What are you looking for?'**
  String get homeSearchHint;

  /// No description provided for @homeSectionCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get homeSectionCategories;

  /// No description provided for @homeSectionFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured Vendors'**
  String get homeSectionFeatured;

  /// No description provided for @homeSectionPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular Vendors'**
  String get homeSectionPopular;

  /// No description provided for @homeSectionCities.
  ///
  /// In en, this message translates to:
  /// **'Popular Cities'**
  String get homeSectionCities;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeCategoryPhotographers.
  ///
  /// In en, this message translates to:
  /// **'Photographers'**
  String get homeCategoryPhotographers;

  /// No description provided for @homeCategoryMakeup.
  ///
  /// In en, this message translates to:
  /// **'Makeup Artists'**
  String get homeCategoryMakeup;

  /// No description provided for @homeCategoryHalls.
  ///
  /// In en, this message translates to:
  /// **'Wedding Halls'**
  String get homeCategoryHalls;

  /// No description provided for @homeCategoryPlanners.
  ///
  /// In en, this message translates to:
  /// **'Wedding Planners'**
  String get homeCategoryPlanners;

  /// No description provided for @homeCategoryDj.
  ///
  /// In en, this message translates to:
  /// **'DJs'**
  String get homeCategoryDj;

  /// No description provided for @homeCategoryCatering.
  ///
  /// In en, this message translates to:
  /// **'Catering'**
  String get homeCategoryCatering;

  /// No description provided for @homeCategoryDecoration.
  ///
  /// In en, this message translates to:
  /// **'Decoration'**
  String get homeCategoryDecoration;

  /// No description provided for @homeCategoryCarRental.
  ///
  /// In en, this message translates to:
  /// **'Car Rental'**
  String get homeCategoryCarRental;

  /// No description provided for @cityCairo.
  ///
  /// In en, this message translates to:
  /// **'Cairo'**
  String get cityCairo;

  /// No description provided for @cityAlexandria.
  ///
  /// In en, this message translates to:
  /// **'Alexandria'**
  String get cityAlexandria;

  /// No description provided for @cityGiza.
  ///
  /// In en, this message translates to:
  /// **'Giza'**
  String get cityGiza;

  /// No description provided for @cityElGouna.
  ///
  /// In en, this message translates to:
  /// **'El Gouna'**
  String get cityElGouna;

  /// No description provided for @cityHurghada.
  ///
  /// In en, this message translates to:
  /// **'Hurghada'**
  String get cityHurghada;

  /// No description provided for @citySharmElSheikh.
  ///
  /// In en, this message translates to:
  /// **'Sharm El Sheikh'**
  String get citySharmElSheikh;

  /// No description provided for @cityVendorCount.
  ///
  /// In en, this message translates to:
  /// **'{count} vendors'**
  String cityVendorCount(int count);

  /// No description provided for @homeErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your home feed right now.'**
  String get homeErrorMessage;

  /// No description provided for @vendorStartingFrom.
  ///
  /// In en, this message translates to:
  /// **'From EGP {amount}'**
  String vendorStartingFrom(String amount);

  /// No description provided for @vendorReviewCount.
  ///
  /// In en, this message translates to:
  /// **'({count})'**
  String vendorReviewCount(int count);

  /// No description provided for @categoriesScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesScreenTitle;

  /// No description provided for @categoriesScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover every kind of vendor for your big day.'**
  String get categoriesScreenSubtitle;

  /// No description provided for @categoriesErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load categories right now.'**
  String get categoriesErrorMessage;

  /// No description provided for @searchCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get searchCancel;

  /// No description provided for @searchRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get searchRecentTitle;

  /// No description provided for @searchClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get searchClearAll;

  /// No description provided for @searchSuggestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Browse by Category'**
  String get searchSuggestionsTitle;

  /// No description provided for @searchResultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} results'**
  String searchResultsCount(int count);

  /// No description provided for @searchNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get searchNoResultsTitle;

  /// No description provided for @searchNoResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find any vendors matching \"{query}\". Try a different search.'**
  String searchNoResultsMessage(String query);

  /// No description provided for @searchErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t complete your search. Please try again.'**
  String get searchErrorMessage;

  /// No description provided for @searchEmptyPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Find your perfect vendor'**
  String get searchEmptyPromptTitle;

  /// No description provided for @searchEmptyPromptMessage.
  ///
  /// In en, this message translates to:
  /// **'Search by vendor name, category, or city.'**
  String get searchEmptyPromptMessage;

  /// No description provided for @filtersButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersButtonLabel;

  /// No description provided for @filtersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersTitle;

  /// No description provided for @filtersReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get filtersReset;

  /// No description provided for @filtersApply.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get filtersApply;

  /// No description provided for @filtersCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get filtersCategory;

  /// No description provided for @filtersAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get filtersAllCategories;

  /// No description provided for @filtersCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get filtersCity;

  /// No description provided for @filtersAllCities.
  ///
  /// In en, this message translates to:
  /// **'All Cities'**
  String get filtersAllCities;

  /// No description provided for @filtersRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get filtersRating;

  /// No description provided for @filtersAnyRating.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get filtersAnyRating;

  /// No description provided for @filtersRating4Plus.
  ///
  /// In en, this message translates to:
  /// **'4.0+'**
  String get filtersRating4Plus;

  /// No description provided for @filtersRating45Plus.
  ///
  /// In en, this message translates to:
  /// **'4.5+'**
  String get filtersRating45Plus;

  /// No description provided for @filtersPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get filtersPriceRange;

  /// No description provided for @filtersPriceRangeValue.
  ///
  /// In en, this message translates to:
  /// **'EGP {min} – EGP {max}'**
  String filtersPriceRangeValue(String min, String max);

  /// No description provided for @filtersSort.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get filtersSort;

  /// No description provided for @sortRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get sortRecommended;

  /// No description provided for @sortHighestRated.
  ///
  /// In en, this message translates to:
  /// **'Highest Rated'**
  String get sortHighestRated;

  /// No description provided for @sortLowestPrice.
  ///
  /// In en, this message translates to:
  /// **'Lowest Price'**
  String get sortLowestPrice;

  /// No description provided for @sortHighestPrice.
  ///
  /// In en, this message translates to:
  /// **'Highest Price'**
  String get sortHighestPrice;

  /// No description provided for @sortFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get sortFeatured;

  /// No description provided for @vendorListingEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No vendors found'**
  String get vendorListingEmptyTitle;

  /// No description provided for @vendorListingEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters to see more results.'**
  String get vendorListingEmptyMessage;

  /// No description provided for @vendorListingErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load these vendors right now.'**
  String get vendorListingErrorMessage;

  /// No description provided for @vendorDetailAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get vendorDetailAbout;

  /// No description provided for @vendorDetailPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get vendorDetailPortfolio;

  /// No description provided for @vendorDetailPackages.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get vendorDetailPackages;

  /// No description provided for @vendorDetailReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get vendorDetailReviews;

  /// No description provided for @vendorDetailErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load this vendor\'s profile right now.'**
  String get vendorDetailErrorMessage;

  /// No description provided for @egpAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'EGP {amount}'**
  String egpAmountLabel(String amount);

  /// No description provided for @vendorPackagesSelectPrompt.
  ///
  /// In en, this message translates to:
  /// **'Select a package to continue.'**
  String get vendorPackagesSelectPrompt;

  /// No description provided for @vendorPackagesContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get vendorPackagesContinue;

  /// No description provided for @vendorPackagesSelectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get vendorPackagesSelectedLabel;

  /// No description provided for @vendorReviewsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get vendorReviewsEmptyTitle;

  /// No description provided for @vendorReviewsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'This vendor hasn\'t been reviewed yet.'**
  String get vendorReviewsEmptyMessage;

  /// No description provided for @vendorReviewsErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load reviews right now.'**
  String get vendorReviewsErrorMessage;

  /// No description provided for @bookingRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Request'**
  String get bookingRequestTitle;

  /// No description provided for @bookingRequestSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get bookingRequestSummary;

  /// No description provided for @bookingRequestEventDate.
  ///
  /// In en, this message translates to:
  /// **'Event Date'**
  String get bookingRequestEventDate;

  /// No description provided for @bookingRequestSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get bookingRequestSelectDate;

  /// No description provided for @bookingRequestDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select an event date'**
  String get bookingRequestDateRequired;

  /// No description provided for @bookingRequestGuestCount.
  ///
  /// In en, this message translates to:
  /// **'Guest Count'**
  String get bookingRequestGuestCount;

  /// No description provided for @bookingRequestNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes (optional)'**
  String get bookingRequestNotes;

  /// No description provided for @bookingRequestNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Anything the vendor should know?'**
  String get bookingRequestNotesHint;

  /// No description provided for @bookingRequestErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t send your request. Please try again.'**
  String get bookingRequestErrorMessage;

  /// No description provided for @bookingSuccessViewBookings.
  ///
  /// In en, this message translates to:
  /// **'View My Bookings'**
  String get bookingSuccessViewBookings;

  /// No description provided for @bookingSuccessGuestsLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} guests'**
  String bookingSuccessGuestsLabel(int count);

  /// No description provided for @customerBookingsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No bookings yet'**
  String get customerBookingsEmptyTitle;

  /// No description provided for @customerBookingsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your booking requests will appear here.'**
  String get customerBookingsEmptyMessage;

  /// No description provided for @customerBookingsErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load your bookings right now.'**
  String get customerBookingsErrorMessage;

  /// No description provided for @vendorDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here\'s how your business is doing.'**
  String get vendorDashboardSubtitle;

  /// No description provided for @vendorDashboardNewRequests.
  ///
  /// In en, this message translates to:
  /// **'New Requests'**
  String get vendorDashboardNewRequests;

  /// No description provided for @vendorDashboardThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get vendorDashboardThisMonth;

  /// No description provided for @vendorDashboardRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get vendorDashboardRating;

  /// No description provided for @vendorDashboardRecentRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Requests'**
  String get vendorDashboardRecentRequestsTitle;

  /// No description provided for @vendorDashboardViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get vendorDashboardViewAll;

  /// No description provided for @vendorDashboardEmptyRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'No requests yet'**
  String get vendorDashboardEmptyRequestsTitle;

  /// No description provided for @vendorDashboardEmptyRequestsMessage.
  ///
  /// In en, this message translates to:
  /// **'New booking requests from couples will appear here.'**
  String get vendorDashboardEmptyRequestsMessage;

  /// No description provided for @vendorBookingsAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get vendorBookingsAccept;

  /// No description provided for @vendorBookingsDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get vendorBookingsDecline;

  /// No description provided for @vendorBookingsDeclineConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Decline this request?'**
  String get vendorBookingsDeclineConfirmTitle;

  /// No description provided for @vendorBookingsDeclineConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone.'**
  String get vendorBookingsDeclineConfirmMessage;

  /// No description provided for @vendorBookingsDeclineConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get vendorBookingsDeclineConfirmAction;

  /// No description provided for @vendorBookingsCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get vendorBookingsCancelAction;

  /// No description provided for @vendorProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Business Profile'**
  String get vendorProfileTitle;

  /// No description provided for @vendorProfileListingSection.
  ///
  /// In en, this message translates to:
  /// **'Your Listing'**
  String get vendorProfileListingSection;

  /// No description provided for @vendorProfilePortfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get vendorProfilePortfolio;

  /// No description provided for @vendorProfilePackages.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get vendorProfilePackages;

  /// No description provided for @vendorProfileBusinessDetails.
  ///
  /// In en, this message translates to:
  /// **'Business Details'**
  String get vendorProfileBusinessDetails;

  /// No description provided for @vendorProfileComingSoonBadge.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get vendorProfileComingSoonBadge;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'ll let you know when something needs your attention.'**
  String get notificationsEmptyMessage;
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
