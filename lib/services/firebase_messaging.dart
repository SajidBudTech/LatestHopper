
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/home.bloc.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';
import 'package:flutter_hopper/views/appbarview/notification_page.dart';
import 'package:flutter_hopper/views/home/home_page.dart';
import 'package:flutter_hopper/views/home/main_home_page.dart';
import 'package:flutter_hopper/views/playing/playing_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_hopper/constants/api.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_strings.dart';
import 'package:flutter_hopper/services/http.service.dart';
import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AppNotification extends HttpService {
  static BuildContext buildContext;

  static setUpFirebaseMessaging() async {

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    var token=await _firebaseMessaging.getToken();
    print("FCM---TOKEN-------${token}");

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    var initializationSettingsAndroid = new AndroidInitializationSettings('@drawable/ic_notification');
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
      /*final String largeIconPath = await _downloadAndSaveFile(
          message.data['image'], 'largeIcon');
      final String bigPicturePath = await _downloadAndSaveFile(
          message.data['image'], 'bigPicture');*/
      AndroidNotificationDetails androidPlatformChannelSpecifics;
      if (Platform.isAndroid) {
        if (message.data['image']!=null) {
          final String largeIcon = await _base64encodedImage(
              message.data['image']);
          final String bigPicture = await _base64encodedImage(
              message.data['image']);
          BigPictureStyleInformation bigPictureStyleInformation =
              BigPictureStyleInformation(
                  ByteArrayAndroidBitmap.fromBase64String(bigPicture),
                  //Base64AndroidBitmap(bigPicture),
                  largeIcon: ByteArrayAndroidBitmap.fromBase64String(largeIcon),
                  contentTitle: message.notification.title,
                  htmlFormatContentTitle: true,
                  summaryText: message.notification.body,
                  htmlFormatSummaryText: true);

          androidPlatformChannelSpecifics = AndroidNotificationDetails(
              AppStrings.appName, //AppStrings.appName,
              AppStrings.appName,
              channelDescription: AppStrings.appName,
              importance: Importance.max,
              priority: Priority.high,
              enableLights: true,
              playSound: true,
              enableVibration: true,
              channelAction: AndroidNotificationChannelAction.createIfNotExists,
              styleInformation: bigPictureStyleInformation
          );
        }else{
          androidPlatformChannelSpecifics = AndroidNotificationDetails(
              AppStrings.appName, //AppStrings.appName,
              AppStrings.appName,
              channelDescription: AppStrings.appName,
              importance: Importance.max,
              priority: Priority.high,
              enableLights: true,
              playSound: true,
              enableVibration: true,
              channelAction: AndroidNotificationChannelAction.createIfNotExists,
          );
        }
      }

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

   /* FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      print("onMessageOpenedApp");
      //var _message = await FirebaseMessaging.instance.getInitialMessage();
      *//* if(event != null){
         if(event.data['post_id']!=null){
           HomeBloc.postID=event.data['post_id'].toInt();
           await Navigator.of(AudioConstant.navigatorKey.currentContext).push(MaterialPageRoute(builder: (context) => PlayingPage()));
         }else{
           await Navigator.of(AudioConstant.navigatorKey.currentContext).push(MaterialPageRoute(builder: (context) => NotificationPage()));
         }
       }*//*

      await Navigator.of(buildContext).push(MaterialPageRoute(builder: (context) => HomePage()));
    });*/

    // FirebaseMessaging.onBackgroundMessage(onBackgroundMessageHandler);


  }

  static Future<String> _base64encodedImage(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    final String base64Data = base64Encode(response.bodyBytes);
    return base64Data;
  }


  Future<void> _showBigPictureNotificationBase64() async {

    final String largeIcon =
    await _base64encodedImage('https://via.placeholder.com/48x48');
    final String bigPicture =
    await _base64encodedImage('https://via.placeholder.com/400x800');

    final BigPictureStyleInformation bigPictureStyleInformation =
    BigPictureStyleInformation(
        ByteArrayAndroidBitmap.fromBase64String(
            bigPicture), //Base64AndroidBitmap(bigPicture),
        largeIcon: ByteArrayAndroidBitmap.fromBase64String(largeIcon),
        contentTitle: 'overridden <b>big</b> content title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'big text channel id', 'big text channel name',
        channelDescription: 'big text channel description',
        styleInformation: bigPictureStyleInformation);
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
   // await flutterLocalNotificationsPlugin.show(
       // 0, 'big text title', 'silent body', platformChannelSpecifics);
  }

  static Future selectNotification(String payload) async {
    print("selectNotification");
    await Navigator.of(AudioConstant.navigatorKey.currentContext).push(MaterialPageRoute(builder: (context) => HomePage()));
  }


  /*static Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
    print("onBackgroundMessageHandler");

    await Firebase.initializeApp();


    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    //handling the notification process
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher

    var initializationSettingsAndroid = new AndroidInitializationSettings('drawable/ic_notification');
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

    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "post_notification",//AppStrings.appName,
      "post_notification",
      channelDescription: "post_notification",
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


    return Future.value();

  }*/


}
