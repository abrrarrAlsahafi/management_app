import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/generated/I10n.dart';
import 'package:management_app/model/app_model.dart';
import 'package:management_app/model/channal.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/model/massege.dart';
import 'package:management_app/model/note.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/widget/bulid_memberimage.dart';
import 'package:management_app/widget/chat_list_widget.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:management_app/widget/flat_action_botton_wedget.dart';
import 'package:management_app/widget/search.dart';
import 'package:provider/provider.dart';
import '../../bottom_bar.dart';
import 'direct_chat_detail_screen.dart';

bool newchat = false;

class ChatList extends StatefulWidget {
  final name;

  ChatList(
      {Key key, // @required this.items,
      this.name})
      : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> with TickerProviderStateMixin {
  List<Chat> chatHestoryList = [];
  TextEditingController controller = new TextEditingController();
  int newmass;
  Timer timer;
  List items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     checkForNewSharedLists();
    newmass =
        // Provider.of<NewMessagesModel>(context, listen: false).newMessages
        Provider.of<NewMessagesModel>(context, listen: false).newMessages ==
                null
            ? -1
            : Provider.of<NewMessagesModel>(context, listen: false)
                .newMessages
                .totalNewMessages;
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      if (totalMessges > 0) {
        print('totalMessges $totalMessges');
        checkForNewSharedLists();
    //    setState(() {});
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  checkForNewSharedLists() {
    AppModel().config(context);//when back update list chat screen
    items = chatHestoryList == null
        ? []
        : List.generate(
            chatHestoryList.length,
            (i) => MessageItem(chatHestoryList[i], false),
          );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    chatHestoryList.forEach((userDetail) {
      if (userDetail.name.contains(text) ||
          userDetail.lastMessage.contains(text) ||
          userDetail.name.toUpperCase().contains(text))
        _searchResult.add(MessageItem(userDetail, null));
    });

    setState(() {});
  }

  List _searchResult = [];
  String s = '';
  bool onTapSearsh = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatModel>(builder: (context, myCounter, _) {
      chatHestoryList = myCounter.chatsList;
     // checkForNewSharedLists();
      return chatHestoryList == null
          ? Container()
          : Scaffold(
          backgroundColor:MyTheme.kAccentColor,
          // appBar: AppBar(title:ContentApp(code: 'chat',style: MyTheme.kAppTitle),backgroundColor: MyTheme.kPrimaryColorVariant,actions: [Icon(Icons.search)],) ,
            //  floatingActionButton: 
              body:Stack(
                    children: [
                      Column(children: [
                        SafeArea(
                      child: Material(
                        elevation: 2.0,
                        color:MyTheme.kPrimaryColorVariant,
                        child:  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                          child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                    child: ContentApp(code: 'chat',style: MyTheme.kAppTitle),
                                  ),//TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
                                  Container(
                                    //padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                                   // height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                     // color: Colors.amber[50],
                                    ),
                                    child: TextButton(

                                        //on: Icons.chat_outlined,
                                        onPressed: () {
                                          setState(() {
                                            search=search?false:true;
                                          });
                                        },
                                    child:
                                          Icon(Icons.search_rounded,color: Colors.white,size: 30),

                                    ),
                                  )
                                ],
                          ),
                        ),
                      ),
                ),
                        search?  SearchWidget(
                                  controller: controller,
                                  onSearchTextChanged: onSearchTextChanged,
                                  onPressed: () {
                                    controller.clear();
                                    onSearchTextChanged('');
                                  },
                                ):
                          Container(),
                        chatHestoryList.isEmpty
                            ? Container(
                          margin: EdgeInsets.only(top: 120),
                          padding: EdgeInsets.all(33),
                          //width: 200,alignment: Alignment.center,
                          child: Align(
                            alignment: Alignment.center,
                            child: ContentApp(
                              code: 'hchatEmpty',
                              style:
                              TextStyle(fontSize: 22, color: Colors.grey[400]),
                            ),
                          ),
                        )
                            :   Expanded(
                            child: Container(
                               // margin: EdgeInsets.all(0.0),
                                //width: 444,
                                height: MediaQuery.of(context).size.height,
                                child: ListView.separated(
                                    padding: EdgeInsets.only(top: 8),

                                    // Let the ListView know how many items it needs to build.
                                    itemCount: _searchResult.length != 0 ||
                                            controller.text.isNotEmpty
                                        ? _searchResult.length
                                        : chatHestoryList.length,
                                    //items.length,
                                    separatorBuilder: (context, index) => Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  6.5),
                                          //bottom: MediaQuery.of(context).size.width / 66),
                                          child: Divider(
                                            color: Colors.black26,
                                          ),
                                        ),
                                    // Provide a builder function. This is where the magic happens.
                                    // Convert each item into a widget based on the type of item it is.
                                    itemBuilder: (context, index) {
                                      // print("total massges.. ${chatHestoryList[index].newMessages}");
                                      return Container(
                                        height: 60,
                                        child: TextButton(
                                          onPressed: () {
                                            chatHestoryList[index].newMessage = false;
                                            print(chatHestoryList[index].newMessage);
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  // settings: RouteSettings(name: "boo"),
                                                  builder: (context) =>
                                                      MyDirectChatDetailPage(
                                                          chatDetils:
                                                              chatHestoryList[index],
                                                          // ischatGroup: false,
                                                          isPrivetGroup: false,
                                                          newChat: false,
                                                          isChat:
                                                              chatHestoryList[index]
                                                                  .isChat,
                                                          //member: chatHestoryList[index].members,
                                                          mid: chatHestoryList[index]
                                                              .id,
                                                          title:
                                                              chatHestoryList[index]
                                                                  .name
                                                          //chatTitle(chatHestoryList[index].name)
                                                          )),
                                            );
                                          },
                                          child: ConversationList(
                                              name: chatHestoryList[index].name,
                                              messageText:
                                                  chatHestoryList[index].lastMessage,
                                              imageUrl: chatHestoryList[index].id,
                                              time: chatHestoryList[index].lastDate,
                                              numberMessgeUnread:
                                                  chatHestoryList[index].newMessages,
                                              isMessageRead: chatHestoryList[index]
                                                          .newMessage !=
                                                      null
                                                  ? chatHestoryList[index].newMessage
                                                  : false

                                              //  ?
                                              //item.buildNewMessege(3,context)
                                              //   chatHestoryList[index].newMessages ),
                                              //   )

                                              //   : Container()
                                              //   : Container(),
                                              ),
                                        ),
                                      );
                                      /* return Stack(children: [
                               ListTile(
                                dense: true,
                                onTap: () {
                                  chatHestoryList[index].newMessage = false;
                                  // print(chatHestoryList[index].newMessage=false);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      // settings: RouteSettings(name: "boo"),
                                        builder: (context) =>
                                            MyDirectChatDetailPage(
                                                chatDetils: chatHestoryList[index],
                                                // ischatGroup: false,
                                                isPrivetGroup: false,
                                                newChat: false,
                                                isChat:
                                                chatHestoryList[index].isChat,
                                                //member: chatHestoryList[index].members,
                                                mid: chatHestoryList[index].id,
                                                title: chatHestoryList[index].name
                                                //chatTitle(chatHestoryList[index].name)
                                            )),
                                  );
                                },
                                leading: item.buildLeading(),
                                title: Row(crossAxisAlignment:CrossAxisAlignment.start,children: [item.buildTitle(context),Expanded(child: SizedBox(width: 12,)),item.buildTrailing(context)]),
                                subtitle: Row(crossAxisAlignment:CrossAxisAlignment.end,children: [ item.buildSubtitle(context),Expanded(child: SizedBox(width: 12,)),item.buildNewMessege(3,context)])
                                //trailing:
                              ),
                                //chatHestoryList[index].newMessage != null
                                   // ? chatHestoryList[index].newMessage
                                     //  ?
                                //item.buildNewMessege(3,context)
                                           //   chatHestoryList[index].newMessages ),
                                     //   )

                                     //   : Container()
                                 //   : Container()
                              ]);*/
                                    })),
                          ),
                        ]),
                      Positioned(
                        left: MediaQuery.of(context).size.width/1.5,
                        top:MediaQuery.of(context).size.height/1.2 ,
                        child: FlatActionButtonWidget(

                          icon: Icons.chat_bubble_outline_outlined,
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ListUsers())),

                        ),
                      ),
                    ],
                  ));
    }); //);
    // });
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);

  Widget buildLeading();

  Widget buildTrailing(BuildContext context);

  buildNewMessege(int n, context);
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final item;
  final isFolowing;

  MessageItem(this.item, this.isFolowing);

  Widget buildLeading() => MembertImage(item: item);

  Widget buildTitle(BuildContext context) {
    if (item.runtimeType == Note) {
      return Row(
        children: [
          Text(
            item.user,
            style: MyTheme.heading2,
          ),
          SizedBox(width: 10),
          Text("-  ${DateFormat.yMMMd().format(DateTime.parse(item.date))}",
              style: MyTheme.dateStyle)
        ],
      );
    } else {
      return Text(
        item.name, //item[index].name,
        style: MyTheme.heading2,
      );
    }
  }

  Widget buildNewMessege(int number, context) {
    return Positioned(
      //top: 0.0,
      left: MediaQuery.of(context).size.height / 2.3,

      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: MyTheme.kUnreadChatBG,
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        child: Center(
          child: Text(
            "$number",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildSubtitle(BuildContext context) {
    if (item.runtimeType == Chat) {
      return Text(
        item.lastMessage.toString().length > 22
            ? item.lastMessage.toString().substring(0, 22) + '..'
            : item.lastMessage,
        style: TextStyle(
          color: const Color(0xff336699),
        ),
      );
    } else {
      return Text(
        isFolowing ? 'admin' : '',
        style: TextStyle(
          color: const Color(0xff336699),
        ),
      );
    }
  }

  Widget buildTrailing(BuildContext context) => Text(
      item.lastDate == 'False' || item.lastDate == null
          ? ''
          : DateFormat('yMMMd').format(DateTime.parse(item.lastDate)),
      style: TextStyle(color: Colors.black38, fontSize: 11));
}

class CreateGruope extends StatefulWidget {
  final members;
  final isPrivate;

  const CreateGruope({Key key, this.members, this.isPrivate}) : super(key: key);

  @override
  _CreateGruopeState createState() => _CreateGruopeState();
}

class _CreateGruopeState extends State<CreateGruope> {
  ScrollController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  var groupName;
  List items = [];

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    Folowing admin = Folowing(
        isAddmin: true,
        id: Provider.of<UserModel>(context, listen: false).user.uid,
        name: Provider.of<UserModel>(context, listen: false).user.name,
        image: widget.members[0].image);

    widget.members.add(admin);
    //widget.members.sort();
    // items.add(MessageItem(admin, false));
    //print("member ${widget.members.length}");
    items = List.generate(
      widget.members.length,
      (i) => MessageItem(widget.members[i], false),
    );
    //
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        //you can do anything here
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        //you can do anything here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.kAccentColor,
      appBar: AppBar(
          backgroundColor: MyTheme.kPrimaryColorVariant,
        title: ContentApp(code: 'new group', style:TextStyle(color: Colors.white)),
      ),
      floatingActionButton: FlatActionButtonWidget(
        onPressed: () => validateInput(),
        icon: Icons.add,
      ),
      body: ListView(
        children: [
          ListTile(
            dense: true,
            title: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (String value) {
                  if (value.isEmpty)
                    return S.of(context).chatValidation;
                  else
                    return null;
                },
                onSaved: (String value) {
                  groupName = value;
                },
                cursorColor: const Color(0xff336699),
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  labelStyle: TextStyle(
                    color: const Color(0xff336699),
                    fontFamily: 'Assistant',
                    fontSize: 14,
                  ),
                  hintText: S.of(context).chatValidation,
                  hintStyle: TextStyle(
                    color: Colors.black45,
                    fontFamily: 'Assistant',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            leading: Icon(Icons.people_outline_rounded),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Divider(
              color: Colors.black12,
            ),
          ),
          Container(
            color:MyTheme.kAccentColor,
            height: MediaQuery.of(context).size.height,
            child: ListView.separated(
                padding: EdgeInsets.zero,
                controller: _controller,
                shrinkWrap: true,
                separatorBuilder: (context, index) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Divider(
                        color: Colors.black12,
                      ),
                    ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        item.buildLeading(),
                        SizedBox(width: 12,),
                        item.buildTitle(context),
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
      //  backgroundColor: const Color(0xfff3f6fc),
    );
  }

  validateInput() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyDirectChatDetailPage(
                  isChat: false,
                  isPrivetGroup: widget.isPrivate,
                  // chatDetils: ,
                  member: widget.members,
                  title: groupName,
                  newChat: true,
                )),
      );
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}

class ListUsers extends StatefulWidget {
  final isgruop;
  final isPrivet;
  final member;

  const ListUsers({Key key, this.isgruop, this.isPrivet, this.member})
      : super(key: key);

  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  bool privitGrup = false;
  bool newgruop = false;
  List items;
  List<bool> isChecked;
  List listFolow;

  @override
  void initState() {
    listFolow = Provider.of<FollowingModel>(context, listen: false).followList;
//print('....  ${listFolow[0]}');
    items = List.generate(
      listFolow.length, (i) => MessageItem(listFolow[i], null),
    );
    isChecked = List<bool>.filled(items.length, false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List userSelected() {
    List usersSelected = [];
    for (int i = 0; i < items.length; i++) {
      // print("${isChecked[i]}, $i");
      if (isChecked[i]) {
        // print(items[i].chatslist[i]);
        usersSelected.add(items[i].item); //.chatslist[i]);
      }
    }
    return usersSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f6fc),
      floatingActionButton: newgruop
          ? FloatingActionButton(
              child: Icon(
                Icons.chat_outlined,
                color: Colors.white,
              ),
              backgroundColor: Color(0xffe9a14e),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateGruope(
                            isPrivate: privitGrup,
                            members: userSelected(),
                          ))).then((value) {
                //  setState(() {
                //  Provider.of<ChatModel>(context).chatsList.add(value);
                //  });
              }),
            )
          : Container(),
      appBar: AppBar(
        backgroundColor: MyTheme.kPrimaryColorVariant,
        // leading: ,
        title: ContentApp(code:'addNew', style:TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          newgruop
              ? Container()
              : TextButton(
                  //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () {
                    setState(() {
                      newgruop = true;
                      privitGrup = false;
                    });
                  },
                  child: TileWidget(
                    title: S.of(context).newg,
                    icon: Icon(Icons.group_outlined),
                  ),
                ),
          newgruop
              ? Container()
              : TextButton(
                  //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () {
                    setState(() {
                      newgruop = true;
                      privitGrup = true;
                    });
                  },
                  child: TileWidget(
                    title: S.of(context).privite,
                    icon: Icon(Icons.people_outline_rounded),
                  ),
                ),
          newgruop
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(
                    color: Colors.black26,
                  ),
                ),
          Expanded(child: items == null ? Container() : listMember()),
        ],
      ),
    );
  }

  listMember() {
    return ListView.separated(
      padding: EdgeInsets.only(top: 8),
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
        print(items[index]);
        final item = items[index];
        return newgruop
            ? CheckboxListTile(
                // selected:isChecked[index] ,
                // activeColor: Colors.red,
                value: isChecked[index],
                onChanged: (val) {
                  setState(() {
                    isChecked[index] = val;
                  });
                },
                title: ListTile(
                  leading: item.buildLeading(),
                  title: item.buildTitle(context),
                ),
              )
            : ListTile(
                onTap: () {
                  int oldChat = Provider.of<ChatModel>(context, listen: false)
                      .haveChatRoom(listFolow[index].id);
//print(oldChat);
                  if (oldChat == null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyDirectChatDetailPage(
                                chatDetils: listFolow[index],
                                newChat: true,
                                member: listFolow[index],
                                // ischatGroup: false,
                                isPrivetGroup: true,
                                isChat: true,
                              )),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyDirectChatDetailPage(
                                mid: oldChat,
                                chatDetils: listFolow[index],
                                newChat: false,
                                isChat: true,
                                isPrivetGroup: true,
                              )),
                    );
                  }
                },
                leading: item.buildLeading(),
                title: item.buildTitle(context),
              );
      },
    );
  }
}

class TileWidget extends StatelessWidget {
  final icon;
  final title;
  final onPres;

  const TileWidget({Key key, this.icon, this.title, this.onPres})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Align(alignment: Alignment(-1.2, 0), child: Text(title)),
      leading: icon,
    );
  }
}
