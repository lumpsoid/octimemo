import 'package:flutter/material.dart';
import 'package:octimemo/notes_overview/notes_overview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesOverviewBloc, NotesOverviewState>(
        builder: (context, state) {
      return IconButton(
        onPressed: () => context
            .read<NotesOverviewBloc>()
            .add(const NotesOverviewSearchStart()),
        icon: const Icon(Icons.search),
      );
    });
  }
}
