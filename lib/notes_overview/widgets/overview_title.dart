import 'package:flutter/material.dart';
import 'package:memocti/notes_overview/notes_overview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OverviewTitle extends StatelessWidget {
  const OverviewTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesOverviewBloc, NotesOverviewState>(
        builder: (context, state) {
      return state.searchStatus || state.datePicked != 0
          ? const Text('Filtered Memos')
          : const Text('Memos');
    });
  }
}
