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
  String get homeSeeAll => 'عرض الكل';

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
  String get categoriesScreenSubtitle =>
      'اكتشفي كل نوع من مزودي الخدمة ليوم زفافكِ.';

  @override
  String get categoriesErrorMessage => 'تعذّر تحميل الفئات الآن.';

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
}
