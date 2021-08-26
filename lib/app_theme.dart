import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'common/constant.dart';

class MyTheme {
  MyTheme._();

  static List colors=[hexToColor('#74788d')];//, Colors.black45, Colors.indigo];
  //static Color kPrimaryColor = Color(0xff7C7B9B);
  static Color kPrimaryColorVariant = Color(0xff336699);
  static Color kAccentColor = Color(0xfff3f6fc);
  static Color kAccentColorVariant = hexToColor('#E1E8F5');
  static Color kUnreadChatBG = Color(0xffe9a14e);

  static final TextStyle kAppTitle = GoogleFonts.tajawal(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white);
  static final TextStyle heading2 = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle chatSenderName = TextStyle(
    color: Colors.black38,
    fontSize: 12,
    fontWeight: FontWeight.bold,
    //letterSpacing: 1.5,
  );
  static final TextStyle dateStyle = TextStyle(
    color: Colors.black38,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    //letterSpacing: 1.5,
  );
  static final TextStyle bodyText1 = TextStyle(
      color: MyTheme.kPrimaryColorVariant,
      fontSize: 14,
      //letterSpacing: 1.2,
      fontWeight: FontWeight.bold);
  static final TextStyle bodyText2 = TextStyle(
      color: Colors.black87,
      fontSize: 14,
      fontWeight: FontWeight.bold);
  static final TextStyle bodyTextMessage = TextStyle(
      fontSize:11,
      fontWeight: FontWeight.w600);
  static final TextStyle bodyTextTask = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.grey[400],
  );
  static final TextStyle bodyTextTime = TextStyle(
    color: Colors.blue,
    fontSize: 11,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle Snacbartext = TextStyle(
    color: Colors.white,
    fontSize:11,
    fontWeight: FontWeight.bold,
  );
}
