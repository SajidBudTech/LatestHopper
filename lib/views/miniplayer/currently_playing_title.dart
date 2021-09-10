import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';

class CurrentlyPlayingText extends StatelessWidget{

  final double fontSize;
  final TextAlign textAlign;
  final String title;
  final String subtitle;

  CurrentlyPlayingText({this.fontSize, this.textAlign = TextAlign.left,this.title,this.subtitle});


  @override
  Widget build(BuildContext context) {
    return /*currentlyPlaying = watch(currentlyPlayingProvider);
    return currentlyPlaying.when(
        data: (audioTrackModel) =>*/
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           /* Text(
            // '${audioTrackModel.trackName} \u25CF ${audioTrackModel.artistName} ',
            title??"",
            style: AppTextStyle.h4TitleTextStyle(color: AppColor.textColor(context)),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
              ),*/
              Container(
              padding: EdgeInsets.only(),
              alignment: Alignment.topLeft,
              child:Text(
                // '${audioTrackModel.trackName} \u25CF ${audioTrackModel.artistName} ',
                "Pediatricians plead with FDA to move quickly on covid vaccine for kids",
                style: AppTextStyle.h5TitleTextStyle(color: Colors.white),
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
            ],
          );


  }
}