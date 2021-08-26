import 'dart:async';
import 'package:intl/intl.dart';
import 'package:management_app/Screen/create_meeting.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/model/note.dart';
import 'package:management_app/model/project.dart';
import 'package:management_app/model/task.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/widget/alert_dialog_widget.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:management_app/widget/expanded_selection.dart';
import 'package:management_app/widget/flat_action_botton_wedget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:management_app/widget/search.dart';
import 'package:management_app/widget/slide_left.dart';
import 'package:management_app/widget/slide_right.dart';
import 'package:management_app/widget/task_card.dart';
import 'package:provider/provider.dart';

import '../online_root.dart';
import 'task_details.dart';
import 'chat/chat_list.dart';

class TaskScreen extends StatefulWidget {
  bool isAdmin;
  final projectid;
  final TabController tabController;

  TaskScreen({Key key, this.isAdmin, this.projectid, this.tabController})
      : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

List stageList = ['New', 'Assign', 'In Progress', 'Done', 'Canceled'];
List<bool> expandList; //=[false,false,false];

class _TaskScreenState extends State<TaskScreen> with TickerProviderStateMixin {
  String dropdownValue; //= 'New';
  List listStageTask = [];
  bool _disposed = false;
  TabController _tabController;
  List<Task> taskList;
  int _selectedTab = 0;
  Future<TaskModel> _calculation;
  bool isManeger = false;

  //List<Note> note;
  @override
  void initState() {
    projectid = widget.projectid;
    super.initState();
    taskHistory();

    _tabController = TabController(vsync: this, length: stageList.length);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedTab = _tabController.index;
        });
      }
    });
  }

  goToSecondScreen(item, id) async {
    var result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => CreateScreen(
                  item: item,
                  projectid: id,
                ),
            //new SecondScreen(context),
            fullscreenDialog: true));
    print(result);
    // AppModel().config(context);
    if (result) {
      taskHistory();
      addTask = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: ContentApp(
            code: 'New',
            style: MyTheme.Snacbartext,
          ),
          duration: Duration(seconds: 4),
          backgroundColor: MyTheme.kUnreadChatBG));
    } //return result;
  }

  taskHistory() async {
    // print("frist $taskList");
    taskList = await Provider.of<TaskModel>(context, listen: false)
        .getUserTasks(projectid.id);
    //widget.projectid.id
    //  await Provider.of<TaskModel>(context, listen: false).viewLogNote();
    setState(() {});
    //print('${taskList.first.notes.first}');
    expandList = List.generate(taskList.length, (index) => false);
    // List<FocusNode> _focusNodes = List<FocusNode>.generate(taskList.length, (int index) => FocusNode());

    //  getStage();
  }

  bool click = false;

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this.taskHistory());
    _disposed = true;
    taskList.clear();
    super.dispose();
    isManeger = false;
  }

  TextEditingController controller = new TextEditingController();

  final focus = FocusNode();

  bool addTask = false;
  var result;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, addTask);
        return addTask;
      }, //=>addTask, //
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: MyTheme.kPrimaryColorVariant,
            leading: Container(
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      print("addtask $addTask");
                      Navigator.pop(context, addTask);
                    })),
            title: Text(projectid.name, //widget.projectid.name,
                style: MyTheme.kAppTitle),
          ),
          backgroundColor: MyTheme.kAccentColor,
          floatingActionButton: FlatActionButtonWidget(
            icon: Icons.playlist_add,
            onPressed: () {
              goToSecondScreen(Task(), projectid.id); //widget.projectid.id,
            },
            tooltip: 'task',
          ), //:Container(),
          body: FutureBuilder<void>(builder: (BuildContext context, snapshot) {
            if (snapshot.hasData || taskList == null) {
              // setState(() {});
              //print('taskList  ${taskList}');
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xff336699),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            } else if (taskList.isEmpty) {
              return Center(
                  child: Column(
                children: [
                  SizedBox(height: 50),
                  Icon(Icons.playlist_add,
                      size: MediaQuery.of(context).size.width / 2,
                      color: Colors.grey[300]),
                  SizedBox(height: 50),
                  ContentApp(
                    code: 'noTask',
                    style: MyTheme.bodyTextTask,
                  ),
                ],
              ));
            } else {
              return bodyTask();
            }
          })),
    );
    //));
  }

  // ScrollController scrollController = new ScrollController();
  bool proi = false;

  bodyTask() {
    // taskHistory();
    //print("widget.projectid ${taskList}");
    String userName = Provider.of<UserModel>(context, listen: false).user.name;
    Provider.of<ProjectModel>(context, listen: false)
        .userProject
        .forEach((element) {
      //  print("id,,, ${element.id }  ${widget.projectid.id}");
      if (element.id == projectid.id //widget.projectid.id
          ) {
        if (element.managerName == userName) {
          //  setState(() {
          isManeger = true;
          //  });
        }
      }
    });
    print(" bodyTa  $isManeger");
    return Column(
      children: [
        expandList.any((element) => element)
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SearchWidget(
                  controller: controller,
                  onSearchTextChanged: onSearchTextChanged,
                  onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },
                ),
              ),
        //: Container(),
        //  Expanded(
        // child:
        Container(
          padding: EdgeInsets.zero,
          height: MediaQuery.of(context).size.height / 1.25,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _searchResult.length != 0 || controller.text.isNotEmpty
                ? _searchResult.length
                : taskList.length,
            itemBuilder: (context, index) {
              //  print("stage ${taskList[index].taskStage}");
              return Container(
                  margin: EdgeInsets.zero,
                   padding: EdgeInsets.symmetric(vertical: 6),
                  child: Dismissible(
                      key: Key('${taskList[index].taskName}'),
                      child: CartTask(
                        // onTapstar:,
                        //  proirty: ,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TaskDetails(
                                      task: taskList[index],
                                      title: projectid.name,
                                    )),
                          );
                        }, des: taskList[index],
isTask: true,
                        click: expandList[index],
                        listTile: ListTile(
                          trailing: Text(
                            taskList[index].notes == null
                                ? ""
                                : DateFormat.yMMMd().format(DateTime.parse(
                                    taskList[index].notes.first.date)),
                            style: MyTheme.bodyTextTime,
                          ),

                          //  leading: MembertImage(item:taskList[index]),
                          title: Text(
                              _searchResult.length != 0 ||
                                      controller.text.isNotEmpty
                                  ? _searchResult[index].taskName
                                  : taskList[index].taskName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Text(
                              "by ${taskList[index].createBy} on ${DateFormat.yMMMd().format(DateTime.parse(taskList[index].createDate))} \nTo ${taskList[index].assignedTo}",
                              //on  ${DateFormat.yMMMd().format(taskList[index].createDate == null ? DateTime.now() : DateTime.parse(taskList[index].createDate))} To ${taskList[index].assignedTo}",
                              style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      background: SlideRightBackgroundWidget(),
                      secondaryBackground: isManeger
                          ? SlideLeftWidget(
                              icon:
                                  isManeger // (Provider.of<UserModel>(context).user.isAdmin)
                                      ? Icons.person_add_outlined
                                      : Icons.redo,
                              title: 'assign')
                          : Container(),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart &&
                            isManeger) {
                          final bool res = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialogPM(
                                    proId: projectid,
                                    index: taskList[index],
                                    dearection: true,
                                    title: Text(
                                      "You want to assgin ${taskList[index].taskName} task to?",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ));
                              });
                          taskHistory();
                        } else if (direction == DismissDirection.startToEnd) {
                          final bool res = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialogPM(
                                    index: taskList[index],
                                    dearection: false,
                                    title: ContentApp(
                                      code: "reply",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ));
                              });
                          //print('showdialog resors $res}');
                          taskHistory();
                        }
                      }));
            },
            //  controller:scrollController ,
          ),
        ),
        //),
      ],
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    taskList.forEach((userDetail) {
      if (userDetail.taskName.contains(text) ||
          userDetail.taskName.toLowerCase().contains(text) ||
          userDetail.taskName.toUpperCase().contains(text))
        _searchResult.add(userDetail);
    });
    setState(() {});
  }

  List<Task> _searchResult = [];

  //List<Task> _userDetails = [];
  whenExpand() {
    expandList.any((element) => element);
  }
}

