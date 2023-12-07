import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'page.dart' show NotePage, itemsPerPage;
import 'note.dart' show Note;

class DbHelper {
  static final DbHelper _instance = DbHelper.internal();

  factory DbHelper() => _instance;

  static bool isConnected = false;
  static late Database _db;
  static late int noteCount;


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
      noteCount = await _getCount(db);
      isConnected = true;
      return db;
    } catch (e) {
      print("Error initializing database: $e");
      rethrow; // Rethrow the error to see the stack trace
    }
  }

  void _onCreate(Database db, int version) async {
    // books-meta
    //// id name author percent date-created date-completed date-last
    // books-text
    //// id text

    // Create books_meta table
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY,
        body TEXT,
        date_created TEXT,
        date_modified TEXT
      )
    ''');
  }

  // CRUD operations
  Future<int> _getCount(Database db) async {
    int? count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM notes'));
    if (count == null) {
      throw StateError('why count is null?');
    }
    return count - 1;
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
    return await dbClient.query('notes', columns: ['id']);;
  }

  Future<int> updateNote(Map<String, dynamic> note) async {
    Database dbClient = await db;
    return await dbClient.update('notes', note,
        where: 'id = ?', whereArgs: [note['id']]);
  }

  Future<int> deleteNote(int id) async {
    Database dbClient = await db;
    return await dbClient.delete('notes',
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    Database dbClient = await db;
    try {
      await dbClient.close();
      isConnected = false;
    } catch(e) {
      print(e);
      rethrow;
    }
  }
}