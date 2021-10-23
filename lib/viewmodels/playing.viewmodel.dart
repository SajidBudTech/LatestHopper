// ViewModel
import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:flutter_hopper/bloc/home.bloc.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';
import 'package:flutter_hopper/constants/strings/general.strings.dart';
import 'package:flutter_hopper/models/audio_item.dart';
import 'package:flutter_hopper/models/dialog_data.dart';
import 'package:flutter_hopper/models/home_category.dart';
import 'package:flutter_hopper/models/home_post.dart';
import 'package:flutter_hopper/models/loading_state.dart';
import 'package:flutter_hopper/models/recenctly_viewed_post.dart';
import 'package:flutter_hopper/repositories/home.repository.dart';
import 'package:flutter_hopper/utils/custom_dialog.dart';
import 'package:flutter_hopper/viewmodels/base.viewmodel.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info/device_info.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_hopper/constants/app_strings.dart';


class PlayingViewModel extends MyBaseViewModel {

  HomePageRepository _homePageRepository= HomePageRepository();

  //
  LoadingState playingLoadingState = LoadingState.Loading;
  int listingStyle = 2;


  List<String> homeList=[];
  List<Hopper> myHopperList=[];
  HomePost playingData;

  bool _permissionReady=false;
  String _localPath;


  PlayingViewModel(BuildContext context) {
    this.viewContext = context;
    if(!AudioConstant.FROM_BOTTOM){
       AudioConstant.audioViewModel=this;
    }
  }

  void getPlayingDetails() async{
    //add null data so listener can show shimmer widget to indicate loading
    playingLoadingState = LoadingState.Loading;
    notifyListeners();
    try {

      if(HomeBloc.postID!=0){
         playingData = await _homePageRepository.getPostDetails(HomeBloc.postID);
         getMyHopperList();
         //initAudio();
      }
      //playingLoadingState = LoadingState.Done;
     // notifyListeners();
    } catch (error) {
      playingLoadingState = LoadingState.Failed;
      notifyListeners();
    }
  }

  void getMyHopperList() async{
    //add null data so listener can show shimmer widget to indicate loading
   // playingLoadingState = LoadingState.Loading;
   // notifyListeners();

    final int userId=AuthBloc.getUserId();

    try {

      myHopperList = await _homePageRepository.getMyHopperPost(userId);
      List<Hopper> toRemove=[];
      myHopperList.forEach((element) {
        if(element.post.iD==playingData.id){
           playingData.isAdded=true;
           toRemove.add(element);
        }
      });

      myHopperList.removeWhere( (e) => toRemove.contains(e));

      initAudio();
      //notifyListeners();
    } catch (error) {
      playingLoadingState = LoadingState.Failed;
      notifyListeners();
    }
  }


  // Playing part............

  AudioPlayer player;
  Duration currentPostion;
  Duration totalDuration;
  Duration bufferedDuration;
  String playerSpeed="1x";
  int currentPlayingIndex=0;
  int previousPlayingIndex=0;
  List<HomePost> myPlayList=[];
  List<AudioSource> allPlayingArticleList=[];
  ConcatenatingAudioSource concatenatingAudioSource;


 /* @override
  void dispose() {
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    player.dispose();
    super.dispose();
  }*/

 /* @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      player.stop();
    }
  }*/

   initAudio()async{
     if(!AudioConstant.FROM_BOTTOM){
        player=AudioPlayer();
       _init();
     }else{

       player=AudioConstant.audioViewModel.player;
       currentPostion=AudioConstant.audioViewModel.currentPostion;
       totalDuration=AudioConstant.audioViewModel.totalDuration;
       bufferedDuration=AudioConstant.audioViewModel.bufferedDuration;
       playerSpeed=AudioConstant.audioViewModel.playerSpeed;
       myPlayList=AudioConstant.audioViewModel.myPlayList;
       currentPlayingIndex=AudioConstant.audioViewModel.currentPlayingIndex;
       allPlayingArticleList=AudioConstant.audioViewModel.allPlayingArticleList;

       player.currentIndexStream.listen((currentIndex) {
         previousPlayingIndex=currentPlayingIndex;
         currentPlayingIndex=currentIndex;
         HomeBloc.postID=myPlayList[currentPlayingIndex].id;
         notifyListeners();
         addToRecentlyViewed();
       });

       playingLoadingState = LoadingState.Done;
       notifyListeners();

     }
   }

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
   // final session = await AudioSession.instance;
   // await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.

