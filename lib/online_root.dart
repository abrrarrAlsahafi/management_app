import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screen/chat/chat_list.dart';
import 'Screen/login_page.dart';
import 'Screen/profile.dart';
import 'Screen/tasks.dart';
import 'bottom_bar.dart';
import 'generated/I10n.dart';
import 'main.dart';
import 'model/app_model.dart';
import 'model/board.dart';
import 'model/channal.dart';
import 'model/folowing.dart';
import 'model/massege.dart';
import 'model/project.dart';
import 'model/task.dart';
import 'model/user.dart';
import 'services/emom_api.dart';
import 'services/index.dart';

String nameUser = '';
var email;
var projectid;


class MyApp extends StatefulWidget {
  final  FlutterLocalNotificationsPlugin appLanguage;

  static Locale locale = Locale('en');

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
    locale = newLocale;
  }

  MyApp({Key key, this.appLanguage}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  Locale get local {
    return locale;
  }


//getLocale()=>locale;
}


void scheduleAlarm(
   // DateTime scheduledNotificationDateTime,  alarmInfo
    ) async {
  var sche=DateTime.now().add(Duration(minutes: 1));
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'alarm_notif',
    'alarm_notif',
    'Channel for Alarm notification',
    icon: 'codex_logo',
   // sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
   // largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
  );

  var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      sound: 'a_long_cold_sting.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true);

  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  await flp.schedule(0, 'Office', 'sche',//alarmInfo.title,
      sche, platformChannelSpecifics);
}


class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en');

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//   cheackIsLoggedIn();
  }

  bool tap = false;

  @override
  Widget build(BuildContext context) {
    if (this._locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800])),
        ),
      );
    } else {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AppModel()),
          ChangeNotifierProvider(create: (context) => UserModel()),
          ChangeNotifierProvider(create: (context) => TaskModel([])),
          ChangeNotifierProvider(create: (context) => ChatModel()),
          ChangeNotifierProvider(create: (context) => FollowingModel([])),
          ChangeNotifierProvider(create: (context) => MassegesContent()),
          ChangeNotifierProvider(create: (context) => NewMessagesModel()),
          ChangeNotifierProvider(create: (context) => ProjectModel()),
          ChangeNotifierProvider(create: (context)=> BoardsModel()),
          ChangeNotifierProvider(create: (context)=> BottomNavigationBarProvider()),
         // BottomNavigationBarProvider
        ],
        child: StreamProvider<User>.value(
            value: Services().user,
            initialData: UserModel().user,
            child: MaterialApp(
              locale: _locale,
              // widget.appLanguage.appLocal,
              supportedLocales: [Locale('en', 'US'), Locale('ar', 'SA')],
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],

              debugShowCheckedModeBanner: false,
              title: 'EWADY',
              // darkTheme: ThemeData.dark(),
              theme: ThemeData(
                  textTheme:
                  GoogleFonts.tajawalTextTheme(Theme.of(context).textTheme),
                  backgroundColor: Color(0xfff3f6fc),
                  appBarTheme: AppBarTheme(
                    color: MyTheme.kPrimaryColorVariant
                  ),
                  //primaryColor: Color(0xff336699),
                //  buttonColor: Color(0xff336699),
                  canvasColor: Colors.transparent),
              routes: <String, WidgetBuilder>{
                '/root': (BuildContext context) => Roots(flp: widget.appLanguage,),

                '/a': (BuildContext context) => BottomBar(),
                '/b': (BuildContext context) => LoginPage(),
                '/d': (BuildContext context) => Profile(),
                '/chat': (BuildContext context) => ChatList(),
                '/task': (BuildContext context) => TaskScreen(projectid: projectid),

              },
              home: Roots(flp: widget.appLanguage),
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode &&
                      supportedLocale.countryCode == locale.countryCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
            )
          //   }),
        ),
      );
    }
  }

  rootMangmentApp() {}
}

class Roots extends StatefulWidget {

  final flp;

  const Roots({Key key, this.flp}) : super(key: key);
  @override
  _RootsState createState() => _RootsState();
}
var isLoggedIn;


class _RootsState extends State<Roots> with WidgetsBindingObserver {
  Timer timer ,timer1;
  bool notification = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // TODO: implement initState
    super.initState();
    //DateTime.now().add(Duratio)
    //  if(isLoggedIn==null || isLoggedIn==false)  {
    if(isLoggedIn==false|| isLoggedIn==null)
     { Future.delayed(const Duration(seconds: 1), () {
        cheackIsLoggedIn();
      });
   }//else{
      //AppModel().config(context);
      timer= Timer.periodic(Duration(seconds:5), (Timer t) {
    //  print(isLoggedIn);
   if(isLoggedIn!=null){
     if(isLoggedIn){
     //  print('the $totalMessges');
       //Future.delayed(Duration(seconds: 1), () {this.checkForNewSharedLists(context);});
     //  timer = Timer.periodic(Duration(minutes: 5), (Timer t) {
         checkForNewSharedLists(context);
         print('the total massege $totalMessges');
   //    });
     }
    }});
  }//}

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);

    // timer1.cancel();
    // TODO: implement dispose
    super.dispose();
  }
