

import 'package:flutter/material.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/model/task.dart';

bool isFrist=false;

// ignore: must_be_immutable
class MembertImage extends StatefulWidget {
  var item;

   MembertImage({Key key, this.item}) : super(key: key);

  @override
  _MembertImageState createState() => _MembertImageState();
}

class _MembertImageState extends State<MembertImage> {
  //String _base64;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return buildImage();
  }

  buildImage() {
          // print("image ${item}");
          //var bytes =item;//'http://demo.ewady.com/web/image?model=mail.channel&id=$item&field=image_128';
           // base64.decode(_base64);
           return widget.item.runtimeType==Task?CircleAvatar(
             child:Text('${widget.item.taskName[0].toString().toUpperCase()}', style: TextStyle(color: Colors.white) ,),
             backgroundColor:MyTheme.colors[0] ,
           ):CircleAvatar(
             child:Text('${widget.item.name[0].toString().toUpperCase()}', style: TextStyle(color: Colors.white) ,),
             backgroundColor:MyTheme.colors[0] ,
           );/*Container(
            width:40,
            height:40,
            decoration: BoxDecoration(
              image:DecorationImage(
                image:Image(
                  gaplessPlayback: true,
                  image:FadeInImage(
                    image: NetworkImage('http://demo.ewady.com/web/image?model=mail.channel&id=$item&field=image_128'),
                    placeholder: AssetImage('assets/bgimgs.png'),
                  //bytes,

                    //placeholder: AssetImage('assets/product.jpg'),
                  //  gaplessPlayback: true,

                    // 'assets/a.jpg',
               //   base64.decode(str),
                  // fit: BoxFit.cover,
                 //   height: 50, width: 50
                  ).image,
                fit: BoxFit.cover,
              ).image,
              ),
              borderRadius:BorderRadius.circular(33),
                border: Border.all(color: Colors.grey[200])
            ),
          );*/

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
     // var str = item.image.toString().substring(2,item.image.toString().length - 1);
          //str = base64.normalize(str);
          return Container(
            width:40,
            height:40,
            decoration: BoxDecoration(
              image:DecorationImage(
                image:Image(
                  gaplessPlayback: true,
                  image:Image.network('${item.image}',
                //  base64.decode(str),
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
 //   Provider.of<>(context)
   // item.user

  }
}
