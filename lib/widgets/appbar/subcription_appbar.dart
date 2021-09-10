import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_icons/flutter_icons.dart';


class SubcriptionAppBar extends StatelessWidget {
  const SubcriptionAppBar({
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
      //height: AppSizes.secondCustomAppBarHeight,
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
          Expanded(
            flex: 5,
            child: Text(
              title??"",
              textAlign: TextAlign.left,
              style: AppTextStyle.h3TitleTextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500
              ),
            ),
           ),
          Expanded(
              flex: 5,
              child:Container(
                  alignment: Alignment.centerRight,
                  child:Image.asset(imagePath??"",
                    height: 56,
                    fit: BoxFit.cover,))
          ),
        ],
      ),
    );
  }
}
