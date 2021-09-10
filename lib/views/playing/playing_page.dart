import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_hopper/viewmodels/main_home_viewmodel.dart';
import 'package:flutter_hopper/views/playing/currently_playing_slider.dart';
import 'package:flutter_hopper/views/playing/player_controllers.dart';
import 'package:flutter_hopper/views/playing/publish_by_item.dart';
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

class PlayingPage extends StatefulWidget {
  const PlayingPage({Key key}) : super(key: key);

  @override
  _PlayingPageState createState() => _PlayingPageState();
}

class _PlayingPageState extends State<PlayingPage>
    with AutomaticKeepAliveClientMixin<PlayingPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<MainHomeViewModel>.reactive(
        viewModelBuilder: () => MainHomeViewModel(context),
        onModelReady: (model) => model.initialise(),
        builder: (context, model, child) => Scaffold(
            body: SafeArea(
              child:Column(
                children: [
                  Stack(
                    children: [
                      Image.asset("assets/images/home_list.png",
                            height: AppSizes.getScreenheight(context)*0.25,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
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
                              child: Icon(
                                Icons.arrow_back_outlined,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child:Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20,top: 10),
                                child: Icon(
                                  Icons.download_sharp,
                                  size: 24,
                                  color: Colors.white,
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
                                        "Ira Robbins",
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
                                      Image.asset(
                                        "assets/images/sleep_ic.png",
                                        width: 28,
                                        height: 28,
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Image.asset(
                                        "assets/images/share_ic.png",
                                        width: 28,
                                        height: 28,
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Image.asset(
                                        "assets/images/play_ic.png",
                                        width: 28,
                                        height: 28,
                                      )
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
                               subtitle: "Trouser Press",
                               iconPath: "assets/images/published_playing.png",
                               timeData: "August 5, 2021",
                             ),
                           )),
                           Expanded(
                               flex: 4,
                               child: Align(
                                 alignment: Alignment.bottomRight,
                                 child: PublishItems(
                                   title: "Narrator",
                                   subtitle: "Rob Garson",
                                   iconPath: "assets/images/published_narrator.png",
                                   timeData: "10 Mins",
                                 ),
                               ))

                         ],
                       ),

                        Container(
                          padding: EdgeInsets.only(top: 16,bottom: 10),
                          child: Text(
                              "Rich Cohen\'s Rolling Stone Memoir Adds Meaningfully to the Canon",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.h4TitleTextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500
                              )),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                              "Pink Floyd\'s visionary founder",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.h5TitleTextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500
                              )),
                        ),
                        Container(
                          padding: EdgeInsets.only(),
                          child: Text(
                              "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here,",
                              textAlign: TextAlign.left,
                              style: AppTextStyle.h4TitleTextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500
                              )),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 8),
                          alignment: Alignment.centerRight,
                          child: Text(
                              "read along",
                              textAlign: TextAlign.left,
                              style: AppTextStyle.h5TitleTextStyle(
                                  color: AppColor.accentColor,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  fontStyle: FontStyle.italic
                              )),
                        ),

                      ],
                    ),
                  )),
               Container(
                 height: AppSizes.getScreenheight(context)*0.20,
                 padding: EdgeInsets.only(left: 20,right: 20),
                 child: Column(
                   children: [
                     CurrentlyPlayingSlider(),
                     UiSpacer.verticalSpace(),
                     PlayerControllButtons(),
                   ],
                 ),
                  )
                ],
              ),
            )));
  }

}
