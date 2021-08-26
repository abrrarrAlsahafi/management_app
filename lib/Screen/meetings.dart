import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_app/Screen/tasks.dart';
import 'package:management_app/Screen/topic.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/model/board.dart';
import 'package:management_app/model/sessions.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/services/emom_api.dart';
import 'package:management_app/widget/alert_dialog_widget.dart';
import 'package:management_app/widget/bulid_memberimage.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:management_app/widget/slide_left.dart';
import 'package:management_app/widget/slide_right.dart';
import 'package:management_app/widget/task_card.dart';
import 'package:provider/provider.dart';

class MeetingsScreen extends StatefulWidget {
  final title;
  final id;

  const MeetingsScreen({Key key, this.title, this.id}) : super(key: key);

  @override
  _MeetingsScreenState createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {
  List<Sessions> meetings;
  bool _disposed = false;
  List expandList = [], topicExpand = [];

  var isMember = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
          backgroundColor: MyTheme.kAccentColor,
          appBar: AppBar(
              backgroundColor: MyTheme.kPrimaryColorVariant,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.white,
                  )),
              title: Text(
                widget.title,
                style: MyTheme.kAppTitle,
              )),
          body: FutureBuilder<void>(builder: (BuildContext context, snapshot) {
            if (snapshot.hasData || meetings == null) {
              // print('taskList  ${taskList}');
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xff336699),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            } else if (meetings.isEmpty) {
              return Center(
                  child: Column(
                children: [
                  SizedBox(height: 50),
                  Icon(Icons.no_meeting_room,
                      size: MediaQuery.of(context).size.width / 4,
                      color: Colors.grey[300]),
                  SizedBox(height: 50),
                  ContentApp(
                    code: 'noMeeting',
                    style: MyTheme.bodyTextTask,
                  ),
                ],
              ));
            } else {
              return bodySessions();
            }
          })),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () {
      this.getSessions();
    });
  }

  //0=false, isAction1=false,isAction2=false, isAction3=false, isAction4=false, isAction5=false;
  @override
  void dispose() {
    _disposed = true;
    meetings.clear();
    super.dispose();
  }

  getSessions() async {
    meetings = await Provider.of<BoardsModel>(context, listen: false)
        .getBoardSessions(widget.id);
    expandList = List.generate(meetings.length, (index) => false);
    setState(() {});
    //checkStage(currentStage)
    // print('meetings .. ${meetings.first}');
  }

  Widget bodySessions() {
    return Container(
      child: ListView.builder(
          itemCount: meetings.length,
          itemBuilder: (context, index) {
            // isAction=false;
            String st = checkStage(meetings[index]);
            bool action = checkAction(meetings[index]);
            // print("stage.. ${st} $isAction");
            topicExpand = List.generate(meetings[index].topics.length, (index) => false);
            return // isMember ?
                Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Dismissible(
                key: Key('${meetings[index].name}'),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart && (action)) {
                    final res = await showAlertDialog(
                        context,
                        st,
                        // checkStage(meetings[index].stage),
                        meetings[index].id,
                        meetings[index].stage);

                    print("res $res");
                    if (res == "true") {
                      setState(() {
                        st = checkStage(meetings[index]);
                        action = checkAction(meetings[index]);
                      });
                    }
                  } else if (direction == DismissDirection.startToEnd &&
                      isMember) {
                    final bool res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialogPM(
                              isMeeting: true,
                              index: meetings[index],
                              dearection: false,
                              title: Text(
                                "Replay",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ));
                        });
                  }
                },
                background:
                    isMember ? SlideRightBackgroundWidget() : Container(),
                secondaryBackground: action
                    ? //isAction[index]?
                    SlideLeftWidget(
                        icon: Icons.redo,
                        title: st, //checkStage(meetings[index].stage),
                      )
                    : Container(),
                child: CartTask(
                  isTask: false,
                 // des:meetings[index].name,
                  click: expandList[index],
                  onTap: () {
                    print('expand.. ${expandList[index]}');
                    setState(() {
                      expandList[index] = expandList[index] ? false : true;
                    });
                  },
                  child: Container(
                    height: meetings[index].topics.length * 88.0,
                    //Topics item
                    // padding: EdgeInsets.all(4),
                    child: ListView.separated(
                        itemBuilder: (BuildContext context, i) {
                          return TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TopicScreen(
                                        item: meetings[index], index: i))),
                            child: Container(
                              //padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  boxShadow: [BoxShadow(color: Colors.black26)],
                                  color: Colors.white,
                                  //  boxShadow:BoxShadow. ,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: MyTheme.kAccentColor,
                                    width: 0.5,
                                  )),
                              child: ListTile(
                                  leading: Text("${i + 1}"),
                                  dense: true,
                                  title: Text(
                                      "${meetings[index].topics[i].name}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  subtitle: Text(
                                      "by ${meetings[index].topics[i].source}",
                                      style: TextStyle(fontSize: 10))),
                            ),
                          );
                        },
                        separatorBuilder: (context, i) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Divider(
                                color: Colors.black12,
                              ),
                            ),
                        itemCount: topicExpand.length),
                  ),
                  listTile: ListTile(
                      dense: true,
                      title: Text(meetings[index].name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: Text(
                          "${meetings[index].stage}",
                          style: MyTheme.bodyTextTask),
                    trailing:Text(meetings[ index].date==null?"":DateFormat.yMMMd().format(DateTime.parse(meetings[ index].date)), style: MyTheme.bodyTextTime,),
                  //  leading: MembertImage(item:meetings[index]),

                  ),

                ),
              ),
            );
          }),
    );
  }

  Future<String> showAlertDialog(
      BuildContext context, widgetTitle, id, stage) async {
    Widget okButton = TextButton(
      child: ContentApp(code: "send"),
      onPressed: () async {
        // stages.forEach((element) async {
        if (stage == 'draft') {
          final replay = await EmomApi().sendToManager(sessionId: id);
          Navigator.pop(context, "true");
        }
        if (stage == 'for_manager') {
          print("object");
          final replay = await EmomApi().sendToMembers(sessionId: id);
          Navigator.pop(context, "true");
        }
        if (stage == 'members') {
          final replay = await EmomApi().actionSign(sessionId: id);

          Navigator.pop(context, "true");
        }
        if (stage == 'for_approval') {
          final replay = await EmomApi().toApproved(sessionId: id);
          Navigator.pop(context, "true");
        }
        if (stage == 'approved') {
          //no API for that
          Navigator.pop(context, "true");
        }
        getSessions();
        // await  Provider.of<BoardsModel>(context).getBoardSessions(widget.id);
        // });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: ContentApp(
        code: widgetTitle,
      ),
      content: Text(""),
      actions: [
        okButton,
      ],
    );

    String returnVal = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    return returnVal;
  }

  checkStage(Sessions session) {
    String userType = curentType();
    String stage = session.stage;
    // print("currentStage  #${curentType()}");
    String str;
    if (stage == "draft" && userType == 'editor') {
      str = stage;
    } else if (stage == "for_manager" && userType == 'manager') {
      str = stage;
    } else if (stage == "members" &&
        (userType == 'member' ||
            userType == 'editor' ||
            userType == 'manager' ||
            userType == 'approval') &&
        isApproved(session.members)) {
      str = stage;
      isMember = true;
    } else if (stage == "for_approval" && userType == 'manager') {
      str = stage;
    }
    // i
    else if (stage == "approved" && userType == 'approval') {
      str = stage;
    } else {
      str = stage;
      //  isAction5=false;
      isMember = false;
    }
    return str;
  }

  bool isApproved(List<Members> members) {
    bool isApproved = true;
    members.forEach((element) {
      if (element.name == Provider.of<UserModel>(context).user.name) {
        if (element.status == 'approved') {
          isApproved = false;
        }
      }
    });
    print("status ${isApproved}");
    return isApproved;
  }

  String curentType() {
    String currentType = 'member';
    /* if (Provider.of<BoardsModel>(context, listen: false)
            .isEditor(context, widget.id) !=
        null) {
      curentType = Provider.of<BoardsModel>(context, listen: false)
          .isEditor(context, widget.id);
    }
    if (Provider.of<BoardsModel>(context, listen: false)
            .isManager(context, widget.id) !=
        null) {
      curentType = Provider.of<BoardsModel>(context, listen: false)
          .isManager(context, widget.id);
    }
    if (Provider.of<BoardsModel>(context, listen: false)
            .isApproval(context, widget.id) !=
        null) {
      curentType = Provider.of<BoardsModel>(context, listen: false)
          .isApproval(context, widget.id);
    }
*/
    //  currentType=Provider.of<BoardsModel>(context, listen: false) .currentType(context, widget.id);
    // print("currentType $currentType");
    Provider.of<BoardsModel>(context, listen: false)
        .userBoard
        .forEach((element) {
      if (element.id == widget.id) {
        if (element.editor ==
            Provider.of<UserModel>(context, listen: false).user.name) {
          currentType = "editor";
        } else if (element.manager ==
            Provider.of<UserModel>(context, listen: false).user.name) {
          print(element.manager);
          currentType = "manager";
        } else if (element.approval ==
            Provider.of<UserModel>(context, listen: false).user.name) {
          return "approval";
        } else {
          return 'member';
        }
      }
    });
    print("element $currentType)");
    return currentType;
  }

  checkAction(Sessions session) {
    String userType = curentType();
    String stage = session.stage;
    bool action = false;
    // print("currentStage  #${curentType()}");
    String str;
    if (stage == "draft" && userType == 'editor') {
      str = stage;
      action = true;
    } else if (stage == "for_manager" && userType == 'manager') {
      str = stage;
      action = true;
    } else if (stage ==
            "members" && //(userType=='member'||userType=='editor'||userType=='manager'||userType=='approval')&&
        isApproved(session.members)) {
      str = stage;
      action = true;
      isMember = true;
    } else if (stage == "for_approval" && userType == 'manager') {
      str = stage;
      action = true;
    }
    // i
    else if (stage == "approved" && userType == 'approval') {
      str = stage;
      action = true;
    } else {
      str = stage;

      //  isAction5=false;
      isMember = false;
    }
    return action;
  }
}
