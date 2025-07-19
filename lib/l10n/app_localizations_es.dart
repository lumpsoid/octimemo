// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get overviewInputSearchHint => 'Buscar';

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
  String get overviewNotificationDeleteText => 'La nota fue eliminada';

  @override
  String get overviewNotificationDeleteUndoButton => 'Deshacer';

  @override
  String get overviewGlobalInputHint => 'Introduce tu nota...';

  @override
  String get overviewNotificationEmptyText => 'El campo de texto está vacío';

  @override
  String get overviewNoNotesText => 'No hay notas';

  @override
  String get overviewImportOptionText => 'Importar';

  @override
  String get overviewExportOptionText => 'Exportar';

  @override
  String get overviewTitleText => 'Notas';

  @override
  String get overviewTitleFilteredText => 'Notas filtradas';
}
