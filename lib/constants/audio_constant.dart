
import 'package:flutter/material.dart';
import 'package:flutter_hopper/models/audio_player_state.dart';
import 'package:flutter_hopper/models/home_post.dart';
import 'package:flutter_hopper/models/recenctly_viewed_post.dart';
import 'package:flutter_hopper/viewmodels/playing.viewmodel.dart';

class AudioConstant{
  static PlayingViewModel audioViewModel;
  static AudioPlayerState audioState=AudioPlayerState.NotInitiate;
  static HomePost HOMEPOST;
  static bool audioIsPlaying=false;
  static bool FROM_BOTTOM=false;
  static bool FROM_SEE_ALL=false;
  static bool FROM_MINI_PLAYER=false;
  static bool FROM_UPDATE_PROFILE=false;
  static bool isSleeperActive=false;
  static String sleeperActiveTime="";
  static DateTime sleeperCloseTime;
  static bool OFFLINE=false;
  static bool OFFLINECHANGE=false;

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


}