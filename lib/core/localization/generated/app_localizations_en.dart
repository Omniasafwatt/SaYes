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

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navBookings => 'Bookings';

  @override
  String get navProfile => 'Profile';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get comingSoonExploreTitle => 'Explore is on its way';

  @override
  String get comingSoonExploreMessage =>
      'Full category browsing and search land in the next phase.';

  @override
  String get comingSoonFavoritesTitle => 'Favorites is on its way';

  @override
  String get comingSoonFavoritesMessage =>
      'Saving vendors you love lands in a later phase.';

  @override
  String get comingSoonBookingsTitle => 'Bookings is on its way';

  @override
  String get comingSoonBookingsMessage =>
      'Tracking your booking requests lands in a later phase.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileMoreComingSoon =>
      'Full profile management — editing your details, notifications, and settings — lands in a later phase.';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileLogOut => 'Log Out';

  @override
  String get profileEditProfile => 'Edit Profile';

  @override
  String get profileAccountSection => 'Account';

  @override
  String get profilePreferencesSection => 'Preferences';

  @override
  String get profileName => 'Name';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profilePhoneHint => 'Add a phone number';

  @override
  String get profileNoPhone => 'Not added';

  @override
  String get profileSaveChanges => 'Save Changes';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileBookingUpdates => 'Booking updates';

  @override
  String get profileBookingUpdatesSubtitle => 'Status changes on your requests';

  @override
  String get profilePromotions => 'Promotions & offers';

  @override
  String get profilePromotionsSubtitle => 'Occasional vendor deals and offers';

  @override
  String get homeGreetingMorning => 'Good morning';

  @override
  String get homeGreetingAfternoon => 'Good afternoon';

  @override
  String get homeGreetingEvening => 'Good evening';

  @override
  String get homeGreetingSubtitle => 'Let\'s plan something beautiful today.';

  @override
  String get homeHeroHeadline => 'Plan the wedding\nyou\'ve always dreamed of.';

  @override
  String get homeSearchHint => 'What are you looking for?';

  @override
  String get homeSectionCategories => 'Categories';

  @override
  String get homeSectionFeatured => 'Featured Vendors';

  @override
  String get homeSectionPopular => 'Popular Vendors';

  @override
  String get homeSectionCities => 'Popular Cities';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeCategoryPhotographers => 'Photographers';

  @override
  String get homeCategoryMakeup => 'Makeup Artists';

  @override
  String get homeCategoryHalls => 'Wedding Halls';

  @override
  String get homeCategoryPlanners => 'Wedding Planners';

  @override
  String get homeCategoryDj => 'DJs';

  @override
  String get homeCategoryCatering => 'Catering';

  @override
  String get homeCategoryDecoration => 'Decoration';

  @override
  String get homeCategoryCarRental => 'Car Rental';

  @override
  String get cityCairo => 'Cairo';

  @override
  String get cityAlexandria => 'Alexandria';

  @override
  String get cityGiza => 'Giza';

  @override
  String get cityElGouna => 'El Gouna';

  @override
  String get cityHurghada => 'Hurghada';

  @override
  String get citySharmElSheikh => 'Sharm El Sheikh';

  @override
  String cityVendorCount(int count) {
    return '$count vendors';
  }

  @override
  String get homeErrorMessage => 'We couldn\'t load your home feed right now.';

  @override
  String vendorStartingFrom(String amount) {
    return 'From EGP $amount';
  }

  @override
  String vendorReviewCount(int count) {
    return '($count)';
  }

  @override
  String get categoriesScreenTitle => 'Categories';

  @override
  String get categoriesScreenSubtitle =>
      'Discover every kind of vendor for your big day.';

  @override
  String get categoriesErrorMessage =>
      'We couldn\'t load categories right now.';

  @override
  String get searchCancel => 'Cancel';

  @override
  String get searchRecentTitle => 'Recent Searches';

  @override
  String get searchClearAll => 'Clear all';

  @override
  String get searchSuggestionsTitle => 'Browse by Category';

  @override
  String searchResultsCount(int count) {
    return '$count results';
  }

  @override
  String get searchNoResultsTitle => 'No results found';

  @override
  String searchNoResultsMessage(String query) {
    return 'We couldn\'t find any vendors matching \"$query\". Try a different search.';
  }

  @override
  String get searchErrorMessage =>
      'We couldn\'t complete your search. Please try again.';

  @override
  String get searchEmptyPromptTitle => 'Find your perfect vendor';

  @override
  String get searchEmptyPromptMessage =>
      'Search by vendor name, category, or city.';

  @override
  String get filtersButtonLabel => 'Filters';

  @override
  String get filtersTitle => 'Filters';

  @override
  String get filtersReset => 'Reset';

  @override
  String get filtersApply => 'Apply Filters';

  @override
  String get filtersCategory => 'Category';

  @override
  String get filtersAllCategories => 'All Categories';

  @override
  String get filtersCity => 'City';

  @override
  String get filtersAllCities => 'All Cities';

  @override
  String get filtersRating => 'Rating';

  @override
  String get filtersAnyRating => 'Any';

  @override
  String get filtersRating4Plus => '4.0+';

  @override
  String get filtersRating45Plus => '4.5+';

  @override
  String get filtersPriceRange => 'Price Range';

  @override
  String filtersPriceRangeValue(String min, String max) {
    return 'EGP $min – EGP $max';
  }

  @override
  String get filtersSort => 'Sort By';

  @override
  String get sortRecommended => 'Recommended';

  @override
  String get sortHighestRated => 'Highest Rated';

  @override
  String get sortLowestPrice => 'Lowest Price';

  @override
  String get sortHighestPrice => 'Highest Price';

  @override
  String get sortFeatured => 'Featured';

  @override
  String get vendorListingEmptyTitle => 'No vendors found';

  @override
  String get vendorListingEmptyMessage =>
      'Try adjusting your filters to see more results.';

  @override
  String get vendorListingErrorMessage =>
      'We couldn\'t load these vendors right now.';

  @override
  String get vendorDetailAbout => 'About';

  @override
  String get vendorDetailPortfolio => 'Portfolio';

  @override
  String get vendorDetailPackages => 'Packages';

  @override
  String get vendorDetailReviews => 'Reviews';

  @override
  String get vendorDetailErrorMessage =>
      'We couldn\'t load this vendor\'s profile right now.';

  @override
  String egpAmountLabel(String amount) {
    return 'EGP $amount';
  }

  @override
  String get vendorPackagesSelectPrompt => 'Select a package to continue.';

  @override
  String get vendorPackagesContinue => 'Continue';

  @override
  String get vendorPackagesSelectedLabel => 'Selected';

  @override
  String get vendorReviewsEmptyTitle => 'No reviews yet';

  @override
  String get vendorReviewsEmptyMessage =>
      'This vendor hasn\'t been reviewed yet.';

  @override
  String get vendorReviewsErrorMessage =>
      'We couldn\'t load reviews right now.';

  @override
  String get bookingRequestTitle => 'Booking Request';

  @override
  String get bookingRequestSummary => 'Summary';

  @override
  String get bookingRequestEventDate => 'Event Date';

  @override
  String get bookingRequestSelectDate => 'Select a date';

  @override
  String get bookingRequestDateRequired => 'Please select an event date';

  @override
  String get bookingRequestGuestCount => 'Guest Count';

  @override
  String get bookingRequestNotes => 'Additional Notes (optional)';

  @override
  String get bookingRequestNotesHint => 'Anything the vendor should know?';

  @override
  String get bookingRequestErrorMessage =>
      'We couldn\'t send your request. Please try again.';

  @override
  String get bookingSuccessViewBookings => 'View My Bookings';

  @override
  String bookingSuccessGuestsLabel(int count) {
    return '$count guests';
  }

  @override
  String get customerBookingsEmptyTitle => 'No bookings yet';

  @override
  String get customerBookingsEmptyMessage =>
      'Your booking requests will appear here.';

  @override
  String get customerBookingsErrorMessage =>
      'We couldn\'t load your bookings right now.';

  @override
  String get vendorDashboardSubtitle => 'Here\'s how your business is doing.';

  @override
  String get vendorDashboardNewRequests => 'New Requests';

  @override
  String get vendorDashboardThisMonth => 'This Month';

  @override
  String get vendorDashboardRating => 'Rating';

  @override
  String get vendorDashboardRecentRequestsTitle => 'Recent Requests';

  @override
  String get vendorDashboardViewAll => 'View all';

  @override
  String get vendorDashboardEmptyRequestsTitle => 'No requests yet';

  @override
  String get vendorDashboardEmptyRequestsMessage =>
      'New booking requests from couples will appear here.';

  @override
  String get vendorBookingsAccept => 'Accept';

  @override
  String get vendorBookingsDecline => 'Decline';

  @override
  String get vendorBookingsDeclineConfirmTitle => 'Decline this request?';

  @override
  String get vendorBookingsDeclineConfirmMessage => 'This can\'t be undone.';

  @override
  String get vendorBookingsDeclineConfirmAction => 'Decline';

  @override
  String get vendorBookingsCancelAction => 'Cancel';

  @override
  String get vendorProfileTitle => 'Business Profile';

  @override
  String get vendorProfileListingSection => 'Your Listing';

  @override
  String get vendorProfilePortfolio => 'Portfolio';

  @override
  String get vendorProfilePackages => 'Packages';

  @override
  String get vendorProfileBusinessDetails => 'Business Details';

  @override
  String get vendorProfileComingSoonBadge => 'Coming soon';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Mark all as read';

  @override
  String get notificationsEmptyTitle => 'No notifications yet';

  @override
  String get notificationsEmptyMessage =>
      'We\'ll let you know when something needs your attention.';
}
