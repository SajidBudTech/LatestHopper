// ViewModel
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/home.bloc.dart';
import 'dart:io';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';
import 'package:flutter_hopper/constants/strings/general.strings.dart';
import 'package:flutter_hopper/models/home_post.dart';
import 'package:flutter_hopper/models/loading_state.dart';
import 'package:flutter_hopper/repositories/home.repository.dart';
import 'package:flutter_hopper/utils/flash_alert.dart';
import 'package:flutter_hopper/viewmodels/base.viewmodel.dart';
import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:flutter_hopper/models/recenctly_viewed_post.dart';
import 'package:flutter_hopper/utils/custom_dialog.dart';
import 'package:flutter_hopper/models/dialog_data.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class HopperViewModel extends MyBaseViewModel {
  HomePageRepository homePageRepository = HomePageRepository();

  //

  LoadingState myHopperLoadingState = LoadingState.Loading;
  LoadingState recentlyViewedLoadingState = LoadingState.Loading;
  LoadingState downloadLoadingState = LoadingState.Loading;

  List<Hopper> myHopperList = [];
  List<Hopper> recentlyViewedList = [];
  List<Hopper> downloadedList = [];
  List<String> hooperList = [];
  bool _permissionReady = false;
  String _localPath="";
  bool startDownLoad=false;
  double totalDownLoad=1.0;
  double progressDownload=0.0;
  Dio dio=Dio();
  List<HomePost> savedDownLoads=[];
  int userId;

  HopperViewModel(BuildContext context) {
    this.viewContext = context;
  }

  initialise() async {

    getMyHopperList();
    getRecentlyViewedList();
    getDownloadList();
    // getDummyList();
  }

  /*void getBookDetails({int iSBN,String serachID}) async{
    //add null data so listener can show shimmer widget to indicate loading
    bookDetailsLoadingState = LoadingState.Loading;
    notifyListeners();

    try {
      bookData = await _homePageRepository.getBookDetails(iSBN,serachID);
      bookDetailsLoadingState = LoadingState.Done;
      notifyListeners();
    } catch (error) {
      bookDetailsLoadingState = LoadingState.Failed;
      notifyListeners();
    }
  }*/

  getMyHopperList() async {
    myHopperLoadingState = LoadingState.Loading;
    notifyListeners();

    final int userId = AuthBloc.getUserId();
    try {
      myHopperList = await homePageRepository.getMyHopperPost(userId);
      myHopperLoadingState = LoadingState.Done;
      notifyListeners();
    } catch (error) {
      myHopperLoadingState = LoadingState.Failed;
      notifyListeners();
    }
  }

  getRecentlyViewedList() async {
    recentlyViewedLoadingState = LoadingState.Loading;
    notifyListeners();

    final int userId = AuthBloc.getUserId();
    try {
      recentlyViewedList =
          await homePageRepository.getRecenltyViewedPost(userId);
      recentlyViewedLoadingState = LoadingState.Done;
      notifyListeners();
    } catch (error) {
      recentlyViewedLoadingState = LoadingState.Failed;
      notifyListeners();
    }
  }

  void notify(){
    notifyListeners();
  }
  getDownloadList() async {
    downloadLoadingState = LoadingState.Loading;
    notifyListeners();

    userId=await AuthBloc.getUserId();

    List<HomePost> downloads= await AuthBloc.getUserDownloadedFiles();
    downloads.forEach((key) {
      if(key.userBy==userId) {

        savedDownLoads.add(key);

        Hopper hopper = Hopper();
        hopper.post = Post();
        hopper.post.iD = key.id;
        hopper.post.postTitle = key.title.rendered;
        hopper.postCustom = PostCustom();
        hopper.postCustom.subHeader = [];
        hopper.postCustom.subHeader.add(key.subHeader);
        hopper.postCustom.author = [];
        hopper.postCustom.author.add(key.author);
        hopper.postCustom.narrator = [];
        hopper.postCustom.narrator.add(key.narrator);
        hopper.postCustom.publication = [];
        hopper.postCustom.publication.add(key.publication);
        hopper.postCustom.publicationDate = [];
        hopper.postCustom.publicationDate.add(key.publicationDate);
        hopper.postCustom.url = [];
        hopper.postCustom.url.add(key.url);
        hopper.postCustom.audioFile = [];
        hopper.postCustom.audioFile.add(key.audioFile);
        hopper.postCustom.audioFileDuration = [];
        hopper.postCustom.audioFileDuration.add(key.audioFileDuration);
        hopper.postCustom.postDescription = [];
        hopper.postCustom.postDescription.add(key.postDescription);
        hopper.postCustom.coverImageUrl = [];
        hopper.postCustom.coverImageUrl.add(key.coverImageUrl);
        hopper.postCustom.postReadedBy = [];


        downloadedList.add(hopper);

      }

    });

    downloadLoadingState = LoadingState.Done;
    notifyListeners();

   /* final int userId = AuthBloc.getUserId();
    try {
      downloadedList = await homePageRepository.getDownloadList(userId);
      downloadLoadingState = LoadingState.Done;
      notifyListeners();
    } catch (error) {
      downloadLoadingState = LoadingState.Failed;
      notifyListeners();
    }*/


  }

  void addToMyHooperList(HomePost homePost) async {
    if (myHopperList == null) {
      myHopperList = [];
    }

    Hopper hopper = Hopper();
    hopper.post.postTitle = homePost.title.rendered ?? "";
    hopper.postCustom.postDescription.add(homePost.postDescription ?? "");
    hopper.postCustom.publicationDate.add(homePost.publicationDate ?? "");
    hopper.postCustom.coverImageUrl.add(homePost.coverImageUrl ?? "");
    hopper.postCustom.audioFile.add(homePost.audioFile);
    hopper.postCustom.audioFileDuration.add(homePost.audioFileDuration);

    myHopperList.add(hopper);
    notifyListeners();
  }

  void addToMyHooper({int postId, Hopper hopper}) async {
    //update ui state
    final int userId = AuthBloc.getUserId();

    var dialogData = DialogData();
    dialogData.title = "Add To My Hopper";
    dialogData.body = "Please wait.......";
    dialogData.dialogType = DialogType.loading;
    dialogData.isDismissible = false;

    //preparing data to be sent to server
    CustomDialog.showAlertDialog(viewContext, dialogData);
    // setUiState(UiState.loading);
    dialogData = await homePageRepository.addToMyHooper(userId, postId);
    CustomDialog.dismissDialog(viewContext);
    //update ui state after operation
    // setUiState(UiState.done);
    //checking if operation was successful before either showing an error or redirect to home page
    if (dialogData.dialogType == DialogType.success) {
      dialogData.isDismissible = true;
      dialogData.dialogType = DialogType.success;
      //notify the ui with the newly gotten dialogdata model

      if (AudioConstant.audioViewModel != null) {
        bool check=false;
        AudioConstant.audioViewModel.myPlayList.forEach((element) {
          if (element.id == postId) {
             check=true;
          }
        });
        if(!check){
           HomePost _homePost=HomePost();
          _homePost.id=hopper.post.iD;
          _homePost.coverImageUrl=hopper.postCustom.coverImageUrl[0]??"";
          _homePost.author=hopper.postCustom.author[0]??"";
          _homePost.isAdded=true;
          _homePost.publication=hopper.postCustom.publication[0]??"";
          _homePost.publicationDate=hopper.postCustom.publicationDate[0]??"";
          _homePost.narrator=hopper.postCustom.narrator[0]??"";
           _homePost.audioFile=hopper.postCustom.audioFile[0]??"";
          _homePost.audioFileDuration=hopper.postCustom.audioFileDuration[0]??"";
          _homePost.title=Guid();
          _homePost.title.rendered=hopper.post.postTitle??"";
          _homePost.subHeader=hopper.postCustom.subHeader[0]??"";
          _homePost.postDescription=hopper.postCustom.postDescription[0]??"";
          _homePost.url=hopper.postCustom.url[0]??"";
           AudioConstant.audioViewModel.myPlayList.add(_homePost);
           AudioConstant.audioViewModel.concatenatingAudioSource.insert(AudioConstant.audioViewModel.myPlayList.length-1, AudioSource.uri(Uri.parse(_homePost.audioFile??"")));
        }


        notifyListeners();

      }

      CustomDialog.showAlertDialog(viewContext, dialogData,
          onDismissAction: () {
          myHopperList.add(hopper);
          notifyListeners();
      });

      Future.delayed(const Duration(milliseconds: 1500), () {
        CustomDialog.dismissDialog(viewContext);
      });

    } else {
      //prepare the data model to be used to show the alert on the view
      dialogData.isDismissible = true;
      dialogData.dialogType = DialogType.failed;
      //notify the ui with the newly gotten dialogdata model
      CustomDialog.showAlertDialog(viewContext, dialogData,
          onDismissAction: () {
        CustomDialog.dismissDialog(viewContext);
      });
      Future.delayed(const Duration(milliseconds: 1500), () {
        CustomDialog.dismissDialog(viewContext);
      });
    }
  }

  void addToDownload({int postId, Hopper hopper}) async {
    //update ui state
    bool check=false;
    savedDownLoads.forEach((key) {
      if(postId==key.id){
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
      dialogData = await homePageRepository.addToDownload(userId, postId);
      CustomDialog.dismissDialog(viewContext);
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
        //downloadFile(hopper.postCustom.audioFile[0] ?? "",hopper);
        downloadedList.add(hopper);
        notifyListeners();
      } else {
        //prepare the data model to be used to show the alert on the view
        dialogData.isDismissible = true;
        dialogData.dialogType = DialogType.failed;
        //notify the ui with the newly gotten dialogdata model
        CustomDialog.showAlertDialog(viewContext, dialogData,
            onDismissAction: () {
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

  void removeFromMyHopper({int postId}) async {
    //update ui state
    final int userId = AuthBloc.getUserId();

    var dialogData = DialogData();
    dialogData.title = "Remove From My Hopper";
    dialogData.body = "Please wait.......";
    dialogData.dialogType = DialogType.loading;
    dialogData.isDismissible = false;

    //preparing data to be sent to server
    CustomDialog.showAlertDialog(viewContext, dialogData);
    // setUiState(UiState.loading);
    dialogData = await homePageRepository.removeFromMyHooper(userId, postId);
    CustomDialog.dismissDialog(viewContext);
    //update ui state after operation
    // setUiState(UiState.done);
    //checking if operation was successful before either showing an error or redirect to home page
    if (dialogData.dialogType == DialogType.success) {
      dialogData.isDismissible = true;
      if (AudioConstant.FROM_SEE_ALL) {
        dialogData.dialogType = DialogType.successThenClosePage;
      } else {
        dialogData.dialogType = DialogType.success;
      }

      if (AudioConstant.audioViewModel != null) {
          int index=0;
         for(int i=0;i<AudioConstant.audioViewModel.myPlayList.length;i++){
           if (AudioConstant.audioViewModel.myPlayList[i].id == postId) {
              AudioConstant.audioViewModel.myPlayList.removeAt(i);
              index=i;
              break;
           }
         }


         // AudioConstant.audioViewModel.myPlayList.removeWhere((e) => toRemove.contains(e));

          if(HomeBloc.postID==postId){
            AudioConstant.audioViewModel.audioHopperHandler.stop();
            AudioConstant.audioIsPlaying=false;
            if(AudioConstant.audioViewModel.myPlayList.length>0){
              HomeBloc.postID=AudioConstant.audioViewModel.myPlayList[0].id;
            }
            AudioConstant.audioViewModel.currentPlayingIndex=0;

          }else{
             AudioConstant.audioViewModel.concatenatingAudioSource.removeAt(index);
          }

          if(AudioConstant.audioViewModel.myPlayList.length==0){
             AudioConstant.audioIsPlaying=false;
             HomeBloc.postID=0;
           }

        notifyListeners();

      }
      //notify the ui with the newly gotten dialogdata model
      CustomDialog.showAlertDialog(viewContext, dialogData,
          onDismissAction: () {
        List<Hopper> toRemove = [];
        myHopperList.forEach((element) {
          if (element.post.iD == postId) {
            //myHopperList.remove(element);
            //notifyListeners();
            toRemove.add(element);
          }
        });

        myHopperList.removeWhere((e) => toRemove.contains(e));
        notifyListeners();

      });

      Future.delayed(const Duration(milliseconds: 1500), () {
        CustomDialog.dismissDialog(viewContext);
      });
    } else {
      //prepare the data model to be used to show the alert on the view
      dialogData.isDismissible = true;
      dialogData.dialogType = DialogType.failed;
      //notify the ui with the newly gotten dialogdata model
      CustomDialog.showAlertDialog(viewContext, dialogData,
          onDismissAction: () {
        CustomDialog.dismissDialog(viewContext);
      });
    }
  }

  void removeFromRecentlyViewed({int postId}) async {
    //update ui state
    final int userId = AuthBloc.getUserId();

    var dialogData = DialogData();
    dialogData.title = "Remove From Recently Viewed";
    dialogData.body = "Please wait.......";
    dialogData.dialogType = DialogType.loading;
    dialogData.isDismissible = false;

    //preparing data to be sent to server
    CustomDialog.showAlertDialog(viewContext, dialogData);
    // setUiState(UiState.loading);
    dialogData =
        await homePageRepository.removeFromRecenttlyViewed(userId, postId);
    CustomDialog.dismissDialog(viewContext);
    //update ui state after operation
    // setUiState(UiState.done);
    //checking if operation was successful before either showing an error or redirect to home page
    if (dialogData.dialogType == DialogType.success) {
      dialogData.isDismissible = true;
      dialogData.dialogType = DialogType.successThenClosePage;
      //notify the ui with the newly gotten dialogdata model
      CustomDialog.showAlertDialog(viewContext, dialogData,
          onDismissAction: () {
        List<Hopper> toRemove = [];
        recentlyViewedList.forEach((element) {
          if (element.post.iD == postId) {
            //myHopperList.remove(element);
            //notifyListeners();
            toRemove.add(element);
          }
        });

        recentlyViewedList.removeWhere((e) => toRemove.contains(e));
        notifyListeners();
      });
    } else {
      //prepare the data model to be used to show the alert on the view
      dialogData.isDismissible = true;
      dialogData.dialogType = DialogType.failedThenClosePage;
      //notify the ui with the newly gotten dialogdata model
      CustomDialog.showAlertDialog(viewContext, dialogData,
          onDismissAction: () {
        CustomDialog.dismissDialog(viewContext);
      });
    }
  }

  void removeFromDownload({int postId,Hopper hopper}) async {
    //update ui state
    final int userId = AuthBloc.getUserId();

    var dialogData = DialogData();
    dialogData.title = "Remove From Download";
    dialogData.body = "Please wait.......";
    dialogData.dialogType = DialogType.loading;
    dialogData.isDismissible = false;

    //preparing data to be sent to server
    CustomDialog.showAlertDialog(viewContext, dialogData);
    // setUiState(UiState.loading);
    dialogData = await homePageRepository.removeFromDownload(userId, postId);
    CustomDialog.dismissDialog(viewContext);
    //update ui state after operation
    // setUiState(UiState.done);
    //checking if operation was successful before either showing an error or redirect to home page
    if (dialogData.dialogType == DialogType.success) {
      dialogData.isDismissible = true;
      dialogData.dialogType = DialogType.success;
      //notify the ui with the newly gotten dialogdata model
      CustomDialog.showAlertDialog(viewContext, dialogData,
          onDismissAction: () {
        List<Hopper> toRemove = [];
        downloadedList.forEach((element) {
          if (element.post.iD == postId) {
            //myHopperList.remove(element);
            //notifyListeners();
            toRemove.add(element);
          }
        });

        downloadedList.removeWhere((e) => toRemove.contains(e));
        AuthBloc.removeUserDownloadedFiles(postId);
        notifyListeners();

      });

      Future.delayed(const Duration(milliseconds: 1500), () {
        CustomDialog.dismissDialog(viewContext);
      });

    } else {
      //prepare the data model to be used to show the alert on the view
      dialogData.isDismissible = true;
      dialogData.dialogType = DialogType.failed;
      //notify the ui with the newly gotten dialogdata model
      CustomDialog.showAlertDialog(viewContext, dialogData,
          onDismissAction: () {
        CustomDialog.dismissDialog(viewContext);
      });
    }
  }

  downloadFile(String url,Hopper hopper) async {
    _permissionReady = await _checkPermission();

    if (_permissionReady) {
      await _prepareSaveDir();
    }

    startDownLoad=true;
    notifyListeners();

    String fileName=url.split("/").last;
    File saveFile=File(_localPath+"/"+fileName);
    try {
      await dio.download(url, saveFile.path,
          onReceiveProgress: (downloaded, totalSize) {

            progressDownload = downloaded / totalSize;
            if (downloaded == totalSize) {
              startDownLoad = false;
            }

            notifyListeners();

          });

       HomePost _homePost=HomePost();
      _homePost.id=hopper.post.iD;
      _homePost.coverImageUrl=hopper.postCustom.coverImageUrl[0]??"";
      _homePost.author=hopper.postCustom.author[0]??"";
      _homePost.isAdded=true;
      _homePost.publication=hopper.postCustom.publication[0]??"";
      _homePost.publicationDate=hopper.postCustom.publicationDate[0]??"";
      _homePost.narrator=hopper.postCustom.narrator[0]??"";
      _homePost.audioFile=hopper.postCustom.audioFile[0]??"";
      _homePost.audioFileDuration=hopper.postCustom.audioFileDuration[0]??"";
      _homePost.title=Guid();
      _homePost.title.rendered=hopper.post.postTitle??"";
      _homePost.subHeader=hopper.postCustom.subHeader[0]??"";
      _homePost.postDescription=hopper.postCustom.postDescription[0]??"";
      _homePost.url=hopper.postCustom.url[0]??"";


      await AuthBloc.addUserDownloadFile(_homePost,saveFile.path);



    }catch(e){
      print(e);
    }

    /*final taskId = await FlutterDownloader.enqueue(
      url: url ?? "",
      savedDir: _localPath,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );*/
  }

 /* Future<bool> _checkPermission() async {
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
  }*/
  Future<bool> _checkPermission() async {
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
    } else if(Platform.isIOS){
      final status = await Permission.photos.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.photos.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    }
    return false;
  }

  /*Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }*/
  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath());
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create(recursive: true);
    }
  }

 /* Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory?.path;
  }*/
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
      // directory = await getTemporaryDirectory();
      directory=await getApplicationDocumentsDirectory();
      //externalStorageDirPath = (await getApplicationDocumentsDirectory()).absolute.path;
    }

    externalStorageDirPath=directory.path;
    return externalStorageDirPath;
  }

}


