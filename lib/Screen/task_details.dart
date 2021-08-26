import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_app/Screen/tasks.dart';
import 'package:management_app/widget/task_card.dart';

import '../app_theme.dart';

class TaskDetails extends StatelessWidget {
  final task;
  final title;

  const TaskDetails({Key key, this.task, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('$title',style: MyTheme.kAppTitle,),),
      body: ListView(
        children: [
          Container(
            //height: MediaQuery.of(context).size.height/1.25,
              child: CartTask(
                onTap: (){
                  Navigator.pop(context);
                },
                isTask: false,
                des: task,
                child: Container(    height: MediaQuery.of(context).size.height / 1.47,
                    child: TaskNote(note: task.notes == null ? [] : task.notes)),
                click: true, //expandList[index],
                listTile: ListTile(
                  trailing: Text(
                    task.notes == null
                        ? ""
                        : DateFormat.yMMMd()
                            .format(DateTime.parse(task.notes.first.date)),
                    style: MyTheme.bodyTextTime,
                  ),
                  title: Text(task.taskName,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text(
                      "${task.createBy} on  ${DateFormat.yMMMd().format(task.createDate == null ? DateTime.now() : DateTime.parse(task.createDate))} To ${task.assignedTo}",
                      style: TextStyle(fontSize: 11)),
                ),
              )),
        ],
      ),
    );
  }
}
