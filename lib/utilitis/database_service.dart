import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "AppDatabase.db");
    return await openDatabase(
      path,
      version: 2, // Cambia el número de versión a 2 para la migración
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE connection_info (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        qr_result TEXT NOT NULL,
        ip_address TEXT NOT NULL,
        name TEXT,
        image_path TEXT
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE connection_info ADD COLUMN name TEXT;
      ''');
      await db.execute('''
        ALTER TABLE connection_info ADD COLUMN image_path TEXT;
      ''');
    }
  }

  Future<void> insertConnectionInfo(String qrResult, String ipAddress, {String? name, String? imagePath}) async {
    final db = await database;
    await db.insert(
      'connection_info',
      {'qr_result': qrResult, 'ip_address': ipAddress, 'name': name, 'image_path': imagePath},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getConnectionInfo() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('connection_info', limit: 1);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  

  Future<void> clearConnectionInfo() async {
    final db = await database;
    await db.delete('connection_info');
  }

  Future<void> deleteall() async {
    final db = await database;
    await db.delete('connection_info');
  }
    
}
