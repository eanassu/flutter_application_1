import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/todo_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// precisa rodar no terminal:
// dart run sqflite_common_ffi_web:setup
// para funcionar na WEB

class DatabaseHelper {
  static final DatabaseHelper _instance=DatabaseHelper._internal();
  static Database? _database;
  factory DatabaseHelper() {
    return _instance;
  }
  DatabaseHelper._internal();
  Future<Database> get database async {
    if(_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }
  Future <Database> _initDatabase() async {
    String path;
    if(kIsWeb) {
      path = 'todo_app_web.db';
    } else {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      path = join(documentsDirectory.path,'todo_app.db');
    }
    return await openDatabase(
      path, 
      version:1,
      onCreate: _onCreate
    );
  }
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        isDone INTEGER
      )
    ''');

  }
  // Create (Inserir uma tarefa)
  Future<int> insertTodo(Todo todo) async {
    final db = await database;
    return await db.insert('todos', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Read (Obter todas as tarefas)
  Future<List<Todo>> getTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');

    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  // Read (Obter uma tarefa por ID) - Opcional, mas útil
  Future<Todo?> getTodoById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Todo.fromMap(maps.first);
    }
    return null;
  }

  // Update (Atualizar uma tarefa)
  Future<int> updateTodo(Todo todo) async {
    final db = await database;
    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  // Delete (Remover uma tarefa)
  Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close database (Opcional, mas boa prática em alguns cenários)
  Future<void> close() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
      _database = null; // Resetar a instância para reabrir se necessário
    }
  }
}