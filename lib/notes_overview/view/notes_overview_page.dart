import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memocti/notes_overview/notes_overview.dart';
import 'package:memocti/notes_overview/widgets/options_menu.dart';
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
                    duration: const Duration(milliseconds: 1500),
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
      appBar: AppBar(
        title: const OverviewTitle(),
        actions: const [
          DatePickerButton(),
          SearchButton(),
          OptionsMenu(),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<NotesOverviewBloc, NotesOverviewState>(
          builder: (context, state) {
            if (state.datePicked != 0 || state.searchStatus) {
              return const NotesFilteredList();
            }
            return const NotesList();
          },
        ),
      ),
    );
  }
}
