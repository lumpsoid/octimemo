import 'package:flutter/material.dart';
import 'package:octimemo/l10n/l10n.dart';
import 'package:octimemo/notes_overview/notes_overview.dart';
import 'package:octimemo/service_locator/service_locator.dart';

class OptionsMenu extends StatelessWidget {
  const OptionsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final viewModel = getIt<NotesOverviewViewModel>();

    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'import',
            onTap: viewModel.importNotes,
            child: Text(l10n.overviewImportOptionText),
          ),
          PopupMenuItem<String>(
            value: 'export',
            onTap: viewModel.exportNotes,
            child: Text(l10n.overviewExportOptionText),
          ),
        ];
      },
    );
  }
}
