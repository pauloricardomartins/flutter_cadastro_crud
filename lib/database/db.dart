import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:cadastro_crud/models/usuario.dart';

class DB {
  static final DB _instance = DB._internal();
  factory DB() => _instance;
  DB._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute(
      '''
        CREATE TABLE usuarios (
          id INTEGER PRIMARY KEY, nome TEXT NOT NULL, email TEXT NOT NULL
        )
      '''
    );
  }
}
// var db = await openDatabase('my_db.db');
// await db.close();