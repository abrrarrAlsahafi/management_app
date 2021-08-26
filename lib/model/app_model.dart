import 'dart:async';
import 'package:flutter/material.dart';
import 'package:management_app/generated/I10n.dart';
import 'package:management_app/model/project.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/constant.dart';
import 'channal.dart';
import 'folowing.dart';
import 'massege.dart';

const String LAGUAGE_CODE = 'language_code';

//languages code
const String ENGLISH = 'en';
const String ARABIC = 'ar';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? "en";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return Locale(ENGLISH, 'US');
    case ARABIC:
      return Locale(ARABIC, "SA");
    default:
      return Locale(ENGLISH, 'US');
  }
}

String getTranslated(BuildContext context, String key) {
  return S.of(context).translate(key);
}

class AppModel extends ChangeNotifier {
  //= kAdvanceConfig['DefaultLanguage'];
  bool isInit = false;
  Locale _appLocale; // = Locale('en');
  Locale get appLocal => _appLocale ?? Locale("en");
  // Map<String, dynamic> appConfig;
  String locale;
  AppModel() {
    getConfig();
  }

 Future<void> config(context) async {
    await Provider.of<ChatModel>(context, listen: false).getChannalsHistory();
    Provider.of<ChatModel>(context, listen: false).ubdateChatTitle(context);
    Provider.of<NewMessagesModel>(context, listen: false).getnewMasseges(context);
    await Provider.of<FollowingModel>(context, listen: false).getfollowingList(context);
    await Provider.of<MassegesContent>(context, listen: false).gitAllMessagees(context);
   // await Provider.of<ProjectModel>(context, listen: false).getUserProjects();
   // Provider.of<ProjectModel>(context, listen: false).projectManegerName(context);


 }
  Future<bool> getConfig() async {
    // print('appLocal c $appLocal');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      locale = prefs.getString("language_code'") ??
          kAdvanceConfig['DefaultLanguage'];
      isInit = true;
      return true;
    } catch (err) {
      return false;
    }
  }

  fetchLocale() async {
    //print('appLocal $appLocal');

    var prefs = await SharedPreferences.getInstance();
    //  print('fetchLocale ${prefs.getString('language_code')}');

    if (prefs.getString('language_code') == null) {
      _appLocale = Locale('en');
      return Null;
    }
    _appLocale = Locale(prefs.getString('language_code'));
    return Null;
  }

  void changeLanguage(Locale type) async {
    // print('_appLocale $type');
    var prefs = await SharedPreferences.getInstance();
    if (_appLocale == type) {}
    if (type == Locale("ar")) {
      _appLocale = Locale("ar");
      await prefs.setString('language_code', 'ar');
      await prefs.setString('countryCode', 'SA');
      // print('fetchLocale ${prefs.getString('language_code')}');
    } else {
      _appLocale = Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
    }
    await fetchLocale();
    // print('appLocal c ${await getConfig()}');

    notifyListeners();
  }
}
