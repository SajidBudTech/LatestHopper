import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_icons/flutter_icons.dart';


class PublishItems extends StatelessWidget {
  const PublishItems({
    Key key,
    this.title,
    this.subtitle,
    this.iconPath,
    this.timeData
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String iconPath;
  final String timeData;

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        iconPath??"",
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 4,),
                      Text(
                          this.title??"",
                          textAlign: TextAlign.left,
                          style: AppTextStyle.h5TitleTextStyle(
                              color: AppColor.accentColor,
                              fontWeight: FontWeight.w500
                          )),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 28),
                    child: Text(
                        this.subtitle??"",
                        textAlign: TextAlign.left,
                        style: AppTextStyle.h4TitleTextStyle(
                            color: AppColor.accentColor,
                            fontWeight: FontWeight.w600
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 28),
                    child: Text(
                        this.timeData??"",
                        textAlign: TextAlign.left,
                        style: AppTextStyle.h6TitleTextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic
                        )),
                  )
                ],
              );
  }
}
