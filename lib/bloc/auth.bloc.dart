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

  static void saveUserData(Map userDetails,String token,String passwrod) {

    prefs.setString(PreferenceString.UserName,userDetails["local"]["username"]??"");
    prefs.setString(PreferenceString.UserEmail,userDetails["local"]["email"] ?? "");
    prefs.setString(PreferenceString.UserPassword,passwrod??"");
    prefs.setBool(PreferenceString.IsVerfied,userDetails["isVerified"]);
    prefs.setBool(PreferenceString.Trial,userDetails["trial"]);
    prefs.setBool(PreferenceString.Cancel_at_period_end,userDetails["cancel_at_period_end"]);
    //prefs.setDouble(PreferenceString.UserDiscount,userDetails["discount"]);
    prefs.setString(PreferenceString.UserToken,token??"");
    prefs.setString(PreferenceString.UserPlan,userDetails["plan"]??"");
   // prefs.setDouble(PreferenceString.UserPlanCost,userDetails["planCost"]??0);
  }

}
