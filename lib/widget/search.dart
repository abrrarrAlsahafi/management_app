import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final onSearchTextChanged;
  final controller;
  final onPressed;

//hintText: '${S.of(context).search}',
  const SearchWidget(
      {Key key, this.onSearchTextChanged, this.controller, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 12, left: 6, right: 6),
      child: Material(
      //elevation: 2.0,
            borderRadius: BorderRadius.circular(19),
      // borderSide: BorderSide(color: Colors.grey.shade200),
        child: TextFormField(
          controller: controller,
          onChanged: onSearchTextChanged,
          decoration: InputDecoration(
            hintText: "Search...",
           // hintStyle: TextStyle(color: Colors.grey.shade600),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey.shade600,
              size: 20,
            ),
            filled: true,
        fillColor: Colors.grey.shade200,
           contentPadding: EdgeInsets.all(12),
          enabledBorder: OutlineInputBorder(
           borderRadius: BorderRadius.circular(19),
          borderSide: BorderSide(color: Colors.grey.shade200),

        ),

          ),
        ),
      ),
    );
    /*Container(
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
    );*/
  }
}
