import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';

class CurrentlyPlayingSlider extends StatefulWidget {
  CurrentlyPlayingSlider({Key key}) : super(key: key);

  @override
  _CurrentlyPlayingSliderState createState() => _CurrentlyPlayingSliderState();
}

class _CurrentlyPlayingSliderState extends State<CurrentlyPlayingSlider> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                flex: 12,
                child: SizedBox(
                  height: 1.5,
                  child: SliderTheme(
                    child: Slider(
                      value: 0.3,
                      max: 1.0,
                      activeColor: AppColor.accentColor,
                      inactiveColor: Colors.grey[300],
                      onChanged: (value) {
                        setState(() {});
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
                )),
            Expanded(
                flex: 1,
                child: Container(
                    padding: EdgeInsets.only(left: 8),
                    child: Text("1x",
                        textAlign: TextAlign.left,
                        style: AppTextStyle.h5TitleTextStyle(
                          color: AppColor.accentColor,
                          fontWeight: FontWeight.w600,
                        )))),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                flex: 1,
                child: Container(
                    padding: EdgeInsets.only(left: 2),
                    child: Text("0.36",
                        textAlign: TextAlign.left,
                        style: AppTextStyle.h5TitleTextStyle(
                          color: AppColor.accentColor,
                          fontWeight: FontWeight.w500,
                        )))),
            Expanded(
                flex: 1,
                child: Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Text("3.40",
                        textAlign: TextAlign.right,
                        style: AppTextStyle.h5TitleTextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        )))),
          ],
        )
      ],
    );
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
