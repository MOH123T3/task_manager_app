import 'package:demo_task_manager/model/task_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'tasks.db';
  static const _databaseVersion = 1;
  static const table = 'tasks';

  // Singleton pattern
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, _databaseName),
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            reminderTime TEXT,
            category TEXT
          )
        ''');
      },
    );
  }

  // CRUD Operations

  // Insert Task
  Future<int> insertTask(Task task) async {
    Database db = await instance.database;
    return await db.insert(table, task.toMap());
  }

  // Get all Tasks
  Future<List<Task>> getAllTasks() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  // Update Task
  Future<int> updateTask(Task task) async {
    Database db = await instance.database;
    return await db.update(
      table,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete Task
  Future<int> deleteTask(int id) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
