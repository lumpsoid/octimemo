// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get overviewInputSearchHint => 'Suche';

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
  String get overviewNotificationDeleteText => 'Notiz wurde gelöscht';

  @override
  String get overviewNotificationDeleteUndoButton => 'Rückgängig';

  @override
  String get overviewGlobalInputHint => 'Geben Sie Ihre Notiz ein...';

  @override
  String get overviewNotificationEmptyText => 'Textfeld ist leer';

  @override
  String get overviewNoNotesText => 'Keine Notizen';

  @override
  String get overviewImportOptionText => 'Importieren';

  @override
  String get overviewExportOptionText => 'Exportieren';

  @override
  String get overviewTitleText => 'Notizen';

  @override
  String get overviewTitleFilteredText => 'Gefilterte Notizen';
}
