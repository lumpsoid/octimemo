// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get overviewInputSearchHint => 'Pesquisar';

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
  String get overviewNotificationDeleteText => 'Nota foi excluída';

  @override
  String get overviewNotificationDeleteUndoButton => 'Desfazer';

  @override
  String get overviewGlobalInputHint => 'Digite sua nota...';

  @override
  String get overviewNotificationEmptyText => 'Campo de texto está vazio';

  @override
  String get overviewNoNotesText => 'Sem notas';

  @override
  String get overviewImportOptionText => 'Importar';

  @override
  String get overviewExportOptionText => 'Exportar';

  @override
  String get overviewTitleText => 'Notas';

  @override
  String get overviewTitleFilteredText => 'Notas Filtradas';
}
