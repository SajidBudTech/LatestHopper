import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/services/firebase_messaging.dart';
import 'package:flutter_hopper/utils/router.dart' as router;
import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:flutter_hopper/constants/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  await Firebase.initializeApp();
  //Initialize App Database
  //await AppDatabaseSingleton().prepareDatabase();
  //start notification listening
  AppNotification.setUpFirebaseMessaging();

  //initiating tellam
  /*Tellam.initialize(
     // Old https://flutter-projects-5ec90-ba266.firebaseio.com/
    // client firstore===https://console.firebase.google.com/u/3/project/allayurvedic-75fa8/firestore
    databaseUrl: "https://allayurvedic-75fa8-default-rtdb.firebaseio.com",
    uiconfiguration: UIConfiguration(
      accentColor: AppColor.accentColor,
      primaryColor: AppColor.primaryColor,
      primaryDarkColor: AppColor.primaryColorDark,
      buttonColor: AppColor.accentColor,
    ),
  );
*/
  //clear user records if any
  // await AppDatabaseSingleton.database.userDao.deleteAll();
  // await AppDatabaseSingleton.database.productDao.deleteAll();
  // await AppDatabaseSingleton.database.productExtraDao.deleteAll();

  // Set default home.

  //SharedPreferences.setMockInitialValues({});

  String _startRoute = AppRoutes.welcomeRoute;

  //check if user has signin before
  await AuthBloc.getPrefs();

  if (AuthBloc.firstTimeOnApp()) {
    AuthBloc.prefs.setBool(AppStrings.firstTimeOnApp, false);
  } else {
    //_startRoute = AppRoutes.homeRoute;
    if (AuthBloc.authenticated()) {
      _startRoute = AppRoutes.homeRoute;
    }else{
      _startRoute = AppRoutes.loginRoute;
    }

  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        onGenerateRoute: router.generateRoute,
        initialRoute: _startRoute,
        theme: ThemeData(
          accentColor: AppColor.accentColor,
          primaryColor: AppColor.primaryColor,
          primaryColorDark: AppColor.primaryColorDark,
          cursorColor: AppColor.cursorColor,
        ),
      ),

    );
  });
  // Run app!
 /* runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      onGenerateRoute: router.generateRoute,
      initialRoute: _startRoute,
      theme: ThemeData(
        accentColor: AppColor.accentColor,
        primaryColor: AppColor.primaryColor,
        primaryColorDark: AppColor.primaryColorDark,
        cursorColor: AppColor.cursorColor,
      ),
    ),
  );*/

}


/*class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Column(
       children: [

       ],
      )
    );
  }
}*/
