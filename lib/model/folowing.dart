import 'package:flutter/material.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/services/emom_api.dart';
import 'package:provider/provider.dart';

class Folowing {
  int id;
  String name;
  String image;
  bool isAddmin;

  Folowing({this.id, this.name, this.image, this.isAddmin});

  Folowing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class FollowingModel extends ChangeNotifier {
  var imageUser;
  List<Folowing> followList;
  Folowing isAdmin;
  FollowingModel(this.followList);
  getfollowingList(context) async {
    followList = await EmomApi().getfollowingList();
    followList.removeWhere((element) =>
        element.id == Provider.of<UserModel>(context, listen: false).user.uid);
  }
  getNameList(){
   return followList.single.name;//.w((element) => element.name);
  }

  List<Folowing> channalMember;
  getMembersChat(ids, adminId) {
    channalMember = [];
    //print("test  ${followList.where((food) => food.id == adminId).toList()}");

    for (int i = 0; i < followList.length; i++) {
      //print("ids ${followList[i].id}");
      for (int j = 0; j < ids.length; j++) {
        if (followList[i].id == ids[j]) channalMember.add(followList[i]);
        /* if (isAdmin == null) {
          if (followList[i].id == adminId) {
            print('adminId');
            isAdmin = followList[i];
            channalMember.add(followList[i]);
          }
        }*/
      }
    }
    return channalMember;
  }

  channalAdmins(adminId) {
    followList.forEach((element) {
      if (element.id == adminId) {
        //print('adminId');
        isAdmin = element;
        channalMember.add(element);
      }
    });
    return isAdmin;
  }

  gitUserImage(context) {
    followList.forEach((element) {
      return element.name == Provider.of<User>(context).name
          ? element.image
          : 'no image';
    });
  }
}
