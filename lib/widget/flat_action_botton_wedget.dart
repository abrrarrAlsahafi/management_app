import 'package:flutter/material.dart';

import '../app_theme.dart';
import 'content_translate.dart';

class FlatActionButtonWidget extends StatelessWidget {
  final onPressed;
  final tooltip;
  final icon;

  const FlatActionButtonWidget({Key key, this.onPressed, this.tooltip, this.icon}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return  TextButton(
      onPressed: onPressed,
      child: Container(
     padding: EdgeInsets.only(left: 10,right: 8,top: 5,bottom: 2),
       height: 40,
      width: 113,
      decoration: BoxDecoration(
        border: Border.all(color:Colors.grey[100]),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 1,
            offset: Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
       color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      // color: Colors.amber[50],
      ),
        child: Row(
          children: [
                //Icon(Icons.search_rounded,color: MyTheme.kPrimaryColorVariant,size: 30),
                // SizedBox(width: 2,),

             // tooltip: tooltip,
       //elevation: 0.0,
             Icon(
                  icon,
                 // Icons.add,
                  color: MyTheme.kUnreadChatBG,
                ),
            SizedBox(width: 5,),
             ContentApp(code: 'addNew',style: TextStyle( fontSize: 14,fontWeight: FontWeight.bold, color: MyTheme.kUnreadChatBG),),

          ],
        ),
      ),
    );
  }
}
