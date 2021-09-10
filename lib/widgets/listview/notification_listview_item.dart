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

class NotificationListViewItem extends StatefulWidget {
  NotificationListViewItem({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;
  @override
  _NotificationListViewItemState createState() => _NotificationListViewItemState();
}

class _NotificationListViewItemState extends State<NotificationListViewItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onPressed,
        child:Container(
            //margin: EdgeInsets.only(bottom: 16),
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
                        child:
                            Container(
                              padding: EdgeInsets.only(left: 8,top: 0),
                              child: Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In ut odio non nisl aliquet congue. Nam sem tortor, porttitor ac suscipit vel, viverra a nunc.",
                                style: AppTextStyle.h5TitleTextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.textColor(context),
                                ),
                                textDirection: AppTextDirection.defaultDirection,
                              ),
                            ),
                    )
                  ],
                ),
                UiSpacer.verticalSpace(space: 10),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                          //padding: EdgeInsets.only(left: 2,top: 0),
                          alignment: Alignment.centerRight,
                          child: Text(
                            "05 Sep 2021 08:00PM",
                            style: AppTextStyle.h6TitleTextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black26,
                              fontStyle: FontStyle.italic
                            ),
                            textDirection: AppTextDirection.defaultDirection,
                          ),
                        )),
                  ],
                )
              ],
            )
        ));
  }
}
