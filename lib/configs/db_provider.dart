import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
export 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final _dbName = 'Presensi2.db';

  static final _dbVersion = 4;

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(path,
        version: _dbVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  static final String _createTableMessages = "CREATE TABLE Messages ("
      "id TEXT PRIMARY KEY,"
      "content TEXT,"
      "title TEXT,"
      "read_at INTEGER,"
      "published_at TEXT"
      ")";

  static final String _createTableNotificaton = """CREATE TABLE Notification (
      id TEXT PRIMARY KEY,
      isRead INTEGER,
      title TEXT,
      content TEXT,
      date TEXT
      )""";

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_createTableMessages);
    await db.execute(_createTableNotificaton);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      try {
        await db.execute("DROP TABLE IF EXISTS Messages");
        await db.execute(_createTableMessages);
        await db.execute("DROP TABLE IF EXISTS Notification");
        await db.execute(_createTableNotificaton);
      } catch (e) {
        print("Update v3 error : ${e.toString()}");
      }
    }
  }
}
