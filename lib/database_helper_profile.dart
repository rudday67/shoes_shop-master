import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';



//bagian sqflite database profile 

class DatabaseHelperProfile {
  static final DatabaseHelperProfile _instance =
      DatabaseHelperProfile._internal();
  factory DatabaseHelperProfile() => _instance;
  static Database? _database;

  DatabaseHelperProfile._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'profile_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        gender TEXT,
        phone TEXT
      )
    ''');
  }

  Future<void> insertProfile(Map<String, dynamic> profile) async {
    final db = await database;
    await db.insert('profile', profile,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateProfile(Map<String, dynamic> profile) async {
    final db = await database;
    await db.update(
      'profile',
      profile,
      where: 'id = ?',
      whereArgs: [profile['id']],
    );
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('profile');
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  static List user = [];
}
