import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:flutter_hopper/constants/app_strings.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';

class Utils{
   static void sleepTimer(Duration duration){
      Future.delayed(duration, (){
         AudioConstant.isSleeperActive=false;
         AudioConstant.sleeperActiveTime="";
         AuthBloc.prefs.setString(AppStrings.sleepTimerText, "");
         AuthBloc.prefs.setBool(AppStrings.isSleeperActive, false);
      });
   }
}