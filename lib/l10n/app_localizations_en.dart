// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get overviewInputSearchHint => 'Search';

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
  String get overviewNotificationDeleteText => 'Note was deleted';

  @override
  String get overviewNotificationDeleteUndoButton => 'Undo';

  @override
  String get overviewGlobalInputHint => 'Enter your note...';

  @override
  String get overviewNotificationEmptyText => 'Text field is empty';

  @override
  String get overviewNoNotesText => 'No notes';

  @override
  String get overviewImportOptionText => 'Import';

  @override
  String get overviewExportOptionText => 'Export';

  @override
  String get overviewTitleText => 'Memos';

  @override
  String get overviewTitleFilteredText => 'Filtered Memos';
}
