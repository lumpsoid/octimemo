import 'package:flutter/material.dart';
import 'package:octimemo/common/composed_builder.dart';
import 'package:octimemo/l10n/l10n.dart';
import 'package:octimemo/notes_overview/notes_overview.dart';
import 'package:octimemo/service_locator/service_locator.dart';

class OverviewTitle extends StatelessWidget {
  const OverviewTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final viewModel = getIt<NotesOverviewViewModel>();

    return ComposedBuilder2<String, DateTime?, bool>(
      first: viewModel.searchQuery,
      second: viewModel.selectedDate,
      composer: (query, date) => query.isNotEmpty || date != null,
      builder: (context, isFiltered, _) {
        return isFiltered
            ? Text(l10n.overviewTitleFilteredText)
            : Text(l10n.overviewTitleText);
      },
    );
  }
}
