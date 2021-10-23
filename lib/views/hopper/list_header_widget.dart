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

class HopperListHeader extends StatefulWidget {
  HopperListHeader({
    Key key,
    this.title,
    this.onSeeAllClicked,
    this.showSeeAll=true,
  }) : super(key: key);

  final title;
  final Function onSeeAllClicked;
  final bool showSeeAll;
  @override
  _HopperListHeaderState createState() => _HopperListHeaderState();

}

class _HopperListHeaderState extends State<HopperListHeader> {
  @override
  Widget build(BuildContext context) {
    return  Container(
        padding: EdgeInsets.only(top: 8,bottom: 8,left: 20,right: 20),
        color: AppColor.primaryColor,
        child: Row(
          children: [
            Expanded(
              flex: 10,
              child:Text(
                widget.title??"",
                textAlign: TextAlign.left,
                style: AppTextStyle.h4TitleTextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColor.accentColor,
                ),
                textDirection: AppTextDirection.defaultDirection,
              ),
            ),
            Expanded(
              flex: 2,
              child:Visibility(
                visible: widget.showSeeAll,
               child: InkWell(
               onTap: widget.onSeeAllClicked,
               child:Text(
              "see all",
              textAlign: TextAlign.right,
              style: AppTextStyle.h5TitleTextStyle(
                fontWeight: FontWeight.w600,
                color: AppColor.textColor(context),
                decoration: TextDecoration.underline,
                fontStyle: FontStyle.italic
              ),
              textDirection: AppTextDirection.defaultDirection,
             ),
            )))
          ],
        )
    );
  }
}
