import 'package:management_app/model/folowing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat/chat_list.dart';

class MembersList extends StatefulWidget {
   List member;
  var admin;

  MembersList({Key key, this.member, this.admin}) : super(key: key);

  @override
  _MembersListState createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  List<MessageItem> items;
  bool isChckList=false;
  List<bool> isChecked ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.member==null) {
      widget.member = Provider.of<FollowingModel>(context, listen: false).followList;
      isChckList = true;
      items = List.generate(
          widget.member.length,
              (i) => MessageItem(
            widget.member[i], false));
      isChecked = List<bool>.filled(items.length, false);
    } else {
      items = List.generate(
          widget.member.length,
          (i) => MessageItem(
                widget.member[i],
               // widget.member[i],
                widget.admin == null
                    ? false
                    : widget.admin == widget.member[i].id,
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
  //  final title = 'Members';
    return Expanded(
      child: Container(
                // backgroundColor: const Color(0xfff3f6fc),
                height: 200.0 * items.length,
                child: ListView.separated(
                  separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Divider(
                      color: Colors.black12,
                    ),
                  ),
                  // Let the ListView know how many items it needs to build.
                  itemCount: items.length,
                  // Provide a builder function. This is where the magic happens.
                  // Convert each item into a widget based on the type of item it is.
                  itemBuilder: (context, index) {
                      final item = items[index];
                      return
                      ListTile(
                        // onTap: isChckList?()=>addMember():(){},
                        dense: true,
                        leading: item.buildLeading(),
                        title: item.buildTitle(context),
                        subtitle: item.buildSubtitle(context),
                      );
                  },
                ),
              ),

    );
  }

  List userSelected() {
    List usersSelected =[];
    for (int i = 0; i < items.length; i++) {
      // print("${isChecked[i]}, $i");
      if (isChecked[i]) {
        // print(items[i].chatslist[i]);
        usersSelected.add(items[i].item); //.chatslist[i]);
      }
    }
    return usersSelected;
  }

}