import 'package:rss_reader/models/bookmark_article.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BookmarkDbHelper {
  static final BookmarkDbHelper _instance = BookmarkDbHelper._internal();
  factory BookmarkDbHelper() => _instance;
  BookmarkDbHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'bookmarks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE bookmarks(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          content TEXT,
          link TEXT
        )
      ''');
  }

  Future<int> insertBookmark(BookmarkArticle bookmark) async {
    Database db = await database;
    return await db.insert('bookmarks', bookmark.toJson());
  }

  Future<List<BookmarkArticle>> getBookmarks() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bookmarks');
    return List.generate(maps.length, (i) {
      return BookmarkArticle.fromJson(maps[i]);
    });
  }

  Future<int> deleteBookmark(int id) async {
    Database db = await database;
    return await db.delete(
      'bookmarks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteBookmarkWithTitle(String title) async {
    Database db = await database;
    return await db.delete(
      'bookmarks',
      where: 'title = ?',
      whereArgs: [title],
    );
  }
}
