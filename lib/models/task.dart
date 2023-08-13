class Task {
  Task({required this.id, required this.title, required this.date, required this.time, required this.status});
  
  Task.fromMap(Map map){
    id = map['id'];
    title = map['title'];
    date = map['date'];
    time = map['time'];
    status = map['status'];
  }

  int id = -1;
  String title = '';
  String date = '';
  String time = '';
  String status = '';
}