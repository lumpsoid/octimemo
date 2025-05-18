import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:octimemo/common/composed_builder.dart';
import 'package:octimemo/l10n/l10n.dart';
import 'package:octimemo/notes_overview/notes_overview.dart';
import 'package:octimemo/service_locator/service_locator.dart';

class NotesList extends StatelessWidget {
  const NotesList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final viewModel = getIt<NotesOverviewViewModel>();

    return ComposedBuilder2<IList<Note>, IMap<Type, NoteFilter>, IList<Note>>(
      first: viewModel.notes,
      second: viewModel.filters,
      composer: (notes, filters) {
        if (filters.isNotEmpty) {
          return viewModel.getFilteredNotes();
        } else {
          return notes;
        }
      },
      builder: (context, composedNotes, _) {
        if (composedNotes.isEmpty) {
          return Center(
            child: Text(
              l10n.overviewNoNotesText,
            ),
          );
        }
        final height = MediaQuery.sizeOf(context).height;

        return CustomScrollView(
          reverse: true,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return NoteCard(
                    note: viewModel.getNoteReversed(index),
                  );
                },
                childCount: composedNotes.length,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: height / 2,
              ),
            ),
          ],
        );
      },
    );
  }
}
