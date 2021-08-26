import 'package:flutter/material.dart';

class RouteApp {
  const RouteApp({this.tabbartitle, this.icon, this.page});

  final Widget tabbartitle;
  final IconData icon;
  final Widget page;
}

class RootPage extends StatelessWidget {
  const RootPage({Key key, this.route}) : super(key: key);
  final RouteApp route;

  @override
  Widget build(BuildContext context) {
    return Container(
      /* appBar: AppBar(
        backgroundColor: const Color(0xff336699),
        leading: null,
        automaticallyImplyLeading: false,
        title: Align(alignment: Alignment.topLeft, child: Text("Abrar Alsa")),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  // do something
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Profile()),
                          ),
                      child: CircleAvatar(
                        backgroundColor: Colors.black26,
                        foregroundColor: Colors.white,
                        child: Text('AH'),
                      ))),
            ],
          ),
        ],
      ),
      backgroundColor: hexToColor('#F3F6FC'),
     */
      child: route.page,
    );
  }
}
