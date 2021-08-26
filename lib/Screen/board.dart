import 'package:flutter/material.dart';
import 'package:management_app/model/app_model.dart';
import 'package:management_app/model/board.dart';
import 'package:management_app/widget/card_list.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:management_app/widget/search.dart';
import 'package:management_app/widget/subtitel_wedget.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../bottom_bar.dart';
import 'meetings.dart';

class BoardScreen extends StatefulWidget {
  @override
  _BoardScreenState createState() => _BoardScreenState();
}

List<Boards> meetings = [];

class _BoardScreenState extends State<BoardScreen> {
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // meetings =
    //_userDetails =
        getMyProjects();// meetings;
  }
  getMyProjects()  async {
   // print(',,,,');
    //  WidgetsBinding.instance.addPostFrameCallback((_) async {
    _userDetails = await Provider.of<BoardsModel>(context, listen: false).getUserBoards();
    setState(() {});

    //  Provider.of<ProjectModel>(context, listen: false).projectManegerName(context);



    //});

  }


  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.name.contains(text) ||
          userDetail.name.toLowerCase().contains(text))
        _searchResult.add(userDetail);
    });
    setState(() {});
  }

  List<Boards> _searchResult = [];
  List<Boards> _userDetails = [];

  goToSecondScreen({Boards board}) async {
    var result = await Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => MeetingsScreen(
            title: board.name,
            id:board.id
          ),
          //new SecondScreen(context),
          fullscreenDialog: true,
        ));
    // setState(() {
    //project.noOfTask=result;
    //});
    AppModel().config(context);

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "there is new task added to ${board.name}",
          style: MyTheme.Snacbartext,
        ),
        duration: Duration(seconds: 4),
        backgroundColor: MyTheme.kUnreadChatBG,
      ));
    } //return result;
  }

  @override
  Widget build(BuildContext context) {
//print(_userDetails);
    return  Column(children: [
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
                    child: ContentApp(code: 'bords',style: MyTheme.kAppTitle),
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
        Expanded(
            child:_userDetails==null?Container(): Container(
                height: MediaQuery.of(context).size.height / 1.49,
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 8),

                    itemCount:
                        _searchResult.length != 0 || controller.text.isNotEmpty
                            ? _searchResult.length
                            : _userDetails.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () =>
                              goToSecondScreen(board: _userDetails[index]),
                          child: CardListWidget(
                            countName: 'meetings',
                            countNumber: Text(
                                '${_userDetails[index].sessionsCount == null ? 0 : _userDetails[index].sessionsCount}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            titelCollunm: Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _searchResult.length != 0 ||
                                            controller.text.isNotEmpty
                                        ? _searchResult[index].name
                                        : _userDetails[index].name,
                                    style: MyTheme.bodyText1,
                                  ),
                                  // dense: true,
                                  Expanded(child: SizedBox(height: 6)),
                                  Container(
                                      child: SubTitelWidget(
                                          child: Icon(
                                            Icons.description,
                                            color: Colors.grey[700],
                                            size: 15,
                                          ),
                                          title:
                                              "${_userDetails[index].description?_userDetails[index].description:''}")),
                                  SizedBox(height: 12),
                                  Container(
                                      child: SubTitelWidget(
                                          child: Icon(Icons.people_outline_rounded,color: Colors.grey[700], size: 15) ,
                                          title:
                                              "${_userDetails[index].membersCount}")),
                                ],
                              ),
                            ),
                          ));
                    })))
      ]
    );
  }
}
