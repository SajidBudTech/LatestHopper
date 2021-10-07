// ViewModel
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';
import 'package:flutter_hopper/constants/strings/general.strings.dart';
import 'package:flutter_hopper/models/home_post.dart';
import 'package:flutter_hopper/models/loading_state.dart';
import 'package:flutter_hopper/repositories/home.repository.dart';
import 'package:flutter_hopper/viewmodels/base.viewmodel.dart';
import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:flutter_hopper/models/recenctly_viewed_post.dart';
import 'package:flutter_hopper/utils/custom_dialog.dart';
import 'package:flutter_hopper/models/dialog_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class HopperViewModel extends MyBaseViewModel {

  HomePageRepository _homePageRepository= HomePageRepository();

  //

  LoadingState myHopperLoadingState = LoadingState.Loading;
  LoadingState recentlyViewedLoadingState = LoadingState.Loading;
  LoadingState downloadLoadingState = LoadingState.Loading;

  List<Hopper> myHopperList=[];
  List<Hopper> recentlyViewedList=[];
  List<Hopper> downloadedList=[];
  List<String> hooperList=[];
  bool _permissionReady=false;
  String _localPath;

  HopperViewModel(BuildContext context) {
    this.viewContext = context;
  }

  initialise() async{
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

  getMyHopperList()async{
    myHopperLoadingState = LoadingState.Loading;
    notifyListeners();

    final int userId=AuthBloc.getUserId();
    try {
      myHopperList = await _homePageRepository.getMyHopperPost(userId);
      myHopperLoadingState = LoadingState.Done;
      notifyListeners();
    } catch (error) {
      myHopperLoadingState = LoadingState.Failed;
      notifyListeners();
    }
  }

  getRecentlyViewedList()async{
    recentlyViewedLoadingState = LoadingState.Loading;
    notifyListeners();

    final int userId=AuthBloc.getUserId();
    try {
      recentlyViewedList = await _homePageRepository.getRecenltyViewedPost(userId);
      recentlyViewedLoadingState = LoadingState.Done;
      notifyListeners();
    } catch (error) {
      recentlyViewedLoadingState = LoadingState.Failed;
      notifyListeners();
    }
  }

  getDownloadList()async{
    downloadLoadingState = LoadingState.Loading;
    notifyListeners();

    final int userId=AuthBloc.getUserId();
    try {
      downloadedList = await _homePageRepository.getDownloadList(userId);
      downloadLoadingState = LoadingState.Done;
      notifyListeners();
    } catch (error) {
      downloadLoadingState = LoadingState.Failed;
      notifyListeners();
    }
  }

   void addToMyHooperList(HomePost homePost)async{
     if(myHopperList==null){
       myHopperList=[];
     }

     Hopper hopper=Hopper();
     hopper.post.postTitle=homePost.title.rendered??"";
     hopper.postCustom.postDescription.add(homePost.postDescription??"");
     hopper.postCustom.publicationDate.add(homePost.publicationDate??"");
     hopper.postCustom.coverImageUrl.add(homePost.coverImageUrl??"");
     hopper.postCustom.audioFile.add(homePost.audioFile);
     hopper.postCustom.audioFileDuration.add(homePost.audioFileDuration);

     myHopperList.add(hopper);
     notifyListeners();

  }

  void addToMyHooper({int postId,Hopper hopper}) async {

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
    dialogData = await _homePageRepository.addToMyHooper(userId,postId);
    CustomDialog.dismissDialog(viewContext);
    //update ui state after operation
    // setUiState(UiState.done);
    //checking if operation was successful before either showing an error or redirect to home page
    if (dialogData.dialogType == DialogType.success) {

      dialogData.isDismissible = true;
      dialogData.dialogType = DialogType.success;
      //notify the ui with the newly gotten dialogdata model
      CustomDialog.showAlertDialog(viewContext, dialogData,onDismissAction: (){
        myHopperList.add(hopper);
        notifyListeners();
      });

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

  void addToDownload({int postId,Hopper hopper}) async {

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

     /* dialogData.isDismissible = true;
      dialogData.dialogType = DialogType.success;
      //notify the ui with the newly gotten dialogdata model
      CustomDialog.showAlertDialog(viewContext, dialogData,onDismissAction: (){
        myHopperList.add(hopper);
        notifyListeners();
      });*/
      downloadFile(hopper.postCustom.audioFile[0]??"");
      downloadedList.add(hopper);
      notifyListeners();

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
    dialogData = await _homePageRepository.removeFromMyHooper(userId,postId);
    CustomDialog.dismissDialog(viewContext);
    //update ui state after operation
    // setUiState(UiState.done);
    //checking if operation was successful before either showing an error or redirect to home page
    if (dialogData.dialogType == DialogType.success) {

      dialogData.isDismissible = true;
      if(AudioConstant.FROM_SEE_ALL){
        dialogData.dialogType = DialogType.successThenClosePage;
      }else{
        dialogData.dialogType = DialogType.success;
      }
      //notify the ui with the newly gotten dialogdata model
      CustomDialog.showAlertDialog(viewContext, dialogData,onDismissAction: (){
        List<Hopper> toRemove = [];
        myHopperList.forEach((element) {
          if(element.post.iD==postId){
            //myHopperList.remove(element);
            //notifyListeners();
            toRemove.add(element);
          }
        });

        myHopperList.removeWhere( (e) => toRemove.contains(e));
        notifyListeners();
      });

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
    dialogData = await _homePageRepository.removeFromRecenttlyViewed(userId,postId);
    CustomDialog.dismissDialog(viewContext);
    //update ui state after operation
    // setUiState(UiState.done);
    //checking if operation was successful before either showing an error or redirect to home page
    if (dialogData.dialogType == DialogType.success) {

      dialogData.isDismissible = true;
      dialogData.dialogType = DialogType.successThenClosePage;
      //notify the ui with the newly gotten dialogdata model
      CustomDialog.showAlertDialog(viewContext, dialogData,onDismissAction: (){
        List<Hopper> toRemove = [];
        recentlyViewedList.forEach((element) {
          if(element.post.iD==postId){
            //myHopperList.remove(element);
            //notifyListeners();
            toRemove.add(element);
          }
        });

        recentlyViewedList.removeWhere( (e) => toRemove.contains(e));
        notifyListeners();
      });

    } else {
      //prepare the data model to be used to show the alert on the view
      dialogData.isDismissible = true;
      dialogData.dialogType = DialogType.failedThenClosePage;
      //notify the ui with the newly gotten dialogdata model
      CustomDialog.showAlertDialog(viewContext, dialogData,onDismissAction: (){
        CustomDialog.dismissDialog(viewContext);
      });

    }

  }
  void removeFromDownload({int postId}) async {

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
    dialogData = await _homePageRepository.removeFromDownload(userId,postId);
    CustomDialog.dismissDialog(viewContext);
    //update ui state after operation
    // setUiState(UiState.done);
    //checking if operation was successful before either showing an error or redirect to home page
    if (dialogData.dialogType == DialogType.success) {

      dialogData.isDismissible = true;
      dialogData.dialogType = DialogType.success;
      //notify the ui with the newly gotten dialogdata model
      CustomDialog.showAlertDialog(viewContext, dialogData,onDismissAction: (){
        List<Hopper> toRemove = [];
        downloadedList.forEach((element) {
          if(element.post.iD==postId){
            //myHopperList.remove(element);
            //notifyListeners();
            toRemove.add(element);
          }
        });

        downloadedList.removeWhere( (e) => toRemove.contains(e));
        notifyListeners();

      });

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



  downloadFile(String url)async{
    _permissionReady = await _checkPermission();

    if (_permissionReady) {
      await _prepareSaveDir();
    }

    final taskId = await FlutterDownloader.enqueue(
      url: url??"",
      savedDir: _localPath,
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );



  }

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
    } else {
      return true;
    }
    return false;
  }
  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory?.path;
  }
}


