import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/home.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_hopper/utils/custom_dialog.dart';
import 'package:flutter_hopper/utils/termandcondition_utils.dart';
import 'package:flutter_hopper/viewmodels/main_home_viewmodel.dart';
import 'package:flutter_hopper/viewmodels/playing.viewmodel.dart';
import 'package:flutter_hopper/views/playing/bottom_dialog_page.dart';
import 'package:flutter_hopper/views/playing/currently_playing_slider.dart';
import 'package:flutter_hopper/views/playing/player_controllers.dart';
import 'package:flutter_hopper/views/playing/publish_by_item.dart';
import 'package:flutter_hopper/widgets/empty/empty_playing.dart';
import 'package:share_plus/share_plus.dart';
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
import 'package:intl/intl.dart';
import 'package:flutter_hopper/utils/flash_alert.dart';
import 'package:flutter_hopper/widgets/platform/center_progress_bar.dart';

class PlayingPage extends StatefulWidget {
  const PlayingPage({Key key}) : super(key: key);

  @override
  _PlayingPageState createState() => _PlayingPageState();

}

class _PlayingPageState extends State<PlayingPage> with AutomaticKeepAliveClientMixin<PlayingPage> {
  @override
  bool get wantKeepAlive => true;
  Widget pageBody;
  String dynamicShortLink;
  List<String> sleepList=["Off","In 5 mins","In 15 mins","In 30 mins","In an hour","When current article ends","Cancel"];
  List<String> speedList=["x1.0","x1.25","x1.5","Cancel"];

