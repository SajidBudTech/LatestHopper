import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/models/recenctly_viewed_post.dart';
import 'package:flutter_hopper/utils/custom_dialog.dart';
import 'package:flutter_hopper/viewmodels/hopper.viewmodel.dart';
import 'package:flutter_hopper/viewmodels/main_home_viewmodel.dart';
import 'package:flutter_hopper/views/hopper/hopper_bottom_sheet_page.dart';
import 'package:flutter_hopper/views/hopper/list_header_widget.dart';
import 'package:flutter_hopper/widgets/appbar/home_appbar.dart';
import 'package:flutter_hopper/widgets/empty/hopper_empty.dart';
import 'package:flutter_hopper/widgets/listview/myhopper_listview_item.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_hopper/models/loading_state.dart';
import 'package:flutter_hopper/widgets/shimmers/vendor_shimmer_list_view_item.dart';
import 'package:flutter_hopper/models/state_data_model.dart';
import 'package:flutter_hopper/widgets/state/state_loading_data.dart';

class SeeAllPagePage extends StatefulWidget {
  SeeAllPagePage({Key key,this.title,this.hopperList,this.model}) : super(key: key);

  String title;
  List<Hopper> hopperList;
  HopperViewModel model;

  @override
  _SeeAllPageState createState() => _SeeAllPageState();

}

class _SeeAllPageState extends State<SeeAllPagePage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: SafeArea(
                child:Column(
                    children: [
                      HomeAppBar(
                        imagePath: "assets/images/appbar_image.png",
                        backgroundColor: AppColor.accentColor,
                        visibleBottom: false,
                      ),
                      Expanded(
                          child:SingleChildScrollView(
                            primary: true,
                            padding: EdgeInsets.only(top: 20,bottom: 20),
                            physics: AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                HopperListHeader(
                                  title: widget.title??"",
                                  showSeeAll: false,
                                  onSeeAllClicked: (){

                                  },
                                ),
                                Container(
                                  child: (widget.title=="My Hopper"?widget.model.myHopperList.length==0:
                                       (widget.title=="RECENTLY VIEWED"?widget.model.recentlyViewedList.length==0:widget.model.downloadedList.length==0))
                                      ?EmptyHopper(title: "Nothing Added to "+widget.title??"")
                                      :ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap:true,
                                    primary: false,
                                    padding: AppPaddings.defaultPadding(),
                                    itemBuilder: (context, index) {
                                      return MyHopperListViewItem(
                                        hopper: widget.title=="My Hopper"?widget.model.myHopperList[index]:(widget.title=="RECENTLY VIEWED"?widget.model.recentlyViewedList[index]:widget.model.downloadedList[index]),
                                        showDownload: (widget.title=="My Hopper" || widget.title=="RECENTLY VIEWED")?true:false,
                                        showAddTOPlayer: (widget.title=="DOWNLOADED" || widget.title=="RECENTLY VIEWED")?true:false,
                                        onPressed: (){
                                          showSortBottomSheetDialog(widget.title=="My Hopper"?widget.model.myHopperList[index]:(widget.title=="RECENTLY VIEWED"?widget.model.recentlyViewedList[index]:widget.model.downloadedList[index]),widget.title=="My Hopper"?true:false,widget.model);
                                        },
                                        onDownloadPressed: (){
                                          widget.model.addToDownload(postId:widget.hopperList[index].post.iD,hopper: widget.title=="My Hopper"?widget.model.myHopperList[index]:(widget.title=="RECENTLY VIEWED"?widget.model.recentlyViewedList[index]:widget.model.downloadedList[index]));
                                        },
                                      );
                                    },
                                    /* separatorBuilder: (context, index) => Container(
                          height: 8,
                        ),*/
                                    itemCount: widget.title=="My Hopper"?widget.model.myHopperList.length:(widget.title=="RECENTLY VIEWED"?widget.model.recentlyViewedList.length:widget.model.downloadedList.length),
                                  ),
                                ),
                               /* HopperListHeader(
                                  title: "RECENTLY VIEWED",
                                  onSeeAllClicked: (){

                                  },
                                ),
                                Container(
                                  child: model.recentlyViewedLoadingState == LoadingState.Loading
                                      ? Padding(padding: EdgeInsets.only(left: 20,right: 20),child:VendorShimmerListViewItem())
                                      : model.recentlyViewedLoadingState == LoadingState.Failed
                                      ? LoadingStateDataView(
                                    stateDataModel: StateDataModel(
                                      showActionButton: true,
                                      actionButtonStyle: AppTextStyle.h4TitleTextStyle(
                                        color: Colors.red,
                                      ),
                                      actionFunction: model.initialise,
                                    ),
                                  ) : model.recentlyViewedList.length==0
                                      ?EmptyHopper(title: "Nothing Added to Recently Viewed")
                                      :ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap:true,
                                    primary: false,
                                    padding: AppPaddings.defaultPadding(),
                                    itemBuilder: (context, index) {
                                      return MyHopperListViewItem(
                                        hopper: model.recentlyViewedList[index],
                                        showDownload: true,
                                        showAddTOPlayer: true,
                                        onPressed: (){
                                          showSortBottomSheetDialog(model.recentlyViewedList[index],false,model);
                                        },
                                        onDownloadPressed: (){
                                          model.addToDownload(postId:model.recentlyViewedList[index].post.iD,hopper: model.recentlyViewedList[index]);
                                        },
                                      );
                                    },
                                    *//*separatorBuilder: (context, index) => Divider(
                            height: 1,
                          ),*//*
                                    itemCount: model.recentlyViewedList.length,
                                  ),
                                ),
                                HopperListHeader(
                                  title: "DOWNLOADED",
                                  onSeeAllClicked: (){

                                  },
                                ),
                                Container(
                                  child: model.downloadLoadingState == LoadingState.Loading
                                      ? Padding(padding: EdgeInsets.only(left: 20,right: 20),child:VendorShimmerListViewItem())
                                      : model.downloadLoadingState == LoadingState.Failed
                                      ? LoadingStateDataView(
                                    stateDataModel: StateDataModel(
                                      showActionButton: true,
                                      actionButtonStyle: AppTextStyle.h4TitleTextStyle(
                                        color: Colors.red,
                                      ),
                                      actionFunction: model.initialise,
                                    ),
                                  ) : model.downloadedList.length==0
                                      ?EmptyHopper(title: "Nothing Added to Downloaded")
                                      :ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap:true,
                                    primary: false,
                                    padding: AppPaddings.defaultPadding(),
                                    itemBuilder: (context, index) {
                                      return MyHopperListViewItem(
                                        hopper: model.downloadedList[index],
                                        showDownload: false,
                                        showAddTOPlayer: true,
                                        onPressed: (){
                                          showSortBottomSheetDialog(model.downloadedList[index],false,model);
                                        },
                                        onDownloadPressed: (){

                                        },
                                      );
                                    },
                                    *//* separatorBuilder: (context, index) => Divider(
                            height: 1,
                          ),*//*
                                    itemCount: model.downloadedList.length,
                                  ),
                                )*/
                              ],
                            ),
                          ))
                    ])));
  }

  void showSortBottomSheetDialog(Hopper hopper,bool fromMyhopper, HopperViewModel model) {
     CustomDialog.showCustomBottomSheet(
        context,
        backgroundColor: Colors.white,
        content:HopperBottomSheetPage(
          hopper: hopper,
          fromMyHopper: fromMyhopper,
          model: model,
          fromSeeAll: true,
        ),
    );
  }

}
