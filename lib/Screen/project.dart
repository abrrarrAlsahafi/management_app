import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:management_app/Screen/tasks.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/model/app_model.dart';
import 'package:management_app/model/project.dart';
import 'package:management_app/widget/card_list.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:management_app/widget/search.dart';
import 'package:management_app/widget/subtitel_wedget.dart';
import 'package:provider/provider.dart';

import '../bottom_bar.dart';

class Projects extends StatefulWidget {

  const Projects({Key key}) : super(key: key);
  @override
  _ProjectsState createState() => _ProjectsState();
}

bool serchTask = false;

class _ProjectsState extends State<Projects> {
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback(getMyProjects());

    getMyProjects();
  }

  // WidgetsBinding.instance.addPostFrameCallback(getMyProjects);

  @override
  void dispose() {
   // WidgetsBinding.instance.removeObserver(this.getMyProjects());
    super.dispose();
  }

  getMyProjects()  {
    _userDetails= Provider.of<ProjectModel>(context, listen: false).userProject;
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.name.contains(text) ||
          userDetail.name.toLowerCase().contains(text)||
          userDetail.name.toUpperCase().contains(text))
        _searchResult.add(userDetail);
    });
    setState(() {});
  }

  List<Project> _searchResult = [];
  List<Project> _userDetails = [];

  List<bool> fillStar = List.filled(22, false);

   goToSecondScreen({project})async {
    var result = await Navigator.push(context, new MaterialPageRoute(
      builder: (BuildContext context) => TaskScreen(projectid: project,),
      //new SecondScreen(context),
      fullscreenDialog: true,)
    );


      if(result) {
        AppModel().config(context, false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              ContentApp(
                 code: 'New',
                 style: MyTheme.Snacbartext),
              Text('${project.name}',style: MyTheme.Snacbartext)
            ],
          ), duration: Duration(seconds: 4),backgroundColor: MyTheme.kUnreadChatBG,));
      }//return result;
  }
    @override
  Widget build(BuildContext context) {
    return Consumer<ProjectModel>(
        builder: (context, project,child) {
          _userDetails=project.userProject;
          return child;
        },//locator<ProjectModel>(),
        child: Column(children: [
          search
              ?  SearchWidget(
            controller: controller,
            onSearchTextChanged: onSearchTextChanged,
            onPressed: () {
              setState(() {
                search=false;
              });
              controller.clear();
              onSearchTextChanged('');
            },
          )
              : Container(),
          Expanded(
              child: Container(
                  height: MediaQuery.of(context).size.height / 1.49,
                  child: ListView.builder(
                      itemCount: _searchResult.length != 0 ||
                              controller.text.isNotEmpty
                          ? _searchResult.length
                          : _userDetails.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap:() =>goToSecondScreen(project: _userDetails[index]),
                            child: CardListWidget(
                              countName: 'tasks',
                              countNumber: Text(
                                  '${_userDetails[index].noOfTask == null ? 0 : _userDetails[index].noOfTask}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight:
                                      FontWeight
                                          .bold)),
                              titelCollunm: Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _searchResult.length != 0 ||
                                          controller
                                              .text.isNotEmpty
                                          ? _searchResult[index].name
                                          : _userDetails[index].name,
                                      style: MyTheme.bodyText1,
                                    ),
                                    // dense: true,
                                    SizedBox(height: 6),
                                    Container(
                                        child: SubTitelWidget(
                                            child: ContentApp(
                                              style: MyTheme.bodyText2,
                                              code: 'progectManeger',
                                            ),
                                            title:":  ${_searchResult.length != 0 || controller.text.isNotEmpty ? _searchResult[index].managerName : _userDetails[index].managerName == null ? '' : _userDetails[index].managerName}")
                                    ),
                                  ],
                                ),
                              ),
                            )

                         );
                      })))
        ]));
  }
}
