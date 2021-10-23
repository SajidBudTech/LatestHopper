import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_icons/flutter_icons.dart';


class SeeAllAppBar extends StatelessWidget {
  const SeeAllAppBar({
    Key key,
    this.backgroundColor,
    this.imagePath,
    this.subtitle,
    this.onPressed
  }) : super(key: key);

  final Color backgroundColor;
  final String subtitle;
  final Function onPressed;
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
          Expanded(
              child:Container(
                  alignment: Alignment.center,
                  child:Image.asset(imagePath??"",
                    height:36,
                    fit: BoxFit.cover,))
          ),
        ],
      ),
    );
  }
}
