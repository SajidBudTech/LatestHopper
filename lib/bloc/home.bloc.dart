import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/models/dialog_data.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:flutter_hopper/repositories/home.repository.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';

class HomeBloc extends BaseBloc {
  //
  static BehaviorSubject<int> currentPageIndex;
  HomePageRepository _homePageRepository= HomePageRepository();

  static int postID=0;
  //switch page to cart
  static void switchPageToPalying(int postId) {
    AudioConstant.FROM_MINI_PLAYER=false;
    postID=postId;
    currentPageIndex.add(1);
  }

  static void switchPageToHome() {
    AudioConstant.FROM_MINI_PLAYER=false;
    currentPageIndex.add(0);
  }

  static void initiBloc() {
    currentPageIndex = BehaviorSubject<int>();
  }

  static void closeListener() {
    currentPageIndex.close();
  }

  void addToMyHooper({int postId}) async {

    //update ui state
    final int userId = AuthBloc.getUserId();

    // setUiState(UiState.loading);
    final resultDialogData = await _homePageRepository.addToMyHooper(userId,postId);

    //update ui state after operation
    // setUiState(UiState.done);
    //checking if operation was successful before either showing an error or redirect to home page
    if (resultDialogData.dialogType == DialogType.success) {
      dialogData.title = resultDialogData.title;
      dialogData.body = resultDialogData.body;
      dialogData.backgroundColor = AppColor.successfulColor;
      dialogData.iconData = FlutterIcons.done_mdi;
      setShowAlert(true);
    } else {
      //prepare the data model to be used to show the alert on the view
      dialogData.title = resultDialogData.title;
      dialogData.body = resultDialogData.body;
      dialogData.backgroundColor = AppColor.failedColor;
      dialogData.iconData = FlutterIcons.error_mdi;
      //notify listners to show show alert
      setShowAlert(true);

    }

  }
}
