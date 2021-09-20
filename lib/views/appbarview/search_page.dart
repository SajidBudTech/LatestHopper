import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/search_hopper.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/constants/strings/search.strings.dart';
import 'package:flutter_hopper/models/home_post.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_hopper/widgets/appbar/empty_appbar.dart';
import 'package:flutter_hopper/widgets/buttons/custom_button.dart';
import 'package:flutter_hopper/widgets/empty/hopper_empty.dart';
import 'package:flutter_hopper/widgets/search/search_bar.dart';
import 'package:flutter_hopper/widgets/search/search_groupedlist_view.dart';

class SearchHopperPage extends StatefulWidget {
  SearchHopperPage({Key key}) : super(key: key);

  @override
  _SearchHopperPageState createState() => _SearchHopperPageState();
}

class _SearchHopperPageState extends State<SearchHopperPage> {
  //SearchVendorsBloc instance
  final SearchHopperBloc _searchHopperBloc = SearchHopperBloc();

  //search bar focus node
  final _searchBarFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchBarFocusNode.requestFocus();
    _searchHopperBloc.initBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _searchHopperBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackground(context),
      appBar: EmptyAppBar(
        backgroundColor: AppColor.appBackground(context),
        brightness: MediaQuery.of(context).platformBrightness,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            //vendors
            Positioned(
              //if you are using CustomAppbar
              //use this AppSizes.customAppBarHeight
              //or this AppSizes.secondCustomAppBarHeight, if you are using the second custom appbar
              top: AppSizes.secondCustomAppBarHeight,
              left: 0,
              right: 0,
              bottom: 0,
              child: ListView(
                //padding: AppPaddings.defaultPadding(),
                padding: EdgeInsets.fromLTRB(
                  AppPaddings.contentPaddingSize,
                  0,
                  //MediaQuery.of(context).size.height * 0.10,
                  AppPaddings.contentPaddingSize,
                  AppPaddings.contentPaddingSize,
                ),
                children: <Widget>[
                  //Resut
                  StreamBuilder<List<HomePost>>(
                    stream: _searchHopperBloc.searchPosts,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return EmptyHopper(
                          title: "No Search Found, Please try again with another filter or keyword",
                        );
                      }
                      return SearchGroupedVendorsListView(
                        title: "Search Results",
                        searchPosts: snapshot.data,
                        titleTextStyle: AppTextStyle.h3TitleTextStyle(
                          color: AppColor.textColor(context),
                        ), //products: snapshot.data,
                      );
                    },
                  ),
                ],
              ),
            ),

            //filter and search header/bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              //normal
              child: Container(
                // height: AppSizes.secondCustomAppBarHeight,
                padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                decoration: BoxDecoration(
                    color: AppColor.accentColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                    )
                ),
                child:Row(
                      textDirection: AppTextDirection.defaultDirection,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        //close button
                        Expanded(
                            child:SearchBar(
                              onSearchBarPressed: null,
                              hintText: "Type here",
                              readOnly: false,
                              onSubmit: _searchHopperBloc.initSearch,
                              focusNode: _searchBarFocusNode,
                            )),

                      ],
                    ),
                    //UiSpacer.verticalSpace(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
