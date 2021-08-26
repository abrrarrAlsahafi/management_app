import 'package:flutter/material.dart';
import 'package:management_app/Screen/tasks.dart';
import 'package:management_app/model/task.dart';

import '../app_theme.dart';
import 'content_translate.dart';
import 'expanded_selection.dart';

class CartTask extends StatelessWidget {
  final listTile;
  final onTap;
  final click;
  final isTask;
  final child;
  final  des;

  CartTask(
      {Key key,
      this.listTile,
      this.onTap,
      this.click,
    //  this.onTapstar,
     // this.proirty,
      this.child,
      this.des, this.isTask})
      : super(key: key);
 // final onTapstar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black26)],
              color: Colors.white,
              //  boxShadow:BoxShadow. ,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: MyTheme.kAccentColor,
                width: 0.5,
              )),
          child: Column(
            children: [
            listTile,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: click
                      ? Icon(Icons.keyboard_arrow_up,
                          size: 12, color: Colors.black26)
                      : Icon(Icons.keyboard_arrow_down,
                          size: 12, color: Colors.black26),
                ),
              ),
              ExpandedSection(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Divider(
                        color: Colors.black12,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        des == null
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    des.description == 'false' ||
                                            des.description == null
                                        ? ''
                                        : removeAllHtmlTags(des.description),
                                    style: MyTheme.bodyTextTask),
                              ),
                        des == null
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      height: .5,
                                      color: Colors.black12,
                                      width: MediaQuery.of(context).size.width /
                                          2.7),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: ContentApp(
                                      code: "logNote",
                                      style: MyTheme.bodyTextTask,
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                          height: .5,
                                          color: Colors.black12,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.7)),
                                ],
                              ),
                       isTask ?Container(): child,
                      ],
                    ),
                  ],
                ),
                expand: click,
              )
            ],
          )),
    );
  }
}
