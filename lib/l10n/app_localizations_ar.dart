// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get overviewInputSearchHint => 'بحث';

  @override
  String get overviewOptionsMenuLabel => 'Options';

  @override
  String get overviewDatePickerLabel => 'Filter by date';

  @override
  String get search => 'Search';

  @override
  String get close => 'Close';

  @override
  String get overviewNotificationNoteCopied =>
      'Note text copied to the clipboard';

  @override
  String get overviewNotificationDeleteText => 'تم حذف الملاحظة';

  @override
  String get overviewNotificationDeleteUndoButton => 'تراجع';

  @override
  String get overviewGlobalInputHint => 'أدخل ملاحظتك...';

  @override
  String get overviewNotificationEmptyText => 'حقل النص فارغ';

  @override
  String get overviewNoNotesText => 'لا توجد ملاحظات';

  @override
  String get overviewImportOptionText => 'استيراد';

  @override
  String get overviewExportOptionText => 'تصدير';

  @override
  String get overviewTitleText => 'ملاحظات';

  @override
  String get overviewTitleFilteredText => 'ملاحظات مفلترة';
}
