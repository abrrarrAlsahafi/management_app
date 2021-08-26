import 'package:flutter/material.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/model/app_model.dart';
import 'package:management_app/model/user.dart';
import 'package:management_app/widget/content_translate.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../online_root.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isChecked = false;
  bool status = false;
  bool isLogout = false;
  bool _disposed = false;

  //Geolocator geolocator = Geolocator();
  // String _latitude = "24.7348936";
  //String _longitude = "46.783085899999996";
  //bool _isGettingLocation;
  var val = AppModel().locale == 'ar' ? langList.first : langList.last;

  var a = 1.1;

  void initState() {
    super.initState();
    // _isGettingLocation = false;
    //_getCurrentLocation();
  }

/*
  _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true); //.catchError((err) => print(err));

// this will get the coordinates from the lat-long using Geocoder Coordinates
    final coordinates = Coordinates(position.latitude, position.longitude);

// this fetches multiple address, but you need to get the first address by doing the following two codes
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      _isGettingLocation =
          (_longitude == (addresses.first.coordinates.longitude.toString())) &&
              (_latitude == (addresses.first.coordinates.latitude.toString()));
    });
    print(
        "latt ${addresses.first.coordinates.longitude.toString()} ${addresses.first.coordinates.latitude.toString()}");
  }
*/
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return profileApp(context);
  }

  profileApp(context) {
    return Scaffold(

        //  backgroundColor: MyTheme.kAccentColor,
        body: ListView(
      children: [
        SafeArea(
          child: Material(
            elevation: 2.0,
            color: MyTheme.kPrimaryColorVariant,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical:10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  isLogout
                      ? Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Color(0xff336699),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Expanded(
                          child: Text(
                              '${Provider.of<UserModel>(context, listen: false).user.name}',
                              style: MyTheme.kAppTitle),
                        ),
                  IconButton(
                    icon: Icon(Icons.lock, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        isLogout = true;
                        isLoggedIn = false;
                        //  index=0;
                      });
                      //
                      //  SharedPreferences prefs = await SharedPreferences.getInstance();
                      //  await prefs.setBool('remember', false);
                      //  Navigator.of(context).pushNamed('/');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Roots()));
                      Provider.of<UserModel>(context, listen: false)
                          .logout(context);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(12),
          height: MediaQuery.of(context).size.height / 1.3,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            //borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          // color: hexToColor('#336699'),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                height: MediaQuery.of(context).size.width / 66,
                width: MediaQuery.of(context).size.width / 4,
              ),
              employeeInfo(),
              /*    Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).size.height / 33),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Expanded(
                        child: SizedBox(
                      width: 12,
                    )),
                    IconButton(
                      icon: Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () async {
                        await EmomApi().logOut(
                          username: Provider.of<UserModel>(context, listen: false)
                              .user
                              .username,
                          password: Provider.of<UserModel>(context, listen: false)
                              .user
                              .pass,
                        );

                        setState(() {
                          isLoggedIn = false;
                          Navigator.of(context).pushNamed('/b');
                        });
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width / 66),
                    alignment: Alignment.topCenter,
                    child: Text(
                      '${Provider.of<UserModel>(context).user.partnerDisplayName}',
                      style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  // width:MediaQuery.of(context).size.width/1.5 ,
                  height: MediaQuery.of(context).size.height / 1.288,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(33))),
                  child: employeeInfo(),
                ),
              ),*/
            ],
          ),
        ),
      ],
    ));
  }

  employeeInfo() {
    return Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 22),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ContentApp(
                  code: 'uid', //'Company Id:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                      color: Colors.grey)),
              Expanded(child: SizedBox(height: 10)),
              isLogout
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color(0xff336699),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text("${Provider.of<UserModel>(context).user.uid}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          // SizedBox(height: 10),
          Divider(color: Colors.grey),
          //  SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ContentApp(
                code: 'lang',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                    color: Colors.grey)),
            Expanded(child: SizedBox(height: 10)),
            Align(
              alignment: Alignment.center,
              child: DropdownButton<String>(
                dropdownColor: Colors.white,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xffe9a14e),
                ),
                iconSize: 24,
                underline: Container(height: 0),
                elevation: 1,
                style: TextStyle(color: Color(0xffe9a14e), fontSize: 16),
                value: val,
                onChanged: (newValue) {
                  setState(() {
                    val = newValue;
                    if (newValue == 'العربية') {
                      //Provider.of<AppModel>(context, listen: false)
                      // Local newLocale =;

                      // AppModel().changeLanguage(Locale('ar'));
                      Locale newLocale = Locale('ar', 'SA');
                      MyApp.setLocale(context, newLocale);
                    } else {
                      //  Provider.of<AppModel>(context, listen: false)
                      // AppModel().changeLanguage(Locale('en'));
                      Locale newLocale = Locale('en', 'US');
                      MyApp.setLocale(context, newLocale);
                    }
                  });
                },
                items: langList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ]),
          // SizedBox(height: 10),
          Divider(color: Colors.grey),
          SizedBox(height: MediaQuery.of(context).size.height / 55),

          // SizedBox(height: MediaQuery.of(context).size.width / 6),
          ContentApp(
              code: 'scan',
              style: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          SizedBox(height: MediaQuery.of(context).size.height / 44),
          Container(
              padding: EdgeInsets.only(left: 5),
              height: MediaQuery.of(context).size.width / 1.9,
              width: MediaQuery.of(context).size.width / 1.6,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xffe9a14e),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(22))),
              child: isLogout
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color(0xff336699),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Center(
                      child: QrImage(
                      data:
                          "${Provider.of<UserModel>(context).user.uid + num.parse(DateTime.now().microsecond.toString())}",
                      version: QrVersions.auto,
                      size: MediaQuery.of(context).size.width / 1.2,
                    ) /*_isGettingLocation == null
                    ? Expanded(
                      child: ContentApp(
                          code: 'loding',
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w200,
                              fontSize: 12)),
                    )
                    : _isGettingLocation
                        ? QrImage(
                            data:
                                "${Provider.of<UserModel>(context).user.uid + num.parse(DateTime.now().microsecond.toString())}",
                            version: QrVersions.auto,
                            size: MediaQuery.of(context).size.width / 1.2,
                          )
                        : Expanded(
                          child: ContentApp(
                              code: 'place',
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ),
              */
                      )),
          SizedBox(height: MediaQuery.of(context).size.height / 44),
          Divider(color: Colors.grey),
          SizedBox(height: MediaQuery.of(context).size.height / 44),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Logowithtext.png',
                height: MediaQuery.of(context).size.height / 15,
              ),
              SizedBox(width: 22),
              Image.asset('assets/logo.png',
                  height: MediaQuery.of(context).size.height / 15),
              Text("EWADY",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 44,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.kUnreadChatBG)),
            ],
          ),
          Text("V 1.0.0",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height / 44,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
        ]));
  }
}

List<String> langList = ['العربية', 'English'];
