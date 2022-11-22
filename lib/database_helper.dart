import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {


  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'fsm',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE ruangan(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nama TEXT,
        kapasitas INTEGER
      )
      """);
  }
// id: the id of a item
// title, description: name and description of  activity
// created_at: the time that the item was created. It will be automatically handled by SQLite
  // Create new item
  static Future<int> addRuangan(String? nama, String? kapasitas) async {
    final db = await DatabaseHelper.db();

    final data = {'nama': nama, 'kapasitas': int.parse(kapasitas!)};
    final id = await db.insert('ruangan', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;

    // When a UNIQUE constraint violation occurs,
    // the pre-existing rows that are causing the constraint violation
    // are removed prior to inserting or updating the current row.
    // Thus the insert or update always occurs.
  }

  // Read all items
  static Future<List<Map<String, dynamic>>> getAll() async {
    final db = await DatabaseHelper.db();
    return db.query('ruangan', orderBy: "id");
  }

  // Get a single item by id
  //We dont use this method, it is for you if you want it.
  static Future<List<Map<String, dynamic>>> getRuangan(int id) async {
    final db = await DatabaseHelper.db();
    return db.query('ruangan', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateRuangan(
      int id, String nama, String? kapasitas) async {
    final db = await DatabaseHelper.db();

    final data = {
      'nama': nama,
      'kapasitas': int.parse(kapasitas!),
    };

    final result =
    await db.update('ruangan', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteRuangan(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("ruangan", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}