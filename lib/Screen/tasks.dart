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
import 'package:provider/provider.dart';

import '../online_root.dart';
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
  List listStageTask =[];
  bool _disposed = false;
  TabController _tabController;
  List<Task> taskList;
  int _selectedTab = 0;
  Future<TaskModel> _calculation;
  bool isManeger= false;

  //List<Note> note;
  @override
  void initState() {
    projectid=widget.projectid;
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


  goToSecondScreen(item,id) async {
    var result = await Navigator.push(context, new MaterialPageRoute(
      builder: (BuildContext context) => CreateScreen(
        item: item,projectid: id,
      ),
      //new SecondScreen(context),
      fullscreenDialog: true)
    );
    print(result);
   // AppModel().config(context);
    if(result) {
      taskHistory();
      addTask = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ContentApp(code: 'New', style: MyTheme.Snacbartext,),
          duration: Duration(seconds: 4),backgroundColor: MyTheme.kUnreadChatBG));
    }//return result;
  }
  taskHistory() async {
    // print("frist $taskList");
    taskList = await Provider.of<TaskModel>(context, listen: false)
        .getUserTasks(projectid.id//widget.projectid.id
    );
  //  await Provider.of<TaskModel>(context, listen: false).viewLogNote();

    expandList = List.generate(taskList.length, (index) => false);
    setState(() {});
  //  getStage();

  }

  bool click = false;

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this.taskHistory());
    _disposed = true;
    taskList.clear();
    super.dispose();
    isManeger=false;
  }


  TextEditingController controller = new TextEditingController();


  bool addTask = false;
  var result;
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, addTask);
        return addTask;
      },//=>addTask, //
      child:
      Scaffold(
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
            title: Text(projectid.name,//widget.projectid.name,
                style: MyTheme.kAppTitle),
          ),
          backgroundColor: MyTheme.kAccentColor,
          floatingActionButton: FlatActionButtonWidget(
            icon: Icons.playlist_add,
            onPressed: ()  {
               goToSecondScreen(Task(), projectid.id);//widget.projectid.id,
            },
            tooltip: 'task',
          ), //:Container(),
          body: FutureBuilder<void>(builder: (BuildContext context, snapshot) {
            if (snapshot.hasData || taskList == null) {
             // print('taskList  ${taskList}');
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xff336699),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            }
            else if (taskList.isEmpty) {
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

  bool proi = false;
  bodyTask() {
    //print("widget.projectid ${taskList}");
    String userName=Provider.of<UserModel>(context, listen: false).user.name;
    Provider.of<ProjectModel>(context, listen: false).userProject.forEach((element) {
    //  print("id,,, ${element.id }  ${widget.projectid.id}");
      if( element.id ==projectid.id//widget.projectid.id
      ){
        if(element.managerName==userName){
        //  setState(() {
            isManeger=true;
        //  });
        }
      }
    });
    print(" bodyTa  $isManeger");
    return  ListView(
      children: [
        SearchWidget(
          controller: controller,
          onSearchTextChanged: onSearchTextChanged,
          onPressed: () {
            controller.clear();
            onSearchTextChanged('');
          },
        ),
        //: Container(),
        Container(
          height:MediaQuery.of(context).size.height/1.26,
          child: ListView.builder(
                    itemCount:  _searchResult.length != 0 ||
                        controller
                            .text.isNotEmpty
                        ? _searchResult.length
                        : taskList.length,
                    itemBuilder: (context, index)  {
                    //  print("stage ${taskList[index].taskStage}");
                      return Container(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Dismissible(
                              key: Key('${taskList[index].taskName}'),
                              child: CartTask(
                                des:taskList[index],
                                child:TaskNote(note:taskList[index].notes==null?[]:taskList[index].notes),
                                  click: expandList[index],
                                  onTap: () {
                                    setState(() {
                                      expandList[index] =
                                          expandList[index] ? false : true;
                                    });
                                  },

                                  listTile:ListTile(
                                      title: Text(_searchResult.length != 0 ||
                                          controller
                                              .text.isNotEmpty
                                          ? _searchResult[index].taskName:
                                           taskList[ index].taskName,
                                          style:
                                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      subtitle: Text(
                                          "by ${   _searchResult.length != 0 ||
                                              controller
                                                  .text.isNotEmpty
                                              ? _searchResult[index].createBy
                                              : taskList[ index].createBy}  on  ${DateFormat.yMMMd().format(taskList[index].createDate == null ? DateTime.now() : DateTime.parse(taskList[index].createDate))} To ${taskList[index].assignedTo}",
                                          style: TextStyle(fontSize: 11)))),
                              background: SlideRightBackgroundWidget(),
                              secondaryBackground:isManeger? SlideLeftWidget(
                                    icon:isManeger// (Provider.of<UserModel>(context).user.isAdmin)
                                    ? Icons.person_add_outlined
                                    : Icons.redo,
                                title:'assign'
                              ):
                              Container(),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart&& isManeger) {
                                  final bool res = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialogPM(
                                            // taskId: taskList[index],
                                            index: taskList[index],
                                            dearection: true,
                                            title: Text(
                                            "You want to assgin ${taskList[index].taskName} task to?",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ));
                                      });


                                }
                                else if (direction == DismissDirection.startToEnd) {
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
                                }
                              })
                      );
                    },
          ),
        ),
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
          userDetail.taskName.toLowerCase().contains(text)||
          userDetail.taskName.toUpperCase().contains(text))
          _searchResult.add(userDetail);
    });
    setState(() {});
  }

  List<Task> _searchResult = [];
  //List<Task> _userDetails = [];


}


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

class CartTask extends StatelessWidget {
  final listTile;
  final onTap;
  final click;
  final proirty;
  final child;
  final Task des;

  CartTask(
      {Key key,
      this.listTile,
      this.onTap,
      this.click,
      this.onTapstar,
      this.proirty, this.child, this.des})
      : super(key: key);
  final onTapstar;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black26)],
            color: Colors.white,
            //  boxShadow:BoxShadow. ,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: MyTheme.kAccentColor,
              width: 0.5,
            )),
        child: Column(
          children: [
            listTile,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: click?Icon(Icons.keyboard_arrow_up,size: 12, color:Colors.black26):
                Icon(Icons.keyboard_arrow_down,size: 12, color:Colors.black26),
              ),
            ),
            ExpandedSection(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Divider(
                      color: Colors.black12,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      des == null?Container():
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(des.description=='false'?'':removeAllHtmlTags(des.description), style: MyTheme.bodyTextTask),
                          ),
                      des == null? Container():  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Container(height: .5, color:Colors.black12,width: MediaQuery.of(context).size.width/2.7),
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 5),
                           child: ContentApp(code: "logNote", style: MyTheme.bodyTextTask,),
                         ),
                         Expanded(child: Container(height: .5,color:Colors.black12,width: MediaQuery.of(context).size.width/2.7)),
                       ],
                     ),
                      child,

                    ],
                  ),
                ],
              ),
              expand: click,
            )
          ],
        ),
      ),
    );
  }
}
String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true
  );

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
   List<Note> note=[];
   TaskNote({Key key, this.note}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List items = List.generate(note.length, (index) => MessageItem(note[index], true));
    return Container(
      height: MediaQuery.of(context).size.height/6,
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
