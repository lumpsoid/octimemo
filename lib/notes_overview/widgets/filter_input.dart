import 'package:flutter/material.dart';
import 'package:octimemo/l10n/l10n.dart';
import 'package:octimemo/notes_overview/notes_overview.dart';
import 'package:octimemo/service_locator/service_locator.dart';

class FilterInput extends StatelessWidget {
  const FilterInput({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final viewModel = getIt<NotesOverviewViewModel>();

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InkWell(
            onTap: viewModel.clearQuery,
            child: const Icon(Icons.search_off),
          ),
        ),
        Expanded(
          child: TextField(
            onChanged: viewModel.changeQuery,
            decoration: InputDecoration(
              hintText: l10n.overviewInputSearchHint,
            ),
          ),
        ),
      ],
    );
  }
}
