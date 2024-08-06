import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

  Stream<IList<Note>> getNotesStream() {
    return _notes.asBroadcastStream();
  }

  Task<List<Map<String, dynamic>>> getNote(int id) =>
      Task(() => _db.query('notes', where: 'id = ?', whereArgs: [id]));

  Task<void> fetchNotes() => Task(() async {
        final notes = await _db.query('notes');
        _notes.add(notes
            .map(
              (note) => Note.fromDb(note),
            )
            .toIList());
      });

  Task<void> insertNote(
    Note note,
  ) =>
      Task(() async {
        _db.insert(
          'notes',
          note.ToDb(),
        );
        _notes.add(_notes.value.add(note));
      });

  Task<void> insertNotes(
    IList<Note> notes,
  ) =>
      Task(() async {
        await _db.transaction(
          (txn) async {
            for (final note in notes) {
              txn.insert('notes', note.ToDb());
            }
          },
        );
        _notes.add(_notes.value.addAll(notes));
      });

  Task<void> updateNote(Note note) => Task(() async {
        _db.update(
          'notes',
          note.ToDb(),
          where: 'id = ?',
          whereArgs: [note.id],
        );
        _notes.add(_notes.value
            .map(
              (n) => n.id == note.id ? note : n,
            )
            .toIList());
      });

  Task<void> deleteNote(int noteId) => Task(() async {
        _db.delete(
          'notes',
          where: 'id = ?',
          whereArgs: [noteId],
        );
        _notes.add(_notes.value.removeWhere((note) => note.id == noteId));
      });

  Task<void> exportNotes(String filePath) => Task(() async {
        final result = _notes.value;
        final notes = List<String>.generate(result.length, (index) {
          final note = result[index];
          return note.toCsv();
        });
        await File(filePath).writeAsBytes(
          utf8.encode(notes.join()),
          flush: true,
        );
      });

  Task<void> importNotes(String filePath) => Task(() async {
        final notesOnlyNew = await File(filePath).readAsString().then(
              (result) => result
                  .trim()
                  .split('\n')
                  .map(Note.fromCsv)
                  .difference(
                    Eq.eqInt.contramap<Note>((n) => n.id),
                    _notes.value,
                  )
                  .toIList(),
            );
        await insertNotes(notesOnlyNew).run();
      });

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
      await fetchNotes().run();
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
        date_created INTEGER,
        date_modified INTEGER
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
            'to delete this note, try to long tap on this note to see additional actions',
          ).ToDb(),
        );
        await db.insert(
          'notes',
          Note.fromBody(
            'to edit this note, try to tap on this note',
          ).ToDb(),
        );
        await db.insert(
          'notes',
          Note.fromBody(
            'also you can use search button to filter notes',
          ).ToDb(),
        );
        await db.insert(
          'notes',
          Note.fromBody(
            'and use callendar button to filter notes by date, this two buttons can be used together',
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
