import 'package:flutter/material.dart';

import '../app_theme.dart';
import 'content_translate.dart';

// ignore: must_be_immutable
class CardListWidget extends StatelessWidget {
  final titelCollunm;
  var countNumber;
  var countName;

   CardListWidget({Key key, this.countName, this.countNumber,this.titelCollunm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 6),
        elevation: 2,
        child: ClipPath(
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              mainAxisAlignment:
              MainAxisAlignment.start,
              children: [
                titelCollunm,
                Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 6, horizontal: 12),
                    height: 70,
                    width: 3,
                    color: MyTheme.kUnreadChatBG),
                Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        child: Center(
                            child: countNumber),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: MyTheme.kPrimaryColorVariant),
                      ),
                      Expanded(child: SizedBox(height: 6)),
                      ContentApp(
                          code: countName,
                          style: MyTheme.heading2)
                    ])
              ],
            ),
            height: 86,
            //  decoration: BoxDecoration(  border: Border(right: BorderSide(color: Color(0xffe9a14e), width: 5))),
          ),
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(3))),
        ));
  }
}
