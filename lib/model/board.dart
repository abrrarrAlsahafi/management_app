import 'package:flutter/material.dart';
import 'package:management_app/model/sessions.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/services/emom_api.dart';
import 'package:provider/provider.dart';

class Boards {
  int id;
  String name;
  String editor;
  String manager;
  String approval;
  List<String> members;
  bool description;
  List<int> sessionsids;
  String labelSessions;
  int sessionsCount;
  String labelMembers;
  int membersCount;
  String displayName;
  List<Sessions> sessions;

  Boards(
      {this.id,
      this.sessionsids,
      this.name,
      this.editor,
      this.manager,
      this.approval,
      this.members,
      this.description,
      this.sessions,
      this.labelSessions,
      this.sessionsCount,
      this.labelMembers,
      this.membersCount,
      this.displayName});

  Boards.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    editor = json['editor'];
    manager = json['manager'];
    approval = json['approval'];
    members = json['members'].cast<String>();
    description = json['description'];
    sessionsids = json['sessions'].cast<int>();
    labelSessions = json['label_sessions'];
    sessionsCount = json['sessions_count'];
    labelMembers = json['label_members'];
    membersCount = json['members_count'];
    displayName = json['display_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['editor'] = this.editor;
    data['manager'] = this.manager;
    data['approval'] = this.approval;
    data['members'] = this.members;
    data['description'] = this.description;
    data['sessions'] = this.sessionsids;
    data['label_sessions'] = this.labelSessions;
    data['sessions_count'] = this.sessionsCount;
    data['label_members'] = this.labelMembers;
    data['members_count'] = this.membersCount;
    data['display_name'] = this.displayName;
    return data;
  }
}

class BoardsModel extends ChangeNotifier {
  List<Boards> userBoard;
  List<Sessions> boardsSessions;

  getUserBoards() async {
    userBoard = await EmomApi().getMyBoards();
    print("fff ${userBoard.length}");
    return userBoard;
  }

  getBoardSessions(id) async {
    boardsSessions = await EmomApi().getBoardSessions(boardId: id);
    fillBoards();
    return boardsSessions;
  }

  fillBoards() {
    userBoard.forEach((element) {
      element.sessions = boardsSessions;
    });
  }

  currentType(context, bordId) {
    userBoard.forEach((element) {
      if (element.id == bordId) {
        if (element.editor ==
            Provider.of<UserModel>(context, listen: false).user.name) {
          return "editor";
        } else if (element.manager ==
            Provider.of<UserModel>(context, listen: false).user.name) {
          return "manager";
        } else if (element.approval ==
            Provider.of<UserModel>(context, listen: false).user.name) {
          return "approval";
        } else {
          return 'member';
        } //print("element ${bordId}");
      }
    });
  }
}
