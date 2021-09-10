import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/views/miniplayer/currently_playing_thumbnail.dart';
import 'package:flutter_hopper/views/miniplayer/currently_playing_title.dart';
import 'package:flutter_hopper/views/miniplayer/play_pause_button.dart';
import 'package:flutter_hopper/views/playing/currently_playing_slider.dart';

class MiniPlayer extends StatefulWidget {

  MiniPlayer({Key key}):super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();

}
class _MiniPlayerState extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      child: Container(
        height: 62,
        color: AppColor.accentColor,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 1),
                child:Row(
                  children: [
                    Flexible(
                      flex: 11,
                      child: GestureDetector(
                        onTap: () {
                          /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AudioPlayerPage()));*/

                        },
                        child: Row(
                          children: [
                            Flexible(
                                child: CurrentlyPlayingThumbnail(
                                  height: 48,
                                  width: 48,
                                )),
                            Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: CurrentlyPlayingText(
                                  fontSize: 14,
                                  //title: widget.audioPlayerViewModel.currentAudioModel.title,
                                 // subtitle: widget.audioPlayerViewModel.currentAudioModel.author,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: SizedBox(
                            height: 42,
                            width: 42,
                            child: PlayPauseButton(
                              height: 20,
                              width: 20,
                              pauseIcon: Icons.pause,
                              playIcon: Icons.play_arrow,
                            ),
                          ),
                        ))
                  ],
                ))
          ],
        ),
      ),
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