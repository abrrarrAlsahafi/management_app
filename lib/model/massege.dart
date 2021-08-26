import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:management_app/model/channal.dart';
import 'dart:core';

import 'package:management_app/services/emom_api.dart';
import 'package:provider/provider.dart';

import '../notification_test.dart';

class Massege {
  var text;
  var sender;
  DateTime date;
  var idSender;
  bool isMine;

  Massege(this.text, this.date, this.sender, this.isMine);

  Massege.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['message_date']);
    text = json['message_body'];
    sender = json['message_sender'];
    idSender = json['sender_id'];
    isMine = json['is_mine'];
  //  print('date $date, $text}');

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message_date'] = this.date;
    data['message_body'] = this.text;
    data['message_sender'] = this.sender;
    data['sender_id'] = this.idSender;
    data['is_mine'] = this.isMine;
    return data;
  }
}

class MassegesContent extends ChangeNotifier {
  bool isNewMassege = false;
  List massegesContent;

  MassegesContent();

  get masseges => massegesContent.last;

  getMassegesContext(mid) async {
    massegesContent = await EmomApi().getMassegesContext(mid);
    return massegesContent;
    //await EmomApi().getMassegesContent(mid);
  }

  gitAllMessagees(context) {
    Provider.of<ChatModel>(context, listen: false)
        .chatsList
        .forEach(( Chat element) async {
          if(element.newMessage==null||!element.newMessage){element.massegContex = await getMassegesContext(element.id);}
    //  print("masseges ${element.newMessage}");
    });
  }
}

class NewMessagesModel extends ChangeNotifier {
  NewMessages newMessages;
  NewMessages backupNewMessages;
  bool notificatin=false;
   //List<Chat> channelMessages;
  // int totalm=-1;
  NewMessagesModel();

  newMessagesList(context) async {
    newMessages = await EmomApi().newMasseges();

    if (newMessages.totalNewMessages > 0 &&(backupNewMessages==null
        ||backupNewMessages.channelMessages.last.lastMessage!=newMessages.channelMessages.last.lastMessage)) {
     backupNewMessages=newMessages;//:backupNewMessages;//==newMessages?newMessages:backupNewMessages;

      print('nnn.. ${backupNewMessages.channelMessages.last.lastMessage},,${newMessages.channelMessages.last.lastMessage}');

     if( backupNewMessages.channelMessages.last.lastMessage==newMessages.channelMessages.last.lastMessage){
       notificatin=true;
       getnewMasseges(context);
     }
      //update chat hestory

    //  await Provider.of<ChatModel>(context, listen: false).getChannalsHistory();
    //  Provider.of<ChatModel>(context, listen: false).orderByLastAction();

    }
    //sortchatlist
    print("total messege ${newMessages.totalNewMessages}");
    return newMessages.totalNewMessages;
  }

  getnewMasseges(context){

    Provider.of<NewMessagesModel>(context,listen: false).newMessages.channelMessages.forEach((element) {
     // print("element ${element.newMessages}");
        Provider.of<ChatModel>(context, listen: false).chatsList.forEach((e) {
      //    print("e ${e.newMessages}");

          if (e.id == element.id) {
            e.newMessages=element.newMessages;
            e.newMessage = true;
            e.lastMessage = element.lastMessage;
            e.lastDate = element.lastDate;
          //  notificatin=true;
            localNotificationCall(context);
           // print("e ${e.newMessages}");
        //    showNotification(e.lastMessage, e.name, flp);

            Provider.of<ChatModel>(context, listen: false).orderByLastAction();
  } else {
          //  e.newMessage = false;
            // Provider.of<ChatModel>(context, listen: false)
           // Provider.of<ChatModel>(context, listen: false).orderByLastAction();
          }
        });
      });
    }


    localNotificationCall(context){//newMessages.channelMessages.last.lastMessage==backupNewMessages.channelMessages.last.lastMessage&&
    if( notificatin){//Provider.of<NewMessagesModel>(context,listen: false).newMessages.channelMessages.last.lastMessage== Provider.of<ChatModel>(context, listen: false).chatsList.last.lastMessage){
      FlutterLocalNotificationsPlugin flp =
      FlutterLocalNotificationsPlugin();
      var android = AndroidInitializationSettings('@mipmap/ic_launcher_foreground');
      var iOS = IOSInitializationSettings();
      var initSetttings =
      InitializationSettings( android, iOS);
      flp.initialize(initSetttings);
      showNotification(newMessages.channelMessages.last.lastMessage,
          newMessages.channelMessages.last.name, flp);
      /*scheduleNotification(
          notifsPlugin: flp, //Or whatever you've named it in main.dart
          id: DateTime.now().toString(),
          body: "A scheduled Notification",
          scheduledTime: DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute+1));
      */  notificatin=false;
      //backupNewMessages=newMessages;
    }
    }

  bool isHaveNewMassge(int id) {
    bool ishave = false;
    newMessages.channelMessages.forEach((element) {
      if (id == element.id) {
        ishave = true;
        // totalm=totalm-1;
        return ishave;
      }
      // return ishave;
    });
    return ishave;
  }
}

class NewMessages {
  int totalNewMessages ;
  List<Chat> channelMessages;

  NewMessages({this.totalNewMessages, this.channelMessages});

  NewMessages.fromJson(Map<String, dynamic> json) {
    print('${json['total_new_messages'].runtimeType}');
    totalNewMessages =
        json['total_new_messages']; //int.parse(json['total_new_messages']);
    if (json['channel_messages'] != null) {
      channelMessages = []; //new List<ChannelMessages>();
      json['channel_messages'].forEach((v) {
        channelMessages.add(new Chat.fromJson(v));

      });
      //int("channelMessages ${channelMessages.first.id}");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_new_messages'] = this.totalNewMessages;
    if (this.channelMessages != null) {
      data['channel_messages'] =
          this.channelMessages.map((v) => Chat.toJson(v)).toList();
    }
    return data;
  }
}
/*
class ChannelMessages {
  int channelId;
  int newMessages;
  String channelName;
  String image;
  String lastMessage;
  String lastDate;
  bool isChat;

  ChannelMessages(
      {this.channelId,
      this.newMessages,
      this.channelName,
      this.image,
      this.lastMessage,
      this.lastDate,
      this.isChat});

  ChannelMessages.fromJson(Map<String, dynamic> json) {
    channelId = json['channel_id'];
    newMessages = json['new_messages'];
    channelName = json['channel_name'];
    image = json['image'];
    lastMessage = json['last_message'];
    lastDate = json['last_date'];
    isChat = json['is_chat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channel_id'] = this.channelId;
    data['new_messages'] = this.newMessages;
    data['channel_name'] = this.channelName;
    data['image'] = this.image;
    data['last_message'] = this.lastMessage;
    data['last_date'] = this.lastDate;
    data['is_chat'] = this.isChat;
    return data;
  }
}
*/