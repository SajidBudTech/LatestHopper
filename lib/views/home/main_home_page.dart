import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/home.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';
import 'package:flutter_hopper/models/loading_state.dart';
import 'package:flutter_hopper/models/state_data_model.dart';
import 'package:flutter_hopper/viewmodels/main_home_viewmodel.dart';
import 'package:flutter_hopper/widgets/appbar/home_appbar.dart';
import 'package:flutter_hopper/widgets/listview/animated_vendor_list_view_item.dart';
import 'package:flutter_hopper/widgets/shimmers/vendor_shimmer_list_view_item.dart';
import 'package:flutter_hopper/widgets/state/state_loading_data.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/widgets/platform/center_progress_bar.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({Key key}) : super(key: key);

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage>
    with AutomaticKeepAliveClientMixin<MainHomePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<MainHomeViewModel>.reactive(
        viewModelBuilder: () => MainHomeViewModel(context),
        onModelReady: (model) => model.initHomeValue(),
        builder: (context, model, child) => Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  HomeAppBar(
                       imagePath: "assets/images/appbar_image.png",
                       backgroundColor: AppColor.accentColor,
                       visibleBottom: true,
                       onPressed: (value){
                         Navigator.pushNamed(context, AppRoutes.filterRoute,
                         arguments: [value,model]);
                       },
                  ),
              Expanded(
                child:Stack(
                    children: [
                      /*Expanded(
                          child:*/
                          CustomScrollView(slivers: [
                            SliverPadding(
                              padding: AppPaddings.defaultPadding(),
                              sliver:
                              model.mainHomeLoadingState == LoadingState.Loading
                              //the loadinng shimmer
                                  ? SliverToBoxAdapter(
                                child: VendorShimmerListViewItem(),
                              ) : model.mainHomeLoadingState == LoadingState.Failed
                                  ? SliverToBoxAdapter(child:LoadingStateDataView(
                                stateDataModel: StateDataModel(
                                  showActionButton: true,
                                  actionButtonStyle: AppTextStyle.h4TitleTextStyle(
                                    color: Colors.red,
                                  ),
                                  actionFunction: model.initHomeValue,
                                ),
                              ))
                                  :
                              //listing type
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    return AnimatedVendorListViewItem(
                                      index: index,
                                      homePost: model.mainhomeList[index],
                                      OnPressed: (){

                                        if(AudioConstant.audioIsPlaying){
                                          AudioConstant.audioViewModel.player.stop();
                                        }
                                        AudioConstant.FROM_BOTTOM=false;
                                        HomeBloc.switchPageToPalying(model.mainhomeList[index].id);
                                      },
                                    );
                                  },
                                  childCount: model.mainhomeList.length,
                                ),
                              ),
                            ),
                          ]),
                       //),
                      Visibility(
                          visible: model.mainHomeLoadingState==LoadingState.Loading,
                          child:Positioned.fill(
                              child: CenterCircularProgressIndicator()
                          )
                      )
                    ],
                  ))
                ],
              ),
             /* color: AppColor.pagebackgroundColor,
              padding: AppPaddings.defaultPadding(),
              child: CustomScrollView(slivers: [
                SliverToBoxAdapter(
                    child: Container(
                        alignment: Alignment.topLeft,
                        //padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Continue Listening',
                          style: AppTextStyle.h7TitleTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.start,
                          textDirection: AppTextDirection.defaultDirection,
                        ))),
                SliverToBoxAdapter(
                  child:UiSpacer.verticalSpace(space: 12),
                ),

                SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      height:177,
                      child: model.continueListeningLoadingState == LoadingState.Loading
                      //the loadinng shimmer
                          ? Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppPaddings.contentPaddingSize,
                        ),
                        child: VendorShimmerListViewItem(),
                      )
                      // the faild view
                          : model.continueListeningLoadingState == LoadingState.Failed
                          ? LoadingStateDataView(
                        stateDataModel: StateDataModel(
                          showActionButton: true,
                          actionButtonStyle: AppTextStyle.h4TitleTextStyle(
                            color: Colors.red,
                          ),
                          actionFunction: model.initialise,
                        ),
                      )
                          : ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: model.continueListeningList.length,
                        // padding: EdgeInsets.only(left: AppPaddings.contentPaddingSize,right: AppPaddings.contentPaddingSize),
                        separatorBuilder: (context, index) =>
                            UiSpacer.horizontalSpace(space: 0),
                        itemBuilder: (context, index) {
                          return ContinueListeningItem(
                            category: model.continueListeningList[index],
                            // onPressed: model.openCategorySearchPage,
                          );
                        },
                      ),
                    )
                ),
                SliverToBoxAdapter(
                  child:UiSpacer.verticalSpace(space: 12),
                ),
                SliverToBoxAdapter(
                    child: Container(
                        alignment: Alignment.topLeft,
                        //padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Best Sellers',
                          style: AppTextStyle.h7TitleTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.start,
                          textDirection: AppTextDirection.defaultDirection,
                        ))),
                SliverToBoxAdapter(
                  child:UiSpacer.verticalSpace(space: 12),
                ),

                SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      height:177,
                      child: model.bestSellerLoadingState == LoadingState.Loading
                      //the loadinng shimmer
                          ? Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppPaddings.contentPaddingSize,
                        ),
                        child: VendorShimmerListViewItem(),
                      )
                      // the faild view
                          : model.bestSellerLoadingState == LoadingState.Failed
                          ? LoadingStateDataView(
                        stateDataModel: StateDataModel(
                          showActionButton: true,
                          actionButtonStyle: AppTextStyle.h4TitleTextStyle(
                            color: Colors.red,
                          ),
                          actionFunction: model.initialise,
                        ),
                      )
                          : ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: model.bestSellerList.length,
                        //padding: EdgeInsets.only(left: AppPaddings.contentPaddingSize,right: AppPaddings.contentPaddingSize),
                        separatorBuilder: (context, index) =>
                            UiSpacer.horizontalSpace(space: 0),
                        itemBuilder: (context, index) {
                          return BestSellerListViewItem(
                            commonBook: model.bestSellerList[index],
                            // onPressed: model.openCategorySearchPage,
                          );
                        },
                      ),
                    )
                ),
                SliverToBoxAdapter(
                  child:UiSpacer.verticalSpace(space: 12),
                ),
                SliverToBoxAdapter(
                    child: Container(
                        alignment: Alignment.topLeft,
                        //padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'New Releases',
                          style: AppTextStyle.h7TitleTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.start,
                          textDirection: AppTextDirection.defaultDirection,
                        ))),
                SliverToBoxAdapter(
                  child:UiSpacer.verticalSpace(space: 12),
                ),

                SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      height:177,
                      child: model.newRealseLoadingState == LoadingState.Loading
                      //the loadinng shimmer
                          ? Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppPaddings.contentPaddingSize,
                        ),
                        child: VendorShimmerListViewItem(),
                      )
                      // the faild view
                          : model.newRealseLoadingState == LoadingState.Failed
                          ? LoadingStateDataView(
                        stateDataModel: StateDataModel(
                          showActionButton: true,
                          actionButtonStyle: AppTextStyle.h4TitleTextStyle(
                            color: Colors.red,
                          ),
                          actionFunction: model.initialise,
                        ),
                      )
                          : ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: model.newReleaseList.length,
                        // padding: EdgeInsets.only(left: AppPaddings.contentPaddingSize,right: AppPaddings.contentPaddingSize),
                        separatorBuilder: (context, index) =>
                            UiSpacer.horizontalSpace(space: 0),
                        itemBuilder: (context, index) {
                          return BestSellerListViewItem(
                            commonBook: model.newReleaseList[index],
                            // onPressed: model.openCategorySearchPage,
                          );
                        },
                      ),
                    )
                ),
                SliverToBoxAdapter(
                  child:UiSpacer.verticalSpace(space: 12),
                ),
                SliverToBoxAdapter(
                    child: Container(
                        alignment: Alignment.topLeft,
                        //padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Abantu Favorites",//'Independent Audiobooks',
                          style: AppTextStyle.h7TitleTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.start,
                          textDirection: AppTextDirection.defaultDirection,
                        ))),
                SliverToBoxAdapter(
                  child:UiSpacer.verticalSpace(space: 12),
                ),

                SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      height:177,
                      child: model.abantuFavoritesLoadingState == LoadingState.Loading
                      //the loadinng shimmer
                          ? Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppPaddings.contentPaddingSize,
                        ),
                        child: VendorShimmerListViewItem(),
                      )
                      // the faild view
                          : model.abantuFavoritesLoadingState == LoadingState.Failed
                          ? LoadingStateDataView(
                        stateDataModel: StateDataModel(
                          showActionButton: true,
                          actionButtonStyle: AppTextStyle.h4TitleTextStyle(
                            color: Colors.red,
                          ),
                          actionFunction: model.initialise,
                        ),
                      )
                          : ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: model.abantuFavoritesList.length,
                        // padding: EdgeInsets.only(left: AppPaddings.contentPaddingSize,right: AppPaddings.contentPaddingSize),
                        separatorBuilder: (context, index) =>
                            UiSpacer.horizontalSpace(space: 0),
                        itemBuilder: (context, index) {
                          return BestSellerListViewItem(
                            commonBook: model.abantuFavoritesList[index],
                            // onPressed: model.openCategorySearchPage,
                          );
                        },
                      ),
                    )
                ),

                SliverToBoxAdapter(
                    child:UiSpacer.verticalSpace(space: 20)
                )




              ]),

*//*
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[*//*
              *//*Container(
                        width: double.infinity,
                          height: 150,
                          padding: AppPaddings.defaultPadding(),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                                colors: [
                                  AppColor.primaryColorDark,
                                  AppColor.primaryColor
                                ]),
                          ),
                    child:Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                  flex:8,
                                  child:Container(
                                      alignment: Alignment.topLeft,
                                      padding: EdgeInsets.only(left: 20),
                                      child:Text(
                                        'PADEL',
                                        style: AppTextStyle.h2TitleTextStyle(
                                            color:Colors.white,
                                            fontWeight: FontWeight.w700
                                        ),
                                        textAlign: TextAlign.start,
                                        textDirection: AppTextDirection.defaultDirection,
                                      ))),
                              Expanded(
                                  flex:2,
                                  child:InkWell(
                                  onTap: (){
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.notificationsRoute,
                                    );
                                  },
                                  child:CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(FlutterIcons.notifications_mdi,color: AppColor.primaryColorDark,size: 28,)
                                  )
                                  )
                              )

                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: SearchBar(
                            hintText: 'Search',
                            onSearchBarPressed: null,
                            onSubmit: _searchVendorsBloc.initSearch,
                            focusNode: _searchBarFocusNode,
                            onItemChanged: (text)=>model.onSearchTextChanged(text),
                          ),
                        )
                      ],
                    )),
                  Expanded(
                      child: CustomScrollView(slivers: [
                    SliverPadding(
                      padding: AppPaddings.defaultPadding(),
                      sliver:
                          model.branchesLoadingState == LoadingState.Loading
                              //the loadinng shimmer
                              ? SliverToBoxAdapter(
                                  child: VendorShimmerListViewItem(),
                                )
                              :
                              //listing type
                              SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return AnimatedVendorListViewItem(
                                        index: index,
                                        branchDetails: model.searchResult[index],
                                      );
                                    },
                                    childCount: model.searchResult.length,
                                  ),
                                ),
                    ),
                  ])),
*//*

              //   ]
              // )*/
            )));
  }

  Widget _getSectionTitle(String title, context) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppPaddings.contentPaddingSize,
        ),
        child: Text(
          title,
          style: AppTextStyle.h3TitleTextStyle(
            color: AppColor.textColor(context),
          ),
        ),
      ),
    );
  }

  void callBanner() async {
    Navigator.pushNamed(
      context,
      AppRoutes.categoryVendorsRoute,
    );
  }
}
