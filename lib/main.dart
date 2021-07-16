import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//import 'package:workmanager/workmanager.dart';
import 'notification_test.dart';
import 'online_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterLocalNotificationsPlugin flp =
  FlutterLocalNotificationsPlugin();
  var android = AndroidInitializationSettings('@mipmap/ic_launcher');
  var iOS = IOSInitializationSettings();
  var initSetttings =
  InitializationSettings( android, iOS);
  flp.initialize(initSetttings);
  //showNotification('lastMessage','name', flp);

  /* if (Platform.isIOS) {

    flp
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }
*/
  runApp(MyApp(appLanguage: flp));
}

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppModel appLanguage = AppModel();
  runApp(MyApp(appLanguage: appLanguage));
}



var email;

class MyApp extends StatefulWidget {
  final AppModel appLanguage;

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

  /// getLocale()=>locale;
}

var projectid;

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
          ChangeNotifierProvider(create: (context) => BoardsModel()),
        ],
        child: StreamProvider<User>.value(
            value: Services().user,
            initialData: UserModel().user,
            child: MaterialApp(
              locale: _locale, // widget.appLanguage.appLocal,
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
                '/a': (BuildContext context) => BottomBar(),
                '/b': (BuildContext context) => LoginPage(),
                '/d': (BuildContext context) => Profile(),
                '/chat': (BuildContext context) => ChatList(),
                '/task': (BuildContext context) =>
                    TaskScreen(projectid: projectid),
              },
              home: Roots(),
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
  @override
  _RootsState createState() => _RootsState();
}

class _RootsState extends State<Roots> {
  bool isLoggedIn;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      cheackIsLoggedIn();
    });
  }

  cheackIsLoggedIn() async {
    var status;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool b1=prefs.getBool('isLoggedIn');
    if(prefs.getString('pass')==null|| prefs.getString('email')==null){
       status=false;
    }else{
      status=  prefs.getBool('isLoggedIn') ?? false;
    }
     //
  //  print("$status ${prefs.getBool('isLoggedIn')} ${prefs.getString('email')} ${prefs.getString('pass')}");
    if (status ) {
      var user = await EmomApi().login(context,
          username: prefs.getString('email'),
          password: prefs.getString('pass'));
      print(user.runtimeType);
     if(user.runtimeType!=User){
       setState(() {
         status=false;
         prefs.clear();
       });
     }
     else{
       Provider.of<UserModel>(context, listen: false).saveUser(user);
       AppModel().config(context);
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

    return FutureBuilder<void>(builder: (BuildContext context, snapshot) {
          if (isLoggedIn == null) {
            // print('taskList  ${taskList}');
            return Scaffold(
              appBar: AppBar(),
              backgroundColor: Color(0xfff3f6fc),
              body: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color(0xff336699),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          } else if (isLoggedIn) {
            return BottomBar();
          } else {
            return LoginPage();
          }
        }); //auth login
  }
}
*/
