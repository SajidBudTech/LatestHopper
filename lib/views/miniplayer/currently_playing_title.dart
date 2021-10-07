import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/viewmodels/playing.viewmodel.dart';

class CurrentlyPlayingText extends StatefulWidget {

  double fontSize;
  TextAlign textAlign;
  String title;
  String subtitle;

  PlayingViewModel model;

  CurrentlyPlayingText({this.fontSize, this.textAlign = TextAlign.left, this.model});
  @override _CurrentlyPlayingTextState createState() => _CurrentlyPlayingTextState();

}
class _CurrentlyPlayingTextState extends State<CurrentlyPlayingText> {

  String description;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    description=widget.model.myPlayList[widget.model.currentPlayingIndex].trackDescription??"";
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: widget.model.player.currentIndexStream,
        builder: (context, snapshot){
      if (snapshot.data != null) {
        description=widget.model.myPlayList[snapshot.data].trackDescription??"";
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(),
              alignment: Alignment.topLeft,
              child: Text(
                 description??"",
                //"Pediatricians plead with FDA to move quickly on covid vaccine for kids",
                style: AppTextStyle.h5TitleTextStyle(color: Colors.white),
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
        ],
      );
    });
  }
}