// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get overviewInputSearchHint => '搜索';

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
  String get overviewNotificationDeleteText => '笔记已删除';

  @override
  String get overviewNotificationDeleteUndoButton => '撤销';

  @override
  String get overviewGlobalInputHint => '输入你的笔记...';

  @override
  String get overviewNotificationEmptyText => '文本字段为空';

  @override
  String get overviewNoNotesText => '没有笔记';

  @override
  String get overviewImportOptionText => '导入';

  @override
  String get overviewExportOptionText => '导出';

  @override
  String get overviewTitleText => '笔记';

  @override
  String get overviewTitleFilteredText => '筛选笔记';
}
