// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get overviewInputSearchHint => 'Recherche';

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
  String get overviewNotificationDeleteText => 'La note a été supprimée';

  @override
  String get overviewNotificationDeleteUndoButton => 'Annuler';

  @override
  String get overviewGlobalInputHint => 'Entrez votre note...';

  @override
  String get overviewNotificationEmptyText => 'Le champ de texte est vide';

  @override
  String get overviewNoNotesText => 'Pas de notes';

  @override
  String get overviewImportOptionText => 'Importer';

  @override
  String get overviewExportOptionText => 'Exporter';

  @override
  String get overviewTitleText => 'Notes';

  @override
  String get overviewTitleFilteredText => 'Notes filtrées';
}
