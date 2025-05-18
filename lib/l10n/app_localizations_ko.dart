// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get overviewInputSearchHint => '검색';

  @override
  String get overviewOptionsMenuLabel => 'Options';

  @override
  String get overviewDatePickerLabel => 'Filter by date';

  @override
  String get search => 'Search';

  @override
  String get close => 'Close';

  @override
  String get overviewNotificationNoteCopied => 'Note text copied to the clipboard';

  @override
  String get overviewNotificationDeleteText => '노트가 삭제되었습니다';

  @override
  String get overviewNotificationDeleteUndoButton => '실행 취소';

  @override
  String get overviewGlobalInputHint => '노트를 입력하세요...';

  @override
  String get overviewNotificationEmptyText => '텍스트 필드가 비어 있습니다';

  @override
  String get overviewNoNotesText => '노트가 없습니다';

  @override
  String get overviewImportOptionText => '가져오기';

  @override
  String get overviewExportOptionText => '내보내기';

  @override
  String get overviewTitleText => '메모';

  @override
  String get overviewTitleFilteredText => '필터된 메모';
}
