// ignore_for_file: prefer_const_constructors
import 'package:fpdart/fpdart.dart';
import 'package:local_sqflite_api/local_sqflite_api.dart';
import 'package:test/test.dart';

void main() {
  group('LocalSqfliteApi', () {
    test('can be instantiated', () async {
      // something horible happend here
      TaskEither.tryCatch(
        () => initializeNoteDb(
          'notes.db',
          (p0, p1) => null,
        ).run(),
        (error, stackTrace) => 'Error initializing database: $error',
      ).flatMap(
        (db) => TaskEither.tryCatch(
          () async {
            db.fold(
              (l) => 'Test failed: $l',
              (db) => expect(LocalSqfliteApi(db: db), isNotNull),
            );
          },
          (error, stackTrace) => 'Test failed: $error',
        ),
      );
      ;
    });
  });
}
