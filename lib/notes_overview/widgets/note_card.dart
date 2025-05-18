import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note_sqflite_api/note_sqflite_api.dart';
import 'package:octimemo/notes_overview/notes_overview.dart';
import 'package:octimemo/service_locator/service_locator.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({required this.note, super.key});

  final Note note;

  @override
  Widget build(BuildContext context) {
    final viewModel = getIt<NotesOverviewViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Dismissible(
        key: Key(note.id.toString()),
        resizeDuration: const Duration(milliseconds: 200),
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15),
          child: const Icon(
            Icons.edit_outlined,
            color: Colors.green,
          ),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 15),
          child: const Icon(
            Icons.delete_outline,
            color: Colors.red,
          ),
        ),
        confirmDismiss: (DismissDirection direction) async {
          // edit
          if (direction == DismissDirection.startToEnd) {
            unawaited(
              viewModel.startEditing(
                note.id,
                note.body,
              ),
            );
            return false;
          }
          // delete
          if (direction == DismissDirection.endToStart) {
            return true;
          }
          return false;
        },
        onDismissed: (DismissDirection direction) async {
          // edit
          // if (direction == DismissDirection.startToEnd) {
          // }
          // delete
          if (direction == DismissDirection.endToStart) {
            unawaited(viewModel.deleteNote(note.id));
          }
        },
        child: InkWell(
          borderRadius: BorderRadius.circular(3),
          overlayColor: WidgetStateProperty.all(
            Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(40),
          ),
          onLongPress: () => viewModel.copyToClipboard(note.body),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.getDateCreatedFormatted(),
                  style: TextTheme.of(context).bodySmall!.copyWith(
                        color: ColorScheme.of(context).secondary,
                      ),
                ),
                Text(
                  note.body,
                  style: TextTheme.of(context).bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
