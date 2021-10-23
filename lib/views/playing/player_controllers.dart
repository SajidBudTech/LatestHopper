import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';
import 'package:flutter_hopper/viewmodels/playing.viewmodel.dart';
import 'package:just_audio/just_audio.dart';

class PlayerControllButtons extends StatefulWidget {

  PlayerControllButtons({Key key,this.model}):super(key: key);

  PlayingViewModel model;
  @override
  _PlayerControllButtonsState createState() => _PlayerControllButtonsState();

}

class _PlayerControllButtonsState extends State<PlayerControllButtons> {

  bool isPlaying = false;
  bool completed=false;

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<PlayerState>(
        stream: widget.model.player.playerStateStream,
        builder: (context, snapshot) {
          if(snapshot.data!=null){
            final playerState = snapshot.data;
            final processingState = playerState.processingState;
            completed=false;
            AudioConstant.audioIsPlaying=playerState.playing;
            isPlaying = playerState.playing;
            if(processingState==ProcessingState.completed){
              isPlaying = false;
              completed=true;
              widget.model.addToRecentlyViewed();
              if(widget.model.player.hasNext){
                widget.model.totalDuration=Duration.zero;
                widget.model.currentPostion=Duration.zero;
                widget.model.player.seekToNext();
              }
            }
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  child:IconButton(
                      alignment: Alignment.center,
                      highlightColor: Colors.white,
                      splashColor: Colors.white,
                      iconSize: 36,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(
                        Icons.skip_previous_sharp,
                        color: Colors.black,
                        //size: 48,
                      ),
                      onPressed: () {
                        if(widget.model.player.hasPrevious){
                          setState(() {
                            widget.model.currentPostion=Duration.zero;
                            widget.model.player.seekToPrevious();
                          });
                        }
                      }
                  )),
              InkWell(
                highlightColor: Colors.white,
                splashColor: Colors.white,
                onTap: (){
                  widget.model.seekAudio(Duration(milliseconds: (widget.model.currentPostion.inMilliseconds-15000).isNegative?0:(widget.model.currentPostion.inMilliseconds-15000)));
                },
                child: Image.asset("assets/images/back15.png",
                  width: 65,
                  height: 65,
                ),
              ),
              InkWell(
                highlightColor: Colors.white,
                splashColor: Colors.white,
                onTap: (){
                  if(isPlaying){
                    widget.model.player.pause();
                  }else if(completed){
                    widget.model.seekAudio(Duration.zero);
                  }else{
                    widget.model.player.play();
                  }
                  setState(() {
                    isPlaying=!isPlaying;
                  });
                },
                child: isPlaying?
                Image.asset("assets/images/pause.png",
                  width: 65,
                  height: 65,
                )
                    :Image.asset("assets/images/paly.png",
                  width: 65,
                  height: 65,
                ),
              ),
              InkWell(
                highlightColor: Colors.white,
                splashColor: Colors.white,
                onTap: (){
                  widget.model.seekAudio(Duration(milliseconds: (widget.model.currentPostion.inMilliseconds+15000)>widget.model.totalDuration.inMilliseconds?widget.model.totalDuration.inMilliseconds:widget.model.currentPostion.inMilliseconds+15000));
                },
                child: Image.asset("assets/images/forward15.png",
                  width: 65,
                  height: 65,
                ),
              ),
              Container(
                  child:IconButton(
                      alignment: Alignment.center,
                      iconSize: 36,
                      padding: EdgeInsets.zero,
                      highlightColor: Colors.white,
                      splashColor: Colors.white,
                      constraints: BoxConstraints(),
                      icon: Icon(
                        Icons.skip_next_sharp,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        if(widget.model.player.hasNext){
                          setState(() {
                            widget.model.currentPostion=Duration.zero;
                            widget.model.player.seekToNext();
                          });
                        }
                      }
                  )),
            ],
          );
        },
    );
  }
}