    //player.stop();

   /* player.positionStream.listen((event) {
        currentPostion=event;
    });*/

     player.playbackEventStream.listen((event) {
           currentPostion=event.updatePosition;
           bufferedDuration=event.bufferedPosition;
           totalDuration=event.duration;
        },
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    // Try to load audio from a source and catch any errors.
    try {

        /* AudioItem audioItem=AudioItem();
         audioItem.trackId=playingData.id;
         audioItem.audioSource=AudioSource.uri(Uri.parse(playingData.audioFile??""));
         audioItem.trackDescription=playingData.title.rendered??"";
         audioItem.trackImage=playingData.coverImageUrl??"";*/
         allPlayingArticleList.add(AudioSource.uri(Uri.parse(playingData.audioFile??"")));


         myPlayList.add(playingData);


         myHopperList.forEach((element) {
          /*AudioItem audioItem=AudioItem();
          audioItem.trackId=element.post.iD;
          audioItem.audioSource=AudioSource.uri(Uri.parse(element.postCustom.audioFile[0]??""));
          audioItem.trackDescription=element.post.postTitle??"";
          audioItem.trackImage=element.postCustom.coverImageUrl[0]??"";
          myPlayList.add(audioItem);*/
          allPlayingArticleList.add(AudioSource.uri(Uri.parse(element.postCustom.audioFile[0]??"")));

           HomePost _homePost=HomePost();
          _homePost.id=element.post.iD;
          _homePost.coverImageUrl=element.postCustom.coverImageUrl[0]??"";
          _homePost.author=element.postCustom.author[0]??"";
          _homePost.isAdded=true;
          _homePost.publication=element.postCustom.publication[0]??"";
          _homePost.publicationDate=element.postCustom.publicationDate[0]??"";
          _homePost.narrator=element.postCustom.narrator[0]??"";
          _homePost.audioFile=element.postCustom.audioFile[0]??"";
          _homePost.audioFileDuration=element.postCustom.audioFileDuration[0]??"";
          _homePost.title=Guid();
          _homePost.title.rendered=element.post.postTitle??"";
          _homePost.subHeader=element.postCustom.subHeader[0]??"";
          _homePost.postDescription=element.postCustom.postDescription[0]??"";
          _homePost.url=element.postCustom.url[0]??"";
           myPlayList.add(_homePost);

         });

         playingLoadingState = LoadingState.Done;
         notifyListeners();
         concatenatingAudioSource= await ConcatenatingAudioSource(
           // Start loading next item just before reaching it.
           useLazyPreparation: true, // default
           // Customise the shuffle algorithm.
           shuffleOrder: DefaultShuffleOrder(), // default
           // Specify the items in the playlist.
           children: allPlayingArticleList,
         );

        await player.setAudioSource(
          concatenatingAudioSource,
          // Playback will be prepared to start from track1.mp3
          initialIndex: currentPlayingIndex, // default
          // Playback will be prepared to start from position zero.
          initialPosition: Duration.zero, // default
        );
    } catch (e) {
      print("Error loading audio source: $e");
    }

    player.positionStream.listen((position) {
      currentPostion=position;
      //notifyListeners();
    });

     player.bufferedPositionStream.listen((buffered) {
      bufferedDuration=buffered;
    });

    player.currentIndexStream.listen((currentIndex) {
      previousPlayingIndex=currentPlayingIndex;
      currentPlayingIndex=currentIndex;
      HomeBloc.postID=myPlayList[currentPlayingIndex].id;
      notifyListeners();

      addToRecentlyViewed();
    });



     player.play();

  }


