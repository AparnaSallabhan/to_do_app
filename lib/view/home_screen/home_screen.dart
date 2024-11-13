// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/controller/home_screen_controller.dart';
import 'package:to_do_app/view/home_screen/widgets/task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<HomeScreenController>().getTasks();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeScreenprovider = context.watch<HomeScreenController>();
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    String? selectedPriority;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        centerTitle: true,
        title: Text(
          "Your Tasks",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),
        ),
        actions: [
          PopupMenuButton(
            child: Icon(Icons.menu),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("All Tasks"),
                onTap: () {
                  context.read<HomeScreenController>().getTasks();
                },
              ),
              PopupMenuItem(
                child: Text("Completed Tasks"),
                onTap: () {
                  context.read<HomeScreenController>().completedTasks();
                },
              ),
              PopupMenuItem(
                child: Text("Pending Tasks"),
                onTap: () {
                  context.read<HomeScreenController>().pendingTasks();
                },
              )
            ],
          ),
          SizedBox(
            width: 25,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          _addTaskMethod(context, titleController, descriptionController,
              homeScreenprovider, selectedPriority);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              homeScreenprovider.sortingPriorityList.length,
              (index) => TextButton(
                onPressed: () {
                  context
                      .read<HomeScreenController>()
                      .getTasksByPriority(index);
                },
                child: Text(
                  homeScreenprovider.sortingPriorityList[index],
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
                padding: EdgeInsets.all(15),
                itemBuilder: (context, index) => TaskCard(
                      description:
                          homeScreenprovider.filteredTasks[index].description,
                      title: homeScreenprovider.filteredTasks[index].title,
                      priority:
                          homeScreenprovider.filteredTasks[index].priority,
                      iscompleted:
                          homeScreenprovider.filteredTasks[index].isCompleted ??
                              false,
                      onDelete: () {
                        context.read<HomeScreenController>().onDelete(index);
                      },
                      onCheckChanged: (isChecked) {
                        context
                            .read<HomeScreenController>()
                            .onTaskCompletion(index, isChecked ?? false);
                      },
                    ),
                separatorBuilder: (context, index) => SizedBox(
                      height: 15,
                    ),
                itemCount: homeScreenprovider.filteredTasks.length),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _addTaskMethod(
      BuildContext context,
      TextEditingController titleController,
      TextEditingController descriptionController,
      HomeScreenController homeScreenprovider,
      String? selectedPriority) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 8,
              ),
              //title text field
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 4, color: Colors.black),
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Description",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 8,
              ),
              //description textfield
              TextField(
                controller: descriptionController,
                maxLines: 2,
                decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 4, color: Colors.black),
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Priorities",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 8,
              ),
//priority button
              DropdownButton(
                hint: Text("Select Priority"),
                value: selectedPriority,
                focusColor: Colors.grey,
                alignment: Alignment.center,
                icon: Icon(Icons.keyboard_arrow_down_outlined),
                items: List.generate(
                  homeScreenprovider.priorityList.length,
                  (index) => DropdownMenuItem(
                    value: homeScreenprovider.priorityList[index].toString(),
                    child: Text(homeScreenprovider.priorityList[index]),
                  ),
                ),
                onChanged: (value) {
                  selectedPriority = value;
                },
              ),
              SizedBox(
                height: 15,
              ),
              //row of buttons
              Row(
                children: [
                  //save button
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        //calling the addtask fuction
                        context.read<HomeScreenController>().addTask(
                            title: titleController.text,
                            description: descriptionController.text,
                            priority: selectedPriority!);
                        //clearing controllers
                        titleController.clear();
                        descriptionController.clear();
                        //poping botom sheet
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  //cancel button
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
