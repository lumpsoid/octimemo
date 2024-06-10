import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memocti/notes_overview/notes_overview.dart';

class NotesList extends StatelessWidget {
  const NotesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesOverviewBloc, NotesOverviewState>(
      builder: (context, state) {
        if (state.status == NotesOverviewStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Expanded(
              child: state.notes.isEmpty
                  ? const Center(child: Text('No notes.'))
                  : ListView.builder(
                      itemCount: state.notes.length,
                      itemBuilder: (context, index) {
                        final reversedIndex = state.notes.length - 1 - index;
                        return NoteCard(
                          note: state.notes[reversedIndex],
                        );
                      },
                    ),
            ),
            const GlobalInputField(),
          ],
        );
      },
    );
  }
}
