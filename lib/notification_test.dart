import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//import 'package:workmanager/workmanager.dart';


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

 callbackDispatcher() {
  //Workmanager().executeTask((task, inputData) async {
   //var a= await EmomApi().getSessionId();
  //  print(a);
 // return Future.value(true); });
}



