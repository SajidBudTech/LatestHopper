import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_hopper/constants/app_strings.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';

class EmptyHopper extends StatelessWidget {
  final title;
  EmptyHopper({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
        padding: EdgeInsets.only(top: 16,bottom: 16,left: 20,right: 20),
       // color: Colors.white,
        child:Text(
          this.title??"",
        textAlign: TextAlign.center,
        style: AppTextStyle.h4TitleTextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black54,
        ),
      textDirection: AppTextDirection.defaultDirection,
    ),
    );
  }
}
