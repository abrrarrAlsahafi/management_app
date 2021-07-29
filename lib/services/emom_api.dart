import 'dart:convert' as convert;
import 'dart:convert';
import 'package:management_app/model/board.dart';
import 'package:management_app/model/channal.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/model/massege.dart';
import 'package:management_app/model/note.dart';
import 'package:management_app/model/project.dart';
import 'package:management_app/model/sessions.dart';
import 'package:management_app/model/task.dart';
import 'package:management_app/model/user.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'index.dart';

class EmomApi implements BaseServices {
  var _client = "http://demo.ewady.com/";
  var _db = 'ewady_production'; //listMember
/*  OdooClient  client = OdooClient("http://demo.ewady.com/");//listMember
  final orpc = OdooClient('http://demo.ewady.com');
  OdooSession odooSession;

  getSessionId()  async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    odooSession= await orpc.authenticate('ewady_production', '${localStorage.getString('email')}', '${localStorage.getString('pass')}');
    print("check session id ${ odooSession.isSystem}");
    print(" session id ${orpc.sessionId}");
    return orpc.sessionId;

    //odooSession.updateSessionId(newSessionId);
  }
*/
  _setHeaders(id) =>
      {
        'Content-Type': 'application/json',
        'Cookie': 'frontend_lang=en_US; session_id=$id'
      };

