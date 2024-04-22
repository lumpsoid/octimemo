import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fpdart/fpdart.dart';
import 'package:note_sqflite_api/note_sqflite_api.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';

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
class NoteSqfliteApi {
  /// {@macro local_sqflite_api}
  NoteSqfliteApi();

  static const String notes_table = 'notes';
  late final Database _db;
  final _notes = BehaviorSubject.seeded(IList(const <Note>[]));

  Stream<IList<Note>> getNotesStream(NoteSqfliteApi localApi) {
    return localApi._notes.asBroadcastStream();
  }

  Task<List<Map<String, dynamic>>> getNote(NoteSqfliteApi api, int id) =>
      Task(() => api._db.query('notes', where: 'id = ?', whereArgs: [id]));

  Task<int> insertNote(
    Note note,
  ) =>
      Task(
        () => _db.insert(
          'notes',
          note.ToDb(),
        ),
      );

  Task<int> updateNote(Note note) => Task(
        () => _db.update(
          'notes',
          note.ToDb(),
          where: 'id = ?',
          whereArgs: [note.id],
        ),
      );

  Task<int> deleteNote(int noteId) => Task(
        () => _db.delete(
          'notes',
          where: 'id = ?',
          whereArgs: [noteId],
        ),
      );

  Future<void> initializeDb() async {
    try {
      final databasesPath = await getDatabasesPath();
      final path = join(
        databasesPath,
        'notes.db',
      );
      _db = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
      return;
    } catch (error, __) {
      throw Exception('Error initializing database: $error');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY,
        body TEXT,
        date_created TEXT,
        date_modified TEXT
      )
    ''');
    await generateExampleNotes(db).run();
  }

  Task<void> generateExampleNotes(Database db) => Task(() async {
        await db.insert(
          'notes',
          Note.fromBody(
            'text input field at the bottom will be always there for you',
          ).ToDb(),
        );
        await db.insert(
          'notes',
          Note.fromBody(
            'to delete this note, swipte it to the left',
          ).ToDb(),
        );
        await db.insert(
          'notes',
          Note.fromBody(
            'to edit this note, swipe it to the rigth',
          ).ToDb(),
        );
        await db.insert(
          'notes',
          Note.fromBody(
            'and you good to go',
          ).ToDb(),
        );
      });
}
