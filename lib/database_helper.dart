import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';


//bagian sqflite databases add produk


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'shoes_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE shoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price TEXT,
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getShoes() async {
    final db = await database;
    return await db.query('shoes');
  }

  Future<void> insertShoe(Map<String, dynamic> shoe) async {
    final db = await database;
    await db.insert('shoes', shoe,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateShoe(Map<String, dynamic> shoe) async {
    final db = await database;
    await db.update(
      'shoes',
      shoe,
      where: 'id = ?',
      whereArgs: [shoe['id']],
    );
  }

  Future<void> deleteShoe(int id) async {
    final db = await database;
    await db.delete(
      'shoes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static List user = [];
}
