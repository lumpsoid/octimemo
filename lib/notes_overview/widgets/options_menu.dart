import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octimemo/l10n/l10n.dart';
import 'package:octimemo/notes_overview/bloc/notes_overview_bloc.dart';

class OptionsMenu extends StatelessWidget {
  const OptionsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'import',
            child: Text(l10n.overviewImportOptionText),
            onTap: () {
              context.read<NotesOverviewBloc>().add(
                    const NotesOverviewImport(),
                  );
            },
          ),
          PopupMenuItem<String>(
            value: 'export',
            child: Text(l10n.overviewExportOptionText),
            onTap: () {
              context.read<NotesOverviewBloc>().add(
                    const NotesOverviewExport(),
                  );
            },
          ),
        ];
      },
    );
  }
}
