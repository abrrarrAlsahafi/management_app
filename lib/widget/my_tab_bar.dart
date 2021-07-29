import 'package:flutter/material.dart';
import 'package:management_app/widget/content_translate.dart';
import '../app_theme.dart';
import '../bottom_bar.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({
    Key key,
    @required this.tabController,
   // this.totalmassege,
  }) : super(key: key);

  final TabController tabController;
 // final int totalmassege;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color:MyTheme.kPrimaryColorVariant, //Colors.white, //background color of box
      boxShadow: [
      BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(0, 3), // changes position of shadow
    ),
    ],
      ),
      height: 60,
      //color: Colors.white, //MyTheme.kPrimaryColorVariant,
      child: TabBar(
        controller: tabController,
        labelPadding: EdgeInsets.zero,
        indicatorColor: MyTheme.kUnreadChatBG,
        tabs: [
          Tab(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat,
                        color:Colors.white,// MyTheme.kPrimaryColorVariant,
                        size: 23),
                    ContentApp(
                      code: "chat",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        //MyTheme.kPrimaryColorVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    //   Expanded(child: SizedBox(height: 1)),
                  ],
                ),
                //Provider.of<NewMessagesModel>(context,listen: false).totalm!=-1||
                // Provider.of<NewMessagesModel>(context,listen: false).newMessages.totalNewMessages>0||
                totalMessges > 0
                    ? Positioned(
                        top: 0.0,
                        left: 12,
                        right: 0.0,
                        bottom: 27,
                        // padding: EdgeInsets.all(12),
                        //alignment: Alignment.center,
                        child: //Provider.of<NewMessagesModel>(context,listen: false).totalm == 0
                            //  ? Container()
                            // :
                            Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xffe9a14e)),
                          child: Center(
                            child: Text(
                              '$totalMessges',
                              //  "    ${Provider.of<NewMessagesModel>(context).newMessages.totalNewMessages}",
                              style: TextStyle(
                                  color: MyTheme.kPrimaryColorVariant,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // )
                        // ],
                      )
                    : Container(),
              ],
            ),
            //  icon:
          ),
          Tab(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.playlist_add_check_outlined,
                        color:Colors.white,// MyTheme.kPrimaryColorVariant,
                        size: 25),
                    ContentApp(
                      code: "tasks",
                      style: TextStyle(
                        fontSize:10,
                        color: Colors.white, //MyTheme.kPrimaryColorVariant,

                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Tab(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset('assets/boards_icon_active.png',
                        height: 19,//Icons.playlist_add_check_outlined,
                        color: Colors.white, //MyTheme.kPrimaryColorVariant
                    ),
                    SizedBox(height: 6),
                    ContentApp(
                      code: "bords",
                      style: TextStyle(
                        fontSize:10,
                        color: Colors.white, //MyTheme.kPrimaryColorVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                /*  Provider.of<NewMessagesModel>(context,listen: false).totalm>0?
                Positioned(
                  top: 1.0,
                  left:13,
                  right: 0.0,
                  bottom: 30,
                  // padding: EdgeInsets.all(12),
                  //alignment: Alignment.center,
                  child: //Provider.of<NewMessagesModel>(context,listen: false).totalm == 0
                  //  ? Container()
                  // :
                  Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffe9a14e)),
                    child: Center(
                      child: Text(
                        '${Provider.of<NewMessagesModel>(context,listen: false).totalm}',
                        //  "    ${Provider.of<NewMessagesModel>(context).newMessages.totalNewMessages}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // )
                  // ],
                ):Container(),
             */
              ],
            ),
          ),
        ],
      ),
    );
  }
}
