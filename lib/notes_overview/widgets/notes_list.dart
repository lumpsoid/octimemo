import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:octimemo/notes_overview/notes_overview.dart';

class NotesList extends StatelessWidget {
  const NotesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesOverviewBloc, NotesOverviewState>(
      builder: (context, state) {
        IList<Note> notes;

        if (state.searchStatus || state.datePicked != 0) {
          notes = state.filteredNotes;
        } else {
          notes = state.notes;
        } 

        if (notes.isEmpty) {
          return const Center(child: Text('No notes'));
        }

        return ListView.builder(
          reverse: true,
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final reversedIndex = notes.length - 1 - index;
            return NoteCard(
              note: notes[reversedIndex],
            );
          },
        );
      },
    );
  }
}
