// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get overviewInputSearchHint => 'Zoeken';

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
  String get overviewNotificationDeleteText => 'Notitie is verwijderd';

  @override
  String get overviewNotificationDeleteUndoButton => 'Ongedaan maken';

  @override
  String get overviewGlobalInputHint => 'Voer uw notitie in...';

  @override
  String get overviewNotificationEmptyText => 'Tekstveld is leeg';

  @override
  String get overviewNoNotesText => 'Geen notities';

  @override
  String get overviewImportOptionText => 'Importeren';

  @override
  String get overviewExportOptionText => 'Exporteren';

  @override
  String get overviewTitleText => 'Notities';

  @override
  String get overviewTitleFilteredText => 'Gefilterde notities';
}
