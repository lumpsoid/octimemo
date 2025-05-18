// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get overviewInputSearchHint => 'Cerca';

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
  String get overviewNotificationDeleteText => 'Nota eliminata';

  @override
  String get overviewNotificationDeleteUndoButton => 'Annulla';

  @override
  String get overviewGlobalInputHint => 'Inserisci la tua nota...';

  @override
  String get overviewNotificationEmptyText => 'Il campo di testo è vuoto';

  @override
  String get overviewNoNotesText => 'Nessuna nota';

  @override
  String get overviewImportOptionText => 'Importa';

  @override
  String get overviewExportOptionText => 'Esporta';

  @override
  String get overviewTitleText => 'Note';

  @override
  String get overviewTitleFilteredText => 'Note filtrate';
}
