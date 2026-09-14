// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'سيّ يس';

  @override
  String get appTagline => 'مخطط الأفراح الفاخر';

  @override
  String get splashSubtitle =>
      'نُخطط لاحتفالات مصرية لا تُنسى، بعناية واهتمام فائقين.';

  @override
  String get splashCities => 'القاهرة · الإسكندرية · الجونة';

  @override
  String get onboardingSkip => 'تخطي';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingGetStarted => 'ابدأ الآن';

  @override
  String onboardingStep(int current, int total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get onboarding1Headline => 'حفل زفافك المثالي\nيبدأ من هنا.';

  @override
  String get onboarding1Body =>
      'اكتشفي قاعات ساحرة، ومصورين موهوبين، وكل ما تحتاجينه للاحتفال الذي طالما حلمتِ به.';

  @override
  String get onboarding2Headline => 'تعرّفي على مزودي خدمة\nيمكنكِ الوثوق بهم.';

  @override
  String get onboarding2Body =>
      'كل مزود خدمة موثّق — تقييمات حقيقية، أسعار واضحة، وأعمال سابقة يمكنكِ تصفحها قبل الحجز.';

  @override
  String get onboarding3Headline => 'خططي لكل شيء\nفي مكان واحد.';

  @override
  String get onboarding3Body =>
      'من الاكتشاف إلى الحجز، أديري رحلة زفافك بالكامل من تطبيق واحد أنيق وبسيط.';

  @override
  String get onboarding3Vendors => 'مزودو الخدمة';

  @override
  String get onboarding3Bookings => 'الحجوزات';

  @override
  String get onboarding3Favorites => 'المفضلة';

  @override
  String get onboarding3Reviews => 'التقييمات';

  @override
  String get authLoginTitle => 'أهلاً بعودتكِ';

  @override
  String get authLoginSubtitle => 'سجّلي الدخول لمتابعة التخطيط ليوم أحلامكِ.';

  @override
  String get authForgotPassword => 'نسيتِ كلمة المرور؟';

  @override
  String get authSignInButton => 'تسجيل الدخول';

  @override
  String get authNoAccount => 'ليس لديكِ حساب؟';

  @override
  String get authCreateAccount => 'إنشاء حساب';

  @override
  String get authLoginError =>
      'تعذّر تسجيل الدخول. يرجى التحقق من بياناتكِ والمحاولة مرة أخرى.';

  @override
  String get authRegisterTitle => 'أنشئي حسابكِ';

  @override
  String get authRegisterSubtitle => 'أخبرينا القليل عن نفسكِ للبدء.';

  @override
  String get authRoleCustomerTitle => 'أنا أخطط لزفافي';

  @override
  String get authRoleCustomerSubtitle =>
      'اكتشفي مزودي الخدمة، احفظي المفضلة، واحجزي بكل ثقة.';

  @override
  String get authRoleCustomerTag1 => 'تصفح مزودي الخدمة';

  @override
  String get authRoleCustomerTag2 => 'حفظ المفضلة';

  @override
  String get authRoleCustomerTag3 => 'حجز سهل';

  @override
  String get authRoleVendorTitle => 'أنا مقدم خدمات أفراح';

  @override
  String get authRoleVendorSubtitle =>
      'اعرضي أعمالكِ واستقبلي طلبات حجز من العرائس والعرسان.';

  @override
  String get authRoleVendorTag1 => 'عرض الأعمال السابقة';

  @override
  String get authRoleVendorTag2 => 'استقبال الحجوزات';

  @override
  String get authRoleVendorTag3 => 'نمِّي أعمالكِ';

  @override
  String get authNameLabel => 'الاسم الكامل';

  @override
  String get authNameHint => 'اسمكِ';

  @override
  String get authPhoneLabel => 'رقم الهاتف';

  @override
  String get authPhoneHint => '+20 1xx xxx xxxx';

  @override
  String get authConfirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get authConfirmPasswordHint => 'أعيدي إدخال كلمة المرور';

  @override
  String get authCreateAccountButton => 'إنشاء حساب';

  @override
  String get authHaveAccount => 'لديكِ حساب بالفعل؟';

  @override
  String get authSignIn => 'تسجيل الدخول';

  @override
  String get authTermsNotice =>
      'بالمتابعة، أنتِ توافقين على شروط الخدمة وسياسة الخصوصية الخاصة بـ سيّ يس.';

  @override
  String get authRegisterError => 'تعذّر إنشاء حسابكِ. يرجى المحاولة مرة أخرى.';

  @override
  String get authForgotTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get authForgotSubtitle =>
      'أدخلي بريدكِ الإلكتروني وسنرسل لكِ رمزاً لإعادة تعيين كلمة المرور.';

  @override
  String get authSendCodeButton => 'إرسال رمز إعادة التعيين';

  @override
  String get authForgotSuccessTitle => 'تحققي من بريدكِ الإلكتروني';

  @override
  String authForgotSuccessMessage(String email) {
    return 'أرسلنا رمز إعادة التعيين إلى $email. أدخليه في الشاشة التالية لاختيار كلمة مرور جديدة.';
  }

  @override
  String get authEnterCodeButton => 'إدخال رمز إعادة التعيين';

  @override
  String get authBackToLogin => 'العودة لتسجيل الدخول';

  @override
  String get authForgotError =>
      'تعذّر إرسال رمز إعادة التعيين. يرجى المحاولة مرة أخرى.';

  @override
  String get authForgotDevTokenNotice =>
      'خادم تجريبي — لم يُرسَل أي بريد إلكتروني فعليًا. رمزك هو:';

  @override
  String get authResetTitle => 'تعيين كلمة مرور جديدة';

  @override
  String get authResetSubtitle =>
      'أدخلي الرمز الذي أرسلناه واختاري كلمة مرور جديدة.';

  @override
  String get authCodeLabel => 'رمز إعادة التعيين';

  @override
  String get authCodeHint => 'أدخلي الرمز المكوّن من 6 أرقام';

  @override
  String get authNewPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get authNewPasswordHint => 'أدخلي كلمة مرور جديدة';

  @override
  String get authResetButton => 'إعادة تعيين كلمة المرور';

  @override
  String get authResetSuccessTitle => 'تم تحديث كلمة المرور';

  @override
  String get authResetSuccessMessage =>
      'تم تغيير كلمة مرورك بنجاح. يمكنكِ الآن تسجيل الدخول بكلمة المرور الجديدة.';

  @override
  String get authResetSuccessButton => 'العودة لتسجيل الدخول';

  @override
  String get authResetError =>
      'تعذّر إعادة تعيين كلمة المرور. يرجى المحاولة مرة أخرى.';

  @override
  String get validationRequired => 'هذا الحقل مطلوب';

  @override
  String get validationEmailInvalid => 'أدخلي بريداً إلكترونياً صحيحاً';

  @override
  String get validationPasswordTooShort =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get validationPasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get validationNameTooShort => 'يرجى إدخال اسمكِ الكامل';

  @override
  String get validationCodeTooShort => 'أدخلي الرمز الذي أرسلناه إليكِ';

  @override
  String get validationPhoneInvalid => 'أدخلي رقم هاتف صحيح';

  @override
  String get showcaseTitle => 'نظام التصميم';

  @override
  String get showcaseSubtitle => 'كل عناصر الأساس لتجربة سيّ يس الفاخرة.';

  @override
  String get sectionColors => 'الألوان';

  @override
  String get sectionTypography => 'الخطوط';

  @override
  String get sectionButtons => 'الأزرار';

  @override
  String get sectionInputs => 'حقول الإدخال';

  @override
  String get sectionChips => 'فئات الخدمات';

  @override
  String get sectionCards => 'بطاقات مزودي الخدمة';

  @override
  String get sectionBadges => 'الشارات والحالة';

  @override
  String get sectionRating => 'التقييمات';

  @override
  String get sectionStates => 'حالات فارغة / خطأ / نجاح';

  @override
  String get sectionLoading => 'التحميل والهياكل العظمية';

  @override
  String get primaryButtonLabel => 'طلب حجز';

  @override
  String get secondaryButtonLabel => 'عرض الأعمال السابقة';

  @override
  String get textButtonLabel => 'تخطي الآن';

  @override
  String get loadingButtonLabel => 'جارٍ الإرسال';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get categoryPhotography => 'التصوير الفوتوغرافي';

  @override
  String get categoryMakeup => 'خبيرة المكياج';

  @override
  String get categoryHalls => 'قاعات الأفراح';

  @override
  String get categoryPlanning => 'منظمو حفلات الزفاف';

  @override
  String get vendorSampleName => 'قاعة نور الشام للأفراح';

  @override
  String get vendorSampleCity => 'الزمالك، القاهرة';

  @override
  String get vendorSamplePrice => 'يبدأ من 45,000 جنيه';

  @override
  String get vendorSampleReviews => '(120)';

  @override
  String get verifiedLabel => 'موثّق';

  @override
  String get featuredLabel => 'مميز';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get statusAccepted => 'مقبول';

  @override
  String get statusRejected => 'مرفوض';

  @override
  String get ratingReviewsLabel => '120 تقييم';

  @override
  String get emptyFavoritesTitle => 'مزودو الخدمة المفضلون لديك\nسيظهرون هنا.';

  @override
  String get emptyFavoritesMessage =>
      'اضغطي على أيقونة القلب لأي مزود لحفظه لوقت لاحق.';

  @override
  String get emptyFavoritesAction => 'ابدئي الاستكشاف';

  @override
  String get errorTitle => 'حدث خطأ ما';

  @override
  String get errorMessage => 'تعذّر تحميل هذا الآن. يرجى المحاولة مرة أخرى.';

  @override
  String get errorAction => 'إعادة المحاولة';

  @override
  String get successTitle => 'تم إرسال طلبك بنجاح!';

  @override
  String get successMessage =>
      'استلم مزود الخدمة طلب الحجز الخاص بك. سنُبقيك على اطّلاع.';

  @override
  String get successAction => 'العودة للرئيسية';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navExplore => 'استكشاف';

  @override
  String get navFavorites => 'المفضلة';

  @override
  String get navBookings => 'الحجوزات';

  @override
  String get navProfile => 'حسابي';

  @override
  String get navDashboard => 'لوحة التحكم';

  @override
  String get comingSoonExploreTitle => 'الاستكشاف قادم قريباً';

  @override
  String get comingSoonExploreMessage =>
      'تصفح الفئات والبحث الكامل يصلان في المرحلة القادمة.';

  @override
  String get comingSoonFavoritesTitle => 'المفضلة قادمة قريباً';

  @override
  String get comingSoonFavoritesMessage =>
      'حفظ مزودي الخدمة المفضلين لديكِ يصل في مرحلة لاحقة.';

  @override
  String get comingSoonBookingsTitle => 'الحجوزات قادمة قريباً';

  @override
  String get comingSoonBookingsMessage =>
      'متابعة طلبات الحجز الخاصة بكِ تصل في مرحلة لاحقة.';

  @override
  String get profileTitle => 'حسابي';

  @override
  String get profileMoreComingSoon =>
      'إدارة الحساب الكاملة — تعديل بياناتكِ، والإشعارات، والإعدادات — تصل في مرحلة لاحقة.';

  @override
  String get profileLanguage => 'اللغة';

  @override
  String get profileLogOut => 'تسجيل الخروج';

  @override
  String get profileEditProfile => 'تعديل الملف الشخصي';

  @override
  String get profileAccountSection => 'الحساب';

  @override
  String get profilePreferencesSection => 'التفضيلات';

  @override
  String get profileName => 'الاسم';

  @override
  String get profilePhone => 'رقم الهاتف';

  @override
  String get profilePhoneHint => 'أضيفي رقم هاتف';

  @override
  String get profileNoPhone => 'لم تتم الإضافة';

  @override
  String get profileSaveChanges => 'حفظ التغييرات';

  @override
  String get profileNotifications => 'الإشعارات';

  @override
  String get profileBookingUpdates => 'تحديثات الحجوزات';

  @override
  String get profileBookingUpdatesSubtitle =>
      'تغييرات حالة طلبات الحجز الخاصة بكِ';

  @override
  String get homeGreetingMorning => 'صباح الخير';

  @override
  String get homeGreetingAfternoon => 'مساء الخير';

  @override
  String get homeGreetingEvening => 'مساء الخير';

  @override
  String get homeGreetingSubtitle => 'لنُخطط لشيء جميل اليوم.';

  @override
  String get homeHeroHeadline => 'خططي لحفل الزفاف\nالذي طالما حلمتِ به.';

  @override
  String get homeHeroSubtitle => 'اكتشفي موردين موثوقين لكل تفصيلة.';

  @override
  String get homeHeroCta => 'استكشفي الآن';

  @override
  String get homeSearchHint => 'عمّاذا تبحثين؟';

  @override
  String get homeSectionCategories => 'الفئات';

  @override
  String get homeSectionFeatured => 'مزودو خدمة مميزون';

  @override
  String get homeSectionPopular => 'مزودو خدمة شائعون';

  @override
  String get homeSectionCities => 'المدن الأكثر بحثاً';

  @override
  String get homeSectionInspiration => 'إلهام لحفل زفافك';

  @override
  String get homeSeeAll => 'عرض الكل';

  @override
  String get homeStatsVendorsLabel => 'مزود موثّق';

  @override
  String get homeStatsCategoriesLabel => 'فئة';

  @override
  String get homeStatsCitiesLabel => 'مدن';

  @override
  String get homeInspirationPalaceTag => 'قصور';

  @override
  String get homeInspirationPalaceCaption => 'رومانسية القصور';

  @override
  String get homeInspirationSeasideTag => 'شاطئ';

  @override
  String get homeInspirationSeasideCaption => 'عهد على الشاطئ';

  @override
  String get homeInspirationGardenTag => 'حدائق';

  @override
  String get homeInspirationGardenCaption => 'أناقة الحدائق';

  @override
  String get homeCategoryPhotographers => 'المصورون';

  @override
  String get homeCategoryMakeup => 'خبيرات المكياج';

  @override
  String get homeCategoryHalls => 'قاعات الأفراح';

  @override
  String get homeCategoryPlanners => 'منظمو حفلات الزفاف';

  @override
  String get homeCategoryDj => 'دي جي';

  @override
  String get homeCategoryCatering => 'الضيافة والتموين';

  @override
  String get homeCategoryDecoration => 'الديكور';

  @override
  String get homeCategoryCarRental => 'تأجير السيارات';

  @override
  String get cityCairo => 'القاهرة';

  @override
  String get cityAlexandria => 'الإسكندرية';

  @override
  String get cityGiza => 'الجيزة';

  @override
  String get cityElGouna => 'الجونة';

  @override
  String get cityHurghada => 'الغردقة';

  @override
  String get citySharmElSheikh => 'شرم الشيخ';

  @override
  String cityVendorCount(int count) {
    return '$count مزود خدمة';
  }

  @override
  String get homeErrorMessage => 'تعذّر تحميل الصفحة الرئيسية الآن.';

  @override
  String vendorStartingFrom(String amount) {
    return 'يبدأ من $amount جنيه';
  }

  @override
  String vendorReviewCount(int count) {
    return '($count)';
  }

  @override
  String get categoriesScreenTitle => 'الفئات';

  @override
  String get categoriesErrorMessage => 'تعذّر تحميل الفئات الآن.';

  @override
  String get categoriesFilterAll => 'الكل';

  @override
  String get searchCancel => 'إلغاء';

  @override
  String get searchRecentTitle => 'عمليات البحث الأخيرة';

  @override
  String get searchClearAll => 'مسح الكل';

  @override
  String get searchSuggestionsTitle => 'تصفحي حسب الفئة';

  @override
  String searchResultsCount(int count) {
    return '$count نتيجة';
  }

  @override
  String get searchNoResultsTitle => 'لا توجد نتائج';

  @override
  String searchNoResultsMessage(String query) {
    return 'لم نجد أي مزودي خدمة مطابقين لـ \"$query\". جرّبي بحثاً مختلفاً.';
  }

  @override
  String get searchErrorMessage => 'تعذّر إتمام البحث. يرجى المحاولة مرة أخرى.';

  @override
  String get searchEmptyPromptTitle => 'اعثري على مزود الخدمة المثالي';

  @override
  String get searchEmptyPromptMessage =>
      'ابحثي باسم مزود الخدمة، أو الفئة، أو المدينة.';

  @override
  String get filtersButtonLabel => 'الفلاتر';

  @override
  String get filtersTitle => 'الفلاتر';

  @override
  String get filtersReset => 'إعادة تعيين';

  @override
  String get filtersApply => 'تطبيق الفلاتر';

  @override
  String get filtersCategory => 'الفئة';

  @override
  String get filtersAllCategories => 'كل الفئات';

  @override
  String get filtersCity => 'المدينة';

  @override
  String get filtersAllCities => 'كل المدن';

  @override
  String get filtersRating => 'التقييم';

  @override
  String get filtersAnyRating => 'أي تقييم';

  @override
  String get filtersRating4Plus => '+4.0';

  @override
  String get filtersRating45Plus => '+4.5';

  @override
  String get filtersPriceRange => 'النطاق السعري';

  @override
  String filtersPriceRangeValue(String min, String max) {
    return '$min – $max جنيه';
  }

  @override
  String get filtersSort => 'الترتيب حسب';

  @override
  String get sortRecommended => 'الموصى به';

  @override
  String get sortHighestRated => 'الأعلى تقييماً';

  @override
  String get sortLowestPrice => 'الأقل سعراً';

  @override
  String get sortHighestPrice => 'الأعلى سعراً';

  @override
  String get sortFeatured => 'المميز';

  @override
  String get vendorListingEmptyTitle => 'لا يوجد مزودو خدمة';

  @override
  String get vendorListingEmptyMessage =>
      'جربي تعديل الفلاتر لرؤية المزيد من النتائج.';

  @override
  String get vendorListingErrorMessage => 'تعذّر تحميل مزودي الخدمة الآن.';

  @override
  String get vendorDetailAbout => 'نبذة';

  @override
  String get vendorDetailPortfolio => 'معرض الأعمال';

  @override
  String get vendorDetailPackages => 'الباقات';

  @override
  String get vendorDetailReviews => 'التقييمات';

  @override
  String get vendorDetailErrorMessage =>
      'تعذّر تحميل الملف الشخصي لمزود الخدمة الآن.';

  @override
  String egpAmountLabel(String amount) {
    return '$amount جنيه';
  }

  @override
  String get vendorPackagesSelectPrompt => 'اختاري باقة للمتابعة.';

  @override
  String get vendorPackagesContinue => 'متابعة';

  @override
  String get vendorPackagesSelectedLabel => 'تم الاختيار';

  @override
  String get vendorReviewsEmptyTitle => 'لا توجد تقييمات بعد';

  @override
  String get vendorReviewsEmptyMessage => 'لم يتم تقييم مزود الخدمة هذا بعد.';

  @override
  String get vendorReviewsErrorMessage => 'تعذّر تحميل التقييمات الآن.';

  @override
  String get bookingRequestTitle => 'طلب الحجز';

  @override
  String get bookingRequestSummary => 'الملخص';

  @override
  String get bookingRequestEventDate => 'تاريخ المناسبة';

  @override
  String get bookingRequestSelectDate => 'اختاري تاريخاً';

  @override
  String get bookingRequestDateRequired => 'يرجى اختيار تاريخ المناسبة';

  @override
  String get bookingRequestGuestCount => 'عدد الضيوف';

  @override
  String get bookingRequestNotes => 'ملاحظات إضافية (اختياري)';

  @override
  String get bookingRequestNotesHint => 'هل هناك ما يجب أن يعرفه مزود الخدمة؟';

  @override
  String get bookingRequestErrorMessage =>
      'تعذّر إرسال طلبك. يرجى المحاولة مرة أخرى.';

  @override
  String get bookingSuccessViewBookings => 'عرض حجوزاتي';

  @override
  String bookingSuccessGuestsLabel(int count) {
    return '$count ضيف';
  }

  @override
  String get customerBookingsEmptyTitle => 'لا توجد حجوزات بعد';

  @override
  String get customerBookingsEmptyMessage => 'ستظهر طلبات الحجز الخاصة بك هنا.';

  @override
  String get customerBookingsErrorMessage => 'تعذّر تحميل حجوزاتك الآن.';

  @override
  String get vendorDashboardSubtitle => 'نظرة عامة على أداء عملك.';

  @override
  String get vendorDashboardNewRequests => 'طلبات جديدة';

  @override
  String get vendorDashboardThisMonth => 'هذا الشهر';

  @override
  String get vendorDashboardRating => 'التقييم';

  @override
  String get vendorDashboardRecentRequestsTitle => 'الطلبات الأخيرة';

  @override
  String get vendorDashboardViewAll => 'عرض الكل';

  @override
  String get vendorDashboardEmptyRequestsTitle => 'لا توجد طلبات بعد';

  @override
  String get vendorDashboardEmptyRequestsMessage =>
      'ستظهر هنا طلبات الحجز الجديدة من العرائس والعرسان.';

  @override
  String get vendorBookingsAccept => 'قبول';

  @override
  String get vendorBookingsDecline => 'رفض';

  @override
  String get vendorBookingsDeclineConfirmTitle => 'هل تريدين رفض هذا الطلب؟';

  @override
  String get vendorBookingsDeclineConfirmMessage =>
      'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get vendorBookingsDeclineConfirmAction => 'رفض';

  @override
  String get vendorBookingsCancelAction => 'إلغاء';

  @override
  String get vendorProfileTitle => 'الملف التجاري';

  @override
  String get vendorProfileListingSection => 'قائمتك';

  @override
  String get vendorProfilePortfolio => 'معرض الأعمال';

  @override
  String get vendorProfilePackages => 'الباقات';

  @override
  String get vendorProfileBusinessDetails => 'بيانات النشاط التجاري';

  @override
  String vendorListingPhotoCount(int count) {
    return '$count صورة';
  }

  @override
  String vendorListingPackageCount(int count) {
    return '$count باقة';
  }

  @override
  String get vendorListingPortfolioTitle => 'إدارة معرض الأعمال';

  @override
  String get vendorListingPortfolioEmptyTitle => 'لا توجد صور بعد';

  @override
  String get vendorListingPortfolioEmptyMessage =>
      'أضيفي صورًا ليتمكن العروسان من رؤية أعمالك.';

  @override
  String get vendorListingAddPhoto => 'إضافة صورة';

  @override
  String get vendorListingChoosePhotoTitle => 'اختاري صورة';

  @override
  String get vendorListingRemovePhotoTitle => 'إزالة هذه الصورة؟';

  @override
  String get vendorListingRemovePhotoMessage =>
      'لن تظهر بعد الآن في قائمتك العامة.';

  @override
  String get vendorListingRemoveAction => 'إزالة';

  @override
  String get vendorListingPackagesTitle => 'إدارة الباقات';

  @override
  String get vendorListingPackagesEmptyTitle => 'لا توجد باقات بعد';

  @override
  String get vendorListingPackagesEmptyMessage =>
      'أضيفي باقة ليعرف العروسان ما تقدمينه.';

  @override
  String get vendorListingAddPackage => 'إضافة باقة';

  @override
  String get vendorListingEditPackage => 'تعديل الباقة';

  @override
  String get vendorListingPackageName => 'اسم الباقة';

  @override
  String get vendorListingPackageNameHint => 'مثال: تغطية اليوم الكامل';

  @override
  String get vendorListingPackageDescription => 'وصف مختصر';

  @override
  String get vendorListingPackageDescriptionHint => 'أول سطر سيراه العروسان';

  @override
  String get vendorListingPackagePrice => 'السعر الابتدائي (جنيه)';

  @override
  String get vendorListingPackageInclusions => 'ما تتضمنه الباقة';

  @override
  String get vendorListingPackageInclusionsHint => 'عنصر واحد في كل سطر';

  @override
  String get vendorListingDeletePackageTitle => 'حذف هذه الباقة؟';

  @override
  String get vendorListingDeletePackageMessage =>
      'ستتم إزالتها من قائمتك العامة.';

  @override
  String get vendorListingDeleteAction => 'حذف';

  @override
  String get vendorListingBusinessDetailsTitle => 'بيانات النشاط التجاري';

  @override
  String get vendorListingBusinessName => 'اسم النشاط التجاري';

  @override
  String get vendorListingCategory => 'الفئة';

  @override
  String get vendorListingCity => 'المدينة / المنطقة';

  @override
  String get vendorListingCityHint => 'مثال: الزمالك، القاهرة';

  @override
  String get vendorListingStartingPrice => 'السعر الابتدائي (جنيه)';

  @override
  String get vendorListingDescription => 'عن نشاطك التجاري';

  @override
  String get vendorListingDescriptionHint => 'أخبري العروسين بما يميز خدمتك';

  @override
  String get vendorListingSavedMessage => 'تم تحديث بيانات النشاط التجاري';

  @override
  String get vendorListingCategoryLockedNote =>
      'يتم تحديد الفئة عند إنشاء ملفك ولا يمكن تغييرها هنا.';

  @override
  String get vendorListingStartingPriceNote =>
      'يتم حساب هذا تلقائيًا من أرخص باقة لديك.';

  @override
  String get vendorSetupTitle => 'أنشئ ملف نشاطك التجاري';

  @override
  String get vendorSetupSubtitle =>
      'أخبر العرائس والعرسان بما تقدمه قبل ظهور ملفك للعامة.';

  @override
  String get vendorSetupCategoryHint => 'اختر فئتك';

  @override
  String get vendorSetupCategoryRequired => 'يرجى اختيار فئة';

  @override
  String get vendorSetupCity => 'المدينة / المنطقة';

  @override
  String get vendorSetupCityHint => 'مثال: الزمالك، القاهرة';

  @override
  String get vendorSetupBio => 'عن نشاطك التجاري';

  @override
  String get vendorSetupBioHint => 'أخبر العرائس والعرسان بما يميز خدمتك';

  @override
  String get vendorSetupSubmit => 'إنشاء ملفي';

  @override
  String get vendorSetupError => 'تعذر إنشاء ملفك. يرجى المحاولة مرة أخرى.';

  @override
  String get vendorProfileSubscription => 'الاشتراك';

  @override
  String get subscriptionMyPlanTitle => 'باقتي';

  @override
  String get subscriptionCurrentPlanBadge => 'الباقة الحالية';

  @override
  String subscriptionTrialDaysRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أيام متبقية في الفترة التجريبية',
      one: 'يوم واحد متبقٍ في الفترة التجريبية',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionComparePlans => 'مقارنة الباقات';

  @override
  String get subscriptionPlansTitle => 'اختر باقتك';

  @override
  String get subscriptionMonthly => '/ شهريًا';

  @override
  String get subscriptionYearly => '/ سنويًا';

  @override
  String get subscriptionUnlimited => 'غير محدود';

  @override
  String subscriptionMaxPackages(String count) {
    return '$count باقات';
  }

  @override
  String subscriptionMaxPortfolioItems(String count) {
    return '$count صور معرض';
  }

  @override
  String get subscriptionSwitchAction => 'التبديل إلى هذه الباقة';

  @override
  String get subscriptionSwitchConfirmTitle => 'تبديل الباقة؟';

  @override
  String get subscriptionSwitchConfirmMessage =>
      'ستُطبَّق باقتك الجديدة فورًا.';

  @override
  String get subscriptionSwitchSuccess => 'تم تحديث الباقة';

  @override
  String get subscriptionSwitchError =>
      'تعذر تبديل باقتك. يرجى المحاولة مرة أخرى.';

  @override
  String get subscriptionHistoryTitle => 'سجل الباقات';

  @override
  String get vendorReviewsWriteAction => 'اكتب تقييمًا';

  @override
  String get vendorReviewsWriteTitle => 'قيّم تجربتك';

  @override
  String get vendorReviewsRatingLabel => 'تقييمك';

  @override
  String get vendorReviewsRatingRequired => 'يرجى اختيار تقييم';

  @override
  String get vendorReviewsCommentLabel => 'مراجعتك';

  @override
  String get vendorReviewsCommentHint => 'شارك تجربتك مع هذا المورد';

  @override
  String get vendorReviewsSubmitAction => 'إرسال التقييم';

  @override
  String get vendorReviewsSubmitSuccess => 'شكرًا على تقييمك!';

  @override
  String get vendorReviewsSubmitError =>
      'تعذر إرسال تقييمك. يرجى المحاولة مرة أخرى.';

  @override
  String get vendorReviewsEditTitle => 'تعديل تقييمك';

  @override
  String get vendorReviewsEditAction => 'تعديل';

  @override
  String get vendorReviewsDeleteTitle => 'حذف تقييمك؟';

  @override
  String get vendorReviewsDeleteMessage =>
      'هذا يحذف تقييمك لهذا المورد نهائيًا.';

  @override
  String get vendorReviewsDeleteAction => 'حذف';

  @override
  String get vendorReviewsDeleteError =>
      'تعذر حذف تقييمك. يرجى المحاولة مرة أخرى.';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsMarkAllRead => 'تعليم الكل كمقروء';

  @override
  String get notificationsEmptyTitle => 'لا توجد إشعارات بعد';

  @override
  String get notificationsEmptyMessage =>
      'سنعلمكِ عندما يحتاج شيء ما إلى انتباهك.';

  @override
  String get notificationSentTitle => 'تم إرسال طلب الحجز';

  @override
  String notificationSentBody(String vendorName) {
    return 'طلبك إلى $vendorName في الطريق — هنبلغك لما يردّوا.';
  }

  @override
  String get notificationAcceptedTitle => 'تم قبول طلب الحجز';

  @override
  String notificationAcceptedBody(String vendorName, String date) {
    return '$vendorName وافق على طلبك بتاريخ $date.';
  }

  @override
  String get notificationRejectedTitle => 'تم رفض طلب الحجز';

  @override
  String notificationRejectedBody(String vendorName) {
    return '$vendorName رفض طلبك. استكشفي موردين تانيين لموعدك.';
  }

  @override
  String get notificationIncomingTitle => 'طلب حجز جديد';

  @override
  String notificationIncomingBody(
    String customerName,
    String packageName,
    String date,
  ) {
    return '$customerName طلب $packageName بتاريخ $date.';
  }

  @override
  String get notificationVendorAcceptedTitle => 'وافقت على حجز';

  @override
  String notificationVendorAcceptedBody(String customerName, String date) {
    return 'أكّدت طلب $customerName بتاريخ $date.';
  }

  @override
  String get notificationVendorRejectedTitle => 'رفضت حجز';

  @override
  String notificationVendorRejectedBody(String customerName) {
    return 'رفضت طلب $customerName.';
  }

  @override
  String get adminPanelTitle => 'لوحة التحكم';

  @override
  String get adminNavDashboard => 'الرئيسية';

  @override
  String get adminNavVendors => 'الموردون';

  @override
  String get adminNavUsers => 'المستخدمون';

  @override
  String get adminNavBookings => 'الحجوزات';

  @override
  String get adminNavReviews => 'التقييمات';

  @override
  String get adminNavCategories => 'الفئات';

  @override
  String get adminNavPlans => 'باقات الاشتراك';

  @override
  String get adminNavAnalytics => 'التحليلات';

  @override
  String get adminNavSettings => 'الإعدادات';

  @override
  String get adminDashboardWelcome => 'نظرة عامة على المنصة';

  @override
  String get adminDashboardEmptyTitle => 'لا توجد إحصائيات بعد';

  @override
  String get adminDashboardEmptyMessage =>
      'ستظهر عدادات المنصة هنا بمجرد توفر بيانات.';

  @override
  String get adminDashboardQuickLinks => 'روابط سريعة';

  @override
  String get adminCategoriesEmptyTitle => 'لا توجد فئات بعد';

  @override
  String get adminCategoriesEmptyMessage =>
      'أضف فئة ليتمكن الموردون من الإدراج تحتها.';

  @override
  String get adminCategoryAddAction => 'إضافة فئة';

  @override
  String get adminCategoryAddTitle => 'إضافة فئة';

  @override
  String get adminCategoryEditTitle => 'تعديل الفئة';

  @override
  String get adminCategoryNameLabel => 'اسم الفئة';

  @override
  String get adminCategoryNameHint => 'مثال: قاعة أفراح';

  @override
  String get adminCategoryActiveLabel => 'نشطة';

  @override
  String get adminCategoryActiveSubtitle =>
      'الفئات غير النشطة مخفية عن العملاء';

  @override
  String get adminCategorySaveAction => 'حفظ الفئة';

  @override
  String get adminCategorySavedMessage => 'تم حفظ الفئة';

  @override
  String get adminCategoryDeletedMessage => 'تم حذف الفئة';

  @override
  String get adminCategoryErrorMessage =>
      'تعذر حفظ هذه الفئة. يرجى المحاولة مرة أخرى.';

  @override
  String get adminCategoryDeleteTitle => 'حذف هذه الفئة؟';

  @override
  String get adminCategoryDeleteMessage =>
      'الموردون المدرجون بها بالفعل لن يتأثروا، لكنها لن تقبل موردين جدد بعد الآن.';

  @override
  String get adminCategoryDeleteAction => 'حذف';

  @override
  String get adminCategoryInactiveBadge => 'غير نشطة';

  @override
  String get adminVendorsEmptyTitle => 'لم يتم العثور على موردين';

  @override
  String get adminVendorsEmptyMessage => 'جرّب تعديل عوامل التصفية.';

  @override
  String get adminVendorsFilterTitle => 'تصفية الموردين';

  @override
  String get adminVendorsFilterCategory => 'الفئة';

  @override
  String get adminVendorsFilterCity => 'المدينة';

  @override
  String get adminVendorsFilterCityHint => 'مثال: القاهرة';

  @override
  String get adminVendorsFilterVerifiedOnly => 'الموثّقون فقط';

  @override
  String get adminVendorsFilterAll => 'الكل';

  @override
  String get adminVendorsApplyFilters => 'تطبيق عوامل التصفية';

  @override
  String get adminVendorVerifiedBadge => 'موثّق';

  @override
  String get adminVendorUnverifiedBadge => 'غير موثّق';

  @override
  String get adminVendorVerifyAction => 'توثيق المورد';

  @override
  String get adminVendorUnverifyAction => 'إلغاء توثيق المورد';

  @override
  String get adminVendorDetailTitle => 'تفاصيل المورد';

  @override
  String get adminVendorContactSection => 'بيانات التواصل';

  @override
  String get adminVendorSubscriptionSection => 'الاشتراك';

  @override
  String get adminVendorNoSubscription =>
      'لا يوجد اشتراك نشط — على الباقة المجانية افتراضيًا.';

  @override
  String get adminVendorAssignPlanAction => 'تعيين باقة';

  @override
  String get adminVendorCancelSubscriptionAction => 'إلغاء الاشتراك';

  @override
  String get adminVendorCancelSubscriptionTitle => 'إلغاء هذا الاشتراك؟';

  @override
  String get adminVendorCancelSubscriptionMessage =>
      'سيعود المورد إلى حدود الباقة المجانية.';

  @override
  String get adminVendorDeleteSubscriptionAction => 'حذف السجل';

  @override
  String get adminVendorDeleteSubscriptionTitle => 'حذف سجل الاشتراك هذا؟';

  @override
  String get adminVendorDeleteSubscriptionMessage =>
      'يحذفه نهائيًا — يختلف عن الإلغاء الذي يكتفي بتعليمه كغير نشط.';

  @override
  String get adminVendorSubscriptionCancelledMessage => 'تم إلغاء الاشتراك';

  @override
  String get adminVendorSubscriptionDeletedMessage => 'تم حذف سجل الاشتراك';

  @override
  String get adminSelectPlanTitle => 'اختر باقة';

  @override
  String get adminUsersEmptyTitle => 'لم يتم العثور على مستخدمين';

  @override
  String get adminUsersEmptyMessage => 'جرّب تعديل عوامل التصفية.';

  @override
  String get adminUsersFilterTitle => 'تصفية المستخدمين';

  @override
  String get adminUsersSearchHint => 'ابحث بالاسم أو البريد الإلكتروني';

  @override
  String get adminUsersFilterRole => 'الدور';

  @override
  String get adminUsersFilterActive => 'النشطون فقط';

  @override
  String get adminUserDetailTitle => 'تفاصيل المستخدم';

  @override
  String get adminUserRoleLabel => 'الدور';

  @override
  String get adminUserActiveLabel => 'الحساب نشط';

  @override
  String get adminUserActiveSubtitle =>
      'المستخدمون المعطّلون لا يمكنهم تسجيل الدخول';

  @override
  String get adminUserRoleChangedMessage => 'تم تحديث الدور';

  @override
  String get adminRoleCustomer => 'عميل';

  @override
  String get adminRoleVendor => 'مورد';

  @override
  String get adminRoleAdmin => 'مسؤول';

  @override
  String get adminBookingsEmptyTitle => 'لم يتم العثور على حجوزات';

  @override
  String get adminBookingsEmptyMessage => 'جرّب تعديل عوامل التصفية.';

  @override
  String get adminBookingsFilterTitle => 'تصفية الحجوزات';

  @override
  String get adminBookingsFilterStatus => 'الحالة';

  @override
  String get adminBookingStatusPending => 'قيد الانتظار';

  @override
  String get adminBookingStatusAccepted => 'مقبول';

  @override
  String get adminBookingStatusRejected => 'مرفوض';

  @override
  String get adminBookingStatusCancelled => 'ملغي';

  @override
  String get adminBookingAcceptAction => 'قبول';

  @override
  String get adminBookingRejectAction => 'رفض';

  @override
  String get adminReviewsEmptyTitle => 'لم يتم العثور على تقييمات';

  @override
  String get adminReviewsEmptyMessage => 'جرّب تعديل عوامل التصفية.';

  @override
  String get adminReviewsFilterTitle => 'تصفية التقييمات';

  @override
  String get adminReviewsFilterHiddenOnly => 'المخفية فقط';

  @override
  String get adminReviewHiddenBadge => 'مخفي';

  @override
  String get adminReviewUnknownVendor => 'مورد';

  @override
  String get adminReviewHideAction => 'إخفاء';

  @override
  String get adminReviewUnhideAction => 'إظهار';

  @override
  String get adminReviewDeleteAction => 'حذف';

  @override
  String get adminReviewDeleteTitle => 'حذف هذا التقييم؟';

  @override
  String get adminReviewDeleteMessage =>
      'هذا يحذفه نهائيًا — يمكن للعميل نشر تقييم جديد.';

  @override
  String get adminSettingsGeneralSection => 'المنصة';

  @override
  String get adminSettingsRegistrationEnabled => 'تفعيل التسجيل';

  @override
  String get adminSettingsRegistrationEnabledSubtitle =>
      'السماح بإنشاء حسابات جديدة';

  @override
  String get adminSettingsMaintenanceMode => 'وضع الصيانة';

  @override
  String get adminSettingsMaintenanceModeSubtitle =>
      'يحجب حركة المرور غير الإدارية — استخدمه بحذر';

  @override
  String get adminSettingsSubscriptionRequired => 'الاشتراك مطلوب';

  @override
  String get adminSettingsSubscriptionRequiredSubtitle =>
      'يجب أن يكون الموردون على باقة مدفوعة للإدراج';

  @override
  String get adminSettingsFreeMode => 'الوضع المجاني';

  @override
  String get adminSettingsFreeModeSubtitle =>
      'كل مورد يحصل على وصول كامل دون تكلفة';

  @override
  String get adminSettingsTrialSection => 'الفترة التجريبية';

  @override
  String get adminSettingsTrialEnabled => 'تفعيل الفترة التجريبية';

  @override
  String get adminSettingsTrialEnabledSubtitle =>
      'يحصل الموردون الجدد على فترة تجريبية مجانية';

  @override
  String get adminSettingsTrialDays => 'مدة الفترة التجريبية (أيام)';

  @override
  String get adminSettingsVendorSection => 'الموردون';

  @override
  String get adminSettingsVendorAutoVerification => 'توثيق تلقائي للموردين';

  @override
  String get adminSettingsVendorAutoVerificationSubtitle =>
      'تخطي المراجعة اليدوية عند التسجيل';

  @override
  String get adminSettingsFeaturedSearch => 'تعزيز الظهور المميز';

  @override
  String get adminSettingsFeaturedSearchSubtitle =>
      'موردو الباقة المميزة يظهرون أعلى في نتائج البحث';

  @override
  String get adminSettingsUploadSection => 'الرفع';

  @override
  String get adminSettingsUploadMaxSizeMb =>
      'الحد الأقصى لحجم الرفع (ميجابايت)';

  @override
  String get adminSettingsUploadAllowedTypes => 'أنواع الملفات المسموحة';

  @override
  String get adminSettingsUploadAllowedTypesHint =>
      'مفصولة بفواصل، مثال: image/jpeg, image/png';

  @override
  String get adminSettingsSaveAction => 'حفظ الإعدادات';

  @override
  String get adminSettingsSavedMessage => 'تم حفظ الإعدادات';

  @override
  String get adminSettingsErrorMessage =>
      'تعذر حفظ الإعدادات. يرجى المحاولة مرة أخرى.';

  @override
  String get adminAnalyticsRevenue => 'الإيرادات';

  @override
  String get adminAnalyticsGrowth => 'النمو';

  @override
  String get adminAnalyticsBookings => 'الحجوزات';

  @override
  String get adminAnalyticsReviews => 'التقييمات';

  @override
  String get adminAnalyticsConversion => 'التحويل';

  @override
  String get adminAnalyticsTopCategories => 'أفضل الفئات';

  @override
  String get adminAnalyticsDateRange => 'النطاق الزمني';

  @override
  String get adminAnalyticsNoDataTitle => 'لا يوجد ما يُعرض';

  @override
  String get adminAnalyticsNoData => 'لا توجد بيانات لهذا النطاق بعد.';

  @override
  String get adminAnalyticsFrom => 'من';

  @override
  String get adminAnalyticsTo => 'إلى';

  @override
  String get adminPlansEmptyTitle => 'لا توجد باقات بعد';

  @override
  String get adminPlansEmptyMessage => 'أضف باقة ليشترك بها الموردون.';

  @override
  String get adminPlanAddAction => 'إضافة باقة';

  @override
  String get adminPlanAddTitle => 'إضافة باقة';

  @override
  String get adminPlanEditTitle => 'تعديل الباقة';

  @override
  String get adminPlanNameLabel => 'اسم الباقة';

  @override
  String get adminPlanDescriptionLabel => 'الوصف';

  @override
  String get adminPlanPriceLabel => 'السعر (جنيه / شهريًا)';

  @override
  String get adminPlanPriorityLabel => 'درجة الأولوية';

  @override
  String get adminPlanMaxPackagesLabel =>
      'الحد الأقصى للباقات (اتركه فارغًا = غير محدود)';

  @override
  String get adminPlanMaxPortfolioLabel =>
      'الحد الأقصى لصور المعرض (اتركه فارغًا = غير محدود)';

  @override
  String get adminPlanFeaturedLabel => 'شارة مميزة';

  @override
  String get adminPlanFeaturedSubtitle => 'تُظهر شارة ذهبية في مقارنة الباقات';

  @override
  String get adminPlanActiveLabel => 'نشطة';

  @override
  String get adminPlanActiveSubtitle => 'الباقات غير النشطة مخفية عن الموردين';

  @override
  String get adminPlanSaveAction => 'حفظ الباقة';

  @override
  String get adminPlanSavedMessage => 'تم حفظ الباقة';

  @override
  String get adminPlanDeletedMessage => 'تم حذف الباقة';

  @override
  String get adminPlanErrorMessage =>
      'تعذر حفظ هذه الباقة. يرجى المحاولة مرة أخرى.';

  @override
  String get adminPlanDeleteTitle => 'حذف هذه الباقة؟';

  @override
  String get adminPlanDeleteMessage =>
      'سيُرفض الحذف إذا كان أي مورد ما زال مشتركًا بها.';

  @override
  String get adminPlanDeleteAction => 'حذف';

  @override
  String get adminPlanInactiveBadge => 'غير نشطة';

  @override
  String get adminPlanActivateAction => 'تفعيل';

  @override
  String get adminPlanDeactivateAction => 'إلغاء التفعيل';

  @override
  String get adminGenericErrorMessage => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get adminApplyAction => 'تطبيق';

  @override
  String get adminClearFiltersAction => 'مسح';
}
