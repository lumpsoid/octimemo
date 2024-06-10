import 'package:flutter/material.dart';
import 'package:memocti/notes_overview/bloc/notes_overview_bloc.dart';
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
      child: GestureDetector(
        onLongPressStart: (details) => _showMenu(context, details),
        onTap: () => context.read<NotesOverviewBloc>().add(
              NotesOverviewNoteEdit(note),
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
    );
  }

  void _showMenu(BuildContext context, LongPressStartDetails details) {
    final overlay = Overlay.of(context).context.findRenderObject();
    if (overlay == null) {
      return;
    }
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        details.globalPosition &
            const Size(40, 40), // smaller rect, the touch area
        Offset.zero & overlay.semanticBounds.size,
      ),
      shape: Border.all(color: Theme.of(context).focusColor),
      items: [
        PopupMenuItem(
          child: const Text('Copy'),
          onTap: () {
            context.read<NotesOverviewBloc>().add(
                  NotesOverviewToClipboard(note.body),
                );
          },
        ),
        PopupMenuItem(
          child: const Text('Delete'),
          onTap: () {
            context.read<NotesOverviewBloc>().add(
                  NotesOverviewNoteDelete(
                    note.id,
                  ),
                );
          },
        ),
      ],
    );
  }
}
