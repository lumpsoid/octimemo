// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get overviewInputSearchHint => 'Поиск';

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
  String get overviewNotificationDeleteText => 'Заметка была удалена';

  @override
  String get overviewNotificationDeleteUndoButton => 'Отменить';

  @override
  String get overviewGlobalInputHint => 'Введите вашу заметку...';

  @override
  String get overviewNotificationEmptyText => 'Поле ввода пустое';

  @override
  String get overviewNoNotesText => 'Нет заметок';

  @override
  String get overviewImportOptionText => 'Импорт';

  @override
  String get overviewExportOptionText => 'Экспорт';

  @override
  String get overviewTitleText => 'Заметки';

  @override
  String get overviewTitleFilteredText => 'Отфильтрованные заметки';
}
