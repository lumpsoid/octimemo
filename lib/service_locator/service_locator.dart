import 'package:get_it/get_it.dart';
import 'package:note_sqflite_api/note_sqflite_api.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:octimemo/notes_overview/view_model/notes_overview_view_model.dart';

final getIt = GetIt.instance;

void setupGetIt({
  required NoteSqfliteApi notesService,
}) {
  getIt
    // state management layer
    ..registerLazySingleton<NotesOverviewViewModel>(NotesOverviewViewModel.new)
    // service layer
    ..registerLazySingleton(
      () => NotesRepository(
        localApi: notesService,
      ),
    );
}
