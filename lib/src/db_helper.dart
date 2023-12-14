import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'page.dart' show NotePage, itemsPerPage;
import 'note.dart' show Note;

class DbHelper {
  static final DbHelper _instance = DbHelper.internal();

  factory DbHelper() => _instance;

  static bool isConnected = false;
  static late Database _db;
  late int noteCount;

  // there is a problem with multiple async intialization of db
  Future<Database> get db async {
    if (isConnected) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DbHelper.internal();

  Future<Database> initDb() async {
    try {
      String databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'notes.db');
      Database db = await openDatabase(path, version: 1, onCreate: _onCreate);
      noteCount = await getCount(db);
      isConnected = true;
      return db;
    } catch (e) {
      print("Error initializing database: $e");
      rethrow; // Rethrow the error to see the stack trace
    }
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY,
        body TEXT,
        date_created TEXT,
        date_modified TEXT
      )
    ''');
    db.insert(
        "notes",
        await Note(
                body:
                    'text input field at the bottom will be always there for you')
            .toMap());
    db.insert("notes",
        await Note(body: 'to delete this note, swipte it to the left').toMap());
    db.insert("notes",
        await Note(body: 'to edit this note, swipe it to the rigth').toMap());
    db.insert("notes", await Note(body: 'and you good to go').toMap());
  }

  // CRUD operations
  Future<int> getCount(Database db) async {
    int? count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM notes'));
    if (count == null) {
      throw StateError('why count is null?');
    }
    return count;
  }

  Future<int> getCountTest() async {
    Database dbClient = await db;
    int? count = Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM notes'));
    if (count == null) {
      throw StateError('why count is null?');
    }
    return count;
  }

  Future<int> insertNote(Note note) async {
    Database dbClient = await db;
    return await dbClient.insert('notes', await note.toMap());
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    Database dbClient = await db;
    return await dbClient.query('notes');
  }

  Future<NotePage> fetchNotes(int startingIndex) async {
    Database dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.rawQuery(
      'SELECT * FROM notes ORDER BY id LIMIT $itemsPerPage OFFSET $startingIndex',
    );

    NotePage page = NotePage(
      items: List.generate(
        result.length,
        (index) => Note(
          id: result[index]['id'],
          body: result[index]['body'],
          dateCreated: result[index]['date_created'],
          dateModified: result[index]['date_modified'],
        ),
      ),
      startingIndex: startingIndex,
      hasNext: startingIndex + itemsPerPage < noteCount,
    );
    return page;
  }

  Future<List<Map<String, dynamic>>> getNote(int id) async {
    Database dbClient = await db;
    return await dbClient.query('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getIds() async {
    Database dbClient = await db;
    return await dbClient.query('notes', columns: ['id']);
  }

  Future<int> updateNote(Note note) async {
    Database dbClient = await db;
    return await dbClient.update('notes', await note.toMap(),
        where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    Database dbClient = await db;
    return await dbClient.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    Database dbClient = await db;
    try {
      await dbClient.close();
      isConnected = false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
