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
import 'package:flutter_hopper/widgets/appbar/see_all_appbar.dart';
import 'package:flutter_hopper/widgets/empty/hopper_empty.dart';
import 'package:flutter_hopper/widgets/listview/myhopper_listview_item.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:just_audio/just_audio.dart';

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
                      SeeAllAppBar(
                        imagePath: "assets/images/appbar_image.png",
                        backgroundColor: AppColor.accentColor,
                        onPressed: (){
                          Navigator.pop(context, false);
                        },
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
                                      : widget.title=="My Hopper"?
                                  ReorderableListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap:true,
                                    primary: false,
                                    onReorder: (oldIndex,newIndex){
                                      setState(() {
                                        /*final hopper=widget.model.myHopperList.removeAt(oldIndex);
                                        widget.model.myHopperList.insert(newIndex, hopper);
                                        if(AudioConstant.audioIsPlaying){
                                          AudioConstant.audioViewModel.concatenatingAudioSource.removeAt(oldIndex+1);
                                          AudioConstant.audioViewModel.concatenatingAudioSource.insert(newIndex+1,AudioSource.uri(Uri.parse(widget.model.myHopperList[newIndex].postCustom.audioFile[0]??"")));
                                        }*/
                                       // dragging from top to bottom
                                        if (oldIndex < newIndex) {
                                          int end = newIndex - 1;
                                          final startItem = widget.model.myHopperList[oldIndex];
                                          int i = 0;
                                          int local = oldIndex;
                                          do {
                                            widget.model.myHopperList[local] = widget.model.myHopperList[++local];
                                            i++;
                                          } while (i < end - oldIndex);

                                          widget.model.myHopperList[end] = startItem;
                                          if(AudioConstant.audioIsPlaying){
                                            AudioConstant.audioViewModel.audioHopperHandler.removeQueueItem(AudioConstant.audioViewModel.allMediaItems[end]);
                                            AudioConstant.audioViewModel.audioHopperHandler.insertQueueItem(end, AudioConstant.audioViewModel.allMediaItems[end]);
                                            //AudioConstant.audioViewModel.concatenatingAudioSource.removeAt(oldIndex);
                                            //AudioConstant.audioViewModel.concatenatingAudioSource.insert(newIndex,AudioSource.uri(Uri.parse(model.myHopperList[newIndex].postCustom.audioFile[0]??"")));
                                          }
                                        }
                                        // dragging from bottom to top
                                        else if (oldIndex > newIndex) {
                                          final startItem = widget.model.myHopperList[oldIndex];
                                          for (int i = oldIndex; i > newIndex; i--) {
                                            widget.model.myHopperList[i] = widget.model.myHopperList[i - 1];
                                          }
                                          widget.model.myHopperList[newIndex] = startItem;
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
                                        key: ValueKey(widget.model.myHopperList[index]),
                                        hopper: widget.model.myHopperList[index],
                                        showDownload: true,
                                        showAddTOPlayer: false,
                                        model: widget.model,
                                         onPressed: (){
                                          if(AudioConstant.audioIsPlaying){
                                            AudioConstant.audioViewModel.audioHopperHandler.stop();
                                          }
                                          if(HomeBloc.postID==widget.model.myHopperList[index].post.iD){
                                            AudioConstant.FROM_BOTTOM=true;
                                          }else{
                                            AudioConstant.FROM_BOTTOM=false;
                                            if(AudioConstant.audioViewModel!=null) {
                                              AudioConstant.audioViewModel.audioHopperHandler.currentPosition = Duration.zero;
                                              AudioConstant.audioViewModel.audioHopperHandler.totalDuration = Duration.zero;
                                            }
                                          }
                                          AudioConstant.OFFLINE=false;
                                          HomeBloc.switchPageToPalying(widget.model.myHopperList[index].post.iD);
                                          Navigator.pop(context, false);
                                        },
                                        onThreeDotPressed: (){
                                          showSortBottomSheetDialog(widget.model.myHopperList[index],true,false,widget.model);
                                        },
                                        /*onDownloadPressed: (){
                                    model.addToDownload(postId:model.myHopperList[index].post.iD,hopper: model.myHopperList[index],);
                                  },*/
                                      );
                                    },
                                    itemCount: widget.model.myHopperList.length,
                                  )

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
                                        model: widget.model,
                                        onPressed: (){

                                          if(widget.title=="RECENTLY VIEWED") {
                                            if (AudioConstant.audioIsPlaying) {
                                              AudioConstant.audioViewModel.audioHopperHandler.stop();
                                            }
                                            if (HomeBloc.postID == widget.model.recentlyViewedList[index].post.iD) {
                                              AudioConstant.FROM_BOTTOM = true;
                                            } else {
                                              AudioConstant.FROM_BOTTOM = false;
                                              if(AudioConstant.audioViewModel!=null) {
                                                AudioConstant.audioViewModel.audioHopperHandler.currentPosition = Duration.zero;
                                                AudioConstant.audioViewModel.audioHopperHandler.totalDuration = Duration.zero;
                                              }
                                            }

                                            AudioConstant.OFFLINE = false;
                                            HomeBloc.switchPageToPalying(widget.model.recentlyViewedList[index].post.iD);
                                          }else if(widget.title=="DOWNLOADED"){
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
                                            AudioConstant.HOMEPOST=widget.model.savedDownLoads[index];
                                            HomeBloc.switchPageToPalying(widget.model.downloadedList[index].post.iD);
                                          }
                                          Navigator.pop(context, false);
                                        },
                                        onThreeDotPressed: (){
                                          if(widget.title=="RECENTLY VIEWED") {
                                            showSortBottomSheetDialog(widget.model.recentlyViewedList[index],false,false, widget.model);
                                           }else if(widget.title=="DOWNLOADED"){
                                            showSortBottomSheetDialog(widget.model.downloadedList[index],false,true,widget.model);
                                           }
                                          },
                                      );
                                    },

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

  void showSortBottomSheetDialog(Hopper hopper,bool fromMyhopper,bool fromDownload, HopperViewModel model) {
     CustomDialog.showCustomBottomSheet(
        context,
        backgroundColor: Colors.white,
        content:HopperBottomSheetPage(
          hopper: hopper,
          fromMyHopper: fromMyhopper,
          fromDownload: fromDownload,
          model: model,
          fromSeeAll: true,
        ),
    );
  }

}
