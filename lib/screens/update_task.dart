import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/service/task_service.dart';

class UpdateTask extends StatefulWidget {
  Todo todo;
  UpdateTask({Key? key, required this.todo}) : super(key: key);

  @override
  _UpdateTaskState createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  final _formKey = GlobalKey<FormState>();
  Todo upTodo = Todo();
  TaskService _taskService = TaskService();

  TextEditingController? _dateController;
  TextEditingController? _timeController;
  TextEditingController? _nameController;

  final DateFormat _dateFormatter = DateFormat.yMd();

  TimeOfDay _time = TimeOfDay.now();
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.todo.date);
    _timeController = TextEditingController(text: widget.todo.time);
    _nameController = TextEditingController(text: widget.todo.name);
    upTodo.id = widget.todo.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: TextFormField(
                    style: TextStyle(
                      fontFamily: "Hacen",
                      fontSize: 18,
                    ),
                    validator: (val) => val!.isEmpty ? 'أدخل المهمة' : null,
                    onSaved: (val) => {
                      upTodo.name = val,
                    },
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'اسم المهمة',
                      hintText: 'الاسم',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: TextFormField(
                    style: TextStyle(
                      fontFamily: "Hacen",
                      fontSize: 18,
                    ),
                    controller: _dateController,
                    onTap: () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                  primary: Theme.of(context)
                                      .accentColor, // header background color
                                  onPrimary: Colors.black, // header text color
                                  onSurface: Colors.black // body text color
                                  ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary: Theme.of(context)
                                      .primaryColor, // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      _dateController!.text = _dateFormatter.format(date!);
                    },
                    validator: (val) => val!.isEmpty ? 'أدخل التاريخ' : null,
                    onSaved: (val) => {
                      upTodo.date = val,
                    },
                    decoration: InputDecoration(
                      labelText: 'تاريخ المهمة',
                      hintText: 'التاريخ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: TextFormField(
                    style: TextStyle(
                      fontFamily: "Hacen",
                      fontSize: 18,
                    ),
                    controller: _timeController,
                    onTap: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: _time,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                  primary: Theme.of(context)
                                      .accentColor, // header background color
                                  onPrimary: Colors.black, // header text color
                                  onSurface: Colors.black // body text color
                                  ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary: Theme.of(context)
                                      .primaryColor, // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      _timeController!.text = time!.format(context);
                    },
                    validator: (val) => val!.isEmpty ? 'أدخل الوقت' : null,
                    onSaved: (val) => upTodo.time = val,
                    decoration: InputDecoration(
                      labelText: 'وقت المهمة',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: MaterialButton(
        onPressed: () {
          _submit();
        },
        child: Text(
          'حفظ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Hacen",
            fontSize: 22,
          ),
        ),
        color: Color(0xfff64444),
      ),
    );
  }

  _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      print(upTodo.name);
      print(upTodo.id);
      print(upTodo.date);
      print(upTodo.time);
      _taskService.updateTask(upTodo);

      Navigator.of(context).pop();
    }
  }
}
