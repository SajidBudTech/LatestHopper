// ViewModel
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:audio_service/audio_service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:flutter_hopper/bloc/home.bloc.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';
import 'package:flutter_hopper/constants/strings/general.strings.dart';
import 'package:flutter_hopper/models/audio_item.dart';
import 'package:flutter_hopper/models/audio_player_state.dart';
import 'package:flutter_hopper/models/dialog_data.dart';
import 'package:flutter_hopper/models/home_category.dart';
import 'package:flutter_hopper/models/home_post.dart';
import 'package:flutter_hopper/models/loading_state.dart';
import 'package:flutter_hopper/models/recenctly_viewed_post.dart';
import 'package:flutter_hopper/repositories/home.repository.dart';
import 'package:flutter_hopper/utils/custom_dialog.dart';
import 'package:flutter_hopper/utils/file_download.dart';
import 'package:flutter_hopper/utils/flash_alert.dart';
import 'package:flutter_hopper/utils/other_utils.dart';
import 'package:flutter_hopper/viewmodels/base.viewmodel.dart';
import 'package:flutter_hopper/views/playing/hopper_handler.dart';
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

  DownloadingState downloadingState = DownloadingState.Pending;


  int listingStyle = 2;


  List<String> homeList=[];
  List<Hopper> myHopperList=[];
  HomePost playingData;
  List<MediaItem> allMediaItems=[];
  bool _permissionReady=false;
  String _localPath;
  bool startDownLoad=false;
  double totalDownLoad=1.0;
  double progressDownload=0.0;
  Dio dio=Dio();
  List<HomePost> savedDownLoad=[];
  bool offLine=false;
  FileDownload fileDownload;
  int userId;

  AudioHopperHandler audioHopperHandler;
  String playerSpeed="1x";
  int currentPlayingIndex=0;
  int previousPlayingIndex=0;
  List<HomePost> myPlayList=[];
  List<AudioSource> allPlayingArticleList=[];
  ConcatenatingAudioSource concatenatingAudioSource;


  PlayingViewModel(BuildContext context) {
    this.viewContext = context;
   /* if(!AudioConstant.FROM_BOTTOM){
       AudioConstant.audioViewModel=this;
    }*/
    getDownloads();
  }

  void getDownloads()async{
     userId=await AuthBloc.getUserId();
     List<HomePost> downloads=await AuthBloc.getUserDownloadedFiles();
     downloads.forEach((element) {
       if(element.userBy==userId){
           savedDownLoad.add(element);
        }
     });
  }

   _checkTimer()async{
     if(AudioConstant.isSleeperActive){
       var diff=AudioConstant.sleeperCloseTime.difference(DateTime.now()).inSeconds;
       Duration duration=Duration(seconds: diff);
       if(AudioConstant.sleeperActiveTime=="In 5 mins"){
         stopPlayerAfter(duration);
       }else if(AudioConstant.sleeperActiveTime=="In 15 mins"){
         stopPlayerAfter(duration);
       }else if(AudioConstant.sleeperActiveTime=="In 30 mins"){
         stopPlayerAfter(duration);
       }else if(AudioConstant.sleeperActiveTime=="In an hour"){
         stopPlayerAfter(duration);
       }else if(AudioConstant.sleeperActiveTime=="When current article ends"){
         if(audioHopperHandler.totalDuration!=null) {
           stopPlayerAfter(Duration(seconds:audioHopperHandler.totalDuration.inSeconds - audioHopperHandler.currentPosition.inSeconds));
         }
       }
     }
  }

  void getPlayingDetails() async {
    //add null data so listener can show shimmer widget to indicate loading
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      playingLoadingState = LoadingState.Loading;
      notifyListeners();
      try {
        if (HomeBloc.postID != 0) {
          playingData =
          await _homePageRepository.getPostDetails(HomeBloc.postID);
          getMyHopperList();
          //initAudio();
        }
        //playingLoadingState = LoadingState.Done;
        // notifyListeners();
      } catch (error) {
        playingLoadingState = LoadingState.Failed;
        notifyListeners();
      }
    } else{
       playingLoadingState = LoadingState.NoIntenet;
       notifyListeners();
    }
  }

  void getMyHopperList() async{
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

      savedDownLoad.forEach((element) {
        if(element.id==playingData.id){
          downloadingState=DownloadingState.Completed;
        }
      });

      initAudio();
      //notifyListeners();
    } catch (error) {
      playingLoadingState = LoadingState.Failed;
      notifyListeners();
    }
  }

  void getOffLinePlayer(){

    playingLoadingState = LoadingState.Loading;
    notifyListeners();

    downloadingState=DownloadingState.Completed;
    startDownLoad=false;
    playingData=AudioConstant.HOMEPOST;
    initOffLineAudio();

  }

   initOffLineAudio()async{


     if(AudioConstant.OFFLINECHANGE) {

       if(AudioConstant.audioViewModel!=null){

         if(AudioConstant.audioIsPlaying){
           await AudioConstant.audioViewModel.audioHopperHandler.stop();
         }

         for(int i=0;i<AudioConstant.audioViewModel.allMediaItems.length;i++){
           await AudioConstant.audioViewModel.audioHopperHandler.removeQueueItem(AudioConstant.audioViewModel.allMediaItems[i]);
           AudioConstant.audioViewModel.audioHopperHandler.removePlaylist(0);
         }
         AudioConstant.audioViewModel.audioHopperHandler.currentPosition=Duration.zero;
         AudioConstant.audioViewModel.audioHopperHandler.totalDuration=Duration.zero;
         audioHopperHandler=AudioConstant.audioViewModel.audioHopperHandler;
         audioHopperHandler.currentPosition=Duration.zero;
         audioHopperHandler.totalDuration=Duration.zero;

       }else{
         audioHopperHandler= await AudioService.init(
           builder: () => AudioHopperHandler(),
           config: AudioServiceConfig(
               androidNotificationChannelId: 'com.application.audiohopper',
               androidNotificationChannelName: 'Audio Hopper Service',
               androidNotificationOngoing: true,
               androidStopForegroundOnPause: true,
               androidNotificationIcon: "@drawable/ic_notification",
               notificationColor:Color(0xFF008080)
           ),
         );
       }
       // Try to load audio from a source and catch any errors.
       try {

         allPlayingArticleList.clear();
         myPlayList.clear();
         allMediaItems.clear();
         allPlayingArticleList.add(AudioSource.uri(Uri.parse(playingData.audioFile ?? "")));
         myPlayList.add(playingData);
         MediaItem mediaItem=MediaItem(id:playingData.localFilePath,album: playingData.publication,title: playingData.publication??"",artist: playingData.title.rendered??""/*,duration: Duration(milliseconds: element.dURATION)*/,artUri: Uri.parse(playingData.coverImageUrl??""),extras: {'local': true});
         allMediaItems.add(mediaItem);
         await audioHopperHandler.addQueueItems(allMediaItems);
         //await audioHopperHandler.player.setFilePath(playingData.localFilePath);
         /*var time=myPlayList[0].audioFileDuration.split(":");
         var total=Duration.zero;
         if(time.length==1){
           total=Duration(seconds: int.tryParse(time[0])??0);
         }else if(time.length==2){
           total=Duration(minutes: int.tryParse(time[0])??0,seconds: int.tryParse(time[1])??0);
         }else if(time.length==3){
           total=Duration(hours: int.tryParse(time[0])??0,minutes: int.tryParse(time[1])??0,seconds: int.tryParse(time[1])??0);
         }

         audioHopperHandler.totalDuration=total;*/

       } catch (e) {
         print("Error loading audio source: $e");
       }



       currentPlayingIndex=0;
       previousPlayingIndex=0;


       await audioHopperHandler.player.seek(audioHopperHandler.currentPosition,index: currentPlayingIndex);

       playingLoadingState = LoadingState.Done;
       notifyListeners();

       audioHopperHandler.player.playbackEventStream.listen((event) {
        // audioHopperHandler.currentPosition = event.updatePosition;
          audioHopperHandler.totalDuration = event.duration;

         },
           onError: (Object e, StackTrace stackTrace) {
             print('A stream error occurred: $e');
           });

      /* audioHopperHandler.player.positionStream.listen((position) {
         audioHopperHandler.currentPosition = position;
         //notifyListeners();
       });*/

        if(!audioHopperHandler.player.playing){
          await audioHopperHandler.play();
        }

     }else{

       audioHopperHandler=AudioConstant.audioViewModel.audioHopperHandler;

       audioHopperHandler.currentPosition=AudioConstant.audioViewModel.audioHopperHandler.currentPosition;
       audioHopperHandler.totalDuration=AudioConstant.audioViewModel.audioHopperHandler.totalDuration;
       //bufferedDuration=AudioConstant.audioViewModel.bufferedDuration;
       playerSpeed=AudioConstant.audioViewModel.playerSpeed;
       _localPath=AudioConstant.audioViewModel._localPath;
       userId=AudioConstant.audioViewModel.userId;
       currentPlayingIndex=AudioConstant.audioViewModel.currentPlayingIndex;
       allPlayingArticleList=AudioConstant.audioViewModel.allPlayingArticleList;
       myPlayList=AudioConstant.audioViewModel.myPlayList;



       /*audioHopperHandler.player.positionStream.listen((position) {
         audioHopperHandler.currentPosition = position;
         //notifyListeners();
       });*/

       /*player.bufferedPositionStream.listen((buffered) {
         bufferedDuration = buffered;
       });*/

       if(!audioHopperHandler.player.playing){
         await audioHopperHandler.play();
       }

       playingLoadingState = LoadingState.Done;
       notifyListeners();

     }

     _checkTimer();
     AudioConstant.audioIsPlaying=true;
     AudioConstant.audioViewModel=this;

   }


  // Playing part............

  /*AudioPlayer player;
  Duration currentPostion;
  Duration totalDuration;
  Duration bufferedDuration;*/



   initAudio()async {
     if (!AudioConstant.FROM_BOTTOM) {
       //player=AudioPlayer();
       if(AudioConstant.audioViewModel==null) {
         _init();
       }else{
         AudioConstant.audioViewModel.audioHopperHandler.currentPosition=Duration.zero;
         AudioConstant.audioViewModel.audioHopperHandler.totalDuration=Duration.zero;
         _secondTimeCall();
       }
     } else {
       _secondTimeCall();
     }
   }

   void  _secondTimeCall() async{

     if(AudioConstant.audioIsPlaying){
       await AudioConstant.audioViewModel.audioHopperHandler.stop();
     }

     allPlayingArticleList.clear();
     myPlayList.clear();
     allMediaItems.clear();

     allPlayingArticleList.add(AudioSource.uri(Uri.parse(playingData.audioFile??"")));
     myPlayList.add(playingData);
     MediaItem mediaItem=MediaItem(id: playingData.audioFile??"",album: playingData.publication,title: playingData.publication??"",artist: playingData.title.rendered??""/*,duration: Duration(milliseconds: element.dURATION)*/,artUri: Uri.parse(playingData.coverImageUrl??""));
     allMediaItems.add(mediaItem);

     myHopperList.forEach((element) {

       MediaItem mediaItem=MediaItem(id: element.postCustom.audioFile[0]??"",album: element.postCustom.publication[0],title: element.postCustom.publication[0]??"",artist: element.post.postTitle??""/*,duration: Duration(milliseconds: element.dURATION)*/,artUri: Uri.parse(element.postCustom.coverImageUrl[0]??""));
       allMediaItems.add(mediaItem);

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


     for(int i=0;i<AudioConstant.audioViewModel.allMediaItems.length;i++){
       /*if(AudioConstant.audioViewModel.concatenatingAudioSource!=null) {
           AudioConstant.audioViewModel.concatenatingAudioSource.removeAt(i);
         }*/
       await AudioConstant.audioViewModel.audioHopperHandler.removeQueueItem(AudioConstant.audioViewModel.allMediaItems[i]);
       AudioConstant.audioViewModel.audioHopperHandler.removePlaylist(0);


     }

     /*for(int i=1;i<allPlayingArticleList.length;i++){
         if(AudioConstant.audioViewModel.concatenatingAudioSource!=null) {
           AudioConstant.audioViewModel.concatenatingAudioSource.insert(i, allPlayingArticleList[i]);
         }
       }*/

     audioHopperHandler=AudioConstant.audioViewModel.audioHopperHandler;
     audioHopperHandler.currentPosition=AudioConstant.audioViewModel.audioHopperHandler.currentPosition;
     audioHopperHandler.totalDuration=AudioConstant.audioViewModel.audioHopperHandler.totalDuration;


     //audioHopperHandler.player=AudioConstant.audioViewModel.audioHopperHandler.player;
     await audioHopperHandler.addQueueItems(allMediaItems);

     currentPlayingIndex=0;
     previousPlayingIndex=0;

    /* var time=myPlayList[0].audioFileDuration.split(":");
     var total=Duration.zero;
     if(time.length==1){
       total=Duration(seconds: int.tryParse(time[0])??0);
     }else if(time.length==2){
       total=Duration(minutes: int.tryParse(time[0])??0,seconds: int.tryParse(time[1])??0);
     }else if(time.length==3){
       total=Duration(hours: int.tryParse(time[0])??0,minutes: int.tryParse(time[1])??0,seconds: int.tryParse(time[1])??0);
     }

     audioHopperHandler.totalDuration=total;*/


     await audioHopperHandler.player.seek(audioHopperHandler.currentPosition,index: currentPlayingIndex);




     // bufferedDuration=AudioConstant.audioViewModel.bufferedDuration;
     playerSpeed=AudioConstant.audioViewModel.playerSpeed;
     if(myPlayList[currentPlayingIndex].id==AudioConstant.audioViewModel.myPlayList[AudioConstant.audioViewModel.currentPlayingIndex].id) {
       _localPath=AudioConstant.audioViewModel._localPath;
       startDownLoad = AudioConstant.audioViewModel.startDownLoad;
       downloadingState = AudioConstant.audioViewModel.downloadingState;
       totalDownLoad = AudioConstant.audioViewModel.totalDownLoad;
       progressDownload = AudioConstant.audioViewModel.progressDownload;
       dio = AudioConstant.audioViewModel.dio;
       fileDownload = AudioConstant.audioViewModel.fileDownload;
     }


     offLine=AudioConstant.audioViewModel.offLine;


     /* audioHopperHandler.player.playbackEventStream.listen((event) {
             audioHopperHandler.currentPosition=event.updatePosition;
             audioHopperHandler.totalDuration=event.duration;
           },
           onError: (Object e, StackTrace stackTrace) {
             print('A stream error occurred: $e');
           });*/

     /* player.positionStream.listen((position) {
         currentPostion=position;
       });

       player.bufferedPositionStream.listen((buffered) {
         bufferedDuration=buffered;
       });*/

     if(!audioHopperHandler.player.playing){
       await audioHopperHandler.play();
     }

     // AudioConstant.audioIsPlaying=true;

     /*if(!audioHopperHandler.player.playing){
       await audioHopperHandler.play();
     }*/

     playingLoadingState = LoadingState.Done;
     notifyListeners();


     if(fileDownload!=null) {
       try {
         fileDownload.onReceiveProgress = DownloadRecevier;
       } catch (e) {
         ShowFlash(viewContext,
             title: "Error in file downloading...",
             message: "please try again",
             flashType: FlashType.failed)
             .show();
         startDownLoad = false;
         notifyListeners();
       }
     }

     /*audioHopperHandler.player.playbackEventStream.listen((playbackEvent) {
       if(playbackEvent.currentIndex!=null) {
         if (playbackEvent.currentIndex < myPlayList.length) {
           print("CURRENT INDEX-----------${playbackEvent.currentIndex}");
           previousPlayingIndex = currentPlayingIndex;
           currentPlayingIndex = playbackEvent.currentIndex;
           HomeBloc.postID = myPlayList[currentPlayingIndex].id;
           notifyListeners();
           addToRecentlyViewed();
         }
       }
     });*/

       audioHopperHandler.player.currentIndexStream.listen((currentIndex) {
         if(currentIndex < myPlayList.length) {
           //currentIndex--;
           print("CURRENT INDEX-----------${currentIndex}");
           previousPlayingIndex = currentPlayingIndex;
           currentPlayingIndex = currentIndex;
           HomeBloc.postID = myPlayList[currentPlayingIndex].id;
           notifyListeners();
           addToRecentlyViewed();
         }
       });

     _checkTimer();
     AudioConstant.audioViewModel=this;
     print("TOTAL Lenght........."+myPlayList.length.toString());

   }


  Future<void> _init() async {

    // Try to load audio from a source and catch any errors.
    try {

        audioHopperHandler= await AudioService.init(
        builder: () => AudioHopperHandler(),
        config: AudioServiceConfig(
            androidNotificationChannelId: 'com.application.audiohopper',
            androidNotificationChannelName: 'Audio Hopper Service',
            androidNotificationOngoing: true,
            androidStopForegroundOnPause: true,
            androidNotificationIcon: "drawable/ic_notification",
            notificationColor:Color(0xFF008080)
        ),
       );

         allPlayingArticleList.clear();
         myPlayList.clear();
         allMediaItems.clear();
         allPlayingArticleList.add(AudioSource.uri(Uri.parse(playingData.audioFile??"")));
         myPlayList.add(playingData);
         MediaItem mediaItem=MediaItem(id: playingData.audioFile??"",album: playingData.publication,title: playingData.publication??"",artist: playingData.title.rendered??""/*,duration: Duration(milliseconds: element.dURATION)*/,artUri: Uri.parse(playingData.coverImageUrl??""));
         allMediaItems.add(mediaItem);


        myHopperList.forEach((element) {
          /*AudioItem audioItem=AudioItem();
          audioItem.trackId=element.post.iD;
          audioItem.audioSource=AudioSource.uri(Uri.parse(element.postCustom.audioFile[0]??""));
          audioItem.trackDescription=element.post.postTitle??"";
          audioItem.trackImage=element.postCustom.coverImageUrl[0]??"";
          myPlayList.add(audioItem);*/
          MediaItem mediaItem=MediaItem(id: element.postCustom.audioFile[0]??"",album: element.postCustom.publication[0],title: element.postCustom.publication[0]??"",artist: element.post.postTitle??""/*,duration: Duration(milliseconds: element.dURATION)*/,artUri: Uri.parse(element.postCustom.coverImageUrl[0]??""));
          allMediaItems.add(mediaItem);

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

        await audioHopperHandler.addQueueItems(allMediaItems);

    } catch (e) {
      print("Error loading audio source: $e");
    }

    playingLoadingState = LoadingState.Done;
    notifyListeners();


   /* player.positionStream.listen((position) {
      currentPostion=position;
      //notifyListeners();
    });

     player.bufferedPositionStream.listen((buffered) {
      bufferedDuration=buffered;
    });*/

    /*audioHopperHandler.player.playbackEventStream.listen((event) {
      audioHopperHandler.currentPosition=event.updatePosition;
           //bufferedDuration=event.bufferedPosition;
      audioHopperHandler.totalDuration=event.duration;
        },
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });*/

    audioHopperHandler.player.playbackEventStream.listen((event) {
        // audioHopperHandler.currentPosition=event.updatePosition;
         audioHopperHandler.totalDuration=event.duration;
        // print("FIRST CURRENT INDEX-----------${currentPlayingIndex}");
         //notifyListeners();
        },
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });

    audioHopperHandler.player.currentIndexStream.listen((currentIndex) {
         if(currentIndex!=null) {
           if (currentIndex < myPlayList.length) {
             print("FIRST CURRENT INDEX-----------${currentIndex}");
             previousPlayingIndex = currentPlayingIndex;
             currentPlayingIndex = currentIndex;
             HomeBloc.postID = myPlayList[currentPlayingIndex].id;
             notifyListeners();
             addToRecentlyViewed();
           }
         }
    });



     if(!audioHopperHandler.player.playing){
       await audioHopperHandler.play();
     }

    AudioConstant.audioViewModel=this;
     //AudioConstant.audioIsPlaying=true;
    /* Future.delayed(Duration(seconds: 2), (){
       _checkTimer();
     });*/
  }


  /*seekAudio(Duration duration){
    player.seek(duration);
  }*/


  stopPlayerAfter(Duration duration){

   if(duration!=Duration.zero) {
     Future.delayed(duration, () {
       if (AudioConstant.isSleeperActive) {
         audioHopperHandler.player.stop();
         AudioConstant.isSleeperActive = false;
         AudioConstant.sleeperActiveTime = "";
         AudioConstant.sleeperCloseTime = null;
         //AuthBloc.prefs.setString(AppStrings.sleepTimerText, "");
         //AuthBloc.prefs.setBool(AppStrings.isSleeperActive, false);
         notifyListeners();
       }
     });
   }
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
     audioHopperHandler.player.setSpeed(speed);
  }

  void addToDownload({int postId}) async {

    //update ui state

    bool check=false;
    savedDownLoad.forEach((key) {
      if(playingData.id==key.id){
        check=true;
      }
    });

    if(!check) {

      final int userId = AuthBloc.getUserId();

      var dialogData = DialogData();
      dialogData.title = "Add To Download";
      dialogData.body = "Please wait.......";
      dialogData.dialogType = DialogType.loading;
      dialogData.isDismissible = false;

      //preparing data to be sent to server
      CustomDialog.showAlertDialog(viewContext, dialogData);
      // setUiState(UiState.loading);
      dialogData = await _homePageRepository.addToDownload(userId, postId);
      CustomDialog.dismissDialog(viewContext);
      //update ui state after operation
      // setUiState(UiState.done);
      //checking if operation was successful before either showing an error or redirect to home page
      if (dialogData.dialogType == DialogType.success) {
        downloadFile(playingData.audioFile,userId);
      } else {
        //prepare the data model to be used to show the alert on the view
        dialogData.isDismissible = true;
        dialogData.dialogType = DialogType.failed;
        //notify the ui with the newly gotten dialogdata model
        CustomDialog.showAlertDialog(
            viewContext, dialogData, onDismissAction: () {
          CustomDialog.dismissDialog(viewContext);
        });
      }
    }else{
      ShowFlash(viewContext,
          title: "Already added in Download",
          message: "Please try with some other articles.",
          flashType: FlashType.failed)
          .show();
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

  downloadFile(String url, int userId)async{
    _permissionReady = await _checkPermission();

    if (_permissionReady) {
      await _prepareSaveDir();
    }
    startDownLoad=true;
    downloadingState=DownloadingState.Started;
    notifyListeners();

    String fileName=url.split("/").last;
    //_localPath=_localPath+"/"+fileName;
    File saveFile=File(_localPath+"/"+fileName);
    try {


       fileDownload=FileDownload(context: viewContext,url: url,path: saveFile.path,onReceiveProgress:DownloadRecevier);
       await fileDownload.startDownload();
       /*await dio.downloadUri(Uri.parse(url), saveFile.path,
              onReceiveProgress: (downloaded, totalSize) {

            progressDownload = downloaded / totalSize;
            if (downloaded == totalSize) {
              startDownLoad = false;
            }

            notifyListeners();

          });*/


       playingData.localFilePath=saveFile.path;
       playingData.userBy=userId;
       await AuthBloc.addUserDownloadFile(playingData,saveFile.path);


    }catch(e){
      ShowFlash(viewContext,
          title: "Error in file downloading...",
          message: "please try again",
          flashType: FlashType.failed)
          .show();


      startDownLoad = false;
      downloadingState=DownloadingState.Pending;
      notifyListeners();

    }



    /*final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: _localPath,
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true,
      //saveInPublicStorage: true,// click on notification to open downloaded file (for Android)
    );*/

  }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {

      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      final storageStatus = await Permission.storage.status;


      final accessStatus = androidInfo.version.sdkInt >= 30?await Permission.accessMediaLocation.status:true;
      final manageStatus = androidInfo.version.sdkInt >= 30?await Permission.manageExternalStorage.status:true;


      if (storageStatus != PermissionStatus.granted && accessStatus!=PermissionStatus.granted && manageStatus!=PermissionStatus.granted) {
        final result = await Permission.storage.request();
        final result2 = androidInfo.version.sdkInt >= 30?await Permission.accessMediaLocation.request():PermissionStatus.granted;
        final result3 = androidInfo.version.sdkInt >= 30?await Permission.manageExternalStorage.request():PermissionStatus.granted;

        if (result == PermissionStatus.granted && result2 == PermissionStatus.granted && result3 == PermissionStatus.granted) {
          return true;
        }

      } else {
        return true;
      }
    } else if(Platform.isIOS){
      /*final status = await Permission.photos.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.photos.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }*/
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath());
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create(recursive: true);
    }
  }

  Future<String> _findLocalPath() async {
    var externalStorageDirPath;
    Directory directory;
    if (Platform.isAndroid) {
      /*try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }*/

      directory = await getExternalStorageDirectory();
      String newPath="";
      List<String> folders=directory.path.split("/");
      for(int i=1;i<folders.length;i++){
        String folder=folders[i];
        if(folder!="Android"){
          newPath+="/"+folder;
        }else{
          break;
        }
      }

      newPath=newPath+"/AudioHopperApp";
      directory=Directory(newPath);


    } else if (Platform.isIOS) {
       directory = await getTemporaryDirectory();
       //directory=await getApplicationDocumentsDirectory();
       //externalStorageDirPath = (await getApplicationDocumentsDirectory()).absolute.path;
    }

    externalStorageDirPath=directory.path;
    return externalStorageDirPath;

  }


  void DownloadRecevier(int downloaded,int totalSize,bool status){
    progressDownload = downloaded / totalSize;
    if (status) {
      startDownLoad = false;
      downloadingState=DownloadingState.Completed;
    }
    notifyListeners();
  }

}



