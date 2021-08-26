import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:management_app/common/constant.dart';
import 'package:management_app/services/emom_api.dart';
import 'package:management_app/services/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel with ChangeNotifier {
  //final AuthenticationService _authenticationService = locator<AuthenticationService>();

  UserModel() {
    getUser();
  }

  Services _service = Services();
  User user;
  bool loggedIn = false;
  bool loading = false;

  void updateUser(Map<String, dynamic> json) {
    user.name = json['display_name'];
    user.uid = json['user_email'];
    user.pass = json['password'];

    notifyListeners();
  }

  userLangouge() {
    return this.user.userContext.lang.substring(0, 2);
    //  final LocalStorage storage = LocalStorage("emomApp");
  }

  Future<void> saveUser(User user) async {
   // getUser();

    this.user = user;
    print('save user ${user.pass}');
    final LocalStorage storage = LocalStorage("emomApp");
    try {
      // save to Preference
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', true);

      // save the user Info as local storage
      final ready = await storage.ready;

      print("ready 1 ${user.toJson()}");
      if (ready) {
        await storage.setItem('userInfo', user);
       // print("save 2 ${user.name}");
        //print("save 2 ${storage.getItem(kLocalKey["userInfo"])}");

      }
    } catch (err) {
      print('erorr 1 $err');
    }
  }

  Future<void> getUser() async {
    print('getUser');
    final LocalStorage storage = LocalStorage("emomApp");
    try {
      final ready = await storage.ready;
      if (ready) {
        print("ready $ready");

        final json = storage.getItem("userInfo");
        print("ready $json");

        if (json != null) {
          user = User.fromJson(json);
          print(user);
          loggedIn = true;
          notifyListeners();
        }
      }
    } catch (err) {
      print("aaa  $err");
    }
  }

  Future<void> createUser({
    username,
    password,
    firstName,
    lastName,
    Function success,
    Function fail,
  }) async {
    try {
      loading = true;
      notifyListeners();
      user = await _service.createUser(
        firstName: firstName,
        lastName: lastName,
        email: username,
        password: password,
      );
      loggedIn = true;
      await saveUser(user);
      success(user);

      loading = false;
      notifyListeners();
    } catch (err) {
      fail(err.toString());
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout(context) async {
    user = null;
    loggedIn = false;

    // final LocalStorage storage = LocalStorage("emomApp");
    try {
      //  final ready = await storage.ready;
      //if (ready) {
      // await storage.deleteItem(kLocalKey["userInfo"]);
      // await storage.deleteItem(kLocalKey["shippingAddress"]);
      //await storage.deleteItem(kLocalKey["recentSearches"]);
      // await storage.deleteItem(kLocalKey["wishlist"]);
      //await storage.deleteItem('token');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.setBool('isLoggedIn', false);
      await prefs.setBool('remember', false);
      await prefs.remove('email');
      await prefs.remove('pass');
      await prefs.clear();
      // }
      await EmomApi().logOut(
        username: user.username,
        password: user.pass,
      );
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

/*
  Future<void> login({username, password, Function success, Function fail}) async {
    try {
      loading = true;
      notifyListeners();
      user = await _service.login(
        username: username,
        password: password,
      );

      loggedIn = true;
      await saveUser(user);
      success(user);
      loading = false;
      notifyListeners();
    } catch (err) {
      loading = false;
      fail(err.toString());
//      print('login err $err');
      notifyListeners();
    }
  }
*/
  Future<bool> isLogin() async {
    final LocalStorage storage = LocalStorage("emomApp");
    try {
      final ready = await storage.ready;
      if (ready) {
        final json = storage.getItem("userInfo");
        return json != null;
      }
      return false;
    } catch (err) {
      return false;
    }
  }
}

class User {
  var pass;
  var uid;
  bool isSystem;
  bool isAdmin;
  UserContext userContext;
  var db;
  var serverVersion;
  List serverVersionInfo;
  var name;
  var username;
  var partnerDisplayName;
  var companyId;
  var partnerId;
  var webBaseUrl;
  UserCompanies userCompanies;
  var currencies;
  var showEffect;
  bool displaySwitchCompanyMenu;
  var cacheHashes;
  var maxTimeBetweenKeysInMs;
  List webTours;
  bool outOfOfficeMessage;
  bool odoobotInitialized;
  var timesheetUom;
  var timesheetUomFactor;

  User(
      {this.pass,
      this.uid,
      this.isSystem,
      this.isAdmin,
      this.userContext,
      this.db,
      this.serverVersion,
      this.serverVersionInfo,
      this.name,
      this.username,
      this.partnerDisplayName,
      this.companyId,
      this.partnerId,
      this.webBaseUrl,
      this.userCompanies,
      this.currencies,
      this.showEffect,
      this.displaySwitchCompanyMenu,
      this.cacheHashes,
      this.maxTimeBetweenKeysInMs,
      this.webTours,
      this.outOfOfficeMessage,
      this.odoobotInitialized,
      this.timesheetUom,
      this.timesheetUomFactor});

  User.fromJson(Map<String, dynamic> json) {
    // print('name ${json['name']}');
    uid = json['uid'];
    isSystem = json['is_system'];
    isAdmin = json['is_admin'];
    userContext = json['user_context'] != null
        ? new UserContext.fromJson(json['user_context'])
        : null;
    db = json['db'];
    serverVersion = json['server_version'];
    //serverVersionInfo = json['server_version_info'].cast<int>();
    name = json['name'];
    username = json['username'];
    partnerDisplayName = json['partner_display_name'];
    companyId = json['company_id'];
    partnerId = json['partner_id'];
    webBaseUrl = json['web.base.url'];
    userCompanies = json['user_companies'] != null
        ? new UserCompanies.fromJson(json['user_companies'])
        : null;
    //currencies = json['currencies'] != null ? new Currencies.fromJson(json['currencies']) : null;
    showEffect = json['show_effect'];
    displaySwitchCompanyMenu = json['display_switch_company_menu'];
    //cacheHashes = json['cache_hashes'] != null ? new CacheHashes.fromJson(json['cache_hashes']) : null;
    maxTimeBetweenKeysInMs = json['max_time_between_keys_in_ms'];
    // webTours = json['web_tours'].cast<String>();
    outOfOfficeMessage = json['out_of_office_message'];
    odoobotInitialized = json['odoobot_initialized'];
    //timesheetUom = json['timesheet_uom'] != null ? new TimesheetUom.fromJson(json['timesheet_uom']) : null;
    timesheetUomFactor = json['timesheet_uom_factor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['is_system'] = this.isSystem;
    data['is_admin'] = this.isAdmin;
    if (this.userContext != null) {
      data['user_context'] = this.userContext.toJson();
    }
    data['db'] = this.db;
    data['server_version'] = this.serverVersion;
    data['server_version_info'] = this.serverVersionInfo;
    data['name'] = this.name;
    data['username'] = this.username;
    data['partner_display_name'] = this.partnerDisplayName;
    data['company_id'] = this.companyId;
    data['partner_id'] = this.partnerId;
    data['web.base.url'] = this.webBaseUrl;
    if (this.userCompanies != null) {
      data['user_companies'] = this.userCompanies.toJson();
    }
    if (this.currencies != null) {
      data['currencies'] = this.currencies.toJson();
    }
    data['show_effect'] = this.showEffect;
    data['display_switch_company_menu'] = this.displaySwitchCompanyMenu;
    if (this.cacheHashes != null) {
      data['cache_hashes'] = this.cacheHashes.toJson();
    }
    data['max_time_between_keys_in_ms'] = this.maxTimeBetweenKeysInMs;
    data['web_tours'] = this.webTours;
    data['out_of_office_message'] = this.outOfOfficeMessage;
    data['odoobot_initialized'] = this.odoobotInitialized;
    if (this.timesheetUom != null) {
      data['timesheet_uom'] = this.timesheetUom.toJson();
    }
    data['timesheet_uom_factor'] = this.timesheetUomFactor;
    return data;
  }
}

class UserContext {
  var lang;
  var tz;
  var uid;

  UserContext({this.lang, this.tz, this.uid});

  UserContext.fromJson(Map<String, dynamic> json) {
    lang = json['lang'];
    tz = json['tz'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lang'] = this.lang;
    data['tz'] = this.tz;
    data['uid'] = this.uid;
    return data;
  }
}

class UserCompanies {
  List currentCompany;
  List allowedCompanies;

  UserCompanies({this.currentCompany, this.allowedCompanies});

  UserCompanies.fromJson(Map<String, dynamic> json) {
    currentCompany = json['current_company'];
    if (json['allowed_companies'] != null) {
      allowedCompanies = []; //new List<List>();
      json['allowed_companies'].forEach((v) {
        allowedCompanies.add(new List());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_company'] = this.currentCompany;
    if (this.allowedCompanies != null) {
      data['allowed_companies'] = this.allowedCompanies.map((v) => v).toList();
    }
    return data;
  }
}

class AllowedCompanies {
  AllowedCompanies();

  //AllowedCompanies.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
