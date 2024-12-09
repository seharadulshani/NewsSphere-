import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:pavani/models/news.dart';

import '../models/news.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('bookmarks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE bookmarks(id TEXT PRIMARY KEY, title TEXT, urlToImage TEXT, publishedAt TEXT,description TEXT)',
        );
      },
    );
  }

  Future<void> insertBookmark(NewsArticle article) async {
    final db = await instance.database;
    await db.insert('bookmarks', article.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<NewsArticle>> getAllBookmarks() async {
    final db = await instance.database;
    final result = await db.query('bookmarks');
    return result.map((e) => NewsArticle.fromMap(e)).toList();
  }

  // Update an article in the database
  Future<int> updateBookmark(NewsArticle article) async {
    final db = await instance.database;

    // Prepare the data to update
    Map<String, dynamic> row = {
      'title': article.title,
      'description': article.description,
      'urlToImage': article.urlToImage,
      // Add other fields if needed
    };

    // Perform the update
    return await db.update(
      'bookmarks',  // Your table name
      row,
      where: 'id = ?',
      whereArgs: [article.id],
    );
  }

  Future<void> deleteBookmark(String id) async {
    final db = await instance.database;
    await db.delete('bookmarks', where: 'id = ?', whereArgs: [id]);
  }
}
