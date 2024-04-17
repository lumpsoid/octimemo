import 'dart:async';
import 'dart:developer';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fpdart/fpdart.dart';
import 'package:local_sqflite_api/local_sqflite_api.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:rxdart/rxdart.dart';

/// {@template local_sqflite_api}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
// class LocalSqfliteApi {
/// {@macro local_sqflite_api}
// const LocalSqfliteApi();
// }

/// {@template local_sqflite_api}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class LocalSqfliteApi {
  /// {@macro local_sqflite_api}
  LocalSqfliteApi({required this.db});

  static const String notes_table = 'notes';
  final Database db;
  final notes = BehaviorSubject.seeded(IList(const <Note>[]));
}

Stream<IList<Note>> getNotesStreamFromDb(LocalSqfliteApi localApi) {
  return localApi.notes.asBroadcastStream();
}

Task<List<Map<String, dynamic>>> getNoteFromDb(LocalSqfliteApi api, int id) =>
    Task(() => api.db.query('notes', where: 'id = ?', whereArgs: [id]));

Task<int> insertNoteInDb(
  LocalSqfliteApi api,
  Note note,
) =>
    Task(
      () => api.db.insert(
        'notes',
        noteToDb(note),
      ),
    );

Task<int> updateNoteInDb(LocalSqfliteApi api, Note note) => Task(
      () => api.db.update(
        'notes',
        noteToDb(note),
        where: 'id = ?',
        whereArgs: [note.id],
      ),
    );

Task<int> deleteNoteFromDb(LocalSqfliteApi api, int noteId) => Task(
      () => api.db.delete(
        'notes',
        where: 'id = ?',
        whereArgs: [noteId],
      ),
    );

TaskEither<String, Database> initializeNoteDb(
  String dbName,
  FutureOr<void> Function(Database, int)? onCreate,
) =>
    TaskEither.tryCatch(
      () async {
        final databasesPath = await getDatabasesPath();
        final path = join(
          databasesPath,
          dbName,
        );
        return openDatabase(
          path,
          version: 1,
          onCreate: onCreate,
        );
      },
      (error, stackTrace) => 'Error initializing database: $error',
    );

Task<void> onCreate(Database db, int version) => Task(() async {
      await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY,
        body TEXT,
        date_created TEXT,
        date_modified TEXT
      )
    ''');
      await generateExampleNotes(db).run();
    });

Task<void> generateExampleNotes(Database db) => Task(() async {
      await db.insert(
        'notes',
        noteToDb(
          createNewNote(
            'text input field at the bottom will be always there for you',
          ).run(),
        ),
      );
      await db.insert(
        "notes",
        noteToDb(
          createNewNote(
            'to delete this note, swipte it to the left',
          ).run(),
        ),
      );
      await db.insert(
        "notes",
        noteToDb(
          createNewNote(
            'to edit this note, swipe it to the rigth',
          ).run(),
        ),
      );
      await db.insert(
        "notes",
        noteToDb(
          createNewNote(
            'and you good to go',
          ).run(),
        ),
      );
    });
