import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octimemo/notes_overview/notes_overview.dart';

class FilterInput extends StatelessWidget {
  const FilterInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesOverviewBloc, NotesOverviewState>(
      builder: (context, state) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                onTap: () => context.read<NotesOverviewBloc>().add(
                      const NotesOverviewSearchEnd(),
                    ),
                child: const Icon(Icons.search_off),
              ),
            ),
            Expanded(
              child: TextField(
                onChanged: (value) => context.read<NotesOverviewBloc>().add(
                      NotesOverviewSearchQuery(value),
                    ),
                decoration: const InputDecoration(hintText: 'Search'),
              ),
            ),
          ],
        );
      },
    );
  }
}
