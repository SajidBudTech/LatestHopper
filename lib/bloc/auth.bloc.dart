import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/constants/app_strings.dart';
import 'package:flutter_hopper/constants/strings/prefrence_key.string.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthBloc extends BaseBloc {
  //
  static SharedPreferences prefs;

  static Future<SharedPreferences> getPrefs() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return prefs;
  }

  //
  static bool firstTimeOnApp() {
    return prefs.getBool(AppStrings.firstTimeOnApp) ?? true;
  }

  //
  static bool authenticated() {
    return prefs.getBool(AppStrings.authenticated) ?? false;
  }


  static bool NotificationBadget() {
    return prefs.getBool(AppStrings.FlutterAppBadgetConstant) ?? false;
  }


  static void SaveUserToken(String token) {
     prefs.setString(PreferenceString.UserToken,token??"");
  }

  static int getUserId() {
    return prefs.getInt(PreferenceString.UserId)??0;
  }
  static String getUserFullName() {
    return prefs.getString(PreferenceString.UserFullName)??"";
  }
  static String getUserEmail() {
    return prefs.getString(PreferenceString.UserEmail)??"";
  }


  static void saveUserData(Map userDetails,String passwrod) {

    prefs.setString(PreferenceString.UserName,userDetails["username"]??"");
    prefs.setString(PreferenceString.UserFullName,userDetails["first_name"]??"");
    prefs.setString(PreferenceString.UserEmail,userDetails["email"]?? "");
    prefs.setString(PreferenceString.UserPassword,passwrod??"");
    prefs.setInt(PreferenceString.UserId,userDetails["id"]??0);
    prefs.setString(PreferenceString.UserUrl,userDetails["url"]??"");
    prefs.setString(PreferenceString.UserLink,userDetails["link"]??"");

  }



}
