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
}
