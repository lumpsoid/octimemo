import 'package:flutter/material.dart';
import 'package:memocti/notes_overview/notes_overview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DatePickerButton extends StatelessWidget {
  const DatePickerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesOverviewBloc, NotesOverviewState>(
        builder: (context, state) {
      return state.filteredNotes.isEmpty
          ? IconButton(
              icon: const Icon(Icons.calendar_month),
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 20.0, 0.0),
              onPressed: () async {
                final dateNow = DateTime.now();
                final datePicked = await showDatePicker(
                  context: context,
                  initialDate: dateNow,
                  firstDate: DateTime(2024),
                  lastDate: dateNow,
                );
                if (datePicked == null) {
                  return;
                }
                context
                    .read<NotesOverviewBloc>()
                    .add(NotesOverviewDatePick(datePicked));
              },
            )
          : IconButton(
              onPressed: () => context.read<NotesOverviewBloc>().add(
                    const NotesOverviewFilterClean(),
                  ),
              icon: const Icon(Icons.clear));
    });
  }
}
