import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octimemo/notes_overview/notes_overview.dart';

class ActionRowOrFilter extends StatelessWidget {
  const ActionRowOrFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesOverviewBloc, NotesOverviewState>(
      builder: (context, state) {
        return state.searchStatus
            ? const FilterInput()
            : const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OptionsMenu(),
                  Row(
                    children: [
                      DatePickerButton(),
                      SearchButton(),
                    ],
                  )
                ],
              );
      },
    );
  }
}
