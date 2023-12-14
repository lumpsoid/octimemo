import 'package:provider/provider.dart';
import 'note_manager.dart';

import 'note.dart' show Note;
import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final int index;
  final Note note;

  const NoteCard({required this.note, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        // drag to the right (edit)
        background: Container(
          color: Colors.blue[50],
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 30.0),
          child: const Icon(Icons.edit_outlined),
        ),
        // drag to the left (delete)
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
            manager.startEditing(index);
            return false;
          }
          // delete
          if (direction == DismissDirection.endToStart) {
            return true;
          }
          return false;
        },
        onDismissed: (DismissDirection direction) async {
          String message = '';
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
            message = 'Memo was deleted';
          }
          _showSnackBar(manager, context, message);
        },
        key: Key(note.id.toString()),
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: _buildDisplayCard()));
  }

  Future<void> _showSnackBar(
      NoteManager manager, BuildContext context, String message) async {
    if (manager.isSnackbarVisible) {
      return;
    }
    manager.isSnackbarVisible = true;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(message, style: const TextStyle(fontSize: 16.0)),
          duration: const Duration(seconds: 2),
        ))
        .closed
        .then((value) => manager.isSnackbarVisible = false);
  }

  Widget _buildDisplayCard() {
    return Text(note.body!, style: const TextStyle(fontSize: 16.0));
  }
}

class NoteCardLoading extends StatelessWidget {
  const NoteCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: const Text('...', style: TextStyle(fontSize: 16.0)));
  }
}
