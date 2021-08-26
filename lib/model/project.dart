import 'package:flutter/material.dart';
import 'package:management_app/services/emom_api.dart';

class Project {
  int id;
  String name;
  int managerId;
  String managerName;
  int noOfTask;

  Project(
      {this.id, this.name, this.managerId, this.managerName, this.noOfTask});

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    managerId = json['manager_id'];
    managerName = json['manager_name'];
    noOfTask = json['no_of_task'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['manager_id'] = this.managerId;
    data['manager_name'] = this.managerName;
    data['no_of_task'] = this.noOfTask;
    return data;
  }
}

class ProjectModel with ChangeNotifier {
  List<Project> userProject;
  ProjectModel();

  getUserProjects() async {
    userProject = await EmomApi().getMyProjects();
    notifyListeners();

    return userProject;
  }

  taskCount(proId) async {
    List tasks = await EmomApi().getUserTask(proId);
    return tasks.length;
  //  notifyListeners();

  }

  nameOfProject(pid) {
    String nameProject; //=List();
    userProject.forEach((element) {
      if (element.id == pid) {
        nameProject = element.name;
      }
    });

    return nameProject;

  }
}
