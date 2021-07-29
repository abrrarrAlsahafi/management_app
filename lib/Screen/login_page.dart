import 'dart:async';

import 'package:management_app/app_theme.dart';
import 'package:management_app/generated/I10n.dart';
import 'package:management_app/model/app_model.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/services/emom_api.dart';
import 'package:management_app/widget/buttom_widget.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../online_root.dart';

class LoginPage extends StatefulWidget {
  final logout;
  LoginPage({
    Key key, this.logout,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isoffline = false;
  bool _isSelected = false;
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  Timer timer;
  User model = User();
  String error = '';
  TextEditingController emailController; //= TextEditingController()..text = 'Your initial value';
  TextEditingController passController;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
   // if(widget.logout){
     // print('logout..');
      //removedata();
    //}
  // else {
      timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
        setState(() {
          isoffline = false;
        });
      });
      rememberMe();
      super.initState();
   // }
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);

    return Scaffold(
        backgroundColor: const Color(0xfff3f6fc),
        body: ListView(
            children: <Widget>[
              isoffline?
                    errmsg()
              :Container(),
          Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              children: <Widget>[
                Padding(
                  padding:EdgeInsets.all(MediaQuery.of(context).size.width/22),
                  child: Stack(
                      alignment: Alignment.topCenter,
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Container(
                          width: 300.0,
                          height: 220.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: const AssetImage('assets/bgimgs.png'),
                              fit: BoxFit.fitWidth,
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.03),
                                  BlendMode.dstIn),
                            )
                          )
                        ),
                        Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              alignment: Alignment.center,
                              width: 200.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      const AssetImage('assets/logo.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )),
                        Positioned(
                          top: 186,
                          child: Align(
                              //heightFactor: 4.0,
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 352.0,
                                  height: 71.0,
                                  child: Text(
                                    'Board Meetings & Communication',
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: const Color(0xff336699),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )),
                        ),

                      ]),
                ),
                //SizedBox(height: MediaQuery.of(context).size.width/5.5),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () => focus.nextFocus(),

                      keyboardType: TextInputType.emailAddress,
                      onChanged: (str) {
                        setState(() {
                          error = '';
                        });
                      },
                      controller: emailController,
                      validator: (value) {
                        if (value.isEmpty)
                          return S.of(context).validationusername;
                       else return null;
                      },
                      onSaved: (String value) {

                        model.username = value;
                       // print(value);
                      },
                      cursorColor: const Color(0xff336699),
                      // onChanged: ()=>,
                      decoration: InputDecoration(
                        // labelText: 'Email',
                        labelStyle: TextStyle(
                          color: const Color(0xff336699),
                          fontSize: 12,
                        ),
                        hintText:  S.of(context).username,
                        hintStyle:model.username==null? TextStyle(
                          color: Colors.black45,
                          fontSize: 12,
                        ):TextStyle(fontSize: 16),

                        prefixIcon: Icon(Icons.perm_identity),
                      )
                      //  )
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                   //
                    controller: passController,
                    obscureText: _obscureText,
                    cursorColor: const Color(0xff336699),
                    decoration: InputDecoration(
                      hintText: S.of(context).password,
                      hintStyle: TextStyle(
                        color: Colors.black45,
                        fontSize: 12,
                      ),
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: InkWell(
                        onTap: _toggle,
                        child: Icon(Icons.remove_red_eye),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) return S.of(context).validationpassword;
                      else return null;
                    },
                    onSaved: (String value) {
                      model.pass = value;
                    },
                  ),
                ), //),
                Text("$error",
                    style: TextStyle(
                      color: Colors.red,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
               Checkbox(
                      activeColor: MyTheme.kPrimaryColorVariant,
                      value:_isSelected,
                      onChanged: (bool newValue) {
                        setState(() {
                          _isSelected = newValue;
                        });
                      },
                    ),
                    Expanded(
                        child: ContentApp(
                      code: 'rememberme',
                      style: TextStyle(
                        //fontSize: 14,
                        color: Colors.black45,
                      ),
                      // textAlign: TextAlign.left,
                    )),
                  ],
                ),
                ButtonWidget(
                    onPressed: () => validateInput(),
                    child: ContentApp(
                        code: 'bottonlogin',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold,)),
                  ),
              ],
            ),
          )
        ]));
  }

  Future<void> validateInput() async {
    print("user mame .. ${model.username}");
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      dynamic result =
          await EmomApi().login(context,username: model.username, password: model.pass);
     // print('ttt ${result}');

      if (result.runtimeType != User) {
        if(result.toString().contains('Failed host')){
          setState(() {
            isoffline=true;
          });
          //errmsg();
          //print('network connct');
        }else{
        setState(() {
          error=S.of(context).loginValidatin; //'The password or username is incorrect';
        });}
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        UserModel userModel = Provider.of<UserModel>(context, listen: false);
        result.pass=model.pass;
        userModel.saveUser(result);
       setState(() {   isLoggedIn = true;  });
        AppModel().config(context, true);
        Navigator.of(context).pushNamed('/a');
        if (_isSelected) {
          saveEmail(model);
          prefs.setBool('remember', true);
        }else{
          prefs.setBool('remember', false);
        }
      }
    }
    else {
      setState(() {
        _autoValidate = true;
      });
    }
  }



  Widget errmsg(){
    //error message widget.

      //if error is true then show error message box
      return Container(
        height: MediaQuery.of(context).size.height/13,
    //  padding: EdgeInsets.all(10.00),
      //  margin: EdgeInsets.only(bottom: 10.00),
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Text("No Internet Connection Available", style: TextStyle(color: Colors.white)),
          //show error message text
        ]),
      );
  }

  Future<void> saveEmail(User email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // if(saved) {
      if (email.username != null) {
        // prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email.username);
      }
      if (email.pass != null) {
        // prefs = await SharedPreferences.getInstance();
        prefs.setString('pass', email.pass);
      }
      print('email... ${prefs.get('email')}');

  }


  rememberMe() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   bool remember= prefs.getBool('remember')==null?false:prefs.getBool('remember');
   if(remember){
     model.username= prefs.get('email');
     model.pass= prefs.get('pass');
     emailController=TextEditingController()..text = model.username;
     passController=TextEditingController()..text = model.pass;
     _isSelected=true;
     setState((){});

   }
   else{
     prefs.clear();
   }
//print(model.username);
  // return prefs.getBool('remember');
  }

  Future<void> removedata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//prefs.
  }

}