/*
  checkForNewSharedLists(context) async {
    //WidgetsBinding.instance.addPostFrameCallback((_) async {
    // if(totalMessges == -1){
    totalMessges = await Provider.of<NewMessagesModel>(context, listen: false).newMessagesList(context);

    //}
    if (mounted) {
      setState(() {});
    }

    if (totalMessges > 0) {
      if(newMsList.isEmpty){
        getnewMasseges(context);
        print('notification ===============');
      }else {
        if (newMsList.last.lastMessage == Provider
            .of<NewMessagesModel>(context, listen: false)
            .newMessages
            .channelMessages
            .last
            .lastMessage) {
          print('notification stop');
        }else{
          getnewMasseges(context);
        }
      }
    }
    // });
    /* newMessege = await Provider.of<NewMessagesModel>(context, listen: false).newMessagesList();
   setState(() {
      totalMessges = newMessege.totalNewMessages;
  });*/
  }
  var temberory;

  turnOnNotification(){
    // newMsList.last.lastMessage==null?
  }
  List<ChannelMessages> newMsList=[];
  getnewMasseges(context){
    checkForNewSharedLists(context);
    if (Provider.of<NewMessagesModel>(context, listen: false)
        .newMessages
        .totalNewMessages >
        0) {
      newMsList=
          Provider.of<NewMessagesModel>(context, listen: false)
              .newMessages
              .channelMessages;
      //List<ChannelMessages> temp=newMsList
          newMsList.forEach((element) {
        Provider.of<ChatModel>(context, listen: false).chatsList.forEach((e) {
          if (e.id == element.channelId) {

            e.newMessage = true;
            e.lastMessage = element.lastMessage;
            e.lastDate = element.lastDate;
            Provider.of<ChatModel>(context, listen: false).orderByLastAction();
            //if( notification) {
            showNotification(e.lastMessage, e.name, widget.flp);
            //   setState(() {
            //   notification = false;
            // });

          } else {
            e.newMessage = false;
            // Provider.of<ChatModel>(context, listen: false)
            Provider.of<ChatModel>(context, listen: false).orderByLastAction();
          }
        });
      });
    }
  }
*/

//update checklogin Method error when user change password
cheackIsLoggedIn() async {
  var status;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool b1=prefs.getBool('isLoggedIn');
  if(prefs.getString('pass')==null|| prefs.getString('email')==null){
    status=false;
  }else{
    status= prefs.getBool('isLoggedIn') ?? false;
  }
  //
  print("$status ${prefs.getBool('isLoggedIn')} ${prefs.getString('email')} ${prefs.getString('pass')}");
  if (status ) {
    var user ;//= await EmomApi().login(context, username: prefs.getString('email'), password: prefs.getString('pass'));
    print(user.runtimeType);
  // if(user.runtimeType!=User){setState(() {status=false;prefs.clear();});} else{
      Provider.of<UserModel>(context, listen: false).getUser();
      AppModel().config(context);
      setState(() {

      });
      checkForNewSharedLists(context);

  // }
  }
  setState(() {
    isLoggedIn = status;
  });

  //SharedPreferences localStorage = await SharedPreferences.getInstance();
  // isLoggedIn = localStorage.get("isLoggedIn")==null? false: localStorage.get("isLoggedIn");
}

  @override
  Widget build(BuildContext context) {
    print('islog in $isLoggedIn');
    return FutureBuilder<void>(builder: (BuildContext context, snapshot) {
      if ( isLoggedIn==null|| snapshot.hasError) {
        // print('taskList  ${taskList}');
        return Scaffold(
          //appBar: AppBar(),
          backgroundColor: Color(0xfff3f6fc),
          body: Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xff336699),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        );//
      }
      else if(isLoggedIn){
       // print('online');
        return BottomBar();
      } else if(isLoggedIn==false){
        return LoginPage();
      }
      else return Scaffold(
       // appBar: AppBar(),
        backgroundColor: Color(0xfff3f6fc),
        body: Center(
          child: CircularProgressIndicator(
            backgroundColor: Color(0xff336699),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );//
    }
    ); //auth login
  }




  var temberory;

  turnOnNotification(){
    //  newMsList.last.lastMessage==null?
  }
  List<Chat> newMsList=[];
/*  getnewMasseges(context){
    checkForNewSharedLists(context);
    if (Provider.of<NewMessagesModel>(context, listen: false)
        .newMessages
        .totalNewMessages >
        0) {
      newMsList=
          Provider.of<NewMessagesModel>(context, listen: false)
              .newMessages
              .channelMessages;

      //List<ChannelMessages> temp=newMsList
      newMsList.forEach((element) {
        Provider.of<ChatModel>(context, listen: false).chatsList.forEach((e) {
          if (e.id == element.id) {
       //  setState(() {
            e.newMessage = true;
            e.lastMessage = element.lastMessage;
            e.lastDate = element.lastDate;
        //  });
            Provider.of<ChatModel>(context, listen: false).orderByLastAction();
            if( notification) {
              showNotification(e.lastMessage, e.name, widget.flp);
            }
           //   setState(() {
            //   notification = false;
            // });

          } else {
          //  e.newMessage = false;
            // Provider.of<ChatModel>(context, listen: false)
            Provider.of<ChatModel>(context, listen: false).orderByLastAction();
          }
        });
      });
    }
  }*/

}


checkForNewSharedLists(context) async {
  //WidgetsBinding.instance.addPostFrameCallback((_) async {
  // if(totalMessges == -1){
  totalMessges = await Provider.of<NewMessagesModel>(context, listen: false).newMessagesList(context);


  // });
  //  newMessege = await Provider.of<NewMessagesModel>(context, listen: false).newMessagesList();
  // setState(() {totalMessges = newMessege.totalNewMessages;});
}