  String headers;

  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers = (index == -1) ? rawCookie : rawCookie.substring(11, index);
    }
  }

  @override
  Future<User> createUser({
    id,
    firstName,
    lastName,
    email,
    password,
    // passwordconfirmation,
  }) async {
    try {
      // print("create user .. ${firstName}");
      var response = await http.post(
        '',
        body: convert.jsonEncode({
          "First_Name": firstName,
          "Last_Name": lastName,
          "Email": email,
          "password": password,
          "password_confirmation": password
        }),
        //  headers: _setHeaders(id)
      );
      if (response.statusCode == 200) {
        // var body = convert.jsonDecode(response.body);
        // print('code response : ${response.statusCode}, $body');
        return null;
      } else {
        final body = convert.jsonDecode(response.body);
        List error = body["messages"];
        if (error != null && error.isNotEmpty) {
          throw Exception(error[0]);
        } else {
          throw Exception("Can not create user");
        }
      }
    } catch (err) {
      print('$err');
      rethrow;
    }
  }


  @override
  Future<void> logOut({username, password}) async {
   // print('$username  $password');
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      var response = await http.post('${_client}web/session/destroy',
          body: convert.jsonEncode({
            "jsonrpc": "2.0",
            "params": {"db": _db, "login": "$username", "password": "$password"}
          }),
          headers:_setHeaders(id)/* {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }*/);
       print('code logout response : ${response.statusCode}, ${response.body}');
//Todo:cose Provider
    } catch (err) {
      print('$err');
      rethrow;
    }
  }

  @override
  Future<User> getUserInfor(cookie) async {
    var res = await http
        .get(_client, headers: {'Content-Type': 'application/json' + cookie});
    // print('user info: ${res.body}');
    return null; //User.fromOpencartJson(convert.jsonDecode(res.body), cookie);
  }

  @override
  Future<dynamic> login(context,{username, password}) async {
    //getSessionId();
    // print(_client);
    try {
      var response = await http.post("${_client}web/session/authenticate",
          body: convert.jsonEncode({
            "jsonrpc": "2.0",
            "params": {"db": _db, "login": username, "password": password}
          }),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }); //_setHeaders());
      updateCookie(response);
      //print("response.. ${response.body}");

      final body = convert.jsonDecode(response.body);
      if (!response.body.contains("error")) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('session_id', headers);
        localStorage.setInt('uid', body['result']['uid']);
        localStorage?.setBool("isLoggedIn", true);
        // print(response.body);
       // prefs?.setBool("isLoggedIn", true);
      //  User user
        //Provider.of<UserModel>(context,listen: false).saveUser(user);

        return User.fromJson(body['result']);
      } else {
        final body = convert.jsonDecode(response.body);
        return Exception(body["message"] =
        body['error']['data']['message'] //: "Can not get token"
        );
      } /**/ // Network is unreachable,
    } catch (err) {
      // print("network error $err");
      return err;
      // rethrow;
    }
  }

  @override
  Future<int> createNewChannal(String channelName, List memberIds, isChat,
      isPrivate) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      var response = await http.post(
        "${_client}chat/add_new_channel",
        headers: _setHeaders(id),
        body: convert.jsonEncode({
          "jsonrpc": "2.0",
          "params": {
            "channel_name": channelName,
            "member_ids": memberIds,
            "channel_type": isChat ? "chat" : "channel",
            "public": isPrivate ? "private" : "public"
          }
        }),
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        String strNum = "${body['result'].toString()}";
        final iReg = RegExp(r'(\d+)');
        String s = iReg.allMatches(strNum).map((m) => m.group(0)).join(' ');
        var newid = int.parse(s.substring(4));
        //print(iReg.allMatches(strNum).map((m) => m.group(0)).join(' '));
        return newid;
      }
      // String strNum= "{\"code\": 200, \"message\": \"Channel Created\", \"channel_id\": 32}";

      // final iReg = RegExp(r'(\d+)');

    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> postNewMessage(int channalid, String massege) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      var response = await http.post(
        "${_client}chat/post_new_messages",
        headers: _setHeaders(id),
        body: convert.jsonEncode(
          {
            "jsonrpc": "2.0",
            "params": {"message": "$massege", "channel_id": channalid}
          },
        ),
      );
      // print("post massege  ${response.body}");
      if (response.statusCode == 200) {
        return response.body.contains('messages Created');
      } else {
        // print("post massege  ${response.body}");
        return false;
      }
    } catch (e) {
      rethrow;
    }
  } //User.fro

  @override
  Future<List<Chat>> chatHistory(bool isfrist) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      http.Response response = await http.get(
          "${_client}chat/get_user_channels/",
          headers: {'Cookie': 'frontend_lang=en_US; session_id=$id'});
      List<Chat> list = [];
      // var respData = json.decode(response.body);

      if (response.statusCode == 200) {
        for (var item in convert.jsonDecode(response.body)["data"]) {
          list.add(Chat.fromJson(item, isfrist));
        //  print("chat item.. ${item}");

        }
//print("chat list.. ${list}");
      }

      return list;
    } catch (e) {
      rethrow;
    }
  } //User.fromOpencartJson(convert.jsonDecode(res.body), cookie);

  @override
  Future<List<Task>> getUserTask(projectId) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      final response =
      await http.get("${_client}project/get_task_details?project_id=$projectId",
          headers: {
            'Cookie': 'frontend_lang=en_US; session_id=$id'
          });

      List<Task> list = [];
      //  print("${response.body}");

      // var respData = json.decode(response.body);
      // print(response.body);
      if (response.statusCode == 200) {
        for (var item in convert.jsonDecode(response.body)["data"]) {
          list.add(Task.fromJson(item));
        }
      }
      list.forEach((element) async {
        element.notes = await veiwLogNote(tid: element.taskId);
        //print('note ${element.notes}');
      });

      return list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Folowing>> getfollowingList() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      http.Response response = await http.get("${_client}chat/get_user_list/",
          headers: {'Cookie': 'frontend_lang=en_US; session_id=$id'});
      List<Folowing> list = [];

      if (response.statusCode == 200) {
        for (var item in convert.jsonDecode(response.body)["data"]) {
          list.add(Folowing.fromJson(item));
        }
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Massege>> getMassegesContext(var masgId) async {
    //print(masgId);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      http.Response response = await http.get(
          "${_client}chat/get_chanel_messages?channel_id=$masgId",
          headers: {'Cookie': 'frontend_lang=en_US; session_id=$id'});
      List<Massege> list = [];
      // var respData = json.decode(response.body);0

      if (response.statusCode == 200) {
        for (var item in convert.jsonDecode(response.body)["data"]) {
          list.add(Massege.fromJson(item));
        }
      }
      //print('response 1111 ${response.body}');

      return list;
    } catch (e) {
      rethrow;
    }
  }

  saveToLocal(List list, str) async {
    SharedPreferences prf = await SharedPreferences.getInstance();
    await prf.setString(str, Chat.encode(list));
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.getString(str);
  }

  @override
  Future<NewMessages> newMasseges() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');

    try {
      http.Response response = await http.get("${_client}chat/get_new_messages",
          headers: {'Cookie': 'frontend_lang=en_US; session_id=$id'});
      NewMessages newMessages;
      if (response.statusCode == 200) {
        newMessages = NewMessages.fromJson(json.decode(response.body)['data']);
        //   }
      }
      return newMessages;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> createTask({Task taskName, int projId}) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      var response = await http.post(
        "${_client}project/create_task",
        headers: _setHeaders(id),
        body: convert.jsonEncode({
          "jsonrpc": "2.0",
          "params": {
            "task_name": "${taskName.taskName}",
            "project_id": projId,
            "description": "${taskName.description}"
          }
        }),
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        String strNum = "${body['result'].toString()}";
        final iReg = RegExp(r'(\d+)');
        String s = iReg.allMatches(strNum).map((m) => m.group(0))
            .join(' ')
            .substring(4);
     //   print("body: ${s}");
        return int.parse(s);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Project>> getMyProjects() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      http.Response response = await http.get(
          "${_client}project/get_my_projects",
          headers: {
            'Cookie': 'frontend_lang=en_US; session_id=$id'});
      List<Project> myProject =[];
      // final body = json.decode(response.body);
      //print(response);
      if (response.statusCode == 200) {
        for (var item in convert.jsonDecode(response.body)["data"]) {
          myProject.add(Project.fromJson(item));
        }
      }
      return myProject;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Boards>> getMyBoards() async {
    print(';;kl;lklk');
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    print('id $id');
    try {
      http.Response response = await http.get(
          "${_client}mom/get_my_boards",
          headers: {
            'Cookie': 'frontend_lang=en_US; session_id=$id'});
      List<Boards> myBoards = List();
      print("item.... ${response.statusCode}");

      // final body = json.decode(response.body);
      if (response.statusCode == 200) {
        for (var item in convert.jsonDecode(response.body)["boards"]) {
          myBoards.add(Boards.fromJson(item));
        }
        print(myBoards.isEmpty);
        return myBoards;
      }

    } catch (e) {
      print(e.runtimeType);
      rethrow;
    }
  }

  @override
  Future<void> addMembers(channelId, memberId) async {
    //  print("$channelId , $memberId ");
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    var res = await http.post("${_client}chat/add_members",
        body: convert.jsonEncode({
          "jsonrpc": "2.0",
          "params": {"member_ids": memberId, "channel_id": channelId}
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': 'frontend_lang=en_US; session_id=$id'});
  }

  @override
  Future<void> logNote({message, taskId}) async {
   // print('res ${message} $taskId');

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    var res = await http.post("${_client}project/log_note",
        body: convert.jsonEncode({
          "jsonrpc": "2.0",
          "params": {"message": message, "task_id": taskId}
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': 'frontend_lang=en_US; session_id=$id'
        }
    );
    //print('res ${res.body}');
  }

  @override
  Future<void> assignTask({uid, tid}) async {
    //  print("$uid  task  $tid");
    // TODO: implement assignTask
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      var response = await http.post(
        "${_client}project/assign_task",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': 'session_id=$id'
        }, // _setHeaders(id),
        body: convert.jsonEncode(
          {
            "jsonrpc": "2.0",
            "params": {"user_id": uid, "task_id": tid}
          },
        ),
      );

      if(response.hashCode==200){
      //  EmomApi().getMyProjects();
      }
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<List<Note>> veiwLogNote({tid}) async {
    // TODO: implement assignTask
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      var response = await http.get(
          "${_client}project/get_task_notes?task_id=$tid",
          headers: {'Cookie': 'frontend_lang=en_US; session_id=$id'});
      List<Note> list = [];

      if (response.statusCode == 200) {
        for (var item in convert.jsonDecode(response.body)["data"]) {
          list.add(Note.fromJson(item));
        }
      }
      // print('note length  ${list.length}');

      return list;
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<List<Sessions>> getBoardSessions({boardId}) async {
    //  print("id.. $boardId");

    // TODO: implement assignTask
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      var response = await http.get(
          "${_client}mom/get_board_sessions?board_id=$boardId",
          headers: {'Cookie': 'frontend_lang=en_US; session_id=$id'});
      List<Sessions> list = [];
        // print(response.body);

      if (response.statusCode == 200) {
        for (var item in convert.jsonDecode(response.body)["boards"]) {
          list.add(Sessions.fromJson(item));
        }
      }
    //   print('list   ${list}');

      return list;
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future<dynamic> actionSign({sessionId}) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      var response = await http.post("${_client}mom/action_sign",
          body: convert.jsonEncode({
            "jsonrpc": "2.0",
            "params": {"db": _db,
              "session_id": sessionId}
          }),
        headers: _setHeaders(id));//_setHeaders());
     // updateCookie(response);
    //  print("response.. ${response.body}");

      final body = convert.jsonDecode(response.body)['result']['message'];
    // print("body.. ${body}");
      return body.toString();
     /**/ // Network is unreachable,
    } catch (err) {
      // print("network error $err");
      return err;
      // rethrow;
    }
  }



  @override
  Future<dynamic> actionDiscreet({sessionId, discreet}) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      var response = await http.post("${_client}mom/action_discreet",
          body: convert.jsonEncode({
            "jsonrpc": "2.0",
            "params": {"db": _db,
              "session_id": sessionId},
            "discreet":"$discreet"
          }),
          headers: _setHeaders(id));//_setHeaders());
      // updateCookie(response);
      //  print("response.. ${response.body}");

      final body = convert.jsonDecode(response.body)['result']['message'];
      // print("body.. ${body}");
      return body.toString();
      /**/ // Network is unreachable,
    } catch (err) {
      // print("network error $err");
      return err;
      // rethrow;
    }
  }

  @override
  Future<dynamic> sendToManager({sessionId}) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      var response = await http.post("${_client}mom/send_to_manager",
          body: convert.jsonEncode({
            "jsonrpc": "2.0",
            "params": {"db": _db,
              "session_id": sessionId}
          }),
          headers: _setHeaders(id));//_setHeaders());
      // updateCookie(response);
      //  print("response.. ${response.body}");

      final body = convert.jsonDecode(response.body)['result']['message'];
      // print("body.. ${body}");
      return body.toString();
      /**/ // Network is unreachable,
    } catch (err) {
      // print("network error $err");
      return err;
      // rethrow;
    }
  }

  @override
  Future<dynamic> sendToMembers({sessionId}) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      var response = await http.post("${_client}mom/action_sign",
          body: convert.jsonEncode({
            "jsonrpc": "2.0",
            "params": {"db": _db,
              "session_id": sessionId}
          }),
          headers: _setHeaders(id));//_setHeaders());
      // updateCookie(response);
      //  print("response.. ${response.body}");

      final body = convert.jsonDecode(response.body)['result']['message'];
       //print("body.. ${body}");
      return body.toString();
      /**/ // Network is unreachable,
    } catch (err) {
      // print("network error $err");
      return err;
      // rethrow;
    }
  }

  @override
  Future<dynamic> toApproved({sessionId}) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String id = localStorage.get('session_id');
    try {
      var response = await http.post("${_client}mom/action_sign",
          body: convert.jsonEncode({
            "jsonrpc": "2.0",
            "params": {"db": _db,
              "session_id": sessionId}
          }),
          headers: _setHeaders(id));//_setHeaders());
      // updateCookie(response);
      //  print("response.. ${response.body}");

      final body = convert.jsonDecode(response.body)['result']['message'];
      // print("body.. ${body}");
      return body.toString();
      /**/ // Network is unreachable,
    } catch (err) {
      // print("network error $err");
      return err;
      // rethrow;
    }
  }


}


