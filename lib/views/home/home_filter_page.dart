import 'package:flutter/material.dart';
import 'package:flutter_hopper/models/home_category.dart';
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
  HomeFilterPage({Key key,this.title,this.model}) : super(key: key);
  String title;
  MainHomeViewModel model;

  @override
  _HomeFilterPageState createState() => _HomeFilterPageState();
}

class _HomeFilterPageState extends State<HomeFilterPage> {
  //SearchVendorsBloc instance

  LoginBloc _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();

    if(widget.model.filterCategoryMap.length==0){
      for(HomeCategory homeCategory in widget.model.mainhomeCategory){
        widget.model.filterCategoryMap.putIfAbsent(homeCategory.name??"", () => false);
      }
    }
    if(widget.model.filterAuthorMap.length==0){
      for(String author in widget.model.mainhomeAuthor){
        widget.model.filterAuthorMap.putIfAbsent(author??"", () => false);
      }
    }
    if(widget.model.filterPublicationMap.length==0){
      for(String author in widget.model.mainhomePublication){
        widget.model.filterPublicationMap.putIfAbsent(author??"", () => false);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            body: SafeArea(
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CommonAppBar(
                        title: widget.title ?? "",
                        backgroundColor: AppColor.accentColor,
                        capitalized: false,
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                      UiSpacer.verticalSpace(),

                      Expanded(
                          child: Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: /*model.mainHomeLoadingState == LoadingState.Loading
                              //the loadinng shimmer
                                  ? VendorShimmerListViewItem()
                                  : model.mainHomeLoadingState == LoadingState.Failed
                                  ? LoadingStateDataView(
                                stateDataModel: StateDataModel(
                                  showActionButton: true,
                                  actionButtonStyle: AppTextStyle
                                      .h4TitleTextStyle(
                                    color: Colors.red,
                                  ),
                                  actionFunction: () {
                                    widget.title == "CATEGORY" ? widget.model
                                        .getHomeCategoryDetails() :
                                    (widget.title == "AUTHOR" ? widget.model
                                        .getHomeAuthotDetails() : widget.model
                                        .getHomePublicationDetails());
                                  },
                                ),
                              )
                                  :*/
                              ListView(
                                shrinkWrap: true,
                                primary: true,
                                scrollDirection: Axis.vertical,
                                physics: AlwaysScrollableScrollPhysics(),
                                children: widget.title == "CATEGORY"
                                    ?
                                widget.model.filterCategoryMap.keys.map((
                                    String key) {
                                  return new CheckboxListTile(
                                    title: new Text(key,
                                      style: AppTextStyle.h4TitleTextStyle(
                                        color: widget.model.filterCategoryMap[key] ? AppColor
                                            .accentColor : Colors.black,),
                                    ),
                                    value: widget.model.filterCategoryMap[key],
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppColor.accentColor,
                                    checkColor: Colors.white,
                                    onChanged: (bool value) {
                                      setState(() {
                                        widget.model.filterCategoryMap[key] =
                                            value;
                                      });
                                    },
                                  );
                                }).toList()
                                    : widget.title == "AUTHOR"
                                    ? widget.model.filterAuthorMap.keys.map((
                                    String key) {
                                  return new CheckboxListTile(
                                    title: new Text(key,
                                      style: AppTextStyle.h4TitleTextStyle(
                                        color: widget.model.filterAuthorMap[key]
                                            ? AppColor.accentColor
                                            : Colors.black,),
                                    ),
                                    value: widget.model.filterAuthorMap[key],
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppColor.accentColor,
                                    checkColor: Colors.white,
                                    onChanged: (bool value) {
                                      setState(() {
                                        widget.model.filterAuthorMap[key] = value;
                                      });
                                    },
                                  );
                                }).toList()
                                    : widget.model.filterPublicationMap.keys
                                    .map((String key) {
                                  return new CheckboxListTile(
                                    title: new Text(key,
                                      style: AppTextStyle.h4TitleTextStyle(
                                        color: widget.model.filterPublicationMap[key]
                                            ? AppColor.accentColor
                                            : Colors.black,),
                                    ),
                                    value: widget.model.filterPublicationMap[key],
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: AppColor.accentColor,
                                    checkColor: Colors.white,
                                    onChanged: (bool value) {
                                      setState(() {
                                        widget.model.filterPublicationMap[key] = value;
                                      });
                                    },
                                  );
                                }).toList(),
                              ))),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                                    width: double.infinity,
                                    child: CustomButton(
                                      padding: EdgeInsets.only(
                                          top: 20, bottom: 20),
                                      color: AppColor.accentColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                        //side: BorderSide(color: Colors.red)
                                      ),
                                      onPressed:
                                          () {
                                            widget.model.clearAll();
                                            Navigator.pop(context);
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
                                child: Container(
                                    width: double.infinity,
                                    child: CustomButton(
                                      padding: EdgeInsets.only(
                                          top: 20, bottom: 20),
                                      color: AppColor.accentColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                        //side: BorderSide(color: Colors.red)
                                      ),
                                      onPressed:
                                          () {
                                            widget.model.applyFilter();
                                            Navigator.pop(context);
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
                    ]))
        );
   //   }
    //);
  }
}
