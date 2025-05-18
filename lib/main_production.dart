import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:note_sqflite_api/note_sqflite_api.dart';
import 'package:octimemo/app/app.dart';
import 'package:octimemo/bootstrap.dart';
import 'package:octimemo/service_locator/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level = Level.WARNING;
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.time}: ${record.message}');
  });

  final logger = Logger('Octimemo');

  setupGetIt(
    notesService: NoteSqfliteApi()..initializeDb(),
  );

  bootstrap(
    () => const App(),
    logger,
  );
}
