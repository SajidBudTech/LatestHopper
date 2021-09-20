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
import 'package:flutter_hopper/models/home_post.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:intl/intl.dart';

class HomeListViewItem extends StatefulWidget {
  HomeListViewItem({
    Key key,
    this.homePost
  }) : super(key: key);

  HomePost homePost;
  @override
  _HomeListViewItemState createState() => _HomeListViewItemState();
}

class _HomeListViewItemState extends State<HomeListViewItem> {
  @override
  Widget build(BuildContext context) {
    return  Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
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
                 Stack(
                   children: [
                     ClipRRect(
                         borderRadius: BorderRadius.circular(8.0),
                         child:Image.asset("assets/images/home_list.png",
                           height: AppSizes.vendorImageHeight,
                           fit: BoxFit.cover,
                           width: double.infinity,
                         )
                     ),
                     Positioned.fill(child:ClipRRect(
                         borderRadius: BorderRadius.circular(8.0),
                         child:Image.asset("assets/images/black_shadow.png",
                           height: AppSizes.vendorImageHeight,
                           fit: BoxFit.fitHeight,
                           width: double.infinity,
                         )))
                   ],
                 ),


                  Positioned(
                    //right: 20,
                    width: AppSizes.getScreenWidth(context)-56,
                    top: AppSizes.vendorImageHeight - 40,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                       Padding(padding: EdgeInsets.only(left: 16),
                        child:Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              widget.homePost.title.rendered??"",
                              style: AppTextStyle.h4TitleTextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              textDirection: AppTextDirection.defaultDirection,
                            ),
                           Text(
                              DateFormat("MMM dd yyyy").format(DateFormat("yyyy-MM-ddTHH:mm:ss").parse(widget.homePost.date)),
                              style: AppTextStyle.h6TitleTextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[400],
                                fontStyle: FontStyle.italic
                              ),
                              textDirection: AppTextDirection.defaultDirection,
                            ),
                          ],
                        )),
                         Flexible(child: Container(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                              "assets/images/play_ic.png",
                             width: 24,
                            height: 24,
                          ))
                        )
                      ],
                    )
                  ),
                  Positioned.fill(
                      child:Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/play_home.png",
                            width: 42,
                            height: 42,
                          )
                      )
                  ),
                ],
              ),
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, AppRoutes.authorDetailRoute);
                },
                child:Container(
                padding: EdgeInsets.only(left: 2,top: 10),
                child: Text(
                  "By ${widget.homePost.author??""}",
                  style: AppTextStyle.h5TitleTextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColor.accentColor,
                    decoration: TextDecoration.underline,
                    fontStyle: FontStyle.italic
                  ),
                  textDirection: AppTextDirection.defaultDirection,
                ),
              )),
              Container(
                padding: EdgeInsets.only(left: 0,top: 2),
                child: Text(
                  stripHtmlIfNeeded(widget.homePost.excerpt.rendered??""),
                  style: AppTextStyle.h5TitleTextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColor.textColor(context),
                  ),
                  textDirection: AppTextDirection.defaultDirection,
                ),
              ),
              UiSpacer.verticalSpace(space: 10),
              UiSpacer.divider(color: Colors.grey[200])
            ],
          )
        );
  }

  String stripHtmlIfNeeded(String text){
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }
}
