import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_sqflite_api/note_sqflite_api.dart';
import 'package:octimemo/app/app.dart';
import 'package:octimemo/app/app_bloc_observer.dart';
import 'package:notes_repository/notes_repository.dart';

void bootstrap({
  required NoteSqfliteApi localApi,
}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final notesRepository = NotesRepository(localApi: localApi);

  runZonedGuarded(
    () => runApp(App(
      notesRepository: notesRepository,
    )),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
