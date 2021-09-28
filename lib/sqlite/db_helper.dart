import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_app/models/todo.dart';

class DBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String DATE = 'date';
  static const String TIME = 'time';
  static const String TABLE = 'Tasks';
  static const String DB_NAME = 'ToDo.db';

  Future<Database> get dbToDo async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY AUTOINCREMENT, $NAME TEXT, $DATE TEXT, $TIME TEXT)");
  }

  Future<Todo> save(Todo todo) async {
    var dbTodo = await dbToDo;
    todo.id = await dbTodo.insert(TABLE, todo.toMap());
    return todo;
  }

  Future<List<Todo>> getTasks() async {
    var dbTodo = await dbToDo;
    List<Map<String, dynamic>> maps = await dbTodo.query(TABLE);

    List<Todo> tasks = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        tasks.add(Todo.fromMap(maps[i]));
      }
    }
    return tasks;
  }

  Future<int> update(Todo todo) async {
    var dbTodo = await dbToDo;
    return await dbTodo
        .update(TABLE, todo.toMap(), where: '$ID = ?', whereArgs: [todo.id]);
  }

  Future<int> delete(int id) async {
    var dbTodo = await dbToDo;
    return await dbTodo.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future close() async {
    var dbTodo = await dbToDo;
    dbTodo.close();
  }
}
