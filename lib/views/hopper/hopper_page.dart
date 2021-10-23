
import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/home.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';
import 'package:flutter_hopper/models/recenctly_viewed_post.dart';
import 'package:flutter_hopper/utils/custom_dialog.dart';
import 'package:flutter_hopper/viewmodels/hopper.viewmodel.dart';
import 'package:flutter_hopper/viewmodels/main_home_viewmodel.dart';
import 'package:flutter_hopper/viewmodels/playing.viewmodel.dart';
import 'package:flutter_hopper/views/hopper/hopper_bottom_sheet_page.dart';
import 'package:flutter_hopper/views/hopper/list_header_widget.dart';
import 'package:flutter_hopper/widgets/appbar/home_appbar.dart';
import 'package:flutter_hopper/widgets/empty/hopper_empty.dart';
import 'package:flutter_hopper/widgets/listview/myhopper_listview_item.dart';
import 'package:just_audio/just_audio.dart';
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
import 'package:flutter_hopper/widgets/platform/center_progress_bar.dart';

class HopperPage extends StatefulWidget {
  const HopperPage({Key key}) : super(key: key);

  @override
  _HopperPageState createState() => _HopperPageState();
}

class _HopperPageState extends State<HopperPage>
    with AutomaticKeepAliveClientMixin<HopperPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<HopperViewModel>.reactive(
        viewModelBuilder: () => HopperViewModel(context),
        onModelReady: (model) => model.initialise(),
        builder: (context, model, child) => Scaffold(
            body: SafeArea(
              child:Column(
                children: [
                  HomeAppBar(
                    imagePath: "assets/images/appbar_image.png",
                    backgroundColor: AppColor.accentColor,
                    visibleBottom: false,
                  ),
              Expanded(
                child:Stack(
                  children: [
                    SingleChildScrollView(
                      primary: true,
                      padding: EdgeInsets.only(top: 20,bottom: 20),
                      physics: AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          HopperListHeader(
                            title: "My Hopper",
                            onSeeAllClicked: (){
                              Navigator.pushNamed(context, AppRoutes.seeAllHopperRoute,
                                  arguments: ["My Hopper",model.myHopperList,model]);
                            },
                          ),
                          Container(
                            child: model.myHopperLoadingState == LoadingState.Loading
                                ? Padding(padding: EdgeInsets.only(left: 20,right: 20),child:VendorShimmerListViewItem())
                                : model.myHopperLoadingState == LoadingState.Failed
                                ? LoadingStateDataView(
                              stateDataModel: StateDataModel(
                                showActionButton: true,
                                actionButtonStyle: AppTextStyle.h4TitleTextStyle(
                                  color: Colors.red,
                                ),
                                actionFunction: model.initialise,
                              ),
                            ) : model.myHopperList.length==0
                                ?EmptyHopper(title: "Nothing Added to My Hopper")
                                : ReorderableListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap:true,
                              primary: false,
                              onReorder: (oldIndex,newIndex){
                                setState(() {
                                  final hopper=model.myHopperList.removeAt(oldIndex);
                                  model.myHopperList.insert(newIndex, hopper);
                                  if(AudioConstant.audioIsPlaying){
                                    AudioConstant.audioViewModel.concatenatingAudioSource.removeAt(oldIndex+1);
                                    AudioConstant.audioViewModel.concatenatingAudioSource.insert(newIndex+1,AudioSource.uri(Uri.parse(model.myHopperList[newIndex].postCustom.audioFile[0]??"")));
                                  }
                                });
                              },
                              padding: AppPaddings.defaultPadding(),
                              itemBuilder: (context, index) {
                                return MyHopperListViewItem(
                                  key: ValueKey(model.myHopperList[index]),
                                  hopper: model.myHopperList[index],
                                  showDownload: true,
                                  showAddTOPlayer: false,
                                  onPressed: (){
                                      if(AudioConstant.audioIsPlaying){
                                        AudioConstant.audioViewModel.player.stop();
                                      }
                                      AudioConstant.FROM_BOTTOM=false;
                                      HomeBloc.switchPageToPalying(model.myHopperList[index].post.iD);
                                  },
                                  onThreeDotPressed: (){
                                    showSortBottomSheetDialog(model.myHopperList[index],true,model);
                                  },
                                  onDownloadPressed: (){
                                    model.addToDownload(postId:model.myHopperList[index].post.iD,hopper: model.myHopperList[index]);
                                  },
                                );
                              },
                              itemCount: model.myHopperList.length>3?3:model.myHopperList.length,
                            ),
                          ),
                          HopperListHeader(
                            title: "RECENTLY VIEWED",
                            onSeeAllClicked: (){
                              Navigator.pushNamed(context, AppRoutes.seeAllHopperRoute,
                                  arguments: ["RECENTLY VIEWED",model.recentlyViewedList,model]);
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
                                    if(AudioConstant.audioIsPlaying){
                                       AudioConstant.audioViewModel.player.stop();
                                    }
                                    AudioConstant.FROM_BOTTOM=false;
                                    HomeBloc.switchPageToPalying(model.recentlyViewedList[index].post.iD);
                                  },
                                  onThreeDotPressed: (){
                                    showSortBottomSheetDialog(model.recentlyViewedList[index],false,model);
                                  },
                                  onDownloadPressed: (){
                                    model.addToDownload(postId:model.recentlyViewedList[index].post.iD,hopper: model.recentlyViewedList[index]);
                                  },
                                );
                              },
                              /*separatorBuilder: (context, index) => Divider(
                            height: 1,
                          ),*/
                              itemCount: model.recentlyViewedList.length>=3?3:model.recentlyViewedList.length,
                            ),
                          ),
                          HopperListHeader(
                            title: "DOWNLOADED",
                            onSeeAllClicked: (){
                              Navigator.pushNamed(context, AppRoutes.seeAllHopperRoute,
                                  arguments: ["DOWNLOADED",model.downloadedList,model]);
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
                                    if(AudioConstant.audioIsPlaying){
                                      AudioConstant.audioViewModel.player.stop();
                                    }
                                    AudioConstant.FROM_BOTTOM=false;
                                    HomeBloc.switchPageToPalying(model.downloadedList[index].post.iD);
                                  },
                                  onThreeDotPressed: (){
                                    showSortBottomSheetDialog(model.downloadedList[index],false,model);
                                  },
                                  onDownloadPressed: (){

                                  },
                                );
                              },
                              /* separatorBuilder: (context, index) => Divider(
                            height: 1,
                          ),*/
                              itemCount: model.downloadedList.length>=3?3:model.downloadedList.length,
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                        visible: model.downloadLoadingState==LoadingState.Loading,
                        child:Positioned.fill(
                            child: CenterCircularProgressIndicator()
                        )
                    )
                  ],
                )
              )
    ]))));
  }

  void showSortBottomSheetDialog(Hopper hopper,bool fromMyhopper, HopperViewModel model) {
    CustomDialog.showCustomBottomSheet(
        context,
        backgroundColor: Colors.white,
        content:HopperBottomSheetPage(
          hopper: hopper,
          fromMyHopper: fromMyhopper,
          model: model,
          fromSeeAll: false,
        )
    );
  }

}
