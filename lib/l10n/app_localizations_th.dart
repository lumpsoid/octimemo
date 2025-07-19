// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get overviewInputSearchHint => 'ค้นหา';

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
  String get overviewNotificationDeleteText => 'บันทึกถูกลบ';

  @override
  String get overviewNotificationDeleteUndoButton => 'เลิกทำ';

  @override
  String get overviewGlobalInputHint => 'กรอกบันทึกของคุณ...';

  @override
  String get overviewNotificationEmptyText => 'ช่องข้อความว่างเปล่า';

  @override
  String get overviewNoNotesText => 'ไม่มีบันทึก';

  @override
  String get overviewImportOptionText => 'นำเข้า';

  @override
  String get overviewExportOptionText => 'ส่งออก';

  @override
  String get overviewTitleText => 'บันทึกย่อ';

  @override
  String get overviewTitleFilteredText => 'บันทึกย่อที่กรองแล้ว';
}
