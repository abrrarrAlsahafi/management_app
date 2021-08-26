
import 'package:flutter/material.dart';
import 'package:management_app/Screen/profile.dart';
import 'package:management_app/widget/content_translate.dart';
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


bool search = false;

List<RouteApp> allDestinations;
String t1, t2, t3, t4, t5;
//NewMessages newMessege;
int totalMessges = -1;

class _BottomBarState extends State<BottomBar> {
  //with TickerProviderStateMixin {
  String s;
  TabController tabController;
  int currentTabIndex = 0;
  var currenTap = [ChatList(), Projects(), BoardScreen(), Profile()];

  void onTabChange() {
    setState(() {
      currentTabIndex = tabController.index;
      print(currentTabIndex);
    });
  }

  @override
  void initState() {
    //print('botton');
    super.initState();
    //currentTabIndex=0;
    //tabController = TabController(length: 3, vsync: this);
    // tabController.addListener(() {onTabChange();});

  }

  void pageChanged(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }
    List<BottomNavigationBarItem> buildBottomNavBarItems() {
      return [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          title: ContentApp(code: 'chat',),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group_work),
          title: ContentApp(code: 'projectTitle',),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work),
          title: ContentApp(code: 'bords',),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz_rounded),
          title: ContentApp(code: 'more',),
        ),
      ];
    }

    void bottomTapped(int index) {
      setState(() {
        currentTabIndex = index;
        pageController.animateToPage(
            index, duration: Duration(milliseconds: 500), curve: Curves.ease);
      });
    }
    PageController pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );

    Widget buildPageView() {
      return PageView(
          controller: pageController,
          onPageChanged: (index) {
            pageChanged(index);
          },
          children: currenTap
      );
    }

    @override
    void dispose() {
      // tabController.addListener(() {onTabChange();});
      //tabController.dispose();
     // timer?.cancel();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      //var provider = Provider.of<BottomNavigationBarProvider>(context);

      nameUser = Provider
          .of<UserModel>(context, listen: false)
          .user == null ? '' : Provider
          .of<UserModel>(context, listen: false)
          .user
          .name;
      return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            // appBar: appBar(),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentTabIndex,
              backgroundColor:MyTheme.kPrimaryColorVariant,// ,
              selectedItemColor:Colors.white,// MyTheme.kUnreadChatBG,
              unselectedItemColor: Colors.grey[500],//.grey.shade600,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                bottomTapped(index);
              },
              items: buildBottomNavBarItems(),
            ),
            backgroundColor: MyTheme.kAccentColor,
            body: buildPageView()


          )
      );
    }

    appBar() {
      return AppBar(
        elevation: 0.5,
        // backgroundColor: Color(0xff336699),
        leading: IconButton(
          icon: Icon(Icons.menu_outlined, color: Colors.white
          ),
          onPressed: () => Navigator.pushNamed(context, '/d'),
        ),
        automaticallyImplyLeading: false,
        title: Align(
            alignment: Alignment.topLeft,
            child: Text("${nameUser}", style: TextStyle(color: Colors.white),)),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 13),
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.pink[50],
            ),
            child: Row(
              children: <Widget>[
                Icon(Icons.add, color: MyTheme.kUnreadChatBG, size: 20,),
                SizedBox(width: 2,),
                ContentApp(code: 'new',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
              ],
            ),
          )
          /* IconButton(
          icon: Icon(
            Icons.search,
            color:Colors.white,
          ),
          onPressed: () {
            setState(() {
              search = search ? false : true;
            });
          },
        )*/
        ],
      );
    }

    getUsername() {
      if (nameUser == null) {
        return // FutureBuilder<void>(builder: (context, asyncProduct) {
          //if (asyncProduct.hasError || totalMessges == null || nameUser == null) {
          Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xff336699),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
      } //}//}
      else {
        return nameUser;
      }
    }

    String getInitials(String n) {
      return n.toString().substring(0, 2);
    }

}
class BottomNavigationBarProvider with ChangeNotifier {
  int _currentIndex = 0;

  get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}