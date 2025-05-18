// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get overviewInputSearchHint => 'Пошук';

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
  String get overviewNotificationDeleteText => 'Нотатку видалено';

  @override
  String get overviewNotificationDeleteUndoButton => 'Скасувати';

  @override
  String get overviewGlobalInputHint => 'Введіть вашу нотатку...';

  @override
  String get overviewNotificationEmptyText => 'Текстове поле порожнє';

  @override
  String get overviewNoNotesText => 'Немає нотаток';

  @override
  String get overviewImportOptionText => 'Імпортувати';

  @override
  String get overviewExportOptionText => 'Експортувати';

  @override
  String get overviewTitleText => 'Нотатки';

  @override
  String get overviewTitleFilteredText => 'Відфільтровані нотатки';
}
