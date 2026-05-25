import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/song.dart';

class DatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'soundwave.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE downloaded_songs(
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            artist TEXT NOT NULL,
            album TEXT NOT NULL,
            albumArt TEXT NOT NULL,
            audioUrl TEXT NOT NULL,
            duration INTEGER NOT NULL,
            isDownloaded INTEGER DEFAULT 0,
            localPath TEXT,
            isFavorite INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE favorites(
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            artist TEXT NOT NULL,
            album TEXT NOT NULL,
            albumArt TEXT NOT NULL,
            audioUrl TEXT NOT NULL,
            duration INTEGER NOT NULL,
            isDownloaded INTEGER DEFAULT 0,
            localPath TEXT,
            isFavorite INTEGER DEFAULT 1
          )
        ''');
      },
    );
  }

  // Downloaded Songs
  static Future<void> saveDownloadedSong(Song song) async {
    final db = await database;
    await db.insert(
      'downloaded_songs',
      song.copyWith(isDownloaded: true).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Song>> getDownloadedSongs() async {
    final db = await database;
    final maps = await db.query('downloaded_songs');
    return maps.map((m) => Song.fromMap(m)).toList();
  }

  static Future<void> deleteDownloadedSong(String id) async {
    final db = await database;
    await db.delete('downloaded_songs', where: 'id = ?', whereArgs: [id]);
  }

  static Future<bool> isSongDownloaded(String id) async {
    final db = await database;
    final result = await db.query(
      'downloaded_songs',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  // Favorites
  static Future<void> addFavorite(Song song) async {
    final db = await database;
    await db.insert(
      'favorites',
      song.copyWith(isFavorite: true).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Song>> getFavorites() async {
    final db = await database;
    final maps = await db.query('favorites');
    return maps.map((m) => Song.fromMap(m)).toList();
  }

  static Future<bool> isFavorite(String id) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }
}
