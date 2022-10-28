import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../film_video_player.dart';

class FilmPlayerFullScreen extends StatefulWidget {
  final String title;
  final Color backgroundColor;
  final Color progressColor;
  final bool showVideoDuration;
  final bool autoPlay;
  final Duration? startAt;
  final bool showSuggestedVideosWhenEnd;
  final Widget? loader;
  final Widget? errorWidget;
  final Widget? skipIntroButton;
  final double radius;
  final bool showVideos;
  final String url;
  final List<Duration>? intro;
  final List<VideoItem>? videoItems;
  final bool useAutoSize;
  final List<double>? videoSize; // 0 - x, 1- y
  final Color progressPlayedColor;
  final Color progressBufferedColor;
  final Color progressBackgroundColor;
  final Function(Duration, bool)? seeked;
  final Function(VideoPlayerController)? loaded;
  final VoidCallback? onError;
  final Function(Duration)? playing;
  final VoidCallback? paused;
  final VoidCallback? end;
  final VoidCallback? start;
  final VoidCallback? onClickVideoPlayer;
  final Function(VideoItem)? onVideoItemClicked;

  const FilmPlayerFullScreen(
      {Key? key,
      this.progressBackgroundColor = const Color.fromRGBO(255, 0, 0, 0.7),
      this.progressBufferedColor = const Color.fromRGBO(50, 50, 200, 0.2),
      this.progressPlayedColor = const Color.fromRGBO(200, 200, 200, 0.5),
      required this.autoPlay,
      required this.title,
      this.backgroundColor = Colors.black,
      this.onClickVideoPlayer,
      this.showSuggestedVideosWhenEnd = true,
      this.radius = 10,
      this.useAutoSize = true,
      this.progressColor = Colors.blue,
      this.startAt,
      this.intro,
      this.skipIntroButton,
      this.videoItems,
      this.showVideos = false,
      required this.url,
      this.videoSize,
      this.errorWidget,
      this.loader,
      this.onError,
      this.playing,
      this.paused,
      this.onVideoItemClicked,
      this.end,
      this.seeked,
      this.loaded,
      this.start,
      this.showVideoDuration = true})
      : super(key: key);

  @override
  State<FilmPlayerFullScreen> createState() => _FilmPlayerFullScreenState();
}

class _FilmPlayerFullScreenState extends State<FilmPlayerFullScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        FilmPlayer(
            onClickVideoPlayer: widget.onClickVideoPlayer,
            onError: widget.onError,
            progressPlayedColor: widget.progressPlayedColor,
            useAutoSize: widget.useAutoSize,
            videoSize: const [1, 1],
            onVideoItemClicked: widget.onVideoItemClicked,
            startAt: widget.startAt,
            videoItems: widget.videoItems,
            seeked: widget.seeked,
            loaded: widget.loaded,
            playing: widget.playing,
            end: widget.end,
            start: widget.start,
            paused: widget.paused,
            intro: widget.intro,
            url: widget.url,
            autoPlay: widget.autoPlay,
            title: widget.title,
            showVideoDuration: widget.showVideoDuration)
      ],
    ));
  }
}