  seekAudio(Duration duration){
    player.seek(duration);
  }


  stopPlayerAfter(Duration duration){
    Future.delayed(duration, (){
       player.stop();
    });
    notifyListeners();
  }

  setupSpeed(double speed)async{
     if(speed==1.0){
       playerSpeed="1x";
     }else if(speed==1.25){
       playerSpeed="1.2x";
     }else if(speed==1.5){
       playerSpeed="1.5x";
     }
     notifyListeners();
     player.setSpeed(speed);
  }

  void addToDownload({int postId}) async {

    //update ui state
    final int userId = AuthBloc.getUserId();

    var dialogData = DialogData();
    dialogData.title = "Add To Download";
    dialogData.body = "Please wait.......";
    dialogData.dialogType = DialogType.loading;
    dialogData.isDismissible = false;

    //preparing data to be sent to server
    CustomDialog.showAlertDialog(viewContext, dialogData);
    // setUiState(UiState.loading);
    dialogData = await _homePageRepository.addToDownload(userId,postId);
    CustomDialog.dismissDialog(viewContext);
    //update ui state after operation
    // setUiState(UiState.done);
    //checking if operation was successful before either showing an error or redirect to home page
    if (dialogData.dialogType == DialogType.success) {

      downloadFile(playingData.audioFile);

    } else {
      //prepare the data model to be used to show the alert on the view
      dialogData.isDismissible = true;
      dialogData.dialogType = DialogType.failed;
      //notify the ui with the newly gotten dialogdata model
      CustomDialog.showAlertDialog(viewContext, dialogData,onDismissAction: (){
        CustomDialog.dismissDialog(viewContext);
      });

    }

  }

  void addToRecentlyViewed() async {

    //update ui state
    final int userId = AuthBloc.getUserId();

 /*   var dialogData = DialogData();
    dialogData.title = "Add To My Hopper";
    dialogData.body = "Please wait.......";
    dialogData.dialogType = DialogType.loading;
    dialogData.isDismissible = false;

    //preparing data to be sent to server
    CustomDialog.showAlertDialog(viewContext, dialogData);
    // setUiState(UiState.loading);*/
    final dialogData = await _homePageRepository.addRecenltyViewedPost(userId,myPlayList[previousPlayingIndex].id);
    //CustomDialog.dismissDialog(viewContext);
    //update ui state after operation
    // setUiState(UiState.done);
    //checking if operation was successful before either showing an error or redirect to home page
    if (dialogData.dialogType == DialogType.success) {

     /* dialogData.isDismissible = true;
      dialogData.dialogType = DialogType.success;
      //notify the ui with the newly gotten dialogdata model
      CustomDialog.showAlertDialog(viewContext, dialogData,onDismissAction: (){
        myHopperList.add(hopper);
        notifyListeners();
      });*/

    } else {
      //prepare the data model to be used to show the alert on the view
     /* dialogData.isDismissible = true;
      dialogData.dialogType = DialogType.failed;
      //notify the ui with the newly gotten dialogdata model
      CustomDialog.showAlertDialog(viewContext, dialogData,onDismissAction: (){
        CustomDialog.dismissDialog(viewContext);
      });*/

    }

  }

  downloadFile(String url)async{
    _permissionReady = await _checkPermission();

    if (_permissionReady) {
      await _prepareSaveDir();
    }

    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: _localPath,
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true,
      //saveInPublicStorage: true,// click on notification to open downloaded file (for Android)
    );

  }

  Future<bool> _checkPermission() async {
   /* DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (Platform.isAndroid && androidInfo.version.sdkInt <= 28) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;*/
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;

      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath());
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String> _findLocalPath() async {
    var externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath = (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

}


