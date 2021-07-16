import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:management_app/model/massege.dart';
import 'package:management_app/services/emom_api.dart';

//import 'package:shared_preferences/shared_preferences.dart';

class Chat {
  int id;
  String name;

  String image;
  String lastMessage;
  String lastDate;
  bool newMessage;
  List members;
  int adminId;
  bool isChat;
  List<Massege> massegContex;

  Chat(
      {this.id,
      this.name,
      this.image,
      this.lastMessage,
      this.lastDate,
      this.newMessage,
      this.members,
      this.adminId,
      this.isChat});

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['channel_name'];
    image = json['image'];
    lastMessage = json['last_message'];
    lastDate = json['last_date'];
    members = json['member_ids'];
    adminId = json['admin_id'];
    isChat = json['is_chat'];
  }

  static Map<String, dynamic> toJson(Chat chat) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = chat.id;
    data['channel_name'] = chat.name;
    data['image'] = chat.image;
    data['last_message'] = chat.lastMessage;
    data['last_date'] = chat.lastDate;
    data['member_ids'] = chat.members;
    data['admin_id'] = chat.adminId;
    data['is_chat'] = chat.isChat;
    return data;
  }

  static String encode(List<Chat> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>((music) => Chat.toJson(music))
            .toList(),
      );

  static List<Chat> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<Chat>((item) => Chat.fromJson(item))
          .toList();
}

class ChatModel with ChangeNotifier {
  List<Chat> chatsList;
  ChatModel();

  getChannalsHistory() async {
    chatsList = await EmomApi().chatHistory();
    orderByLastAction();
    notifyListeners();
  }

  orderByLastAction() {
    chatsList.sort((a, b) {
      // print('${a.lastDate} ${b.lastDate} , ${b.lastDate.compareTo(a.lastDate)}');
      return // b.dat=='None' || a.lastMessage=='None'?0:
          b.lastDate.compareTo(a.lastDate);
    });
    // notifyListeners();
  }

  addNewChat(chat) => chatsList.add(chat);
  createChannal(chat, isCaht, isPrivate) async {
    // chatsList.removeLast();
    int id = await EmomApi()
        .createNewChannal(chat.name, chat.members, isCaht, isPrivate);
    await getChannalsHistory();
    // print('id new massege = $id');
    notifyListeners();
    return id;
  }

  chatLastMassege(i, newmassege) => chatsList[i].lastMessage = newmassege;
  chatMasseges(id) {
    List<Massege> massegContex = [];
    chatsList.forEach((element) {
      if (element.id == id) {
        massegContex = element.massegContex;
      }
    });
    return massegContex;
  }

  bool isChat(chatId) {
    bool isChat = false;
    chatsList.where(
        (element) => isChat = element.id == chatId ? element.isChat : null);
    return isChat;
  }

  getChannalInformation(channalId) {
    List members = [];
    chatsList.forEach((element) {
      if (element.id == channalId) members = element.members;
    });

    return members;
  }

  addMember(channelId, memberId) async {
    await EmomApi().addMembers(channelId, memberId);
    await getChannalsHistory();
  }

  int haveChatRoom(int senderId) {
    int ischat;

    chatsList.forEach((chat) {
      // print(chat.members);
      if (chat.isChat) {
        if (chat.members.first == senderId || chat.members.last == senderId) {
          print(chat.id);
          ischat = chat.id;
        }
      }
    });

    return ischat;
  }
}
