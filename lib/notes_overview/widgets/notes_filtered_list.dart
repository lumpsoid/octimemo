import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memocti/notes_overview/notes_overview.dart';

class NotesFilteredList extends StatelessWidget {
  const NotesFilteredList({super.key});

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
                  ? const Center(child: Text('Filter is empty.'))
                  : ListView.builder(
                      itemCount: state.filteredNotes.length,
                      itemBuilder: (context, index) {
                        return NoteCard(
                          note: state.filteredNotes[index],
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
