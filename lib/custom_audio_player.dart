import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_demo/seekbar.dart';
import 'package:rxdart/rxdart.dart';

class CustomAudioPlayer extends StatefulWidget {
  const CustomAudioPlayer({
    Key key,
    this.audioPath,
  }) : super(key: key);

  @override
  _CustomAudioPlayerState createState() => _CustomAudioPlayerState();

  final String audioPath;
}

class _CustomAudioPlayerState extends State<CustomAudioPlayer> {
  AudioPlayer _audioPlayer;

  void _initializeAudioPlayer() async {
    _audioPlayer = AudioPlayer();
    // await Future.delayed(const Duration(seconds: 60));
    await _audioPlayer.setFilePath(widget.audioPath);
  }

  @override
  void initState() {
    _initializeAudioPlayer();
    super.initState();
  }

  Widget _playerButton(PlayerState playerState) {
    final processingState = playerState != null
        ? playerState.processingState
        : ProcessingState.loading;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      return Container(
        margin: const EdgeInsets.all(8.0),
        width: 64.0,
        height: 64.0,
        child: const CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    } else if (_audioPlayer.playing != true) {
      return IconButton(
        icon: const Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
        iconSize: 64.0,
        onPressed: _audioPlayer.play,
      );
    } else if (processingState != ProcessingState.completed) {
      return IconButton(
        icon: const Icon(
          Icons.pause,
          color: Colors.white,
        ),
        iconSize: 64.0,
        onPressed: _audioPlayer.pause,
      );
    } else {
      return IconButton(
        icon: const Icon(
          Icons.replay,
          color: Colors.white,
        ),
        iconSize: 64.0,
        onPressed: () => _audioPlayer.seek(
          Duration.zero,
          index: _audioPlayer.effectiveIndices.first,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          Container(
            color: Colors.black38,
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              children: [
                StreamBuilder<PlayerState>(
                  stream: _audioPlayer.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    return _playerButton(playerState);
                  },
                ),
                StreamBuilder<Duration>(
                  stream: _audioPlayer.durationStream,
                  builder: (context, snapshot) {
                    final duration = snapshot.data ?? Duration.zero;
                    return StreamBuilder<PositionData>(
                      stream:
                          Rx.combineLatest2<Duration, Duration, PositionData>(
                              _audioPlayer.positionStream,
                              _audioPlayer.bufferedPositionStream,
                              (position, bufferedPosition) =>
                                  PositionData(position, bufferedPosition)),
                      builder: (context, snapshot) {
                        final positionData = snapshot.data ??
                            PositionData(Duration.zero, Duration.zero);
                        var position = positionData.position;
                        if (position > duration) {
                          position = duration;
                        }
                        var bufferedPosition = positionData.bufferedPosition;
                        if (bufferedPosition > duration) {
                          bufferedPosition = duration;
                        }
                        return Expanded(
                          flex: 1,
                          child: SeekBar(
                            duration: duration,
                            position: position,
                            bufferedPosition: bufferedPosition,
                            onChangeEnd: (newPosition) {
                              _audioPlayer.seek(newPosition);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
