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
  String get authPhoneLabel => 'Phone Number';

  @override
  String get authPhoneHint => '+20 1xx xxx xxxx';

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
  String get authForgotDevTokenNotice =>
      'Test server — no email was actually sent. Your reset code is:';

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
  String get validationPhoneInvalid => 'Enter a valid phone number';

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
  String get homeHeroSubtitle => 'Discover trusted vendors for every detail.';

  @override
  String get homeHeroCta => 'Explore Now';

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
  String get homeSectionInspiration => 'Wedding Inspiration';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeStatsVendorsValue => '500+';

  @override
  String get homeStatsVendorsLabel => 'Verified Vendors';

  @override
  String get homeStatsCouplesValue => '12K+';

  @override
  String get homeStatsCouplesLabel => 'Happy Couples';

  @override
  String get homeStatsCitiesValue => '6';

  @override
  String get homeStatsCitiesLabel => 'Cities';

  @override
  String get homeInspirationPalaceTag => 'PALACE';

  @override
  String get homeInspirationPalaceCaption => 'Palace Romance';

  @override
  String get homeInspirationSeasideTag => 'SEASIDE';

  @override
  String get homeInspirationSeasideCaption => 'Seaside Vows';

  @override
  String get homeInspirationGardenTag => 'GARDEN';

  @override
  String get homeInspirationGardenCaption => 'Garden Elegance';

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
  String get categoriesErrorMessage =>
      'We couldn\'t load categories right now.';

  @override
  String get categoriesFilterAll => 'All';

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
  String vendorListingPhotoCount(int count) {
    return '$count photos';
  }

  @override
  String vendorListingPackageCount(int count) {
    return '$count packages';
  }

  @override
  String get vendorListingPortfolioTitle => 'Manage Portfolio';

  @override
  String get vendorListingPortfolioEmptyTitle => 'No photos yet';

  @override
  String get vendorListingPortfolioEmptyMessage =>
      'Add photos so couples can see your work.';

  @override
  String get vendorListingAddPhoto => 'Add Photo';

  @override
  String get vendorListingChoosePhotoTitle => 'Choose a Photo';

  @override
  String get vendorListingRemovePhotoTitle => 'Remove this photo?';

  @override
  String get vendorListingRemovePhotoMessage =>
      'It will no longer show on your public listing.';

  @override
  String get vendorListingRemoveAction => 'Remove';

  @override
  String get vendorListingPackagesTitle => 'Manage Packages';

  @override
  String get vendorListingPackagesEmptyTitle => 'No packages yet';

  @override
  String get vendorListingPackagesEmptyMessage =>
      'Add a package so couples know what you offer.';

  @override
  String get vendorListingAddPackage => 'Add Package';

  @override
  String get vendorListingEditPackage => 'Edit Package';

  @override
  String get vendorListingPackageName => 'Package Name';

  @override
  String get vendorListingPackageNameHint => 'e.g. Full Day Coverage';

  @override
  String get vendorListingPackageDescription => 'Short Description';

  @override
  String get vendorListingPackageDescriptionHint =>
      'One line couples will see first';

  @override
  String get vendorListingPackagePrice => 'Starting Price (EGP)';

  @override
  String get vendorListingPackageInclusions => 'What\'s Included';

  @override
  String get vendorListingPackageInclusionsHint => 'One item per line';

  @override
  String get vendorListingDeletePackageTitle => 'Delete this package?';

  @override
  String get vendorListingDeletePackageMessage =>
      'It will be removed from your public listing.';

  @override
  String get vendorListingDeleteAction => 'Delete';

  @override
  String get vendorListingBusinessDetailsTitle => 'Business Details';

  @override
  String get vendorListingBusinessName => 'Business Name';

  @override
  String get vendorListingCategory => 'Category';

  @override
  String get vendorListingCity => 'City / Area';

  @override
  String get vendorListingCityHint => 'e.g. Zamalek, Cairo';

  @override
  String get vendorListingStartingPrice => 'Starting Price (EGP)';

  @override
  String get vendorListingDescription => 'About Your Business';

  @override
  String get vendorListingDescriptionHint =>
      'Tell couples what makes your service special';

  @override
  String get vendorListingSavedMessage => 'Business details updated';

  @override
  String get vendorListingCategoryLockedNote =>
      'Category is set when you create your profile and can\'t be changed here.';

  @override
  String get vendorListingStartingPriceNote =>
      'This is calculated automatically from your cheapest package.';

  @override
  String get vendorSetupTitle => 'Set Up Your Vendor Profile';

  @override
  String get vendorSetupSubtitle =>
      'Tell couples what you offer before your listing goes live.';

  @override
  String get vendorSetupCategoryHint => 'Select your category';

  @override
  String get vendorSetupCategoryRequired => 'Please choose a category';

  @override
  String get vendorSetupCity => 'City / Area';

  @override
  String get vendorSetupCityHint => 'e.g. Zamalek, Cairo';

  @override
  String get vendorSetupBio => 'About Your Business';

  @override
  String get vendorSetupBioHint =>
      'Tell couples what makes your service special';

  @override
  String get vendorSetupSubmit => 'Create My Profile';

  @override
  String get vendorSetupError =>
      'We couldn\'t create your profile. Please try again.';

  @override
  String get vendorProfileSubscription => 'Subscription';

  @override
  String get subscriptionMyPlanTitle => 'My Plan';

  @override
  String get subscriptionCurrentPlanBadge => 'Current Plan';

  @override
  String subscriptionTrialDaysRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left in trial',
      one: '1 day left in trial',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionComparePlans => 'Compare Plans';

  @override
  String get subscriptionPlansTitle => 'Choose Your Plan';

  @override
  String get subscriptionMonthly => '/ month';

  @override
  String get subscriptionYearly => '/ year';

  @override
  String get subscriptionUnlimited => 'Unlimited';

  @override
  String subscriptionMaxPackages(String count) {
    return '$count packages';
  }

  @override
  String subscriptionMaxPortfolioItems(String count) {
    return '$count portfolio photos';
  }

  @override
  String get subscriptionSwitchAction => 'Switch to This Plan';

  @override
  String get subscriptionSwitchConfirmTitle => 'Switch plan?';

  @override
  String get subscriptionSwitchConfirmMessage =>
      'Your new plan applies immediately.';

  @override
  String get subscriptionSwitchSuccess => 'Plan updated';

  @override
  String get subscriptionSwitchError =>
      'We couldn\'t switch your plan. Please try again.';

  @override
  String get subscriptionHistoryTitle => 'Plan History';

  @override
  String get vendorReviewsWriteAction => 'Write a Review';

  @override
  String get vendorReviewsWriteTitle => 'Rate Your Experience';

  @override
  String get vendorReviewsRatingLabel => 'Your Rating';

  @override
  String get vendorReviewsRatingRequired => 'Please select a rating';

  @override
  String get vendorReviewsCommentLabel => 'Your Review';

  @override
  String get vendorReviewsCommentHint => 'Share how it went with this vendor';

  @override
  String get vendorReviewsSubmitAction => 'Submit Review';

  @override
  String get vendorReviewsSubmitSuccess => 'Thanks for your review!';

  @override
  String get vendorReviewsSubmitError =>
      'We couldn\'t submit your review. Please try again.';

  @override
  String get vendorReviewsEditTitle => 'Edit Your Review';

  @override
  String get vendorReviewsEditAction => 'Edit';

  @override
  String get vendorReviewsDeleteTitle => 'Delete your review?';

  @override
  String get vendorReviewsDeleteMessage =>
      'This permanently removes your review for this vendor.';

  @override
  String get vendorReviewsDeleteAction => 'Delete';

  @override
  String get vendorReviewsDeleteError =>
      'We couldn\'t delete your review. Please try again.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Mark all as read';

  @override
  String get notificationsEmptyTitle => 'No notifications yet';

  @override
  String get notificationsEmptyMessage =>
      'We\'ll let you know when something needs your attention.';

  @override
  String get adminPanelTitle => 'Admin Panel';

  @override
  String get adminNavDashboard => 'Dashboard';

  @override
  String get adminNavVendors => 'Vendors';

  @override
  String get adminNavUsers => 'Users';

  @override
  String get adminNavBookings => 'Bookings';

  @override
  String get adminNavReviews => 'Reviews';

  @override
  String get adminNavCategories => 'Categories';

  @override
  String get adminNavPlans => 'Subscription Plans';

  @override
  String get adminNavAnalytics => 'Analytics';

  @override
  String get adminNavSettings => 'Settings';

  @override
  String get adminDashboardWelcome => 'Platform overview';

  @override
  String get adminDashboardEmptyTitle => 'No stats yet';

  @override
  String get adminDashboardEmptyMessage =>
      'Platform counters will show up here once there\'s data.';

  @override
  String get adminDashboardQuickLinks => 'Quick Links';

  @override
  String get adminCategoriesEmptyTitle => 'No categories yet';

  @override
  String get adminCategoriesEmptyMessage =>
      'Add a category so vendors can list under it.';

  @override
  String get adminCategoryAddAction => 'Add Category';

  @override
  String get adminCategoryAddTitle => 'Add Category';

  @override
  String get adminCategoryEditTitle => 'Edit Category';

  @override
  String get adminCategoryNameLabel => 'Category Name';

  @override
  String get adminCategoryNameHint => 'e.g. Wedding Hall';

  @override
  String get adminCategoryActiveLabel => 'Active';

  @override
  String get adminCategoryActiveSubtitle =>
      'Inactive categories are hidden from customers';

  @override
  String get adminCategorySaveAction => 'Save Category';

  @override
  String get adminCategorySavedMessage => 'Category saved';

  @override
  String get adminCategoryDeletedMessage => 'Category deleted';

  @override
  String get adminCategoryErrorMessage =>
      'We couldn\'t save this category. Please try again.';

  @override
  String get adminCategoryDeleteTitle => 'Delete this category?';

  @override
  String get adminCategoryDeleteMessage =>
      'Vendors already in it are not affected, but it will no longer accept new ones.';

  @override
  String get adminCategoryDeleteAction => 'Delete';

  @override
  String get adminCategoryInactiveBadge => 'Inactive';

  @override
  String get adminVendorsEmptyTitle => 'No vendors found';

  @override
  String get adminVendorsEmptyMessage => 'Try adjusting your filters.';

  @override
  String get adminVendorsFilterTitle => 'Filter Vendors';

  @override
  String get adminVendorsFilterCategory => 'Category';

  @override
  String get adminVendorsFilterCity => 'City';

  @override
  String get adminVendorsFilterCityHint => 'e.g. Cairo';

  @override
  String get adminVendorsFilterVerifiedOnly => 'Verified only';

  @override
  String get adminVendorsFilterAll => 'All';

  @override
  String get adminVendorsApplyFilters => 'Apply Filters';

  @override
  String get adminVendorVerifiedBadge => 'Verified';

  @override
  String get adminVendorUnverifiedBadge => 'Unverified';

  @override
  String get adminVendorVerifyAction => 'Verify Vendor';

  @override
  String get adminVendorUnverifyAction => 'Unverify Vendor';

  @override
  String get adminVendorDetailTitle => 'Vendor Details';

  @override
  String get adminVendorContactSection => 'Contact';

  @override
  String get adminVendorSubscriptionSection => 'Subscription';

  @override
  String get adminVendorNoSubscription =>
      'No active subscription — on the free plan by default.';

  @override
  String get adminVendorAssignPlanAction => 'Assign a Plan';

  @override
  String get adminVendorCancelSubscriptionAction => 'Cancel Subscription';

  @override
  String get adminVendorCancelSubscriptionTitle => 'Cancel this subscription?';

  @override
  String get adminVendorCancelSubscriptionMessage =>
      'The vendor will drop back to the free plan\'s limits.';

  @override
  String get adminVendorDeleteSubscriptionAction => 'Delete Record';

  @override
  String get adminVendorDeleteSubscriptionTitle =>
      'Delete this subscription record?';

  @override
  String get adminVendorDeleteSubscriptionMessage =>
      'Permanently removes it — this is different from cancelling, which just marks it inactive.';

  @override
  String get adminVendorSubscriptionCancelledMessage =>
      'Subscription cancelled';

  @override
  String get adminVendorSubscriptionDeletedMessage =>
      'Subscription record deleted';

  @override
  String get adminSelectPlanTitle => 'Select a Plan';

  @override
  String get adminUsersEmptyTitle => 'No users found';

  @override
  String get adminUsersEmptyMessage => 'Try adjusting your filters.';

  @override
  String get adminUsersFilterTitle => 'Filter Users';

  @override
  String get adminUsersSearchHint => 'Search name or email';

  @override
  String get adminUsersFilterRole => 'Role';

  @override
  String get adminUsersFilterActive => 'Active only';

  @override
  String get adminUserDetailTitle => 'User Details';

  @override
  String get adminUserRoleLabel => 'Role';

  @override
  String get adminUserActiveLabel => 'Account Active';

  @override
  String get adminUserActiveSubtitle => 'Deactivated users can\'t log in';

  @override
  String get adminUserRoleChangedMessage => 'Role updated';

  @override
  String get adminRoleCustomer => 'Customer';

  @override
  String get adminRoleVendor => 'Vendor';

  @override
  String get adminRoleAdmin => 'Admin';

  @override
  String get adminBookingsEmptyTitle => 'No bookings found';

  @override
  String get adminBookingsEmptyMessage => 'Try adjusting your filters.';

  @override
  String get adminBookingsFilterTitle => 'Filter Bookings';

  @override
  String get adminBookingsFilterStatus => 'Status';

  @override
  String get adminBookingStatusPending => 'Pending';

  @override
  String get adminBookingStatusAccepted => 'Accepted';

  @override
  String get adminBookingStatusRejected => 'Rejected';

  @override
  String get adminBookingStatusCancelled => 'Cancelled';

  @override
  String get adminBookingAcceptAction => 'Accept';

  @override
  String get adminBookingRejectAction => 'Reject';

  @override
  String get adminReviewsEmptyTitle => 'No reviews found';

  @override
  String get adminReviewsEmptyMessage => 'Try adjusting your filters.';

  @override
  String get adminReviewsFilterTitle => 'Filter Reviews';

  @override
  String get adminReviewsFilterHiddenOnly => 'Hidden only';

  @override
  String get adminReviewHiddenBadge => 'Hidden';

  @override
  String get adminReviewHideAction => 'Hide';

  @override
  String get adminReviewUnhideAction => 'Unhide';

  @override
  String get adminReviewDeleteAction => 'Delete';

  @override
  String get adminReviewDeleteTitle => 'Delete this review?';

  @override
  String get adminReviewDeleteMessage =>
      'This permanently removes it — the customer can post a new one.';

  @override
  String get adminSettingsGeneralSection => 'Platform';

  @override
  String get adminSettingsRegistrationEnabled => 'Registration Enabled';

  @override
  String get adminSettingsRegistrationEnabledSubtitle =>
      'Allow new accounts to sign up';

  @override
  String get adminSettingsMaintenanceMode => 'Maintenance Mode';

  @override
  String get adminSettingsMaintenanceModeSubtitle =>
      'Blocks non-admin traffic — use with care';

  @override
  String get adminSettingsSubscriptionRequired => 'Subscription Required';

  @override
  String get adminSettingsSubscriptionRequiredSubtitle =>
      'Vendors must be on a paid plan to list';

  @override
  String get adminSettingsFreeMode => 'Free Mode';

  @override
  String get adminSettingsFreeModeSubtitle =>
      'Every vendor gets full access at no cost';

  @override
  String get adminSettingsTrialSection => 'Trial';

  @override
  String get adminSettingsTrialEnabled => 'Trial Enabled';

  @override
  String get adminSettingsTrialEnabledSubtitle =>
      'New vendors get a free trial period';

  @override
  String get adminSettingsTrialDays => 'Trial Length (days)';

  @override
  String get adminSettingsVendorSection => 'Vendors';

  @override
  String get adminSettingsVendorAutoVerification => 'Auto-Verify Vendors';

  @override
  String get adminSettingsVendorAutoVerificationSubtitle =>
      'Skip manual review on signup';

  @override
  String get adminSettingsFeaturedSearch => 'Featured Search Boost';

  @override
  String get adminSettingsFeaturedSearchSubtitle =>
      'Featured-plan vendors rank higher in search';

  @override
  String get adminSettingsUploadSection => 'Uploads';

  @override
  String get adminSettingsUploadMaxSizeMb => 'Max Upload Size (MB)';

  @override
  String get adminSettingsUploadAllowedTypes => 'Allowed File Types';

  @override
  String get adminSettingsUploadAllowedTypesHint =>
      'Comma-separated, e.g. image/jpeg, image/png';

  @override
  String get adminSettingsSaveAction => 'Save Settings';

  @override
  String get adminSettingsSavedMessage => 'Settings saved';

  @override
  String get adminSettingsErrorMessage =>
      'We couldn\'t save settings. Please try again.';

  @override
  String get adminAnalyticsRevenue => 'Revenue';

  @override
  String get adminAnalyticsGrowth => 'Growth';

  @override
  String get adminAnalyticsBookings => 'Bookings';

  @override
  String get adminAnalyticsReviews => 'Reviews';

  @override
  String get adminAnalyticsConversion => 'Conversion';

  @override
  String get adminAnalyticsTopCategories => 'Top Categories';

  @override
  String get adminAnalyticsDateRange => 'Date Range';

  @override
  String get adminAnalyticsNoDataTitle => 'Nothing to show';

  @override
  String get adminAnalyticsNoData => 'No data for this range yet.';

  @override
  String get adminAnalyticsFrom => 'From';

  @override
  String get adminAnalyticsTo => 'To';

  @override
  String get adminPlansEmptyTitle => 'No plans yet';

  @override
  String get adminPlansEmptyMessage =>
      'Add a plan for vendors to subscribe to.';

  @override
  String get adminPlanAddAction => 'Add Plan';

  @override
  String get adminPlanAddTitle => 'Add Plan';

  @override
  String get adminPlanEditTitle => 'Edit Plan';

  @override
  String get adminPlanNameLabel => 'Plan Name';

  @override
  String get adminPlanDescriptionLabel => 'Description';

  @override
  String get adminPlanPriceLabel => 'Price (EGP / month)';

  @override
  String get adminPlanPriorityLabel => 'Priority Score';

  @override
  String get adminPlanMaxPackagesLabel => 'Max Packages (blank = unlimited)';

  @override
  String get adminPlanMaxPortfolioLabel =>
      'Max Portfolio Photos (blank = unlimited)';

  @override
  String get adminPlanFeaturedLabel => 'Featured Badge';

  @override
  String get adminPlanFeaturedSubtitle => 'Shows a gold badge on Compare Plans';

  @override
  String get adminPlanActiveLabel => 'Active';

  @override
  String get adminPlanActiveSubtitle =>
      'Inactive plans are hidden from vendors';

  @override
  String get adminPlanSaveAction => 'Save Plan';

  @override
  String get adminPlanSavedMessage => 'Plan saved';

  @override
  String get adminPlanDeletedMessage => 'Plan deleted';

  @override
  String get adminPlanErrorMessage =>
      'We couldn\'t save this plan. Please try again.';

  @override
  String get adminPlanDeleteTitle => 'Delete this plan?';

  @override
  String get adminPlanDeleteMessage =>
      'Refused if any vendor is still subscribed to it.';

  @override
  String get adminPlanDeleteAction => 'Delete';

  @override
  String get adminPlanInactiveBadge => 'Inactive';

  @override
  String get adminGenericErrorMessage =>
      'Something went wrong. Please try again.';

  @override
  String get adminApplyAction => 'Apply';

  @override
  String get adminClearFiltersAction => 'Clear';
}
