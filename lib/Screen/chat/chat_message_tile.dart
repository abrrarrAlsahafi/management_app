import 'dart:core';

import 'package:management_app/common/constant.dart';
import 'package:management_app/model/massege.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyMessageChatTile extends StatelessWidget {
  final double minValue = 6.0;
  final sender;
  final Massege message;
  final currentUser;
  final userImage;
  final bool isCurrentUser;
  final msender;
  final DateTime datesend;
  final isChat;

  MyMessageChatTile(
      {this.message,
      this.isCurrentUser,
      this.userImage,
      this.sender,
      this.currentUser,
      this.msender,
      this.datesend, this.isChat});
  @override
  Widget build(BuildContext context) {
   // print(datesend);
    return Align(
          alignment: (isCurrentUser?Alignment.topRight:Alignment.topLeft),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 7,
                  offset: Offset(0.4,0.3),
                  color: Colors.black26
                )
              ],
              borderRadius: isCurrentUser
            ? BorderRadius.only(
              //  topRight:Radius.circular(-10) ,
            topLeft: Radius.circular(minValue * 2),
            bottomLeft: Radius.circular(minValue * 2),
            bottomRight: Radius.circular(minValue * 2),
          )
                : BorderRadius.only(
                  bottomRight: Radius.circular(minValue * 2),
          bottomLeft: Radius.circular(minValue * 2),
          topRight: Radius.circular(minValue * 2)),
        color: isCurrentUser ? hexToColor('#E1E8F5') : Colors.white,
            ),
            padding: EdgeInsets.all(6),
            child: Stack(children:[
               Padding(padding: EdgeInsets.only(top: 14, bottom: 4, right: 10, left: 10),
                child: Text.rich(builder())),
             isChat || isCurrentUser? SizedBox():
             Positioned(child: Text('${msender.toString().trim()}',
                style: TextStyle(
                    fontSize: 10, color: Colors.grey),
              ), left:isCurrentUser? 55.0: 0.0,
                top:0.0,
                right: 6.0,
              ),Positioned(child: MDate(dateToCheck:datesend
                  //'${DateFormat.jm().format(datesend).toString()}'
                 ),//top: 0.0,
                right: 6.0,
                bottom: 0.0,
              )
            ]),
            margin: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
          ),
      );
  }

  TextSpan builder(){
    return TextSpan(
          style: TextStyle(fontSize: 15),
          text:"${message.text.toString().trim()}      ");

  }
}
class MDate extends StatelessWidget {
  final dateToCheck;

  MDate({Key key,this.dateToCheck }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  //  print(dateToCheck);
    final DateTime now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day,now.hour,now.minute);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final daybefor = DateTime(now.year, now.month, now.day - 2);
    final aDate = DateTime(dateToCheck.year, dateToCheck.month,dateToCheck.day,dateToCheck.hour, dateToCheck.minute);
   // print("mmm $aDate , $today ");

    if(aDate.day == today.day) {
      return Text('${DateFormat.jm().format(aDate).toString()}', style: TextStyle(
          fontSize: 7, color: Colors.grey,fontWeight: FontWeight.bold));
    } else if(aDate.day == yesterday.day ) {
     // print("$yesterday");
      return Text("yesterday",style: TextStyle(
          fontSize: 7, color: Colors.grey), );
  } else if(aDate.day == daybefor.day ) {
      //print("$aDate");
  return Text("${DateFormat('EEEE').format(aDate).toString()}",
    style: TextStyle(
  fontSize: 7, color: Colors.grey), );
  }else {
      return Text("${DateFormat('yMd').format(aDate).toString()}",style:
        TextStyle(
          fontSize: 7, color: Colors.grey));
    }

  }



}
