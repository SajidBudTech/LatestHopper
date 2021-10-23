import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_hopper/models/recenctly_viewed_post.dart';
import 'package:intl/intl.dart';

class MyHopperListViewItem extends StatefulWidget {
  MyHopperListViewItem({Key key, this.onPressed,this.onThreeDotPressed, this.hopper,this.onDownloadPressed,this.showDownload,this.showAddTOPlayer})
      : super(key: key);

  final Function onPressed;
  final Function onThreeDotPressed;
  final Function onDownloadPressed;
  final Hopper hopper;
  final bool showDownload;
  final bool showAddTOPlayer;
  @override
  _MyHopperListViewItemState createState() => _MyHopperListViewItemState();
}

class _MyHopperListViewItemState extends State<MyHopperListViewItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onPressed,
        child: Container(
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
                            ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: widget.hopper.postCustom.coverImageUrl[0] ?? "",
                                  placeholder: (context, url) => Container(
                                    height: 60,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                  height: 60,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )),

                            /*ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child:Image.asset("assets/images/home_list.png",
                          height: 60,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )),*/
                            Positioned.fill(
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/images/play_home.png",
                                      width: 32,
                                      height: 32,
                                    ))),
                          ],
                        )),
                    Expanded(
                        flex: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 8, top: 0),
                              child: Text(
                               // "Roack and Roll Globe",
                                widget.hopper.post.postTitle??"",
                                style: AppTextStyle.h5TitleTextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.accentColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textDirection:
                                    AppTextDirection.defaultDirection,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8, top: 0),
                              child: Text(
                                //"Pediatricians plead with FDA to move quickly on covid vaccine for kids.",
                                widget.hopper.postCustom.postDescription[0]??"",
                                style: AppTextStyle.h5TitleTextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.textColor(context),
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textDirection:
                                    AppTextDirection.defaultDirection,
                              ),
                            ),
                          ],
                        ))
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
                        //"Aug 05 2021 10 Mins",
                        (parseDate(widget.hopper.postCustom.publicationDate[0]??"19790401"))+("  ${widget.hopper.postCustom.audioFileDuration[0]??"0"} Mins"),
                        style: AppTextStyle.h6TitleTextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black38,
                            fontStyle: FontStyle.italic),
                        textDirection: AppTextDirection.defaultDirection,
                      ),
                    )),
                    Expanded(
                        child: Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                            visible: (widget.showDownload && !widget.showAddTOPlayer),
                            child:Container(
                            margin:EdgeInsets.only(right: 16),
                            child:InkWell(
                                onTap: widget.onThreeDotPressed,
                                child: Icon(
                                  FlutterIcons.three_bars_oct,
                                  size: 20,
                                  color: Colors.grey,
                                )))),
                        Container(
                            margin:EdgeInsets.only(right: 16),
                            child:InkWell(
                            onTap: widget.onThreeDotPressed,
                            child: Icon(
                              FlutterIcons.dots_three_horizontal_ent,
                              size: 20,
                              color: Colors.grey,
                            ))),
                       /* SizedBox(
                          width: 16,
                        ),*/
                        widget.showDownload?
                         InkWell(
                            onTap: widget.onDownloadPressed,
                            child:Image.asset(
                              "assets/images/download _ic.png",
                              width: 20,
                              height: 20,
                              color: Colors.grey,
                            )):SizedBox.shrink(),
                        /*Visibility(
                        visible: widget.showDownload,
                        child:InkWell(
                         onTap: widget.onDownloadPressed,
                        child:Image.asset(
                          "assets/images/download _ic.png",
                          width: 20,
                          height: 20,
                          color: Colors.grey,
                        ))),*/
                       /* SizedBox(
                          width: 16,
                        ),*/
                        widget.showAddTOPlayer?InkWell(
                            onTap:(){

                            },
                            child:Container(
                              margin: EdgeInsets.only(left: (widget.showAddTOPlayer && widget.showDownload)?16:0),
                                child:Image.asset(
                              "assets/images/play_ic.png",
                              width: 20,
                              height: 20,
                              color: Colors.grey,
                            ))):SizedBox.shrink(),

                       /* Visibility(
                          visible: widget.showAddTOPlayer,
                          child:InkWell(
                          onTap:(){

                          },
                          child:Image.asset(
                          "assets/images/play_ic.png",
                          width: 20,
                          height: 20,
                          color: Colors.grey,
                        )))*/
                      ],
                    )),
                  ],
                )
              ],
            )));
  }

  String parseDate(String date) {
    String year = date.substring(0, 4);
    String mm = date.substring(4, 6);
    String dd = date.substring(6, 8);

    String newDate = year + "/" + mm + "/" + dd;

    return DateFormat("MMMM dd, yyyy").format(DateFormat("yyyy/MM/dd").parse(newDate));
  }
}
