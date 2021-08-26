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

  getMyProjects()  async {
    _userDetails= await Provider.of<ProjectModel>(context, listen: false).getUserProjects();
  setState(() {

  });
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
        AppModel().config(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              ContentApp(
                 code: 'New',
                 style: MyTheme.Snacbartext),
              Text('${project.name}',style: MyTheme.Snacbartext)
            ],
          ), duration: Duration(seconds: 4),
          backgroundColor: MyTheme.kUnreadChatBG,));
      }//return result;
  }
    @override
  Widget build(BuildContext context) {
    //return Consumer<ProjectModel>(builder: (context, project,child) {_userDetails=project.userProject;
          return Column(children: [
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
                          child: ContentApp(code: 'projectTitle',style: MyTheme.kAppTitle),
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
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.search_rounded,color: Colors.white,size: 30),
                                // SizedBox(width: 2,),
                                // ContentApp(code: 'addNew',style: TextStyle( fontSize: 14,fontWeight: FontWeight.bold, color: MyTheme.kUnreadChatBG),),
                              ],
                            ),
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
                  setState(() {
                    search = false;

                  });
                  controller.clear();
                  onSearchTextChanged('');
                },
              ):Container(),
           Expanded(child:
                  _userDetails==null?Container():

                    Container(
                      margin: EdgeInsets.zero,
                      //color: Colors.red,
                        height:MediaQuery.of(context).size.height,
                        child: ListView.builder(
                            padding: EdgeInsets.only(top: 8),

                            itemCount: _searchResult.length != 0 ||
                                controller.text.isNotEmpty
                                ? _searchResult.length
                                : _userDetails.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(onTap:() =>goToSecondScreen(project: _userDetails[index]),
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
                                  ));
                            })),
               )

            ]);
     // );// _userDetails?Container(): child;
      //  },
        //locator<ProjectModel>(),
  //);
 }
}
