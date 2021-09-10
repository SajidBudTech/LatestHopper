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
import 'package:flutter_icons/flutter_icons.dart';

class AuthorListViewItem extends StatefulWidget {
  AuthorListViewItem({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;
  @override
  _AuthorListViewItemState createState() => _AuthorListViewItemState();
}

class _AuthorListViewItemState extends State<AuthorListViewItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onPressed,
        child:Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Stack(
                          children: <Widget>[
                            //vendor feature image
                            /*CachedNetworkImage(
                    imageUrl: widget.vendor.featureImage,
                   placeholder: (context, url) => Container(
                  height: AppSizes.vendorImageHeight,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                height: AppSizes.vendorImageHeight,
                fit: BoxFit.cover,
                width: double.infinity,
               ),*/

                            ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child:Image.asset("assets/images/home_list.png",
                                  height: 60,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )),
                            Positioned.fill(
                                child:Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/images/play_home.png",
                                      width: 32,
                                      height: 32,
                                    )
                                )
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 8,top: 0),
                              child: Text(
                                "Rock and Roll Globe",
                                style: AppTextStyle.h5TitleTextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.accentColor,
                                ),
                                textDirection: AppTextDirection.defaultDirection,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8,top: 0),
                              child: Text(
                                "Pediatricians plead with FDA to move quickly on covid vaccine for kids",
                                style: AppTextStyle.h5TitleTextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.textColor(context),
                                ),
                                textDirection: AppTextDirection.defaultDirection,
                              ),
                            ),
                          ],
                        )
                    )
                  ],
                ),
                UiSpacer.verticalSpace(space: 10),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                          //padding: EdgeInsets.only(left: 2,top: 0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Aug 05 2021 10 Mins",
                            style: AppTextStyle.h6TitleTextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontStyle: FontStyle.italic
                            ),
                            textDirection: AppTextDirection.defaultDirection,
                          ),
                        )),
                    Expanded(
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: widget.onPressed,
                                child:Icon(
                                  FlutterIcons.dots_three_horizontal_ent,
                                  size: 20,
                                  color: Colors.grey,
                                )),
                            SizedBox(
                              width: 16,
                            ),
                            Image.asset(
                              "assets/images/download _ic.png",
                              width: 20,
                              height: 20,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Image.asset(
                              "assets/images/play_ic.png",
                              width: 20,
                              height: 20,
                              color: Colors.grey,
                            )
                          ],
                        )

                    ),
                  ],
                )
              ],
            )
        ));
  }
}
