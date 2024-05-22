import 'package:flutter/material.dart';
import 'package:memocti/notes_overview/notes_overview.dart';
import 'package:note_sqflite_api/note_sqflite_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({required this.note, super.key});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              context.read<NotesOverviewBloc>().add(
                    NotesOverviewNoteDelete(
                      note.id,
                    ),
                  );
            },
          ),
          Expanded(
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
                GestureDetector(
                  onLongPress: () async {
                    context.read<NotesOverviewBloc>().add(
                          NotesOverviewToClipboard(note.body),
                        );
                  },
                  child: Text(
                    note.body,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              context.read<NotesOverviewBloc>().add(
                    NotesOverviewNoteEdit(
                      note,
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}
