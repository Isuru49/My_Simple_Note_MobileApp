import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cw1/model/note.dart';
import 'dart:async';


class NotesRepository {
  static const _dbName = 'notes_database.db';
  static const _tableName = 'notes';

  
  static Future<Database> _database() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, createdAt TEXT)',
        );
      },
      version: 1,
    );
  }

  
  Future<void> insert(Note note) async {
    final db = await _database();
    await db.insert(
      _tableName,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  
  Future<List<Note>> getNotes() async {
    final db = await _database();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }


  Future<void> update(Note note) async {
    final db = await _database();
    await db.update(
      _tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }


  Future<void> delete(Note note) async {
    final db = await _database();
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
}
