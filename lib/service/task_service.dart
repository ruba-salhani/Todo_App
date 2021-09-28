import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/sqlite/db_helper.dart';

class TaskService {
  DBHelper? _dbHelper;
  TaskService() {
    _dbHelper = DBHelper();
  }
  saveTask(Todo todo) async {
    return await _dbHelper!.save(todo);
  }

  readTask() async {
    return await _dbHelper!.getTasks();
  }

  deleteTask(int id) async {
    return await _dbHelper!.delete(id);
  }

  updateTask(Todo todo) async {
    return await _dbHelper!.update(todo);
  }
}
