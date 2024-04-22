import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memocti/notes_overview/view/notes_overview_page.dart';
import 'package:notes_repository/notes_repository.dart';

class App extends StatelessWidget {
  const App({required this.notesRepository, super.key});

  final NotesRepository notesRepository;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: notesRepository,
      child: MaterialApp(
        title: 'Simple Memos',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green[50]!),
          useMaterial3: true,
        ),
        home: const NotesOverviewPage(),
      ),
    );
  }
}
