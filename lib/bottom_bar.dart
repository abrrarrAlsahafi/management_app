import 'package:flutter/material.dart';
import 'package:management_app/widget/my_tab_bar.dart';
import 'package:provider/provider.dart';
import 'Screen/board.dart';
import 'Screen/chat/chat_list.dart';

import 'Screen/project.dart';
import 'app_theme.dart';
import 'model/user.dart';
import 'online_root.dart';
import 'route.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key key}) : super(key: key);
  @override
  _BottomBarState createState() => _BottomBarState();
}

int selectedIndex = 0;

bool search = false;

List<RouteApp> allDestinations;
String t1, t2, t3, t4, t5;
//NewMessages newMessege;
int totalMessges;

class _BottomBarState extends State<BottomBar> with TickerProviderStateMixin {
  String s;
  TabController tabController;
  int currentTabIndex = 0;

  void onTabChange() {
    setState(() {
      currentTabIndex = tabController.index;
      print(currentTabIndex);
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      onTabChange();
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    tabController.addListener(() {
      onTabChange();
    });
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    nameUser=Provider.of<UserModel>(context, listen: false).user==null?'':Provider.of<UserModel>(context, listen: false).user.name;
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: appBar(),
            backgroundColor: MyTheme.kAccentColor,
            body: /*FutureBuilder<void>(builder: (context, asyncProduct) {
              if (asyncProduct.hasError || totalMessges == null ||nameUser==null ) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Color(0xff336699),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              } else {
                return */ Column(
              children: [
                MyTabBar(
                    tabController: tabController,
                    totalmassege: totalMessges == null
                        ? 0
                        : totalMessges),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery
                        .of(context)
                        .size
                        .width / 60),
                    color: MyTheme.kAccentColor,
                    child: TabBarView(
                      controller: tabController,
                      children: [ChatList(),Projects(),BoardScreen()],
                    ),
                  ),
                )
              ],
              //)))
            )

          // })
        )
    );
  }
  appBar() {
    return AppBar(
      elevation: 0.5,
      backgroundColor:Color(0xff336699),
      leading: IconButton(
        icon: Icon(Icons.menu_outlined, color:Colors.white
        ),
        onPressed: () => Navigator.pushNamed(context, '/d'),
      ),
      automaticallyImplyLeading: false,
      title: Align(
          alignment: Alignment.topLeft,
          child: Text("${nameUser}",style: TextStyle(color: Colors.white),)),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color:Colors.white,
          ),
          onPressed: () {
            setState(() {
              search = search ? false : true;
            });
          },
        )
      ],
    );
  }

  getUsername(){
    if( nameUser==null) {
      return// FutureBuilder<void>(builder: (context, asyncProduct) {
        //if (asyncProduct.hasError || totalMessges == null || nameUser == null) {
        Center(
          child: CircularProgressIndicator(
            backgroundColor: Color(0xff336699),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
    }//}//}
    else {return nameUser;}
  }

  String getInitials(String n) {
    return n.toString().substring(0, 2);
  }
}