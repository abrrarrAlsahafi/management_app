import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final onPressed;
  final child;

   ButtonWidget({Key key, this.onPressed, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xff336699),

      ),
      height: 60.0,
      width: 500.0,
      padding: EdgeInsets.all(12.0),
      child: TextButton(
      //  textColor: Colors.white,
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
