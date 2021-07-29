import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/generated/I10n.dart';
import 'package:management_app/model/channal.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/model/massege.dart';
import 'package:management_app/model/note.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/widget/bulid_memberimage.dart';
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
    Provider.of<NewMessagesModel>(context, listen: false)
        .newMessages
          ==
        null
        ? -1
        : Provider.of<NewMessagesModel>(context, listen: false)
        .newMessages
        .totalNewMessages;
  }


  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  checkForNewSharedLists() {
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
          userDetail.lastMessage.contains(text)|| userDetail.name.toUpperCase().contains(text))
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
      checkForNewSharedLists();
      return chatHestoryList == null
          ? Container()
          : Scaffold(
              floatingActionButton: FlatActionButtonWidget(
                icon: Icons.chat_outlined,
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListUsers())),
                tooltip: 'Chat',
              ),
              body: Column(children: [
                search
                    ? SearchWidget(
                        controller: controller,
                        onSearchTextChanged: onSearchTextChanged,
                        onPressed: () {
                          setState(() {
                            search = false;
                          });
                          controller.clear();
                          onSearchTextChanged('');
                        },
                      )
                    : Container(),
                Expanded(
                  child: Container(
                      margin: EdgeInsets.all(0.0),
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: MediaQuery.of(context).size.width / 66),
                      //width: 444,
                      height: MediaQuery.of(context).size.height,
                      child: ListView.separated(
                        // Let the ListView know how many items it needs to build.
                        itemCount: _searchResult.length != 0 ||
                                controller.text.isNotEmpty
                            ? _searchResult.length
                            : chatHestoryList.length,
                        //items.length,
                        separatorBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Divider(
                            color: Colors.black26,
                          ),
                        ),
                        // Provide a builder function. This is where the magic happens.
                        // Convert each item into a widget based on the type of item it is.
                        itemBuilder: (context, index) {
                          final item = _searchResult.length != 0 ||
                              controller.text.isNotEmpty
                              ? _searchResult[index]
                              : items[index];
                          return Stack(children: [
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
                                            chatDetils:
                                            chatHestoryList[index],
                                            // ischatGroup: false,
                                            isPrivetGroup: false,
                                            newChat: false,
                                            isChat:
                                            chatHestoryList[index].isChat,
                                            //member: chatHestoryList[index].members,
                                            mid: chatHestoryList[index].id,
                                            title: chatHestoryList[index]
                                                .name //chatTitle()
                                        )),
                              );
                            },
                            leading: item.buildLeading(),
                            title: item.buildTitle(context),
                            subtitle: item.buildSubtitle(context),
                            trailing: item.buildTrailing(context),
                          ),
                            chatHestoryList[index].newMessage != null
                                ? chatHestoryList[index].newMessage
                                    ? Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Icon(Icons.circle,
                                              color: Color(0xffe9a14e)
                                          ,size: 17,),
                                        ),
                                      )
                                    : Container()
                                : Container()
                          ]);}

                      )),
                ),
              ]));
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
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final item;
  final isFolowing;

  MessageItem(this.item, this.isFolowing);

  Widget buildLeading() => MembertImage(item: item.image
      .toString());

  Widget buildTitle(BuildContext context) {
    if(item.runtimeType==Note){
      return Row(
        children: [
          Text(
            item.user,
            style: MyTheme.heading2,
          ),
          SizedBox(width: 10),
          Text("-  ${DateFormat.yMMMd().format(DateTime.parse(item.date))}", style: MyTheme.dateStyle)
        ],
      );
    }else
    {
      return Text(
         item.name, //item[index].name,
        style: MyTheme.heading2,
      );
    }
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

String chatTitle(str) {
  return "${str[0].toUpperCase()}${str.substring(1)}";
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
        title: ContentApp(code: 'new group'),
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
            color: Colors.white,
            height: 300,
            child: ListView.separated(
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
                  return Row(
                    children: [
                      item.buildLeading(),
                      item.buildTitle(context),
                    ],

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

    items = List.generate(
      listFolow.length,
      (i) => MessageItem(listFolow[i], null),
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
        // leading: ,
        title: Text('New Chat'),
      ),
      body: Column(
        children: [
          newgruop
              ? Container()
              : FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
              : FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
        //print(oldChat);
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
