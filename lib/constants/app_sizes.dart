import 'package:flutter/material.dart';

class AppSizes {
  static double customAppBarHeight = 170;
  static double secondCustomAppBarHeight = 100;
  static double mainHomePageCustomAppBarHeight = 150;

  static double inputHeight = 50;

  static double otpHeight = 65;
  static double otpWidth = 65;

  static double vendorImageHeight = 145;
  static double smallVendorImageHeight = 56;

  static double blogImageHeight = 180;
  static double blogImageWidth = 180;

  static double vendorShopTypeImageHeight = 70;
  static double vendorShopTypeImageWidth = 60;

  static double vendorPageImageHeight = 300;
  static double vendorPageHeaderCollapseHeight = 500;
  static double vendorPageInfoTopMargin = 230;
  static double vendorPageInfoCurveHeight = 50;


  static double doctorPageImageHeight = 200;

  static double productImageHeight = 60;
  static double productImageWidth = 60;

  static double categoryImageHeight = 80;
  static double categoryImageWidth = 80;

  static double productExtraImageHeight = 50;
  static double productExtraImageWidth = 50;

  static double userProfilePictureImageHeight = 110;
  static double userProfilePictureImageWidth = 110;

  static double borderRadius = 20;
  static ShapeBorder containerTopRadiusShape() => RoundedRectangleBorder(
        borderRadius: new BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      );

  static BorderRadiusGeometry containerTopBorderRadiusShape() =>
      BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      );

  static BorderRadiusGeometry containerBottomBorderRadiusShape() =>
      BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      );

  static BorderRadiusGeometry containerBorderRadiusShape(
          {double radius = 30}) =>
      BorderRadius.all(
        Radius.circular(radius),
      );

  static double getScreenWidth(BuildContext context){
    return MediaQuery.of(context).size.width;
  }

  static double getScreenheight(BuildContext context){
    return MediaQuery.of(context).size.height;
  }
}
