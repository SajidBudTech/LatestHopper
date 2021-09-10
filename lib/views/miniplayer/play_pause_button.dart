import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class PlayPauseButton extends StatefulWidget {
  final double width;
  final double height;
  final double iconSize;
  final IconData pauseIcon;
  final IconData playIcon;
  bool isPlaying = false;

  PlayPauseButton({Key key,this.width, this.height, this.pauseIcon, this.playIcon, this.iconSize}):super(key: key);

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();

}

class _PlayPauseButtonState extends State<PlayPauseButton> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
              appearance: CircularSliderAppearance(
                angleRange: 360,
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
              initialValue: 50,
              max: 100,
             innerWidget: (checkVakue){
                    return InkWell(
                      child: Icon(
                        widget.isPlaying?widget.pauseIcon:widget.playIcon,
                        color: Colors.black54,
                        size: 24,
                      ),
                      onTap: (){
                        setState(() {
                          widget.isPlaying=!widget.isPlaying;
                        });
                      },
                    );
                  }
              );
  }
}