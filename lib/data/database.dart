import 'package:hive/hive.dart';

class ToDoDatabase {
  List toDoList = [];

  // reference the box
  final _mybox = Hive.box('mybox');

//  run this method for first time ever opening this app
  void createInitialData() {
    toDoList = [
      ["Make Tutorial", false],
      ["Learn Flutter", false],
    ];
  }

//  load the data from the database
  void loadData() {
    toDoList = _mybox.get("TODOLIST");
  }

// update the database
  void updateDataBase() {
    _mybox.put("TODOLIST", toDoList);
  }
}
