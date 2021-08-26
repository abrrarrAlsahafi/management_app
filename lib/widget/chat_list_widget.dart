
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_app/app_theme.dart';

// ignore: must_be_immutable
class ConversationList extends StatefulWidget {
  String name;
  String messageText;
  int imageUrl;
  String time;
  bool isMessageRead;
  int numberMessgeUnread;

  ConversationList(
      {@required this.name,
      @required this.messageText,
      @required this.imageUrl,
      @required this.time,
      @required this.isMessageRead,
      @required this.numberMessgeUnread});

  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  Random random = new Random();

  int index = 0;

  void changeIndex() {
    setState(() => index = index==MyTheme.colors.length-1?0:index++);
  }

  @override
  Widget build(BuildContext context) {
    print('${widget.name} ,');
   // changeIndex();
    return Container(
    //  height: 80,
      //  padding: EdgeInsets.only(left: 10,right: 10,top: 6),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            child: Text('${widget.name[0].toUpperCase()}', style: TextStyle(color: Colors.white) ,),
            //backgroundImage: NetworkImage('http://demo.ewady.com/web/image?model=mail.channel&id=${widget.imageUrl}&field=image_128'),
            //widget.imageUrl),
            maxRadius: 26,
            backgroundColor: MyTheme.colors[index],
          ),
          SizedBox(
            width: 16,
          ),
         Expanded(
           child: ListView(
             padding: EdgeInsets.zero,
                 // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.name,
                            style: MyTheme.heading2,
                          ),
                        ),
                      
                        Text(
                          widget.time == 'False' || widget.time == null
                              ? ''
                              : DateFormat('yMMMd')
                                  .format(DateTime.parse(widget.time)),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: widget.isMessageRead
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ],
                    ),
                    //SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSubtitle(),
                        // Text(widget.messageText,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
                        Expanded(
                            child: SizedBox(
                          width: 10,
                        )),
                        widget.isMessageRead ? unReadMassege() : Container()
                      ],
                    ),
                  ],
                ),
              ),
],
      ),
    );
  }

  unReadMassege() {
    return Container(
        padding: EdgeInsets.all(4),
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: MyTheme.kUnreadChatBG,
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        child: Center(
            child: Text("${widget.numberMessgeUnread}",
                style: TextStyle(color: Colors.white))));
  }

  Widget buildSubtitle() {
    //   if (item.runtimeType == Chat) {
    return Text(
      widget.messageText.length > 22
          ? widget.messageText.toString().substring(0, 20) + '..'
          : widget.messageText,
      style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade600,
          fontWeight:
              widget.isMessageRead ? FontWeight.bold : FontWeight.normal),
    );
    /* } else {
      return Text(
        isFolowing ? 'admin' : '',
        style: TextStyle(
          color: const Color(0xff336699),
        ),
      );
    }*/
  }
}
