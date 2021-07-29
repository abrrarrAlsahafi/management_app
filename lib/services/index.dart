import 'package:management_app/model/folowing.dart';
import 'package:management_app/model/massege.dart';
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
  Future<dynamic> chatHistory(bool isFrist);
  Future<List<Folowing>> getfollowingList();
  Future<List<Task>> getUserTask(id);
  Future<NewMessages> newMasseges();
  Future<void> assignTask();

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
  Future<dynamic> chatHistory(bool isFrist) {
    throw serviceApi.chatHistory(isFrist);
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
}
