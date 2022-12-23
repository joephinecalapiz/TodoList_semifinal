import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class Database {

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'calapiz_semifinal.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE todolist(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT
      )
      """);
  }

  static Future<int> createTodo(String? title, String? description) async {
    final db = await Database.db();

    final data = {'title': title, 'description': description};
    final id = await db.insert('todolist', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;


  }

  // Read all items
  static Future<List<Map<String, dynamic>>> getTodos() async {
    final db = await Database.db();
    return db.query('todolist', orderBy: "id");
  }


  static Future<List<Map<String, dynamic>>> getTodo(int id) async {
    final db = await Database.db();
    return db.query('todolist', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateTodo(
      int id, String title, String? description) async {
    final db = await Database.db();


    final data = {
      'title': title,
      'description': description,

    };

    final result = await db.update('todolist', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteTodo(int id) async {
    final db = await Database.db();
    try {
      await db.delete("todolist", where: "id = ?", whereArgs: [id]);
    } catch (error404) {
      debugPrint("Error: $error404");
    }
  }
}