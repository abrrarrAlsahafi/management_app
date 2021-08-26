import 'package:flutter/material.dart';
import 'package:management_app/services/emom_api.dart';

import 'note.dart';

class Task {
  int taskId;
  String taskName;
  String assignedTo;
  String taskStage;
  String project;
  String createDate;
  String createBy;
  List<Note>notes;
  String description;

  Task(
      {this.taskId,
        this.taskName,
        this.assignedTo,
        this.taskStage,
        this.project,
        this.createDate,
        this.createBy,
        this.description,
      this.notes});

  Task.fromJson(Map<String, dynamic> json) {
    taskId = json['task_id'];
    taskName = json['task_name'];
    assignedTo = json['assigned_to'].toString();
    taskStage = json['task_stage'].toString()=='false'?'None':json['task_stage'];
    project = json['project'];
    createDate = json['create_date'];
    createBy = json['create_by'];
    description = json['description'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task_id'] = this.taskId;
    data['task_name'] = this.taskName;
    data['assigned_to'] = this.assignedTo;
    data['task_stage'] = this.taskStage;
    data['project'] = this.project;
    data['create_date'] = this.createDate;
    data['create_by'] = this.createBy;
    data['description'] = this.description;
    return data;
  }
}

class TaskModel with ChangeNotifier {
  int uidAssigind;
   List<Task> userTasks;
  TaskModel(this.userTasks);
  getUserTasks(projectid) async {
    userTasks= await EmomApi().getUserTask(projectid);

    orderTaskByStage();
    return userTasks;
  }

  Future<int> creatNewTask(createTask,projectid ) async {
   int taskId= await EmomApi().createTask(taskName: createTask,projId: projectid);
   print('id $taskId');
      getUserTasks(projectid);
return taskId;
  }


  Future<void> logNot({mas, id}) async{
   await EmomApi().logNote(message: mas, taskId: id);

  }


  Future<void> assginTaskTo({uid, tid}) async{
    await EmomApi().assignTask(uid:uid, tid: tid);

  }


  Future<List<Note>> viewLogNote() async{

    userTasks.forEach((element) async {
      element.notes= await EmomApi().veiwLogNote(tid: element.taskId);
    }) ;
    print('logNote .. ${userTasks[0].notes}');


  }

  void orderTaskByStage() {
    userTasks.sort((a,b) =>b.notes.first.date.compareTo(a.notes.first.date)
    // if( a.taskStage=='Done'||  a.taskStage=='Close'|| a.taskStage=='done'){

     //} }
   );

  }

}