/*
int taskId;
  String taskName;
  String assignedTo;
  String taskStage;
  String project;
  String createDate;
  String createBy;
  List<Note>notes;
  String description;

*/
getTab(index, child, _selectedTab) {
  return Tab(
      child: SizedBox.expand(
          child: Container(
    child: Center(
      child: Text(
        child,
        style: TextStyle(fontSize: 11),
      ),
    ),
    decoration: BoxDecoration(
        color: (_selectedTab == index ? Colors.white : Color(0xfff3f6fc)),
        borderRadius: _generateBorderRadius(index, _selectedTab)),
  )));
}

_generateBorderRadius(index, _selectedTab) {
  if ((index + 1) == _selectedTab)
    return BorderRadius.only(bottomRight: Radius.circular(10.0));
  else if ((index - 1) == _selectedTab)
    return BorderRadius.only(bottomLeft: Radius.circular(10.0));
  else
    return BorderRadius.zero;
}

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return htmlText.replaceAll(exp, '');
}

List listOftask(String s, sList, tList) {
  for (int i = 0; i < sList.length; i++) {
    if (s == sList[i]) {
      return tList.where((element) => element.state == s).toList();
    }
  }
}

class TaskNote extends StatelessWidget {
  List<Note> note = [];

  TaskNote({Key key, this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List items =
        List.generate(note.length, (index) => MessageItem(note[index], true));
    return Container(
      //height: MediaQuery.of(context).size.height / 1.47,
      child: ListView.separated(
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Divider(
            color: Colors.black12,
          ),
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          print(note[index].body.length);
          final item = items[index];
          //  if(note[index].body.length<3)
          return Container(
            padding: EdgeInsets.only(top: 8),
            color: MyTheme.kAccentColor,
            child: ListTile(
              dense: true,
              title: item.buildTitle(context),
              subtitle: Text(
                note[index].body,
                style: MyTheme.bodyTextMessage,
              ), //item.buildSubtitle(context)
              //  trailing:item.buildLeading(context),
            ),
          );
          /* :Container(
            height: 100,
            child: Text('empty notes..'),
          );*/
        },
      ),
    );
  }
}

extension Utility on BuildContext {
  void nextBlankTextFocus() {
    var startingTextField;
    do {
      // Set starting text field so we can check if we've come back to where we started
      if (startingTextField == null) {
        startingTextField = FocusScope.of(this).focusedChild.context.widget;
      } else if (startingTextField ==
          FocusScope.of(this).focusedChild.context.widget) {
        // Back to where we started - stop as there are no more blank text fields
        break;
      }

      FocusScope.of(this).nextFocus();
    } while (FocusScope.of(this).focusedChild.context.widget is EditableText &&
        (FocusScope.of(this).focusedChild.context.widget as EditableText)
                .controller
                .text
                .trim()
                .length !=
            0);
  }
}
