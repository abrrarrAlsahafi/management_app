/*
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/user.dart';

class OnlineRoot extends StatefulWidget {
  @override
  _OnlineRootState createState() => _OnlineRootState();
}
enum AuthStatus { unknown, notLoggedIn, loggedIn }


class _OnlineRootState extends State<OnlineRoot> {
  AuthStatus _authStatus = AuthStatus.unknown;
  String currentUid;
  final  _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      _firebaseMessaging .requestNotificationPermissions(IosNotificationSettings());
      _firebaseMessaging.onIosSettingsRegistered.listen((event) {print("IOS Registered");});
    }

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    //get the state, check current User, set AuthStatus based on state
    AuthModel _authStream = Provider.of<AuthModel>(context);
    if (_authStream != null) {
      setState(() {
        _authStatus = AuthStatus.loggedIn;
        currentUid = _authStream.uid;
      });
    } else {
      setState(() {
        _authStatus = AuthStatus.notLoggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget retVal;

    switch (_authStatus) {
      case AuthStatus.unknown:
        retVal = SplashScreen();
        break;
      case AuthStatus.notLoggedIn:
        retVal = Login();
        break;
      case AuthStatus.loggedIn:
        retVal = StreamProvider<UserModel>.value(value:
        DBStream().getCurrentUser(currentUid),
          child: LoggedIn(),
        );
        break;
      default:
    }
    return retVal;
  }
}

class LoggedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserModel _userStream = Provider.of<UserModel>(context);
    Widget retVal;
    if (_userStream != null) {
      if (_userStream.groupId != null) {
        retVal = StreamProvider<GroupModel>.value(
          value: DBStream().getCurrentGroup(_userStream.groupId),
          child: InGroup(),
        );
      } else {
        retVal = NoGroup();
      }
    } else {
      retVal = SplashScreen();
    }

    return retVal;
  }
}
*/



import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screen/chat/chat_list.dart';
import 'Screen/login_page.dart';
import 'Screen/profile.dart';
import 'Screen/tasks.dart';
import 'bottom_bar.dart';
import 'generated/I10n.dart';
import 'model/app_model.dart';
import 'model/board.dart';
import 'model/channal.dart';
import 'model/folowing.dart';
import 'model/massege.dart';
import 'model/project.dart';
import 'model/task.dart';
import 'model/user.dart';
import 'notification_test.dart';
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
                  primaryColor: Color(0xff336699),
                  buttonColor: Color(0xff336699),
                  canvasColor: Colors.transparent),
              routes: <String, WidgetBuilder>{
                '/root': (BuildContext context) => Roots(flp: widget.appLanguage,),

                '/a': (BuildContext context) => BottomBar(),
                '/b': (BuildContext context) => LoginPage(),
                '/d': (BuildContext context) => Profile(),
                '/chat': (BuildContext context) => ChatList(),
                '/task': (BuildContext context) =>
                    TaskScreen(projectid: projectid),

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


class _RootsState extends State<Roots> {
  Timer timer ,timer1;
  bool notification = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //DateTime.now().add(Duratio)
      if(isLoggedIn==null || isLoggedIn==false)  {
      Future.delayed(const Duration(seconds: 1), () {
        cheackIsLoggedIn();
      });
    }
    timer= Timer.periodic(Duration(seconds:5), (Timer t) {
      //print(isLoggedIn);
   if(isLoggedIn!=null){
     if(isLoggedIn){
       print('the $totalMessges');
       //Future.delayed(Duration(seconds: 1), () {this.checkForNewSharedLists(context);});
     //  timer = Timer.periodic(Duration(minutes: 5), (Timer t) {
         checkForNewSharedLists(context);
         print('the total massege $totalMessges');
   //    });
     }
    }});
  }

  @override
  void dispose() {
    timer?.cancel();
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
    var user = await EmomApi().login(context, username: prefs.getString('email'), password: prefs.getString('pass'));
    //print(user.runtimeType);
    if(user.runtimeType!=User){
      setState(() {
        status=false;
        prefs.clear();
      });
    }
    else{
      Provider.of<UserModel>(context, listen: false).saveUser(user);
      AppModel().config(context);
      checkForNewSharedLists(context);

    }
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
      if ( isLoggedIn==null) {
        // print('taskList  ${taskList}');
        return  Scaffold(
          appBar: AppBar(),
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
    }
    ); //auth login
  }



  checkForNewSharedLists(context) async {
    //WidgetsBinding.instance.addPostFrameCallback((_) async {
    // if(totalMessges == -1){
    totalMessges = await Provider.of<NewMessagesModel>(context, listen: false).newMessagesList(context);

    if (mounted) {
    //  setState (() => checkForNewSharedLists(context));
    }

    if (totalMessges > 0) {
      if(newMsList.isEmpty){
        setState(() {
          notification=true;
        });
        getnewMasseges(context);
        print('notification ===============');
      }else {
        if (newMsList.last.lastMessage == Provider
            .of<NewMessagesModel>(context, listen: false)
            .newMessages
            .channelMessages
            .last
            .lastMessage) {
        //  setState(() {
            notification =false;
        //  });
        //  getnewMasseges(context);
          print('notification stop');
        }else{
          setState(() {
            notification=true;
       });
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
    //  newMsList.last.lastMessage==null?
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
            if( notification) {
              showNotification(e.lastMessage, e.name, widget.flp);
            }
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

}





