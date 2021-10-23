// ViewModel
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/models/dialog_data.dart';
import 'package:flutter_hopper/utils/custom_dialog.dart';
import 'package:stacked/stacked.dart';

class MyBaseViewModel extends BaseViewModel {
  BuildContext viewContext;

  //repositories
  //CategoryRepository categoryRepository = CategoryRepository();
  //VendorRepository vendorRepository = VendorRepository();

  //
  void showAlert({
    String title = "",
    String description = "",
    IconData iconData,
    Color backgroundColor,
  }) {
    /*EdgeAlert.show(
      viewContext,
      title: title,
      description: description,
      backgroundColor: backgroundColor ?? AppColor.successfulColor,
      icon: iconData ?? FlutterIcons.check_ant,
    );*/
    showFlash(
      context: viewContext,
      duration: const Duration(seconds: 2),
      builder: (context, controller) {
        return Flash(
          controller: controller,
          backgroundColor: AppColor.accentColor,
          brightness: Brightness.light,
          boxShadows: [BoxShadow(blurRadius: 4)],
          barrierBlur: 3.0,
          barrierColor: Colors.black38,
          barrierDismissible: true,
          //style: FlashStyle.floating,
          position: FlashPosition.top,
          child: FlashBar(
            title: Text(title,style: AppTextStyle.h4TitleTextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400
            ),),
            content:
            Text(description,
              style: AppTextStyle.h6TitleTextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300
              ),),
          ),
        );
      },
    );
  }

  //
  void showDialogAlert({
    DialogData dialogData,
    Function onPositivePressed,
  }) {
    CustomDialog.showConfirmationActionAlertDialog(
      viewContext,
      dialogData,
      negativeButtonAction: () {
        //dismiss dialog
        CustomDialog.dismissDialog(
          viewContext,
        );
      },
      positiveButtonAction: () {
        //dismiss dialog
        CustomDialog.dismissDialog(
          viewContext,
        );

        //
        onPositivePressed();
      },
    );
  }
}
