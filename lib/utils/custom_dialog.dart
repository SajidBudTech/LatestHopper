// ignore_for_file: const_initialized_with_non_constant_value, non_constant_identifier_names
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/models/dialog_data.dart';
import 'package:flutter_hopper/utils/dialog_type_animation.dart';
import 'package:lottie/lottie.dart';

class CustomDialog {
  static dismissDialog(context) {
    try {
      Navigator.of(context, rootNavigator: true).pop();
    } catch (error) {
      print("Error Dismissing Dialog ==> $error");
    }
  }

  //Show dialog
  static showAlertDialog(
    BuildContext context,
    DialogData dialogData, {
    bool isDismissible = true,
    Function onDismissAction,
  }) async {
    Widget alertTitleWidget = Text(
      "${dialogData.title}",
      style: AppTextStyle.h3TitleTextStyle(),
    );

    Widget alertBodyAnimationWidget = Lottie.asset(
      DialogTypeAnimation.getType(dialogData.dialogType),
      width: 100,
      height: 100,
      fit: BoxFit.contain,
    );

    Widget alertBodyWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        alertBodyAnimationWidget,
        (Platform.isIOS) ? SizedBox(height: 10) : SizedBox.shrink(),
        alertTitleWidget,
        (Platform.isIOS) ? SizedBox(height: 10) : SizedBox.shrink(),
        Text(
          "${dialogData.body}",
          style: AppTextStyle.h5TitleTextStyle(),
        ),
      ],
    );

    var alert;

    // set up the AlertDialog
    if (Platform.isAndroid) {
      alert = AlertDialog(
        content: Container(
          child: alertBodyWidget,
        ),
      );
    } else {
      alert = CupertinoAlertDialog(
        content: alertBodyWidget,
      );
    }

    // show the dialog
    if (context != null) {
      showDialog(
        context: context,
        barrierDismissible: isDismissible,
        builder: (BuildContext context) {
          return alert;
        },
      ).then(
        (val) {
          if (dialogData.dialogType == DialogType.closePageAfterDialog ||
              dialogData.dialogType == DialogType.successThenClosePage ||
              dialogData.popAfter) {
               Navigator.pop(context);
          }
          if (onDismissAction != null) {
            onDismissAction();
          }
        },
      );
    }
  }

  static showCustomMaterialAlertDialog(
    BuildContext context, {
    @required Widget content,
    bool isDismissible = false,
  }) {
    // show the dialog
    if (context != null) {
      showDialog(
        context: context,
        barrierDismissible: isDismissible,
        builder: (BuildContext context) {
          return AlertDialog(
            content: content,
          );
        },
      );
    }
  }

  static showConfirmationActionAlertDialog(
    BuildContext context,
    DialogData dialogData, {
    bool isDismissible = true,
    Function negativeButtonAction,
    Function positiveButtonAction,
  }) {
    Widget alertTitleWidget = Text(
      "${dialogData.title}",
      style: AppTextStyle.h3TitleTextStyle(),
    );

    //Load animation file base on dialog model type

    Widget alertBodyWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        (Platform.isIOS) ? SizedBox(height: 10) : SizedBox.shrink(),
        alertTitleWidget,
        (Platform.isIOS) ? SizedBox(height: 10) : SizedBox.shrink(),
        Text(
          dialogData.body,
          style: AppTextStyle.h5TitleTextStyle(),
        ),
      ],
    );

    // set up the negative action button
    Widget negativeButton = FlatButton(
      child: Text(
        dialogData.negativeButtonTitle,
        style: AppTextStyle.h5TitleTextStyle(),
      ),
      onPressed: () {
        negativeButtonAction();
      },
    );

    // set up the positive action button
    Widget positiveButton = FlatButton(
      child: Text(
        dialogData.positiveButtonTitle,
        style: AppTextStyle.h4TitleTextStyle(),
      ),
      onPressed: () {
        positiveButtonAction();
      },
    );

    var alert;

    // set up the AlertDialog
    if (Platform.isAndroid) {
      alert = AlertDialog(
        content: alertBodyWidget,
        actions: <Widget>[
          negativeButton,
          positiveButton,
        ],
      );
    } else {
      alert = CupertinoAlertDialog(
        content: alertBodyWidget,
        actions: <Widget>[
          negativeButton,
          positiveButton,
        ],
      );
    }

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //Bottom Sheet
  static showCustomBottomSheet(
      BuildContext context, {
        @required Widget content,
        EdgeInsetsGeometry contentPadding,
        Color backgroundColor
      }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: AppSizes.containerTopRadiusShape(),
      backgroundColor:backgroundColor==null?AppColor.appBackground(context):backgroundColor,
      builder: (BuildContext bc) {
        return SafeArea(
          bottom: true,
          child: Padding(
            padding: contentPadding ?? EdgeInsets.all(8.0),
            child: content,
          ),
        );
      },
    );
  }
}
