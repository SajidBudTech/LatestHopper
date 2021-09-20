import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';

class ShowFlash{
  BuildContext context;
  String title;
  String message;
  ShowFlash(BuildContext context,{String title,String message}){
    this.context=context;
    this.title=title;
    this.message=message;
  }

  show(){
    showFlash(
      context: context,
      duration: const Duration(seconds: 3),
      builder: (context, controller) {
        return Flash(
          controller: controller,
          backgroundColor: AppColor.primaryColor,
          brightness: Brightness.light,
          boxShadows: [BoxShadow(blurRadius: 4)],
          barrierBlur: 3.0,
          barrierColor: Colors.black38,
          barrierDismissible: true,
          style: FlashStyle.floating,
          position: FlashPosition.top,
          child: FlashBar(
            title: title==null?Container()
            :Text(title??"",style: AppTextStyle.h3TitleTextStyle(
                color:AppColor.accentColor,
                fontWeight: FontWeight.w500
            ),),
            message:message==null?Container():
            Text(message,
               style: AppTextStyle.h5TitleTextStyle(
                  color: AppColor.accentColor,
                  fontWeight: FontWeight.w400
              ),),
          ),
        );
      },
    );
  }
}