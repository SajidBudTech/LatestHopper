import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';

class FileDownload{
  String url;
  String path;
  bool downloadStatus=false;
  Options options=Options(
    responseType: ResponseType.bytes,
  );
  Dio _dio=Dio();
  Function(int,int,bool) onReceiveProgress;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext context;


  FileDownload({ this.url,this.path,this.onReceiveProgress,this.context});

  Future<void> startDownload() async {

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@drawable/ic_notification');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: _onSelectNotification);


    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {


      final response = await _dio.download(
          url,
          path,
          onReceiveProgress: (downloaded,totalSize){
            if(downloaded==totalSize){
              downloadStatus=true;
            }
            onReceiveProgress(downloaded,totalSize,downloadStatus??false);
          },
          options: options,
          deleteOnError: true
      );

      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = path;

    } catch (ex) {
      result['error'] = ex.toString();
      throw ex;
    } finally {
      downloadStatus=true;
      await _showNotification(result);
    }
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'AUDIO_HOPPER_ID',
        'AUDIO_HOPPER_CHANNEL',
        priority: Priority.high,
        importance: Importance.max
    );
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess ? 'File has been downloaded successfully!' : 'There was an error while downloading the file.',
        platform,
        payload: json
    );
  }

  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

}