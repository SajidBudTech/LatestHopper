
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';
import 'package:flutter_hopper/views/appbarview/notification_page.dart';
import 'package:flutter_hopper/views/home/main_home_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_hopper/constants/api.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_strings.dart';
import 'package:flutter_hopper/services/http.service.dart';
import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppNotification extends HttpService {
  static BuildContext buildContext;

  static setUpFirebaseMessaging() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    //handling the notification process
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var token=await _firebaseMessaging.getToken();
    print("FCM-TOKEN,,,,,,${token}");

    var initializationSettingsAndroid = new AndroidInitializationSettings('ic_notification');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
    );
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    //Request for notification permission
    _firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
      criticalAlert: true,
      carPlay: true,
      announcement: true,
      provisional: true,
    );


    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        //Saving the notification
      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        AppStrings.appName,
        AppStrings.appName,
        importance: Importance.max,
        priority: Priority.high,
        enableLights: true,
        playSound: true,
        enableVibration: true,
        channelAction: AndroidNotificationChannelAction.createIfNotExists,
      );
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics
        );

        //
        await flutterLocalNotificationsPlugin.show(
          0,
          message.notification.title,
          message.notification.body,
          platformChannelSpecifics,
          payload: message.notification.title,
        );

    });

  }

  static Future selectNotification(String payload) async {

    await Navigator.of(AudioConstant.navigatorKey.currentContext).push(MaterialPageRoute(
        builder: (context) => NotificationPage()));

  }

  //
 /* //sending notification
  Future<void> sendNotificationToTopic({
    String title = "",
    String body = "",
    String topic,
  }) async {
    //
    final payload = {
      'notification': {
        'title': title,
        'body': body,
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "sound": "default",
        "status": "done",
      },
      'priority': 'high',
      'to': "/topics/$topic",
    };

    //
    await dio.post(
      Api.fcmServer,
      data: payload,
      options: Options(
        headers: {
          // 'content-type': 'application/json',
          'Authorization': 'key=${AppStrings.firebaseServerToken}',
        },
      ),
    );*/

    //
    // print("Response ==> ${result.data}");
  }
