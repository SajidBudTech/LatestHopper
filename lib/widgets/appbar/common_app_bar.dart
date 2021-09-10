import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_icons/flutter_icons.dart';


class CommonAppBar extends StatelessWidget {
  const CommonAppBar({
    Key key,
    this.backgroundColor,
    this.title,
    this.onPressed,
    this.capitalized=true
  }) : super(key: key);

  final Color backgroundColor;
  final String title;
  final Function onPressed;
  final bool capitalized;

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
          //search bar
          InkWell(
                onTap: this.onPressed,
              child:Container(
                  alignment: Alignment.centerLeft,
                  child:Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.white
                  ))),
          //Delivery location
          Container(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              "${this.title[0].toUpperCase()}${capitalized?this.title.substring(1):this.title.substring(1).toLowerCase()}",
              textAlign: TextAlign.left,
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
