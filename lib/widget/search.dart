import 'package:flutter/material.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/generated/I10n.dart';

class SearchWidget extends StatelessWidget {
  final onSearchTextChanged;
  final controller;
  final onPressed;
//hintText: '${S.of(context).search}',
  const SearchWidget({Key key, this.onSearchTextChanged, this.controller, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child:  new TextField(
        controller: controller,
        decoration:  InputDecoration(
          hintText: S.of(context).search,
          hintStyle: TextStyle(
            color: Colors.black45,
            fontSize: 12,
          ),
          prefixIcon: Icon(Icons.search),
          suffixIcon: InkWell(
            onTap: onPressed,
            child: Icon(Icons.close, size: 18, color: MyTheme.kPrimaryColorVariant,),
          ),
        ),//new InputDecoration(contentPadding: EdgeInsets.all(1), hintText: '${S.of(context).search}', border: InputBorder.none),
        onChanged: onSearchTextChanged,
      ),
    );
  }
}
