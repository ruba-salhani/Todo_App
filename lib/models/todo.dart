class Todo {
  int? id;
  String? name;
  String? date;
  String? time;
  Todo({this.name, this.date, this.time});
  Todo.withId({this.id, this.name, this.date, this.time});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'date': date,
      'time': time,
    };

    return map;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    date = map['date'];
    time = map['time'];
  }
}
