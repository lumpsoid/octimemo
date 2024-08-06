import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octimemo/notes_overview/view/notes_overview_page.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:octimemo/theme/theme.dart';

class App extends StatelessWidget {
  const App({required this.notesRepository, super.key});

  final NotesRepository notesRepository;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: notesRepository,
      child: MaterialApp(
        title: 'OctiMemo',
        theme: NotesTheme.light,
        darkTheme: NotesTheme.dark,
        themeMode: ThemeMode.system,
        home: const NotesOverviewPage(),
      ),
    );
  }
}
