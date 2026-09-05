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
  String get splashSubtitle =>
      'Crafting unforgettable Egyptian celebrations, beautifully planned.';

  @override
  String get splashCities => 'Cairo · Alexandria · El Gouna';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String onboardingStep(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get onboarding1Headline => 'Your dream wedding\nstarts here.';

  @override
  String get onboarding1Body =>
      'Discover breathtaking venues, talented photographers, and everything you need for the celebration you\'ve always imagined.';

  @override
  String get onboarding2Headline => 'Find vendors\nyou can trust.';

  @override
  String get onboarding2Body =>
      'Every vendor is verified — real reviews, transparent pricing, and portfolios you can browse before you book.';

  @override
  String get onboarding3Headline => 'Plan everything\nin one place.';

  @override
  String get onboarding3Body =>
      'From discovery to booking, manage your entire wedding journey in one beautifully simple app.';

  @override
  String get onboarding3Vendors => 'Vendors';

  @override
  String get onboarding3Bookings => 'Bookings';

  @override
  String get onboarding3Favorites => 'Favorites';

  @override
  String get onboarding3Reviews => 'Reviews';

  @override
  String get authLoginTitle => 'Welcome back';

  @override
  String get authLoginSubtitle =>
      'Sign in to continue planning your dream day.';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authSignInButton => 'Sign In';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authCreateAccount => 'Create Account';

  @override
  String get authLoginError =>
      'We couldn\'t sign you in. Please check your details and try again.';

  @override
  String get authRegisterTitle => 'Create your account';

  @override
  String get authRegisterSubtitle =>
      'Tell us a little about yourself to get started.';

  @override
  String get authRoleCustomerTitle => 'I\'m planning my wedding';

  @override
  String get authRoleCustomerSubtitle =>
      'Discover vendors, save favorites, and book with confidence.';

  @override
  String get authRoleCustomerTag1 => 'Browse Vendors';

  @override
  String get authRoleCustomerTag2 => 'Save Favorites';

  @override
  String get authRoleCustomerTag3 => 'Easy Booking';

  @override
  String get authRoleVendorTitle => 'I\'m a wedding professional';

  @override
  String get authRoleVendorSubtitle =>
      'Showcase your work and receive booking requests from couples.';

  @override
  String get authRoleVendorTag1 => 'Showcase Portfolio';

  @override
  String get authRoleVendorTag2 => 'Get Bookings';

  @override
  String get authRoleVendorTag3 => 'Grow Your Business';

  @override
  String get authNameLabel => 'Full Name';

  @override
  String get authNameHint => 'Your name';

  @override
  String get authConfirmPasswordLabel => 'Confirm Password';

  @override
  String get authConfirmPasswordHint => 'Re-enter your password';

  @override
  String get authCreateAccountButton => 'Create Account';

  @override
  String get authHaveAccount => 'Already have an account?';

  @override
  String get authSignIn => 'Sign In';

  @override
  String get authTermsNotice =>
      'By continuing, you agree to SayYes\'s Terms of Service and Privacy Policy.';

  @override
  String get authRegisterError =>
      'We couldn\'t create your account. Please try again.';

  @override
  String get authForgotTitle => 'Reset your password';

  @override
  String get authForgotSubtitle =>
      'Enter your email and we\'ll send you a code to reset your password.';

  @override
  String get authSendCodeButton => 'Send Reset Code';

  @override
  String get authForgotSuccessTitle => 'Check your email';

  @override
  String authForgotSuccessMessage(String email) {
    return 'We\'ve sent a reset code to $email. Enter it on the next screen to choose a new password.';
  }

  @override
  String get authEnterCodeButton => 'Enter Reset Code';

  @override
  String get authBackToLogin => 'Back to Sign In';

  @override
  String get authForgotError =>
      'We couldn\'t send that reset code. Please try again.';

  @override
  String get authResetTitle => 'Set new password';

  @override
  String get authResetSubtitle =>
      'Enter the code we sent you and choose a new password.';

  @override
  String get authCodeLabel => 'Reset Code';

  @override
  String get authCodeHint => 'Enter the 6-digit code';

  @override
  String get authNewPasswordLabel => 'New Password';

  @override
  String get authNewPasswordHint => 'Enter a new password';

  @override
  String get authResetButton => 'Reset Password';

  @override
  String get authResetSuccessTitle => 'Password updated';

  @override
  String get authResetSuccessMessage =>
      'Your password has been changed. You can now sign in with your new password.';

  @override
  String get authResetSuccessButton => 'Back to Sign In';

  @override
  String get authResetError =>
      'We couldn\'t reset your password. Please try again.';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationEmailInvalid => 'Enter a valid email address';

  @override
  String get validationPasswordTooShort =>
      'Password must be at least 8 characters';

  @override
  String get validationPasswordMismatch => 'Passwords don\'t match';

  @override
  String get validationNameTooShort => 'Please enter your full name';

  @override
  String get validationCodeTooShort => 'Enter the code we sent you';

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
