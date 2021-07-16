import 'package:flutter/material.dart';
import 'package:management_app/widget/content_translate.dart';

import '../app_theme.dart';

class SlideRightBackgroundWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.only(right: 3),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        //borderRadius: BorderRadius.circular(4.0),
        color: MyTheme.kPrimaryColorVariant,
      ),
      child:// Align(
         // child:
      Column(crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 10),
              Icon(Icons.reply, color: Colors.white),
              SizedBox(width: 10),
              ContentApp(code:'reply',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                 //align: TextAlign
              ),
            ],
          ),
    );
  }
}
