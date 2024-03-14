import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app_2024/data/database.dart';
import 'package:todo_app_2024/utils/dialog_box.dart';
import 'package:todo_app_2024/utils/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the box
  final _mybox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    // if this is the 1st time ever opening the app, then create default data

    if (_mybox.get('TODOLIST') == null) {
      db.createInitialData();
    } else {
      // there already exist data
      db.loadData();
    }

    super.initState();
  }

  final _controller = TextEditingController();

  // //List of todo tasks
  // List toDoList = [
  //   ["Make Tutorial", false],
  //   ["Learn Flutter", false],
  // ];

  //checkbox was tapped
  void checkboxChanged(bool? value, int index) {
    setState(
      () {
        db.toDoList[index][1] = !db.toDoList[index][1];
      },
    );
    db.updateDataBase();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  //create a new tasks
  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  // delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        backgroundColor: Colors.yellow[200],
        title: Text("TO DO"),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: db.toDoList.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              onChanged: (value) => checkboxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
            );
          }),
    );
  }
}
