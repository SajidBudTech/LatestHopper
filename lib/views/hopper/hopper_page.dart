import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
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
                child:SingleChildScrollView(
                  primary: true,
                  padding: EdgeInsets.only(top: 20,bottom: 20),
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                    HopperListHeader(
                      title: "My Hopper",
                      onSeeAllClicked: (){

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
                          :ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap:true,
                        primary: false,
                        padding: AppPaddings.defaultPadding(),
                        itemBuilder: (context, index) {
                          return MyHopperListViewItem(
                             onPressed: (){
                               showSortBottomSheetDialog();
                             },
                          );
                        },
                       /* separatorBuilder: (context, index) => Container(
                          height: 8,
                        ),*/
                        itemCount: model.myHopperList.length,
                      ),
                    ),
                      HopperListHeader(
                        title: "RECENTLY VIEWED",
                        onSeeAllClicked: (){

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
                        ) : model.recentlyViewedList.length==0
                            ?EmptyHopper(title: "Nothing Added to Recently Viewed")
                            :ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap:true,
                          primary: false,
                          padding: AppPaddings.defaultPadding(),
                          itemBuilder: (context, index) {
                            return MyHopperListViewItem(
                              onPressed: (){
                                showSortBottomSheetDialog();
                              },
                            );
                          },
                          /*separatorBuilder: (context, index) => Divider(
                            height: 1,
                          ),*/
                          itemCount: model.recentlyViewedList.length,
                        ),
                      ),
                      HopperListHeader(
                        title: "DOWNLOADED",
                        onSeeAllClicked: (){

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
                        ) : model.downloadedList.length==0
                            ?EmptyHopper(title: "Nothing Added to Downloaded")
                            :ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap:true,
                          primary: false,
                          padding: AppPaddings.defaultPadding(),
                          itemBuilder: (context, index) {
                            return MyHopperListViewItem(
                              onPressed: (){
                                showSortBottomSheetDialog();
                              },
                            );
                          },
                         /* separatorBuilder: (context, index) => Divider(
                            height: 1,
                          ),*/
                          itemCount: model.downloadedList.length,
                        ),
                      )





                    ],
              ),
            ))
    ]))));
  }

  void showSortBottomSheetDialog() {
    CustomDialog.showCustomBottomSheet(
        context,
        backgroundColor: Colors.white,
        content:HopperBottomSheetPage()
    );

  }

}
