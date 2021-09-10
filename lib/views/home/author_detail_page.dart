import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/models/loading_state.dart';
import 'package:flutter_hopper/models/state_data_model.dart';
import 'package:flutter_hopper/viewmodels/main_home_viewmodel.dart';
import 'package:flutter_hopper/widgets/appbar/common_app_bar.dart';
import 'package:flutter_hopper/widgets/appbar/custom_appbar.dart';
import 'package:flutter_hopper/widgets/empty/hopper_empty.dart';
import 'package:flutter_hopper/widgets/listview/author_detial_listview_item.dart';
import 'package:flutter_hopper/widgets/listview/notification_listview_item.dart';
import 'package:flutter_hopper/widgets/shimmers/vendor_shimmer_list_view_item.dart';
import 'package:flutter_hopper/widgets/state/state_loading_data.dart';
import 'package:flutter_hopper/bloc/login.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:stacked/stacked.dart';

class AuthorDetailPage extends StatefulWidget {
  AuthorDetailPage({Key key}) : super(key: key);

  @override
  _AuthorDetailPageState createState() => _AuthorDetailPageState();
}

class _AuthorDetailPageState extends State<AuthorDetailPage> {
  //SearchVendorsBloc instance

  LoginBloc _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainHomeViewModel>.reactive(
      viewModelBuilder: () => MainHomeViewModel(context),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) => Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomAppBar(
                  title: "Gillian G.Gaar",
                  backgroundColor: AppColor.accentColor,
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                // UiSpacer.verticalSpace(),
                Expanded(
                  child: model.mainHomeLoadingState == LoadingState.Loading
                      ? Padding(padding: EdgeInsets.only(left: 20,right: 20),child:VendorShimmerListViewItem())
                      : model.mainHomeLoadingState == LoadingState.Failed
                      ? LoadingStateDataView(
                    stateDataModel: StateDataModel(
                      showActionButton: true,
                      actionButtonStyle: AppTextStyle.h4TitleTextStyle(
                        color: Colors.red,
                      ),
                      actionFunction: model.initialise,
                    ),
                  ) : model.homeList.length==0
                      ?EmptyHopper(title: "Nothing added to this author!")
                      :ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap:true,
                    primary: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: AppPaddings.defaultPadding(),
                    itemBuilder: (context, index) {
                      return AuthorListViewItem(
                        onPressed: (){

                        },
                      );
                    },
                    itemCount: model.homeList.length,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
