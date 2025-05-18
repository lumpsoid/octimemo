// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get overviewInputSearchHint => 'Pretraga';

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
  String get overviewNotificationDeleteText => 'Beleška je obrisana';

  @override
  String get overviewNotificationDeleteUndoButton => 'Poništi';

  @override
  String get overviewGlobalInputHint => 'Unesite svoju belešku...';

  @override
  String get overviewNotificationEmptyText => 'Polje za tekst je prazno';

  @override
  String get overviewNoNotesText => 'Nema beleški';

  @override
  String get overviewImportOptionText => 'Uvezi';

  @override
  String get overviewExportOptionText => 'Izvezi';

  @override
  String get overviewTitleText => 'Beleške';

  @override
  String get overviewTitleFilteredText => 'Filtrirane beleške';
}
