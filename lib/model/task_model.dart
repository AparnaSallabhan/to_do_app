import 'package:hive/hive.dart';
part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel {
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;
  @HiveField(2)
  String priority;
  @HiveField(3)
  bool? isCompleted;

  TaskModel(
      {required this.title,
      required this.description,
      required this.priority,
      this.isCompleted = false});
}
