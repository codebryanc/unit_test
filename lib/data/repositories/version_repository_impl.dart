import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:unit_test/data/models/version_model.dart';
import 'package:unit_test/data/repositories/version_repository.dart';

/// Implementación real del repositorio usando SQLite
/// NOTA: Esta clase NO se usa en pruebas unitarias, solo en la app real
class VersionRepositoryImpl implements VersionRepository {
  static const String _tableName = 'version';
  static const String _databaseName = 'app_database.db';

  Database? _database;

  /// Obtiene la instancia de la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Inicializa la base de datos
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY,
            version TEXT NOT NULL,
            lastUpdated TEXT NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<void> saveVersion(VersionModel version) async {
    final db = await database;

    // Primero eliminamos cualquier versión anterior (solo guardamos una)
    await db.delete(_tableName);

    // Insertamos la nueva versión
    await db.insert(
      _tableName,
      {
        'id': 1,
        ...version.toJson(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<VersionModel?> getVersion() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [1],
    );

    if (maps.isEmpty) {
      return null;
    }

    return VersionModel.fromJson(maps.first);
  }

  @override
  Future<void> deleteVersion() async {
    final db = await database;
    await db.delete(_tableName);
  }

  /// Cierra la base de datos
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
