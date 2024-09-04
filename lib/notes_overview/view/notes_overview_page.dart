import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octimemo/notes_overview/notes_overview.dart';
import 'package:octimemo/notes_overview/widgets/action_row.dart';
import 'package:notes_repository/notes_repository.dart';

class NotesOverviewPage extends StatelessWidget {
  const NotesOverviewPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesOverviewBloc(
        notesRepository: context.read<NotesRepository>(),
      )..add(const NotesOverviewSubscriptionRequest()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<NotesOverviewBloc, NotesOverviewState>(
            listenWhen: (previous, current) =>
                previous.message != current.message,
            listener: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  width: double.infinity,
                  content: Text(
                    state.message.value,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              );
            },
          ),
          BlocListener<NotesOverviewBloc, NotesOverviewState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedNote != current.lastDeletedNote,
            listener: (context, state) {
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    width: double.infinity,
                    content: const Text(
                      'Note was deleted',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        context.read<NotesOverviewBloc>().add(
                              const NotesOverviewNoteRestore(),
                            );
                      },
                    ),
                  ),
                );
            },
          ),
        ],
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
      body: SafeArea(
        child: BlocBuilder<NotesOverviewBloc, NotesOverviewState>(
          builder: (context, state) {
            if (state.status == NotesOverviewStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return const Column(
              children: [
                Expanded(
                  child: NotesList(),
                ),
                ActionRowOrFilter(),
                GlobalInputField(),
              ],
            );
          },
        ),
      ),
    );
  }
}
