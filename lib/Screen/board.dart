import 'package:flutter/material.dart';
import 'package:management_app/model/app_model.dart';
import 'package:management_app/model/board.dart';
import 'package:management_app/widget/card_list.dart';
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
    AppModel().config(context, false);

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
print(_userDetails);
    return Scaffold(
    //  floatingActionButton: FlatActionButtonWidget(  onPressed: (){},   icon: Icons.add,  ),
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
                height: MediaQuery.of(context).size.height / 1.49,
                child: ListView.builder(
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
                                  SizedBox(height: 6),
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
      ]),
    );
  }
}
