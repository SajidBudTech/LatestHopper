import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_icons/flutter_icons.dart';


class AuthAppBar extends StatelessWidget {
  const AuthAppBar({
    Key key,
    this.backgroundColor,
    this.title,
    this.imagePath
  }) : super(key: key);

  final Color backgroundColor;
  final String title;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.secondCustomAppBarHeight,
      padding: AppPaddings.defaultPadding(),
      decoration: BoxDecoration(
        color: AppColor.accentColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
        )
      ),
      child: Row(
        textDirection: AppTextDirection.defaultDirection,
        children: <Widget>[
          //search bar
          Expanded(
            flex: title=="FORGOT PASSWORD?"?3:6,
            child:Container(
              alignment: Alignment.centerLeft,
            child:Image.asset(imagePath??"",
            height: title=="FORGOT PASSWORD?"?56:42,
            fit: BoxFit.cover,))
          ),
          //Delivery location
          Expanded(
            flex: 5,
            child: Text(
               title??"",
               textAlign: TextAlign.right,
               style: AppTextStyle.h3TitleTextStyle(
                 color: Colors.white,
                 fontWeight: FontWeight.w500
               ),
            ),
          ),
        ],
      ),
    );
  }
}
