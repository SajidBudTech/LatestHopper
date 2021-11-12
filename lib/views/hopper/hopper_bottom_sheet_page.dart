import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/bloc/login.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';
import 'package:flutter_hopper/models/recenctly_viewed_post.dart';
import 'package:flutter_hopper/utils/flash_alert.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_hopper/widgets/listview/hopper_sort_listview_item.dart';
import 'package:flutter_hopper/viewmodels/hopper.viewmodel.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_hopper/utils/termandcondition_utils.dart';

class HopperBottomSheetPage extends StatefulWidget {
  HopperBottomSheetPage({
    Key key,
    this.hopper,
    this.fromMyHopper,
    this.fromDownload,
    this.model,
    this.fromSeeAll
  }) : super(key: key);

  Hopper hopper;
  bool fromMyHopper;
  bool fromDownload;
  HopperViewModel model;
  bool fromSeeAll;
  @override
  _HopperBottomSheetPageState createState() => _HopperBottomSheetPageState();


}

class _HopperBottomSheetPageState extends State<HopperBottomSheetPage> {

  List<String> sortlist=[];
  String dynamicShortLink;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AudioConstant.FROM_SEE_ALL=widget.fromSeeAll;
    if(widget.fromMyHopper){
      sortlist.add("Remove from my hopper");
    }else{
      sortlist.add("Add to my hopper");
    }
    if(widget.fromDownload){
      sortlist.add("Remove from Download");
    }
    sortlist.add("Share track");
    sortlist.add("Read along");
    sortlist.add("Cancel");

  }

  @override
  Widget build(BuildContext viewcontext) {
    return Container(
      color: Colors.white,
      child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UiSpacer.verticalSpace(),
            Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: AppPaddings.contentPaddingSize,right: AppPaddings.contentPaddingSize),
                //padding: EdgeInsets.only(),
                child:Text(
                  widget.hopper.post.postTitle??"",
                  style: AppTextStyle.h3TitleTextStyle(
                      color: AppColor.accentColor,
                      fontWeight: FontWeight.w500
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  textDirection: AppTextDirection.defaultDirection,
                )),
            UiSpacer.verticalSpace(space: 8),
            Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: AppPaddings.contentPaddingSize,right: AppPaddings.contentPaddingSize),
                //padding: EdgeInsets.only(),
                child:Text(
                  widget.hopper.postCustom.postDescription[0]??"",
                  style: AppTextStyle.h4TitleTextStyle(
                      color: AppColor.textColor(context),
                      fontWeight: FontWeight.w500
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  textDirection: AppTextDirection.defaultDirection,
                )),
            UiSpacer.verticalSpace(space: 36),
            //UiSpacer.divider(thickness: 0.3,color: AppColor.hintTextColor(context)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: AppPaddings.contentPaddingSize,right: AppPaddings.contentPaddingSize),
              child:  ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: sortlist.length,
                //padding: EdgeInsets.only(left: AppPaddings.contentPaddingSize,right: AppPaddings.contentPaddingSize),
                separatorBuilder: (context, index) =>
                    UiSpacer.horizontalSpace(space: 0),
                itemBuilder: (context, index) {
                  return HopperSortListViewItem(
                    notification:sortlist[index],
                    onPressed: (){
                      Navigator.pop(context);
                      if(index==0){
                        if(!widget.fromMyHopper){
                          bool check=false;
                          widget.model.myHopperList.forEach((element) {
                            if(element.post.iD==widget.hopper.post.iD){
                              check=true;
                            }
                          });
                          if(!check){
                            widget.model.addToMyHooper(postId: widget.hopper.post.iD,hopper: widget.hopper);
                          }else{
                            ShowFlash(context,
                                title:
                                "Already Added In MyHopper",
                                message:
                                "Please try with some other article!",
                                flashType: FlashType.failed)
                                .show();
                          }
                        }else{
                          bool check=false;
                          widget.model.myHopperList.forEach((element) {
                            if(element.post.iD==widget.hopper.post.iD){
                              check=true;
                            }
                          });
                          if(check){
                            widget.model.removeFromMyHopper(postId: widget.hopper.post.iD);
                          }else{
                            ShowFlash(context,
                                title:
                                "Already Removed From MyHopper",
                                message:
                                "Please try with some other article!",
                                flashType: FlashType.failed)
                                .show();
                          }
                        }
                      }else if(sortlist[index]=="Share track"){
                        _generateDynamicLink();
                        // Navigator.pop(context);
                      }else if(sortlist[index]=="Read along"){
                        Terms.lunchReadAlong(widget.hopper.postCustom.url[0]??"");
                        //Navigator.pop(context);
                      }else if(sortlist[index]=="Cancel"){
                       // Navigator.pop(context);
                      }else if(sortlist[index]=="Remove from Download"){
                        widget.model.removeFromDownload(postId: widget.hopper.post.iD,hopper: widget.hopper);
                      }
                    },
                 );
                },
              ),
            ),
            UiSpacer.verticalSpace(space: 40)

          ]),

    );
  }

  void _share() async{
    Share.share("Check out this article from Audio Hopper! ${dynamicShortLink}");
  }

  void _generateDynamicLink() async{

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://audiohopper.page.link',
      link: Uri.parse('https://audiohopper.com/article?postID=${widget.hopper.post.iD}'),
      navigationInfoParameters: NavigationInfoParameters(),
      androidParameters: AndroidParameters(
        packageName: 'com.application.audiohopper',
      ),
      iosParameters: IosParameters(
        bundleId: 'com.audiohopper',
      ),
    );

    final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();

    dynamicShortLink=dynamicUrl.shortUrl.toString();

    _share();

  }
}
