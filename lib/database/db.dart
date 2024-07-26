import 'dart:convert';

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
      onCreate: _migrations,    
    );
  }

  Future _migrations(Database db, int version) async {
    await db.execute('''
        CREATE TABLE usuarios (
          id INTEGER PRIMARY KEY, nome TEXT NOT NULL, email TEXT NOT NULL
        )
      ''');
  }

  Future<void> createUsuario(Usuario usuario) async {
    final db = await database;
    await db.insert('usuarios', usuario.toMap());
  }

  Future<List<Usuario>> allUsuarios() async {
    final db = await database;
    final result = await db.query('usuarios');
    return result.map((json) => Usuario.fromMap(json)).toList();
  }

  Future<List<Usuario>> findUsuario(String term) async {
    final db = await database;
    final result = await db.query(
      'usuarios',
      where: 'nome LIKE ?',
      whereArgs: ['%$term%'],
    );
    return result.map((json) => Usuario.fromMap(json)).toList();
  }

  Future<void> updateUsuario(Usuario usuario) async {
    final db = await database;
    await db.update('usuarios', usuario.toMap(),
        where: 'id = ?', whereArgs: [usuario.id]);
  }

  Future<void> deleteUsuario(int id) async {
    final db = await database;
    await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }
}
