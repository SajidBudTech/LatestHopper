import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/bloc/login.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_strings.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_hopper/viewmodels/playing.viewmodel.dart';
import 'package:flutter_hopper/widgets/listview/bottom_dialog_listview_item.dart';
import 'package:flutter_hopper/widgets/listview/hopper_sort_listview_item.dart';

class BottomDialogSheetPage extends StatefulWidget {
  BottomDialogSheetPage({Key key, this.itemlList, this.title, this.model,this.sleeperTime})
      : super(key: key);

  final List<String> itemlList;
  final String title;
  final PlayingViewModel model;
  final sleeperTime;

  @override
  _BottomDialogSheetPageState createState() => _BottomDialogSheetPageState();
}

class _BottomDialogSheetPageState extends State<BottomDialogSheetPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext viewcontext) {
    return Container(
      color: Colors.white,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        UiSpacer.verticalSpace(),
        Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(
                left: AppPaddings.contentPaddingSize,
                right: AppPaddings.contentPaddingSize),
            //padding: EdgeInsets.only(),
            child: Text(
              widget.title ?? "",
              style: AppTextStyle.h3TitleTextStyle(
                  color: AppColor.accentColor, fontWeight: FontWeight.w500),
              textAlign: TextAlign.start,
              textDirection: AppTextDirection.defaultDirection,
            )),
        UiSpacer.verticalSpace(),
        //UiSpacer.divider(thickness: 0.3,color: AppColor.hintTextColor(context)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
              left: AppPaddings.contentPaddingSize,
              right: AppPaddings.contentPaddingSize),
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: widget.itemlList.length,
            //padding: EdgeInsets.only(left: AppPaddings.contentPaddingSize,right: AppPaddings.contentPaddingSize),
            separatorBuilder: (context, index) =>
                UiSpacer.horizontalSpace(space: 0),
            itemBuilder: (context, index) {
              return BottomDialogListViewItem(
                title: widget.itemlList[index],
                onPressed: (value) {
                  if (widget.title == "Play speed") {
                    if (value == 'x1.0') {
                      widget.model.setupSpeed(1.0);
                    } else if (value == 'x1.25') {
                      widget.model.setupSpeed(1.25);
                    } else if(value=='x1.5'){
                      widget.model.setupSpeed(1.5);
                    }
                  } else {
                    //"Off","In 5 mins","In 15 mins","In 30 mins","In an hour","When current article ends","Cancel";
                   // AuthBloc.prefs.setString(AppStrings.sleepTimerText, value);
                    AudioConstant.sleeperActiveTime=value;
                    if (value == "Off") {
                     // AuthBloc.prefs.setBool(AppStrings.isSleeperActive, false);
                      //AuthBloc.prefs.setString(AppStrings.sleepTimerText, "");
                      AudioConstant.isSleeperActive=false;
                      AudioConstant.sleeperActiveTime="";
                      AudioConstant.sleeperCloseTime=null;
                      widget.model.stopPlayerAfter(Duration.zero);

                    } else if (value == "In 5 mins") {
                      //AuthBloc.prefs.setBool(AppStrings.isSleeperActive, true);
                      AudioConstant.sleeperCloseTime=DateTime.now().add(Duration(minutes: 5));
                      AudioConstant.isSleeperActive=true;
                      widget.model.stopPlayerAfter(Duration(minutes: 5));
                    } else if (value == "In 15 mins") {
                     // AuthBloc.prefs.setBool(AppStrings.isSleeperActive, true);
                      AudioConstant.sleeperCloseTime=DateTime.now().add(Duration(minutes: 15));
                      AudioConstant.isSleeperActive=true;
                      widget.model.stopPlayerAfter(Duration(minutes: 15));
                    } else if (value == "In 30 mins") {
                     // AuthBloc.prefs.setBool(AppStrings.isSleeperActive, true);
                      AudioConstant.sleeperCloseTime=DateTime.now().add(Duration(minutes: 30));
                      AudioConstant.isSleeperActive=true;
                      widget.model.stopPlayerAfter(Duration(minutes: 30));
                    } else if (value == "In an hour") {
                      //AuthBloc.prefs.setBool(AppStrings.isSleeperActive, true);
                      AudioConstant.sleeperCloseTime=DateTime.now().add(Duration(hours: 1));
                      AudioConstant.isSleeperActive=true;
                      widget.model.stopPlayerAfter(Duration(hours: 1));
                    } else if (value == "When current article ends") {
                     // AuthBloc.prefs.setBool(AppStrings.isSleeperActive, true);
                      AudioConstant.isSleeperActive=true;
                      if(widget.model.audioHopperHandler.totalDuration!=null) {
                        AudioConstant.sleeperCloseTime=DateTime.now().add(Duration(seconds: widget.model.audioHopperHandler.totalDuration.inSeconds - widget.model.audioHopperHandler.currentPosition.inSeconds));
                        widget.model.stopPlayerAfter(Duration(seconds: widget.model.audioHopperHandler.totalDuration.inSeconds - widget.model.audioHopperHandler.currentPosition.inSeconds));
                      }
                    }
                  }

                   setState(() {
                     Navigator.pop(viewcontext);
                   });

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
