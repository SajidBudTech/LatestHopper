import 'package:just_audio/just_audio.dart';

class AudioItem{
  int trackId;
  String trackDescription;
  String trackImage;
  AudioSource audioSource;


  AudioItem({
    this.trackId,
    this.audioSource,
    this.trackDescription,
    this.trackImage
    });

}