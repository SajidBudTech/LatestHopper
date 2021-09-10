import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/bloc/login.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_hopper/widgets/listview/hopper_sort_listview_item.dart';


class HopperBottomSheetPage extends StatefulWidget {
  HopperBottomSheetPage({
    Key key,
  }) : super(key: key);

  @override
  _HopperBottomSheetPageState createState() => _HopperBottomSheetPageState();


}

class _HopperBottomSheetPageState extends State<HopperBottomSheetPage> {

  List<String> sortlist=["Add to My Hopper","Remove download","Read along","Cancel"];

  @override
  Widget build(BuildContext viewcontext) {
    return Container(
      color: Colors.white,
      child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UiSpacer.verticalSpace(),
            Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: AppPaddings.contentPaddingSize,right: AppPaddings.contentPaddingSize),
                //padding: EdgeInsets.only(),
                child:Text(
                  'Rock and Roll Globe',
                  style: AppTextStyle.h3TitleTextStyle(
                      color: AppColor.accentColor,
                      fontWeight: FontWeight.w500
                  ),
                  textAlign: TextAlign.start,
                  textDirection: AppTextDirection.defaultDirection,
                )),
            UiSpacer.verticalSpace(space: 8),
            Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: AppPaddings.contentPaddingSize,right: AppPaddings.contentPaddingSize),
                //padding: EdgeInsets.only(),
                child:Text(
                  'Pediatricians plead with FDA to move quickly on covid vaccine for kids',
                  style: AppTextStyle.h4TitleTextStyle(
                      color: AppColor.textColor(context),
                      fontWeight: FontWeight.w500
                  ),
                  textAlign: TextAlign.start,
                  textDirection: AppTextDirection.defaultDirection,
                )),
            UiSpacer.verticalSpace(space: 36),
            //UiSpacer.divider(thickness: 0.3,color: AppColor.hintTextColor(context)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: AppPaddings.contentPaddingSize,right: AppPaddings.contentPaddingSize),
              child:  ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: sortlist.length,
                //padding: EdgeInsets.only(left: AppPaddings.contentPaddingSize,right: AppPaddings.contentPaddingSize),
                separatorBuilder: (context, index) =>
                    UiSpacer.horizontalSpace(space: 0),
                itemBuilder: (context, index) {
                  return HopperSortListViewItem(
                    notification:sortlist[index],
                    onPressed: (){
                      Navigator.pop(viewcontext);
                    },
                  );
                },
              ),
            ),
            UiSpacer.verticalSpace(space: 40)

          ]),

    );
  }
}
