// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  const TaskCard(
      {super.key,
      required this.title,
      required this.description,
      required this.priority,
      this.iscompleted = false,
      this.onCheckChanged,
      this.onDelete});
  final String title;
  final String description;
  final String priority;
  final bool iscompleted;
  final void Function()? onDelete;
  final void Function(bool?)? onCheckChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //row of title and task completing checkbox
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //title
              Text(
                title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: iscompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              Checkbox(
                value: iscompleted,
                onChanged: onCheckChanged,
              )
            ],
          ),

          //description
          Text(
            description,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          // SizedBox(
          //   height: 10,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //priority
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: priorityColor().withOpacity(.2)),
                child: Text(
                  priority,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: priorityColor()),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete,
                    color: Colors.black,
                  )),
            ],
          )
        ],
      ),
    );
  }

//to set the color based on priority
  Color priorityColor() {
    if (priority == "High") {
      return Colors.red;
    } else if (priority == "Medium") {
      return Colors.orange;
    } else {
      return Colors.blue;
    }
  }
}
