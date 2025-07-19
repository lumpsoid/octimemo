// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get overviewInputSearchHint => '検索';

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
  String get overviewNotificationDeleteText => 'ノートが削除されました';

  @override
  String get overviewNotificationDeleteUndoButton => '元に戻す';

  @override
  String get overviewGlobalInputHint => 'ノートを入力...';

  @override
  String get overviewNotificationEmptyText => 'テキストフィールドが空です';

  @override
  String get overviewNoNotesText => 'ノートがありません';

  @override
  String get overviewImportOptionText => 'インポート';

  @override
  String get overviewExportOptionText => 'エクスポート';

  @override
  String get overviewTitleText => 'メモ';

  @override
  String get overviewTitleFilteredText => 'フィルタされたメモ';
}
