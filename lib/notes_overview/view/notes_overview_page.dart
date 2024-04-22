import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memocti/notes_overview/notes_overview.dart';
import 'package:notes_repository/notes_repository.dart';

class NotesOverviewPage extends StatelessWidget {
  const NotesOverviewPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesOverviewBloc(
        notesRepository: context.read<NotesRepository>(),
      ),
      child: const NotesOverviewScreen(),
    );
  }
}

class NotesOverviewScreen extends StatelessWidget {
  const NotesOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode_outlined),
            onPressed: () {
              context
                  .read<NotesOverviewBloc>()
                  .add(const NotesOverviewToggleTheme());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<NotesOverviewBloc, NotesOverviewState>(
          builder: (context, state) {
            if (state.status == NotesOverviewStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.notes.isEmpty) {
              return const Center(child: Text('No notes yet'));
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.notes.length,
                    itemBuilder: (context, index) {
                      return NoteCard(
                        note: state.notes[index],
                      );
                    },
                  ),
                ),
                const GlobalInputField(),
              ],
            );
          },
        ),
      ),
    );
  }
}
