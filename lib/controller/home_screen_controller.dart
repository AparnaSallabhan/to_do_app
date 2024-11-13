import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/model/task_model.dart';

class HomeScreenController with ChangeNotifier {
  final taskBox = Hive.box<TaskModel>("taskBox");
  List priorityList = ["High", "Medium", "Low"];
  List keys = [];
  List<TaskModel> tasks = [];
  List<TaskModel> filteredTasks = []; //to add filtered tasks
  List sortingPriorityList = [
    "All",
    "High",
    "Medium",
    "Low"
  ]; //for sorting tasks by priority

//to add tasks to taskbox
  void addTask(
      {required String title,
      required String description,
      required String priority}) async {
    await taskBox.add(
        TaskModel(title: title, description: description, priority: priority));
    getTasks();
    print(":::::::::::::::::::Task added");
  }

//to get all tasks
  void getTasks() {
    keys = taskBox.keys.toList();
    tasks = taskBox.values.toList();
    filteredTasks = List.from(tasks);
    print(":::::::::::$tasks");
    notifyListeners();
  }

// to get completed tasks
  void completedTasks() {
    filteredTasks = tasks.where((element) => element.isCompleted!).toList();
    notifyListeners();
  }

//to get pending tasks
  void pendingTasks() {
    filteredTasks = tasks.where((element) => !element.isCompleted!).toList();
    notifyListeners();
  }

//to list tasks by priority
  void getTasksByPriority(int index) {
    if (index == 0) {
      getTasks();
    } else {
      filteredTasks = tasks
          .where(
            (element) => element.priority == sortingPriorityList[index],
          )
          .toList();
    }
    notifyListeners();
  }

//for deleting a task
  void onDelete(int index) {
    taskBox.deleteAt(index);
    getTasks();
  }

//on task completion functionaliity of checkbox
  void onTaskCompletion(int index, bool isCompleted) {
    tasks[index].isCompleted = isCompleted;
    taskBox.putAt(index, tasks[index]);
    getTasks();
  }
}
