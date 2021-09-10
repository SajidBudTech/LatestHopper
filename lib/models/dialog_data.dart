import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

enum DialogType {
  normal,
  loading,
  success,
  successThenClosePage,
  failed,
  failedThenClosePage,
  warning,
  closePageAfterDialog,
  redirectPage,
  payment,
}

class DialogData {
  String title;

  String body;

  DialogType dialogType;

  bool repeatAnimation = true;

  bool popAfter = false;

  String negativeButtonTitle;

  String positiveButtonTitle;

  Color backgroundColor;

  IconData iconData;

  bool isDismissible;

  dynamic extraData;

  DialogData({
    this.title = "",
    this.body = "",
    this.dialogType = DialogType.normal,
    this.repeatAnimation = true,
    this.negativeButtonTitle = "",
    this.positiveButtonTitle = "",
    this.backgroundColor = Colors.white,
    this.iconData = FlutterIcons.error_mdi,
    this.isDismissible = false,
    this.extraData,
  });
}
