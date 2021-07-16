
import 'dart:async';

import 'package:flutter/material.dart';
class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Timer _timer;
  FlutterLogoStyle _logoStyle = FlutterLogoStyle.markOnly;

  _LoadingScreenState() {
    _timer = new Timer(const Duration(seconds: 12), () {
      setState(() {
        _logoStyle = FlutterLogoStyle.horizontal;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        color: const Color(0xfff3f6fc),
        child:  Column(
         // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
            //
            //  overflow: Overflow.visible,
              children: <Widget>[
                Stack(alignment: Alignment.topCenter,
                    children: [
                      Container(
                        // padding: EdgeInsets.all(12),
                          width: 300.0,
                          height: 220.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: const AssetImage('assets/bgimgs.png'),
                                fit: BoxFit.fitWidth,
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.03),
                                    BlendMode.dstIn),
                              )
                          )
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 200.0,
                        height: 200.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                            const AssetImage('assets/logo.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),

                Container(
padding: EdgeInsets.all(12),
                        alignment: Alignment.center,
                          child: Text(
                            'Board Meetings \n&\nCommunication',
                            style: TextStyle(
                              fontSize: 30,
                              color: const Color(0xff336699),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                        ),
                      ),


              ]),
      ),
    );
  }
}
