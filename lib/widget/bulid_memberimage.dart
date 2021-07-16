import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:management_app/model/channal.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/model/note.dart';

class MembertImage extends StatelessWidget {
  final item;

  const MembertImage({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return item.runtimeType==Note?buildUserImage(item)
    :buildImage(item);
  }


  buildImage(item) {
    //if(item.runtimeType==Folowing){
        if(item.image=='False') {
          print("image ${item.image}");
        return  falseImage();
      } else{
          var str = item.image.toString().substring(2,item.image.toString().length - 1);
          str = base64.normalize(str);
          return Container(
            width:40,
            height:40,
            decoration: BoxDecoration(
              image:DecorationImage(
                image:Image(
                  gaplessPlayback: true,
                  image:Image.memory(
                  base64.decode(str),
                  fit: BoxFit.cover,
                  height: 40,
                  width: 40
                ).image,
                fit: BoxFit.cover,
              ).image  ,
              ),
              borderRadius:BorderRadius.circular(33),
                border: Border.all(color: Colors.grey[200])
            ),
          );
        }
 /*   }else{

    if(item.runtimeType==Chat){
      print('item run type ${item.isChat}');
      return Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
         color:Colors.grey[300] ,
          shape: BoxShape.circle,
        ),
        child: Icon(
          item.isChat?Icons.person:Icons.group_outlined,
          color: Colors.white,
          size: 36,
        ),
      );
    }
   // if(item)
    }*/
  }

  falseImage(){
    return Container(
      width: 40,
      height: 40,
    //  child: Center(child: Icon(Icons.person, size: 33)),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[200]))
    );
  }

  buildUserImage(item) {
    /*
    *  var str = item.image.toString().substring(2,item.image.toString().length - 1);
          str = base64.normalize(str);
          return Container(
            width:40,
            height:40,
            decoration: BoxDecoration(
              image:DecorationImage(
                image:Image(
                  gaplessPlayback: true,
                  image:Image.memory(
                  base64.decode(str),
                  fit: BoxFit.cover,
                  height: 40,
                  width: 40
                ).image,
                fit: BoxFit.cover,
              ).image  ,
              ),
              borderRadius:BorderRadius.circular(33),
                border: Border.all(color: Colors.grey[200])
            ),
          );*/
 //   Provider.of<>(context)
   // item.user

  }
}
