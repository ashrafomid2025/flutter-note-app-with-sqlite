import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'note.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT NOT NULL,description TEXT NOT NULL, created_at DATETIME DEFAULT CURRENT_TIMESTAMP)",
        );
      },
    );
  }

  Future<int> insertNewNote(String heading, String desc) async {
    final db = await database;

    return await db.insert("notes", {"title": heading, "description": desc});
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    return await db.query("notes", orderBy: "id ASC");
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete("notes", where: "id=$id");
  }

  Future<List<Map<String, dynamic>>> SearchNote(String searchText) async {
    final db = await database;
    return await db.query(
      "notes",
      where: 'LOWER(title) OR LOWER(description) LIKE LOWER(?)',
      whereArgs: ['%$searchText%'],
    );
  }

  Future<void> UpdateNote(int id, String Title, String description) async {
    final db = await database;
    await db.update(
      "notes",
      {"title": Title, "description": description},
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
