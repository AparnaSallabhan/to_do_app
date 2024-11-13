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
    String? dropValue;
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: Text("ToDo",style: TextStyle(fontWeight: FontWeight.bold),),
       // backgroundColor: Colors.grey[300],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Title",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    //title text field
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 4, color: Colors.black),
                              borderRadius: BorderRadius.circular(20))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Description",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    //description textfield
                    TextField(
                      controller: descriptionController,
                      maxLines: 2,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 4, color: Colors.black),
                              borderRadius: BorderRadius.circular(20))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Priorities",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 8,
                    ),
//priority button
                    DropdownButton(
                      hint: Text("Select"),
                      focusColor: Colors.grey,
                      alignment: Alignment.center,
                      icon: Icon(Icons.keyboard_arrow_down_outlined),
                      items: List.generate(
                        homeScreenprovider.priorityList.length,
                        (index) => DropdownMenuItem(
                          value:
                              homeScreenprovider.priorityList[index].toString(),
                          child: Text(homeScreenprovider.priorityList[index]),
                        ),
                      ),
                      onChanged: (value) {
                        dropValue = value;
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
                                  priority: dropValue!);
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
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: ListView.separated(
          padding: EdgeInsets.all(15),
          itemBuilder: (context, index) => TaskCard(
                description: homeScreenprovider.tasks[index].description,
                title: homeScreenprovider.tasks[index].title,
                priority: homeScreenprovider.tasks[index].priority,
                onDelete: () {
                  context.read<HomeScreenController>().onDelete(index);
                },
                onCheckChanged: (p0) {
                  
                },
              ),
          separatorBuilder: (context, index) => SizedBox(
                height: 15,
              ),
          itemCount: homeScreenprovider.tasks.length),
    );
  }
}
