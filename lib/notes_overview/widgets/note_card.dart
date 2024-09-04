import 'package:flutter/material.dart';
import 'package:octimemo/notes_overview/bloc/notes_overview_bloc.dart';
import 'package:octimemo/notes_overview/notes_overview.dart';
import 'package:note_sqflite_api/note_sqflite_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({required this.note, super.key});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Dismissible(
        resizeDuration: const Duration(microseconds: 1),
        // drag to the right (edit)
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15.0),
          child: const Icon(
            Icons.edit_outlined,
            color: Colors.green,
          ),
        ),
        // drag to the left (delete)
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 15.0),
          child: const Icon(
            Icons.delete_outline,
            color: Colors.red,
          ),
        ),
        confirmDismiss: (DismissDirection direction) async {
          // edit
          if (direction == DismissDirection.startToEnd) {
            context.read<NotesOverviewBloc>().add(
                  NotesOverviewNoteEdit(note),
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
            context.read<NotesOverviewBloc>().add(
                  NotesOverviewNoteDelete(note.id),
                );
          }
        },
        key: Key(note.id.toString()),
        child: InkWell(
          onLongPress: () => context.read<NotesOverviewBloc>().add(
                NotesOverviewToClipboard(note.body),
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.getDateCreatedFormatted(),
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
              Text(
                note.body,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
