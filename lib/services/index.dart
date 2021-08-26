import 'package:management_app/model/board.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/model/massege.dart';
import 'package:management_app/model/note.dart';
import 'package:management_app/model/project.dart';
import 'package:management_app/model/sessions.dart';
import 'package:management_app/model/task.dart';
import 'package:management_app/model/user.dart';

import 'emom_api.dart';

abstract class BaseServices {
  Future<User> createUser({
    id,
    firstName,
    lastName,
    email,
    password,
  });

  Future<dynamic> login(context,{username, password});
  Future<void> logOut({username, password});
  Future<dynamic> chatHistory();
  Future<List<Folowing>> getfollowingList();
  Future<List<Task>> getUserTask(id);
  Future<NewMessages> newMasseges();
  Future<void> assignTask();
  Future<List<Massege>> getMassegesContext(var masgId);
  Future<int> createTask({Task taskName, int projId});
  Future<List<Project>> getMyProjects();
  Future<List<Boards>> getMyBoards();
  Future<void> addMembers(channelId, memberId);
  Future<void> logNote({message, taskId});
  Future<List<Note>> veiwLogNote({tid});
  Future<List<Sessions>> getBoardSessions({boardId});
  Future<dynamic> actionSign({sessionId});
  Future<dynamic> actionDiscreet({sessionId, discreet});
  Future<dynamic> sendToManager({sessionId});
  Future<dynamic> sendToMembers({sessionId});
  Future<dynamic> toApproved({sessionId});
}

class Services implements BaseServices {
  BaseServices serviceApi = EmomApi();
  //Stream<Locale> get localLangouge {
   // var localeSubject = BehaviorSubject<Locale>();

    //  (localeSubject.sink )
    //    ? localeSubject.sink.add(Locale('ar', 'AR'))
    //     : localeSubject.sink.add(Locale('en', 'US'));

    //  return localeSubject.stream.distinct();
//  }

  Stream<User> get user {
    //return _auth.onAuthStateChanged.map(_userFormFirebaceUser);
  }
  @override
  Future<User> createUser({
    id,
    firstName,
    lastName,
    email,
    password,
  }) {
    throw serviceApi.createUser();
  }

  @override
  Future<dynamic> login(context,{username, password}) {
    throw serviceApi.login(context);
  }

  @override
  Future<dynamic> chatHistory() {
    throw serviceApi.chatHistory();
  }

  @override
  Future<List<Task>> getUserTask(id) {
    throw serviceApi.getUserTask(id);
  }

  @override
  Future<List<Folowing>> getfollowingList() {
    // TODO: implement getfollowingList
    throw serviceApi.getfollowingList();
  }

  @override
  Future<NewMessages> newMasseges() {
    // TODO: implement newMasseges
    throw serviceApi.newMasseges();
  }

  @override
  Future logOut({username, password}) {
    // TODO: implement sginOut
    throw serviceApi.logOut();
  }

  @override
  Future<void> assignTask() {
    // TODO: implement assignTask
    throw serviceApi.assignTask();
  }

  @override
  Future toApproved({sessionId}) {
    // TODO: implement toApproved
    throw serviceApi.toApproved();
  }

  @override
  Future actionDiscreet({sessionId, discreet}) {
    // TODO: implement actionDiscreet
    throw UnimplementedError();
  }

  @override
  Future actionSign({sessionId}) {
    // TODO: implement actionSign
    throw UnimplementedError();
  }

  @override
  Future<void> addMembers(channelId, memberId) {
    // TODO: implement addMembers
    throw UnimplementedError();
  }

  @override
  Future<int> createTask({Task taskName, int projId}) {
    // TODO: implement createTask
    throw UnimplementedError();
  }

  @override
  Future<List<Sessions>> getBoardSessions({boardId}) {
    // TODO: implement getBoardSessions
    throw UnimplementedError();
  }

  @override
  Future<List<Massege>> getMassegesContext(masgId) {
    // TODO: implement getMassegesContext
    throw UnimplementedError();
  }

  @override
  Future<List<Boards>> getMyBoards() {
    // TODO: implement getMyBoards
    throw UnimplementedError();
  }

  @override
  Future<List<Project>> getMyProjects() {
    // TODO: implement getMyProjects
    throw UnimplementedError();
  }

  @override
  Future<void> logNote({message, taskId}) {
    // TODO: implement logNote
    throw UnimplementedError();
  }

  @override
  Future sendToManager({sessionId}) {
    // TODO: implement sendToManager
    throw UnimplementedError();
  }

  @override
  Future sendToMembers({sessionId}) {
    // TODO: implement sendToMembers
    throw UnimplementedError();
  }

  @override
  Future<List<Note>> veiwLogNote({tid}) {
    // TODO: implement veiwLogNote
    throw UnimplementedError();
  }
}