  HomeBloc _homeBloc=HomeBloc();
  bool ADDED=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _homeBloc.showAlert.listen((show) {
      //when asked to show an alert
      if (show) {
        if (_homeBloc.dialogData.title == "Successfully added to MyHopper!") {
          ShowFlash(context,
              title: _homeBloc.dialogData.title,
              message: _homeBloc.dialogData.body,
              flashType: FlashType.success)
              .show();
          setState(() {
            ADDED=true;
          });
        } else {
          ShowFlash(context,
              title: _homeBloc.dialogData.title,
              message: _homeBloc.dialogData.body,
              flashType: FlashType.failed)
              .show();
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(HomeBloc.postID!=0){
       pageBody=ViewModelBuilder<PlayingViewModel>.reactive(
          viewModelBuilder: () => PlayingViewModel(context),
          onModelReady: (model) => model.getPlayingDetails(),
          builder: (context, model, child) => Scaffold(
              body: Stack(
                children: [
                  SafeArea(
                    child: model.playingLoadingState == LoadingState.Loading?
                    Padding(padding:AppPaddings.defaultPadding(),child:VendorShimmerListViewItem())
                        : model.playingLoadingState == LoadingState.Failed?
                    Padding(padding:AppPaddings.defaultPadding(),child:LoadingStateDataView(
                      stateDataModel: StateDataModel(
                        showActionButton: true,
                        actionButtonStyle: AppTextStyle.h4TitleTextStyle(
                          color: Colors.red,
                        ),
                        actionFunction: model.getPlayingDetails,
                      ),
                    ))
                        :model.playingData==null?
                    Center(
                      // padding: EdgeInsets.only(),
                        child: EmptyPlayingPage()
                    )
                        :Column(
                      children: [
                        Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: model.playingData.coverImageUrl??"",
                              placeholder: (context, url) => Container(
                                height: AppSizes.vendorImageHeight,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              height: AppSizes.getScreenheight(context)*0.25,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            /*Image.asset("assets/images/home_list.png",
                            height: AppSizes.getScreenheight(context)*0.25,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),*/
                            Positioned.fill(
                                child:Image.asset("assets/images/black_shadow.png",
                                  height: AppSizes.getScreenheight(context)*0.25,
                                  fit: BoxFit.fitHeight,
                                  width: double.infinity,
                                )),
                            Positioned(
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 20,top: 10),
                                    child: InkWell(child:Icon(
                                      Icons.arrow_back_outlined,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                      onTap: (){
                                        HomeBloc.switchPageToHome();
                                      },
                                    ),
                                  ),
                                  Expanded(
                                      child:Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 20,top: 10),
                                        child: InkWell(child: Icon(
                                          Icons.download_sharp,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                          onTap: (){
                                            model.addToDownload(postId: model.playingData.id);
                                          },
                                        ),
                                      )
                                  )
                                ],
                              ),
                            ),

                            Positioned(
                                width: AppSizes.getScreenWidth(context)-20,
                                top:(AppSizes.getScreenheight(context)*0.25)-40,
                                child: Row(
                                  children: [
                                    Padding(padding: EdgeInsets.only(left: 20),
                                        child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "By Author",
                                              style: AppTextStyle.h5TitleTextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.primaryColor,
                                                  fontStyle: FontStyle.italic
                                              ),
                                              textDirection: AppTextDirection.defaultDirection,
                                            ),
                                            Text(
                                              model.playingData.author??"",
                                              style: AppTextStyle.h4TitleTextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                              textDirection: AppTextDirection.defaultDirection,
                                            ),
                                          ],
                                        )),
                                    Flexible(child:
                                    Container(
                                        alignment: Alignment.centerRight,
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                                onTap: (){
                                                  showSortBottomSheetDialog(sleepList, "Sleep Timer",model);
                                                },
                                                child:Image.asset(
                                                  "assets/images/sleep_ic.png",
                                                  width: 28,
                                                  height: 28,
                                                )),
                                            SizedBox(
                                              width: 16,
                                            ),
                                            InkWell(
                                                onTap: (){
                                                  _generateDynamicLink();
                                                },
                                                child:Image.asset(
                                                  "assets/images/share_ic.png",
                                                  width: 28,
                                                  height: 28,
                                                )),
                                            SizedBox(
                                              width: 16,
                                            ),
                                            InkWell(
                                                onTap: (){
                                                  if(ADDED){
                                                    _homeBloc.addToMyHooper(postId: model.playingData.id);
                                                  }else{
                                                    model.playingData.isAdded=true;
                                                    ShowFlash(context,
                                                        title: "Already Added In MyHopper",
                                                        message: "Please try with some other article!",
                                                        flashType: FlashType.failed)
                                                        .show();
                                                  }
                                                },
                                                child:Image.asset(
                                                  "assets/images/play_ic.png",
                                                  width: 28,
                                                  height: 28,
                                                ))
                                          ],
                                        )
                                    )
                                    )

                                  ],
                                )
                            )

                          ],
                        ),
                        Expanded(child: SingleChildScrollView(
                          padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      flex: 7,
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: PublishItems(
                                          title: "Published By",
                                          subtitle: model.playingData.publication??"",
                                          iconPath: "assets/images/published_playing.png",
                                          timeData: parseDate(model.playingData.publicationDate??"19790401"),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: PublishItems(
                                          title: "Narrator",
                                          subtitle: model.playingData.narrator??"",
                                          iconPath: "assets/images/published_narrator.png",
                                          timeData: (model.playingData.audioFileDuration??"")+" mins",
                                        ),
                                      ))

                                ],
                              ),

                              Container(
                                padding: EdgeInsets.only(top: 16,bottom: 10),
                                child: Text(
                                    model.playingData.title.rendered??"",
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.h4TitleTextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500
                                    )),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(
                                    model.playingData.subHeader??"",
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.h5TitleTextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500
                                    )),
                              ),
                              Container(
                                padding: EdgeInsets.only(),
                                child: Text(
                                    model.playingData.postDescription??"",
                                    textAlign: TextAlign.left,
                                    style: AppTextStyle.h4TitleTextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500
                                    )),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 8),
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                    onTap: (){
                                     // if(model.playingData.url.isNotEmpty){
                                        Terms.lunchReadAlong(model.playingData.url??"");
                                     // }
                                    },
                                    child:Text(
                                        "read along",
                                        textAlign: TextAlign.left,
                                        style: AppTextStyle.h5TitleTextStyle(
                                            color: AppColor.accentColor,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                            fontStyle: FontStyle.italic
                                        ))),
                              ),

                            ],
                          ),
                        )),
                        Container(
                          height: AppSizes.getScreenheight(context)*0.20,
                          padding: EdgeInsets.only(left: 20,right: 20),
                          child: Column(
                            children: [
                              CurrentlyPlayingSlider(model: model,
                                onSpeedPressed: (){
                                  showSortBottomSheetDialog(speedList, "Play speed",model);
                                },),
                              UiSpacer.verticalSpace(),
                              PlayerControllButtons(model: model),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                      visible: model.playingLoadingState==LoadingState.Loading,
                      child:Positioned.fill(
                          child: CenterCircularProgressIndicator()
                      )
                  )
                ],
              )
          ));
    }else{
      pageBody=Center(
        // padding: EdgeInsets.only(),
        child: EmptyPlayingPage()
      );
    }
    return pageBody;
  }


  String parseDate(String date){
    String year=date.substring(0,4);
    String mm=date.substring(4,6);
    String dd=date.substring(6,8);


    String newDate=year+"/"+mm+"/"+dd;

    return DateFormat("MMMM dd, yyyy").format(DateFormat("yyyy/MM/dd").parse(newDate));

  }

  void showSortBottomSheetDialog(List<String> itemList,String title, PlayingViewModel model) {
    CustomDialog.showCustomBottomSheet(
        context,
        backgroundColor: Colors.white,
        content:BottomDialogSheetPage(
           title: title,
           itemlList: itemList,
          model: model,
        )
    );

  }

  void _share() async{
    Share.share("Check out this article from Hopper Audio! ${dynamicShortLink}");
  }

  void _generateDynamicLink() async{

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://audiohopper.page.link',
      link: Uri.parse('https://audiohopper.com/article?postID=${HomeBloc.postID}'),
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
