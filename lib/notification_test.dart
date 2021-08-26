
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'as notifs;
import 'package:rxdart/subjects.dart' as rxSub;

//this is the name given to the background fetch

const simplePeriodicTask = "simplePeriodicTask";
// flutter local notification setup
/*FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
var android = AndroidInitializationSettings('@mipmap/ic_launcher');
var iOS = IOSInitializationSettings();
var initSetttings = InitializationSettings(android:android, iOS:iOS);*/
void showNotification( v,title, FlutterLocalNotificationsPlugin flp) async {
  var android = AndroidNotificationDetails(
      'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.High, importance: Importance.Max);
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android,iOS);

  await flp.show(0, '$title', '$v', platform, payload: 'VIS \n $v');
//  await flp.s
}


Future<void> scheduleNotification(
    {notifs.FlutterLocalNotificationsPlugin notifsPlugin,
      String id,
      String title,
      String body,
      DateTime scheduledTime}) async {
  var androidSpecifics = notifs.AndroidNotificationDetails(
    id, // This specifies the ID of the Notification
    'Scheduled notification', // This specifies the name of the notification channel
    'A scheduled notification', //This specifies the description of the channel
    icon: 'icon',
  );
  var iOSSpecifics = notifs.IOSNotificationDetails();
  var platformChannelSpecifics = notifs.NotificationDetails(
      androidSpecifics, iOSSpecifics);
  await notifsPlugin.schedule(0, title, "Scheduled notification",
      scheduledTime, platformChannelSpecifics); // This literally schedules the notification
}
 //callbackDispatcher() {
/*
   void callbackDispatcher(context) {
     Workmanager().executeTask((task, inputData) async {
       FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
       var android = AndroidInitializationSettings('@mipmap/ic_launcher');
       var iOS = IOSInitializationSettings();
       var initSetttings = InitializationSettings(android, iOS);
       flp.initialize(initSetttings);
       totalMessges = await Provider.of<NewMessagesModel>(context, listen: false).newMessagesList(context);
       if (totalMessges!=null||totalMessges> 0) {
        // showNotification(Provider.of<NewMessagesModel>(context, listen: false).newMessages.channelMessages.first.lastMessage, Provider.of<NewMessagesModel>(context, listen: false).newMessages.channelMessages.first.name,flp);
       } else {
         print("no messgae");
       }


       return Future.value(true);
     });
   }*/
  //Workmanager().executeTask((task, inputData) async {LoginPage();
  // var a= await Provider.of<NewMessagesModel>(co).newMessagesList(co);
    //print(a);
  //return Future.value(true); });
//}



