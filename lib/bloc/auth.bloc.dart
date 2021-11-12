import 'dart:convert';

import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/constants/app_strings.dart';
import 'package:flutter_hopper/constants/strings/prefrence_key.string.dart';
import 'package:flutter_hopper/models/download_item.dart';
import 'package:flutter_hopper/models/home_post.dart';
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

  static bool isSleeperActive() {
    return prefs.getBool(AppStrings.isSleeperActive) ?? false;
  }

  static String getSleeperTime() {
    return prefs.getString(AppStrings.sleepTimerText) ?? "";
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
  static String getUserPassword() {
    return prefs.getString(PreferenceString.UserPassword)??"";
  }
  static void setUserPassword(String newpasword) {
    prefs.setString(PreferenceString.UserPassword,newpasword??"");
  }
  static void setUserFullName(String name){
    prefs.setString(PreferenceString.UserFullName,name??"");
  }

  static void setUserProfileImage(String name){
    prefs.setString(PreferenceString.UserProifleImage,name??"");
  }
  static String getUserProfileImage(){
    return prefs.getString(PreferenceString.UserProifleImage)??"";
  }

  static void setLoginDownloadUser(int userId){
    prefs.setInt(PreferenceString.DownloadLoginUser,userId);
  }
  static void getLoginDownloadUser(){
    prefs.getInt(PreferenceString.DownloadLoginUser)??0;
  }




  static void saveUserData(Map userDetails,String passwrod) {

    prefs.setString(PreferenceString.UserName,userDetails["username"]??"");
    prefs.setString(PreferenceString.UserFullName,userDetails["name"]??"");
    prefs.setString(PreferenceString.UserEmail,userDetails["email"]?? "");
    prefs.setString(PreferenceString.UserPassword,passwrod??"");
    prefs.setInt(PreferenceString.UserId,userDetails["id"]??0);
    prefs.setString(PreferenceString.UserUrl,userDetails["url"]??"");
    prefs.setString(PreferenceString.UserLink,userDetails["link"]??"");

  }

  static void addUserDownloadFile(HomePost post,String filePath) async{

    List<HomePost> downloadList=await getUserDownloadedFiles();
    if(downloadList==null){
      downloadList=[];
    }
    downloadList.add(post);

    saveUserDownloadedFiles(downloadList);
  }

  static List<HomePost> getUserDownloadedFiles(){
    String encoded=prefs.getString(PreferenceString.UserDownloadFilesMap)??"";
    List<HomePost> decodedList=[];
    if(encoded!=""){
      decodedList=decode(encoded);
    }
    return decodedList;
  }

  static void saveUserDownloadedFiles(List<HomePost> downloadList){
     String encodedMap = encode(downloadList);
     prefs.setString(PreferenceString.UserDownloadFilesMap,encodedMap);
  }

  static void removeUserDownloadedFiles(int postId){
    List<HomePost> myList= getUserDownloadedFiles();
    List<HomePost> toRemove = [];
    myList.forEach((element) {
      if (element.id == postId) {
        //myHopperList.remove(element);
        //notifyListeners();
        toRemove.add(element);
      }
    });

    myList.removeWhere((e) => toRemove.contains(e));
    saveUserDownloadedFiles(myList);
  }



  static String encode(List<HomePost> posts) => json.encode(
    posts.map<Map<String, dynamic>>((post) => HomePost.toJson(post)).toList(),
  );

  static List<HomePost> decode(String musics) => (json.decode(musics) as List<dynamic>).map<HomePost>((item) => HomePost.fromJson(item)).toList();



}
