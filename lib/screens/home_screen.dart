import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/screens/update_task.dart';
import 'package:to_do_app/service/task_service.dart';
import 'new_task.dart';

class HomeScreen extends StatefulWidget {
  Todo? todo;
  HomeScreen({this.todo});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _taskService;

  List<Todo>? _tasklist;

  @override
  void initState() {
    super.initState();
    _taskService = TaskService();

    getAllTasks();
  }

  getAllTasks() async {
    _tasklist = <Todo>[];
    var tasks = await _taskService.readTask();

    tasks.forEach((todo) {
      setState(() {
        var taskModel = Todo();
        taskModel.name = todo.name;
        taskModel.id = todo.id;
        taskModel.date = todo.date;
        taskModel.time = todo.time;
        _tasklist!.add(taskModel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'قائمة المهام',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Hacen",
            fontSize: 22,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () async => {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NewTask()))
              .then((value) => setState(() {
                    getAllTasks();
                  })),
        },
      ),
      body: ListView.builder(
        reverse: false,
        itemCount: _tasklist!.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return //Text(_tasklist[index].name!);

              Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              child: ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _taskService.deleteTask(_tasklist![index].id!);
                        setState(() {
                          getAllTasks();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.create),
                      onPressed: () {
                        Navigator.of(this.context)
                            .push(MaterialPageRoute(
                                builder: (context) => UpdateTask(
                                      todo: _tasklist![index],
                                    )))
                            .then((value) => setState(() {
                                  getAllTasks();
                                }));
                      },
                    ),
                  ],
                ),
                title: Text(
                  _tasklist![index].name!,
                  style: TextStyle(
                    color: Theme.of(this.context).primaryColor,
                    fontFamily: "Hacen",
                    fontSize: 20,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _tasklist![index].time!,
                      style: TextStyle(
                        fontFamily: "Hacen",
                      ),
                    ),
                    Text(
                      _tasklist![index].date!,
                      style: TextStyle(
                        fontFamily: "Hacen",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
