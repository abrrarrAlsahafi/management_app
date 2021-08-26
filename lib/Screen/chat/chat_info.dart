import 'package:flutter/material.dart';
import 'package:management_app/model/channal.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/widget/bulid_memberimage.dart';
import 'package:management_app/widget/buttom_widget.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:management_app/widget/flat_action_botton_wedget.dart';
import 'package:management_app/Screen/chat/chat_list.dart';
import 'package:provider/provider.dart';
import '../../app_theme.dart';
import '../member_list.dart';

class ChatInfo extends StatefulWidget {
  final channalId;
  final sender;

  ChatInfo({Key key, this.sender, this.channalId})
      : super(key: key);

  @override
  _ChatInfoState createState() => _ChatInfoState();
}

class _ChatInfoState extends State<ChatInfo> {
  List<Folowing> members = [];
  //List<ListItem> items = List();
  Folowing admin = Folowing();
  bool newMember=false;
  @override
  void initState() {
    super.initState();
    if (widget.channalId == null) {
      print("is chat ${widget.sender.isChat}");
    } else {
      buildItem(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    // print(      Provider.of<ChatModel>(context, listen: false).isChat(widget.channalId));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0, backgroundColor: MyTheme.kAccentColorVariant,),
      body: Container(

        child: Column(
          children: [
            Container(
              //height: MediaQuery.of(context).size.height/3.9,
              //width: MediaQuery.of(context).size.width,
              color:  MyTheme.kAccentColorVariant,//hexToColor('#336699'),
              child: Column(
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    //borderRadius: BorderRadius.circular(33.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: MembertImage(item: widget.sender)
                    ),
                  ),
                  SizedBox(height: 10),
                  // Image.memory()
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      widget.sender.name.toString(),
                      style: TextStyle(fontSize: 22, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            widget.sender.isChat
                ? Container()
                : MembersList(member: members, admin: widget.sender.adminId)
          ],
        ),
      ),

     floatingActionButton:widget.sender.isChat?Container() :
         widget.sender.adminId==Provider.of<UserModel>(context, listen: false).user.uid?
     FlatActionButtonWidget(
         onPressed:(){
           // _showModalSheet();             // BottonWidget().
           mainBottomSheet(context, 'addMember');
           // print("$b");
           if(newMember)
           {
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
               content: Text("there is new member added to ${widget.sender.name.toString()}",
                 style: MyTheme.Snacbartext,),
               duration: Duration(seconds: 4),
               backgroundColor: MyTheme.kUnreadChatBG,));
           }
         },
         icon: Icons.person_add_alt_1_outlined
     ):Container(),
    );
  }



  buildItem(context) {
    var membersid = Provider.of<ChatModel>(context, listen: false).getChannalInformation(widget.channalId);
    //.getChatInfo(widget.channalId,context);
    // widget.sender.members != null ? widget.sender.members : widget.sender;
    members = Provider.of<FollowingModel>(context, listen: false)
        .getMembersChat(membersid, widget.sender.adminId);

  }

  void mainBottomSheet(BuildContext context, String title) {
    List member = Provider.of<FollowingModel>(context, listen: false).followList;
    // isChckList = true;
    List items = List.generate(
        member.length,
            (i) => MessageItem(
            member[i], false));
    List isChecked = List<bool>.filled(items.length, false);
    Future<void> future=   showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
                return SingleChildScrollView(
                  child: LimitedBox(
                    maxHeight:MediaQuery.of(context).size.height-30,
                    child: Container(
                        padding: EdgeInsets.only(
                          top: MediaQuery
                              .of(context)
                              .padding
                              .top,
                        ),
                        margin: EdgeInsets.only(top: 100),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 200, top: 12),
                              child: ContentApp(
                                  code: '$title',
                                  style: TextStyle(fontSize: 22 , color: Colors.black26)),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: //isList?
                                //  MembersList():
                                ListView.builder(
                                    itemCount: items.length,
                                    itemBuilder: (BuildContext context,
                                        int index) {
                                      final item = items[index];
                                      return CheckboxListTile(
                                        value: isChecked[index],
                                        onChanged: (bool val) {
                                          state(() {
                                            isChecked[index] = val;
                                          });
                                        },
                                        title: ListTile(
                                          dense: true,
                                          leading: item.buildLeading(  context),
                                          title: item.buildTitle(
                                              context ),
                                          subtitle: item.buildSubtitle(
                                              context),
                                        ),
                                      );
                                    }
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 22),
                              child: ButtonWidget(
                                  child: ContentApp(
                                    code: '$title',
                                    style:TextStyle(fontSize: 16,color: Colors.white),
                                  ),
                                  // icon: Icons.check_circle_rounded,
                                  onPressed: () async {
                                    List member = userSelected(items, isChecked);
                                    await Provider.of<ChatModel>(context, listen: false).addMember(widget.channalId, member);
                                    Provider.of<ChatModel>(context,listen: false).getChannalInformation(widget.channalId);

                                    Navigator.pop(context,newMember);//.pop();
                                    //buildItem(context);

                                  }
                              ),
                            ),
                          ],
                        )),
                  ),
                );
              });
        });
    future.then((void value) => _closeModal(value));
  }
  void _closeModal(void value) {
    setState(() {
      newMember=true;
    });

    print('modal $newMember');
  }


  List userSelected(items,isChecked ) {
    List usersSelected =[];
    for (int i = 0; i < items.length; i++) {
      // print("${isChecked[i]}, $i");
      if (isChecked[i]) {
        // print(items[i].chatslist[i]);
        usersSelected.add(items[i].item.id); //.chatslist[i]);
      }
    }
    return usersSelected;
  }
}

