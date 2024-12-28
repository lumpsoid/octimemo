import 'package:flutter/material.dart';
import 'package:octimemo/l10n/l10n.dart';
import 'package:octimemo/notes_overview/notes_overview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OverviewTitle extends StatelessWidget {
  const OverviewTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<NotesOverviewBloc, NotesOverviewState>(
        builder: (context, state) {
      return state.searchStatus || state.datePicked != 0
          ? Text(l10n.overviewTitleFilteredText)
          : Text(l10n.overviewTitleText);
    });
  }
}
