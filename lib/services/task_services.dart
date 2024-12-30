import 'package:demo_task_manager/model/task_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TaskService {
  static const String tableName = 'tasks';

  late Database _db;

  // Initialize the database
  Future<void> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');
    _db = await openDatabase(path, version: 1, onCreate: _createDb);
  }

  // Create the tasks table if not exists
  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        isCompleted INTEGER
      )
    ''');
  }

  // Fetch all tasks
  Future<List<TaskModel>> getTasks() async {
    final List<Map<String, dynamic>> taskMaps = await _db.query(tableName);
    return List.generate(taskMaps.length, (index) {
      return TaskModel.fromMap(taskMaps[index]);
    });
  }

  // Insert a new task
  Future<void> insertTask(TaskModel task) async {
    await _db.insert(tableName, task.toMap());
  }

  // Update an existing task
  Future<void> updateTask(TaskModel task) async {
    await _db.update(
      tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    await _db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close the database
  Future<void> close() async {
    await _db.close();
  }
}
