import 'package:flutter/material.dart';
import 'package:flutter_hopper/models/loading_state.dart';
import 'package:flutter_hopper/models/state_data_model.dart';
import 'package:flutter_hopper/viewmodels/main_home_viewmodel.dart';
import 'package:flutter_hopper/widgets/appbar/common_app_bar.dart';
import 'package:flutter_hopper/widgets/buttons/custom_button.dart';
import 'package:flutter_hopper/widgets/shimmers/vendor_shimmer_list_view_item.dart';
import 'package:flutter_hopper/widgets/state/state_loading_data.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_hopper/bloc/login.bloc.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:stacked/stacked.dart';

class HomeFilterPage extends StatefulWidget {
  HomeFilterPage({Key key,this.title}) : super(key: key);

  String title;
  @override
  _HomeFilterPageState createState() => _HomeFilterPageState();
}

class _HomeFilterPageState extends State<HomeFilterPage> {
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
      onModelReady: (model) => model.getHomeCategoryDetails(),
      builder: (context, model, child) => Scaffold(
          body: SafeArea(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CommonAppBar(
                      title: widget.title??"",
                      backgroundColor: AppColor.accentColor,
                      capitalized: false,
                      onPressed: (){
                        Navigator.pop(context, false);
                      },
                    ),
                    UiSpacer.verticalSpace(),

                    Expanded(
                        child: Container(
                            padding: EdgeInsets.only(left: 20,right: 20),
                            child: model.mainHomeLoadingState == LoadingState.Loading
                            //the loadinng shimmer
                                ?  VendorShimmerListViewItem()
                                : model.mainHomeLoadingState == LoadingState.Failed
                                ? LoadingStateDataView(
                              stateDataModel: StateDataModel(
                                showActionButton: true,
                                actionButtonStyle: AppTextStyle.h4TitleTextStyle(
                                  color: Colors.red,
                                ),
                                actionFunction: model.getHomeCategoryDetails,
                              ),
                            )
                                :
                            ListView(
                              shrinkWrap: true,
                              primary: true,
                              scrollDirection: Axis.vertical,
                              physics: AlwaysScrollableScrollPhysics(),
                              children: model.filterCategoryMap.keys.map((String key) {
                                return new CheckboxListTile(
                                  title: new Text(key,
                                  style: AppTextStyle.h4TitleTextStyle(
                                    color: model.filterCategoryMap[key]?AppColor.accentColor:Colors.black,),
                                  ),
                                  value: model.filterCategoryMap[key],
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  activeColor: AppColor.accentColor,
                                  checkColor: Colors.white,
                                  onChanged: (bool value) {
                                    setState(() {
                                      model.filterCategoryMap[key] = value;
                                    });
                                  },
                                );
                              }).toList(),
                        ))),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                            child:Container(
                                width: double.infinity,
                                child:CustomButton(
                                  padding: EdgeInsets.only(top: 20,bottom: 20),
                                  color: AppColor.accentColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    //side: BorderSide(color: Colors.red)
                                  ),
                                  onPressed:
                                       (){

                                    },
                                  child: Text(
                                    "CLEAR ALL",
                                    style: AppTextStyle.h4TitleTextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500
                                    ),
                                    textAlign: TextAlign.start,
                                    textDirection:
                                    AppTextDirection.defaultDirection,
                                  ),
                                ))),
                            Container(
                              width: 1,
                            ),
                            Expanded(
                                child:Container(
                                    width: double.infinity,
                                    child:CustomButton(
                                      padding: EdgeInsets.only(top: 20,bottom: 20),
                                      color: AppColor.accentColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(0),
                                          //side: BorderSide(color: Colors.red)
                                      ),
                                      onPressed:
                                          (){

                                      },
                                      child: Text(
                                        "APPLY",
                                        style: AppTextStyle.h4TitleTextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500
                                        ),
                                        textAlign: TextAlign.start,
                                        textDirection:
                                        AppTextDirection.defaultDirection,
                                      ),
                                    )))
                          ],
                        ),
                      )
                  ]))),
    );
  }
}
