import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter_hopper/viewmodels/playing.viewmodel.dart';

class PlayPauseButton extends StatefulWidget {
  final double width;
  final double height;
  final double iconSize;
  final IconData pauseIcon;
  final IconData playIcon;
  PlayingViewModel model;

  PlayPauseButton({Key key,this.width, this.height, this.pauseIcon, this.playIcon, this.iconSize,this.model}):super(key: key);

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();

}

class _PlayPauseButtonState extends State<PlayPauseButton> {

  bool isPlaying = AudioConstant.audioIsPlaying;
  bool completed=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
        stream: widget.model.player.positionStream,
        builder: (context, snapshot){
      if (snapshot.data != null) {
        widget.model.currentPostion = snapshot.data;
      }
     return SleekCircularSlider(
          appearance: CircularSliderAppearance(
            angleRange: 360,
            startAngle: 270,
            customColors: CustomSliderColors(
              trackColor: Colors.black54,
              progressBarColor: AppColor.primaryColor,

            ),
            customWidths: CustomSliderWidths(
              progressBarWidth: 4,
              trackWidth: 3,
            ),

            //spinnerMode: true,
          ),
          /* onChange: (double value) {
                print(value);
              },*/
          min: 0,
          initialValue: widget.model.currentPostion!=null?widget.model.currentPostion.inSeconds.toDouble():0,
          max: widget.model.totalDuration!=null?widget.model.totalDuration.inSeconds.toDouble():0,
          innerWidget: (checkVakue) {
            return StreamBuilder<PlayerState>(
                stream: widget.model.player.playerStateStream,
                builder: (context, snapshot){
              if (snapshot.data != null) {
                final playerState = snapshot.data;
                final processingState = playerState.processingState;
                completed = false;
                AudioConstant.audioIsPlaying = playerState.playing;
                isPlaying = playerState.playing;
                if (processingState == ProcessingState.completed) {
                  isPlaying = false;
                  completed = true;
                  widget.model.addToRecentlyViewed();
                  if(widget.model.player.hasNext){
                    widget.model.currentPostion=Duration.zero;
                    widget.model.player.seekToNext();
                  }
                }
              }
              return InkWell(
                child: Icon(
                  isPlaying ? widget.pauseIcon : widget.playIcon,
                  color: Colors.black54,
                  size: 24,
                ),
                onTap: () {
                  if(isPlaying){
                    widget.model.player.pause();
                  }else if(completed){
                    widget.model.seekAudio(Duration.zero);
                  }else{
                    if(widget.model.myPlayList.length>0){
                      widget.model.player.play();
                    }
                  }
                  setState(() {
                    if(widget.model.myPlayList.length>0) {
                       isPlaying = !isPlaying;
                    }
                  });
                },
              );
            },);
          }
      );
    },);
  }
}