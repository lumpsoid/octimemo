import 'package:flutter/material.dart';
import 'package:memocti/notes_overview/bloc/notes_overview_bloc.dart';
import 'package:memocti/src/note_manager.dart';
import 'package:note_sqflite_api/note_sqflite_api.dart';
import 'package:provider/provider.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({required this.note, super.key});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        context.read<NotesOverviewBloc>().add(
              NotesOverviewToClipboard(note.body),
            );
      },
      child: Dismissible(
        // drag to the right (edit)
        background: Container(
          color: Colors.blue[50],
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 30.0),
          child: const Icon(Icons.edit_outlined),
        ),
        // drag to the left (delete)
        dismissThresholds: const {
          DismissDirection.startToEnd: 0.6,
          DismissDirection.endToStart: 0.6,
        },
        secondaryBackground: Container(
          color: Colors.red[50],
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 30.0),
          child: const Icon(Icons.delete_outline),
        ),
        confirmDismiss: (DismissDirection direction) async {
          if (direction == DismissDirection.startToEnd) {
            NoteManager manager = context.read<NoteManager>();
            if (manager.editingIndex != null) {
              return false;
            }
            manager.startEditing(note.id);
            return false;
          }
          // delete
          if (direction == DismissDirection.endToStart) {
            return true;
          }
          return false;
        },
        onDismissed: (DismissDirection direction) async {
          NoteManager manager =
              Provider.of<NoteManager>(context, listen: false);
          // edit
          // if (direction == DismissDirection.startToEnd) {
          //   action = 'edited';
          //   await manager.editNote(index, 'ITSWORKED');
          // }
          // delete
          if (direction == DismissDirection.endToStart) {
            await manager.deleteNote(note);
          }
        },
        key: Key(note.id.toString()),
        child: Text(
          note.body,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
