import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/profile_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('profiles.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE profiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        imagePath TEXT
      )
    ''');

    await _insertInitialProfiles(db);
  }

  Future<void> _insertInitialProfiles(Database db) async {
    final initialProfiles = [
      Profile(name: 'Samuel', imagePath: 'assets/images/perfil_samuel.jpg'),
      Profile(name: 'Yurik', imagePath: 'assets/images/perfil_yurik.jpg'),
      // Adicione os outros SEM ID
    ];

    // Verifica se já existem perfis
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM profiles')) ?? 0;
    
    if (count == 0) {
      for (final profile in initialProfiles) {
        await db.insert('profiles', profile.toMap());
      }
    }
  }

  // CRUD operations
  Future<List<Profile>> getProfiles() async {
    final db = await instance.database;
    final maps = await db.query('profiles');

    return maps.map((map) => Profile.fromMap(map)).toList();
  }

  Future<int> updateProfile(Profile profile) async {
    final db = await instance.database;
    return await db.update(
      'profiles',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  // Adicione este método para fechar o banco
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<int> insertProfile(Profile profile) async {
  final db = await instance.database;
  return await db.insert('profiles', profile.toMap());
   }
}