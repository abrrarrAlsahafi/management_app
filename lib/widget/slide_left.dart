import 'package:flutter/material.dart';
import 'package:management_app/widget/content_translate.dart';

class SlideLeftWidget extends StatelessWidget {
  final icon;
  final title;

  const SlideLeftWidget({Key key, this.icon, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print(Provider.of<AppModel>(context).locale);
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          //borderRadius: BorderRadius.circular(4.0),
          color: Color(0xffe9a14e)
      ),
      child: //Align(
          //child:
      Column(
        crossAxisAlignment:CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.white,
              ),
              ContentApp(
                code: title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                align: TextAlign.right,
              ),
              SizedBox(width: 12),
              SizedBox(width: 20),
            ],
          ),
          //alignment:MyApp().local == Locale('en')
             // ? Alignment.centerRight:
              // Alignment.centerLeft
          // alignment: Alignment.centerRight,
        //  ),
    );
  }
}
