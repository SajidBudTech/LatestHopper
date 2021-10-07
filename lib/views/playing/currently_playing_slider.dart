import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/viewmodels/playing.viewmodel.dart';
import 'package:just_audio/just_audio.dart';

class CurrentlyPlayingSlider extends StatefulWidget {
  CurrentlyPlayingSlider({Key key,this.model,this.onSpeedPressed}) : super(key: key);

  PlayingViewModel model;
  Function onSpeedPressed;

  @override
  _CurrentlyPlayingSliderState createState() => _CurrentlyPlayingSliderState();
}

class _CurrentlyPlayingSliderState extends State<CurrentlyPlayingSlider> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
        stream: widget.model.player.positionStream,
        builder: (context, snapshot) {
          if(snapshot.data !=null){
            widget.model.currentPostion = snapshot.data;
          }
          return  Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      flex: 15,
                      child: SizedBox(
                        height: 1.5,
                        child: SliderTheme(
                          child: Slider(
                            value: widget.model.currentPostion!=null?widget.model.currentPostion.inSeconds.toDouble():0,
                            max:widget.model.totalDuration!=null?widget.model.totalDuration.inSeconds.toDouble():0,
                            activeColor: AppColor.accentColor,
                            inactiveColor: Colors.grey[300],
                            onChanged: (value) {
                              setState(() {

                              });
                            },
                          ),
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColor.primaryColor,
                            inactiveTrackColor: Colors.grey[500],
                            activeTickMarkColor: AppColor.primaryColor,
                            trackShape: SpotifyMiniPlayerTrackShape(),
                            trackHeight: 1.5,
                            thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 0,
                            ),
                          ),
                        ),
                      )
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                          padding: EdgeInsets.only(left: 8),
                          child: InkWell(
                             onTap: this.widget.onSpeedPressed,
                              child:Text(widget.model.playerSpeed??"1x",
                              textAlign: TextAlign.left,
                              style: AppTextStyle.h5TitleTextStyle(
                                color: AppColor.accentColor,
                                fontWeight: FontWeight.w600,
                              ))))),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                          padding: EdgeInsets.only(left: 2),
                          child: Text(widget.model.currentPostion!=null?_printDuration(widget.model.currentPostion):"00.00",
                              textAlign: TextAlign.left,
                              style: AppTextStyle.h5TitleTextStyle(
                                color: AppColor.accentColor,
                                fontWeight: FontWeight.w500,
                              )))),
                  Expanded(
                      flex: 1,
                      child: Container(
                          padding: EdgeInsets.only(right: 20),
                          child: Text(widget.model.totalDuration!=null?_printDuration(widget.model.totalDuration):"00.00",
                              textAlign: TextAlign.right,
                              style: AppTextStyle.h5TitleTextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              )))),
                ],
              )
            ],
          );

        },
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    //${twoDigits(duration.inHours)}
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

}

class SpotifyMiniPlayerTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
