import 'package:flutter/material.dart';

import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/service/task_service.dart';
import 'package:intl/intl.dart';

class NewTask extends StatefulWidget {
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final _formKey = GlobalKey<FormState>();
  Todo todo = Todo();
  TaskService _taskService = TaskService();
  final DateFormat _dateFormatter = DateFormat.yMd();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TimeOfDay _time = TimeOfDay.now();
  DateTime _date = DateTime.now();

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
        title: Text(
          'إضافة مهمة',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Hacen",
            fontSize: 22,
          ),
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
                      _nameController.text = val!,
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
                    onTap: datePicker,
                    validator: (val) => val!.isEmpty ? 'أدخل التاريخ' : null,
                    onSaved: (val) => _dateController.text = val!,
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
                    onTap: timePicker,
                    validator: (val) => val!.isEmpty ? 'أدخل الوقت' : null,
                    onSaved: (val) => _timeController.text = val!,
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
      var newTodo;

      newTodo = Todo(
          name: _nameController.text,
          date: _dateController.text,
          time: _timeController.text);

      var result = await _taskService.saveTask(newTodo);

      Navigator.of(context).pop(newTodo);
    }
  }

  datePicker() async {
    {
      final DateTime? date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                  primary:
                      Theme.of(context).accentColor, // header background color
                  onPrimary: Colors.black, // header text color
                  onSurface: Colors.black // body text color
                  ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Theme.of(context).primaryColor, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      _dateController.text = _dateFormatter.format(date!);
    }
  }

  timePicker() async {
    {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: _time,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                  primary:
                      Theme.of(context).accentColor, // header background color
                  onPrimary: Colors.black, // header text color
                  onSurface: Colors.black // body text color
                  ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Theme.of(context).primaryColor, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      _timeController.text = time!.format(context);
    }
  }
}
