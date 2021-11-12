import 'package:flutter_hopper/constants/audio_constant.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';



class AudioHopperHandler extends BaseAudioHandler with SeekHandler{

  AudioPlayer player=AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);
  Duration totalDuration=Duration.zero;
  Duration currentPosition=Duration.zero;

  AudioHopperHandler() {
    //_playlist= ConcatenatingAudioSource(children: playlist);

    loadEmptyPlaylist();
    //player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    _notifyAudioHandlerAboutPlaybackEvents();
    //_listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
  }

  void removePlaylist(int index){
    _playlist.removeAt(index);
  }

  Future<void> loadEmptyPlaylist() async {
    try {
      await player.setAudioSource(_playlist);
    } catch (e) {
      print("Error: $e");
    }
  }


  @override
  Future<void> stop() => player.stop();

  @override
  Future<void> play() {

    if(AudioConstant.audioIsPlaying){
      AudioConstant.audioViewModel.audioHopperHandler.player.stop();
    }

    /*if(AudioGloble.demoAudioPlayer!=null){
      if(AudioGloble.demoAudioPlayer.playing){
        AudioGloble.demoAudioPlayer.stop();
      }
    }*/



    player.play();

    //AudioConstant.audioState=AudioPlayerState.Playing;
    AudioConstant.audioIsPlaying=true;

  }

  @override
  Future<void> seekBackward(bool begin) {
    // TODO: implement seekBackward
    return super.seekBackward(begin);
  }
  @override
  Future<void> seekForward(bool begin) {
    // TODO: implement seekForward
    return super.seekForward(begin);
  }

  @override
  Future<void> pause() => player.pause();


  @override
  Future<void> seek(Duration position) => player.seek(position);


  @override
  Future<void> skipToNext() {
    player.seekToNext();
    //skipToQueueItem(player.currentIndex);
  }

  @override
  Future<void> skipToPrevious() {
    player.seekToPrevious();
    //skipToQueueItem(player.currentIndex);
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    player.playbackEventStream.listen((PlaybackEvent event) {
     // currentPosition=event.updatePosition;
      //totalDuration=event.duration;
      final playing = player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: {
          //MediaAction.seek,
          player.playing?MediaAction.pause:MediaAction.play,
          MediaAction.skipToPrevious,
          MediaAction.skipToNext,
        },
        androidCompactActionIndices: const [0,1,3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[player.processingState],
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[player.loopMode],
        shuffleMode: (player.shuffleModeEnabled)
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: playing,
        updatePosition: player.position,
        bufferedPosition: player.bufferedPosition,
        speed: player.speed,
        queueIndex: event.currentIndex,
      ));
    });

  }

  void _listenForDurationChanges() {
    player.durationStream.listen((duration) {
      var index = player.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (player.shuffleModeEnabled) {
        index = player.shuffleIndices[index];
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  void _listenForCurrentSongIndexChanges() {
    player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      if (player.shuffleModeEnabled) {
        index = player.shuffleIndices[index];
      }
      mediaItem.add(playlist[index]);
    });
  }

  void _listenForSequenceStateChanges() {
    player.sequenceStateStream.listen((SequenceState sequenceState) {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;
      final items = sequence.map((source) => source.tag as MediaItem);
      queue.add(items.toList());
    });
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    // manage Just Audio
    final audioSource = mediaItems.map(_createAudioSource);
    _playlist.addAll(audioSource.toList());

    // notify system
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);

  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    // manage Just Audio
    final audioSource = _createAudioSource(mediaItem);
    _playlist.add(audioSource);

    // notify system
    final newQueue = queue.value..add(mediaItem);
    queue.add(newQueue);
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    if(mediaItem.extras!=null){
      return AudioSource.uri(Uri.file(mediaItem.id/*extras['url']*/), tag: mediaItem,);
    }else{
      return AudioSource.uri(Uri.parse(mediaItem.id/*extras['url']*/), tag: mediaItem,);
    }

  }


  @override
  Future<void> removeQueueItemAt(int index) async {
    // manage Just Audio
    _playlist.removeAt(index);

    // notify system
    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }


  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    if (player.shuffleModeEnabled) {
      index = player.shuffleIndices[index];
    }
    player.seek(Duration.zero, index: index);

  }



  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        player.setLoopMode(LoopMode.all);
        break;
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      player.setShuffleModeEnabled(false);
    } else {
      await player.shuffle();
      player.setShuffleModeEnabled(true);
    }
  }

  @override
  Future customAction(String name, [Map<String, dynamic> extras]) async {
    if (name == 'dispose') {
      await player.dispose();
      super.stop();
    }
  }



}