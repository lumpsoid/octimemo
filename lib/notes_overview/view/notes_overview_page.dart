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
      )..add(const NotesOverviewSubscriptionRequest()),
      child: BlocListener<NotesOverviewBloc, NotesOverviewState>(
        listenWhen: (previous, current) => current.message.isNotEmpty,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              duration: const Duration(milliseconds: 1500),
              width: 280.0, // Width of the SnackBar.
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0, // Inner padding for SnackBar content.
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );
        },
        child: const NotesOverviewScreen(),
      ),
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
        // actions: [
        // IconButton(
        //   icon: const Icon(Icons.dark_mode_outlined),
        //   onPressed: () {
        // context
        //     .read<NotesOverviewBloc>()
        //     .add(const NotesOverviewToggleTheme());
        // },
        // ),
        // ],
      ),
      body: SafeArea(
        child: BlocBuilder<NotesOverviewBloc, NotesOverviewState>(
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
                            final reversedIndex =
                                state.notes.length - 1 - index;
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
        ),
      ),
    );
  }
}
