import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:octimemo/notes_overview/bloc/notes_overview_bloc.dart';

class OptionsMenu extends StatelessWidget {
  const OptionsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'import',
            child: const Text('Import'),
            onTap: () {
              context.read<NotesOverviewBloc>().add(
                    const NotesOverviewImport(),
                  );
            },
          ),
          PopupMenuItem<String>(
            value: 'export',
            child: const Text('Export'),
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
