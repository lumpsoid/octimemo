import 'dart:async';

import 'package:flutter/material.dart';
import 'package:octimemo/l10n/l10n.dart';
import 'package:octimemo/notes_overview/notes_overview.dart';
import 'package:octimemo/notes_overview/widgets/action_row.dart';
import 'package:octimemo/service_locator/service_locator.dart';

class NotesOverviewScreen extends StatefulWidget {
  const NotesOverviewScreen({super.key});

  @override
  State<NotesOverviewScreen> createState() => _NotesOverviewScreenState();
}

class _NotesOverviewScreenState extends State<NotesOverviewScreen> {
  final viewModel = getIt<NotesOverviewViewModel>();
  late StreamSubscription<NotesOverviewEffect?> _effect;

  @override
  void initState() {
    super.initState();
    _effect = viewModel.effect.listen(_processEffect);
    viewModel.init();
  }

  @override
  void dispose() {
    _effect.cancel();
    viewModel.dispose();
    super.dispose();
  }

  void _processEffect(NotesOverviewEffect? effect) {
    final l10n = context.l10n;
    final textTheme = TextTheme.of(context);
    final snackbarTextStyle = textTheme.bodyLarge?.copyWith(
      color: Theme.of(context).colorScheme.onInverseSurface,
    );

    switch (effect) {
      case NoteDeletedEffect():
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              onVisible: viewModel.clearEffect,
              action: SnackBarAction(
                label: l10n.overviewNotificationDeleteUndoButton,
                onPressed: viewModel.restoreNote,
              ),
              content: Text(
                l10n.overviewNotificationDeleteText,
                style: snackbarTextStyle,
              ),
            ),
          );
      case ShowMessageEvent():
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              onVisible: viewModel.clearEffect,
              content: Text(
                effect.message,
                style: snackbarTextStyle,
              ),
            ),
          );
      case CopiedToClipboardEvent():
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              onVisible: viewModel.clearEffect,
              content: Text(
                l10n.overviewNotificationNoteCopied,
                style: snackbarTextStyle,
              ),
            ),
          );
      case EmptyGlobalInputEffect():
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              onVisible: viewModel.clearEffect,
              content: Text(
                context.l10n.overviewNotificationEmptyText,
                style: snackbarTextStyle,
              ),
            ),
          );
      case OpenMenuEffect():
        _showOptionsBottomSheet(context);

      case ErrorEvent():
        break;

      default:
        break;
    }
  }

  void _showOptionsBottomSheet(BuildContext context) {
    final l10n = context.l10n;

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.download),
                title: Text(l10n.overviewImportOptionText),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.importNotes();
                },
              ),
              ListTile(
                leading: const Icon(Icons.upload),
                title: Text(l10n.overviewExportOptionText),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.exportNotes();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: viewModel.canPop,
      builder: (context, canPop, child) {
        return PopScope(
          canPop: canPop,
          onPopInvokedWithResult: viewModel.onPop,
          child: child!,
        );
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: ValueListenableBuilder<NotesOverviewStatus>(
            valueListenable: viewModel.status,
            builder: (context, status, _) {
              if (status == NotesOverviewStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              final width = MediaQuery.sizeOf(context).width * 0.6;
              return Column(
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: NotesList(),
                    ),
                  ),
                  Container(
                    height: 1,
                    width: width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: ColorScheme.of(context).onSurface.withAlpha(
                                76,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const GlobalInputField(),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: ColorScheme.of(context).surfaceContainerLow,
                    ),
                    child: const SafeArea(
                      top: false,
                      left: false,
                      right: false,
                      child: ActionRowOrFilter(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
