import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/model/task_model.dart';

class HomeScreenController with ChangeNotifier {
  final taskBox = Hive.box<TaskModel>("taskBox");
  List priorityList =["High","Medium","Low"];
  List keys = [];
  List<TaskModel> tasks = [];
  String? selectedPriority;
  void addTask(
      //to add tasks to taskbox
      {required String title,
      required String description,
      required String priority}) async {
    await taskBox.add(
        TaskModel(title: title, description: description, priority: priority));
        getTasks();
        print(":::::::::::::::::::Task added");
  }

  void getTasks() {
    keys = taskBox.keys.toList();
    tasks = taskBox.values.toList();
    print(":::::::::::$tasks");
    notifyListeners();
  }
  
  void onDelete(int index){
    taskBox.deleteAt(index);
    getTasks();
  }

}
