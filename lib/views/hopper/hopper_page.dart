
import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/home.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';
import 'package:flutter_hopper/models/recenctly_viewed_post.dart';
import 'package:flutter_hopper/utils/custom_dialog.dart';
import 'package:flutter_hopper/viewmodels/hopper.viewmodel.dart';
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
                                ? EmptyHopper(title: "No My Hopper to show")/*LoadingStateDataView(
                              stateDataModel: StateDataModel(
                                showActionButton: true,
                                title: "Internet Connectivity",
                                description: "Please check your internet connectivity and try again.",
                                actionButtonStyle: AppTextStyle.h4TitleTextStyle(
                                  color: Colors.red,
                                ),
                                actionFunction: model.initialise,
                              ),
                            )*/ : model.myHopperList.length==0
                                ?EmptyHopper(title: "Nothing Added to My Hopper")
                                : ReorderableListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap:true,
                              primary: false,
                              onReorder: (oldIndex,newIndex){
                                setState(() {

                                    /*final hopper = model.myHopperList.removeAt(oldIndex);
                                    model.myHopperList.insert(newIndex, hopper);

                                    if (AudioConstant.audioIsPlaying) {
                                      AudioConstant.audioViewModel.concatenatingAudioSource.removeAt(oldIndex + 1);
                                      AudioConstant.audioViewModel.concatenatingAudioSource.insert(newIndex+1, AudioSource.uri(Uri.parse(model.myHopperList[newIndex].postCustom.audioFile[0] ?? "")));
                                    }*/

                                  if (oldIndex < newIndex) {
                                    int end = newIndex - 1;
                                    final startItem = model.myHopperList[oldIndex];
                                    int i = 0;
                                    int local = oldIndex;
                                    do {
                                      model.myHopperList[local] = model.myHopperList[++local];
                                      i++;
                                    } while (i < end - oldIndex);
                                    model.myHopperList[end] = startItem;
                                    if(AudioConstant.audioIsPlaying){
                                        AudioConstant.audioViewModel.audioHopperHandler.removeQueueItem(AudioConstant.audioViewModel.allMediaItems[end]);
                                        AudioConstant.audioViewModel.audioHopperHandler.insertQueueItem(end, AudioConstant.audioViewModel.allMediaItems[end]);
                                        //AudioConstant.audioViewModel.concatenatingAudioSource.removeAt(oldIndex);
                                        //AudioConstant.audioViewModel.concatenatingAudioSource.insert(newIndex,AudioSource.uri(Uri.parse(model.myHopperList[newIndex].postCustom.audioFile[0]??"")));
                                    }
                                  }
                                  // dragging from bottom to top
                                  else if (oldIndex > newIndex) {
                                    final startItem = model.myHopperList[oldIndex];
                                    for (int i = oldIndex; i > newIndex; i--) {
                                      model.myHopperList[i] = model.myHopperList[i - 1];
                                    }
                                    model.myHopperList[newIndex] = startItem;
                                    if(AudioConstant.audioIsPlaying){
                                      AudioConstant.audioViewModel.audioHopperHandler.removeQueueItem(AudioConstant.audioViewModel.allMediaItems[newIndex]);
                                      AudioConstant.audioViewModel.audioHopperHandler.insertQueueItem(newIndex, AudioConstant.audioViewModel.allMediaItems[newIndex]);
                                      //AudioConstant.audioViewModel.concatenatingAudioSource.removeAt(oldIndex);
                                      //AudioConstant.audioViewModel.concatenatingAudioSource.insert(newIndex,AudioSource.uri(Uri.parse(model.myHopperList[newIndex].postCustom.audioFile[0]??"")));
                                    }
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
                                  model: model,
                                  onPressed: (){
                                      if(AudioConstant.audioIsPlaying){
                                        AudioConstant.audioViewModel.audioHopperHandler.stop();
                                      }
                                      if(HomeBloc.postID==model.myHopperList[index].post.iD){
                                        AudioConstant.FROM_BOTTOM=true;
                                      }else{
                                        AudioConstant.FROM_BOTTOM=false;
                                        if(AudioConstant.audioViewModel!=null) {
                                          AudioConstant.audioViewModel.audioHopperHandler.currentPosition = Duration.zero;
                                          AudioConstant.audioViewModel.audioHopperHandler.totalDuration = Duration.zero;
                                        }
                                      }
                                      AudioConstant.OFFLINE=false;
                                      HomeBloc.switchPageToPalying(model.myHopperList[index].post.iD);
                                   },
                                  onThreeDotPressed: (){
                                    showSortBottomSheetDialog(model.myHopperList[index],true,false,model);
                                  },
                                  /*onDownloadPressed: (){
                                    model.addToDownload(postId:model.myHopperList[index].post.iD,hopper: model.myHopperList[index],);
                                  },*/
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
                                ? EmptyHopper(title: "No Recently Viewed to show")/*LoadingStateDataView(
                              stateDataModel: StateDataModel(
                                showActionButton: true,
                                actionButtonStyle: AppTextStyle.h4TitleTextStyle(
                                  color: Colors.red,
                                ),
                                actionFunction: model.initialise,
                              ),
                            ) */: model.recentlyViewedList.length==0
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
                                  model: model,
                                  onPressed: (){
                                    if(AudioConstant.audioIsPlaying){
                                       AudioConstant.audioViewModel.audioHopperHandler.stop();
                                    }
                                    if(HomeBloc.postID==model.recentlyViewedList[index].post.iD){
                                      AudioConstant.FROM_BOTTOM=true;
                                    }else{
                                      AudioConstant.FROM_BOTTOM=false;
                                      if(AudioConstant.audioViewModel!=null) {
                                        AudioConstant.audioViewModel.audioHopperHandler.currentPosition = Duration.zero;
                                        AudioConstant.audioViewModel.audioHopperHandler.totalDuration = Duration.zero;
                                      }
                                    }

                                    AudioConstant.OFFLINE=false;
                                    HomeBloc.switchPageToPalying(model.recentlyViewedList[index].post.iD);

                                  },
                                  onThreeDotPressed: (){
                                    showSortBottomSheetDialog(model.recentlyViewedList[index],false,false,model);
                                  },
                                  /*onDownloadPressed: (){
                                    model.addToDownload(postId:model.recentlyViewedList[index].post.iD,hopper: model.recentlyViewedList[index]);
                                  },*/
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
                                  model: model,
                                  onPressed: (){

                                    if(AudioConstant.audioIsPlaying){
                                       AudioConstant.audioViewModel.audioHopperHandler.stop();
                                    }

                                    if(AudioConstant.audioViewModel!=null) {
                                      AudioConstant.audioViewModel.audioHopperHandler.currentPosition = Duration.zero;
                                      AudioConstant.audioViewModel.audioHopperHandler.totalDuration = Duration.zero;
                                    }
                                    AudioConstant.FROM_BOTTOM=false;
                                    AudioConstant.OFFLINE=true;
                                    AudioConstant.OFFLINECHANGE=true;
                                    AudioConstant.HOMEPOST=model.savedDownLoads[index];
                                    HomeBloc.switchPageToPalying(model.downloadedList[index].post.iD);

                                  },
                                  onThreeDotPressed: (){
                                    showSortBottomSheetDialog(model.downloadedList[index],false,true,model);
                                  },
                                 /* onDownloadPressed: (){

                                  },*/
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

  void showSortBottomSheetDialog(Hopper hopper,bool fromMyhopper,bool fromDownload, HopperViewModel model) {
    CustomDialog.showCustomBottomSheet(
        context,
        backgroundColor: Colors.white,
        content:HopperBottomSheetPage(
          hopper: hopper,
          fromMyHopper: fromMyhopper,
          fromDownload: fromDownload,
          model: model,
          fromSeeAll: false,
        )
    );
  }

}
