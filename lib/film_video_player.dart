import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class VideoItem {
  final String imageSrc;
  final String? title;
  final String? subtitle;
  final String url;
  final bool useGradient;

  VideoItem(
      {required this.imageSrc,
      this.title,
      this.subtitle,
      required this.url,
      this.useGradient = false});
}

class FilmPlayer extends StatefulWidget {
  final String title;
  final Color backgroundColor;
  final Color progressColor;
  final bool showVideoDuration;
  final bool isFullScreen;
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
  final List<VideoItem>? videos;
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
  final Function(VideoItem)? onVideoItemClicked;
  final Function(DeviceOrientation, SystemUiMode)? onRotated;

  FilmPlayer(
      {Key? key,
      this.progressBackgroundColor = const Color.fromRGBO(255, 0, 0, 0.7),
      this.progressBufferedColor = const Color.fromRGBO(50, 50, 200, 0.2),
      this.progressPlayedColor = const Color.fromRGBO(200, 200, 200, 0.5),
      required this.autoPlay,
      required this.title,
      this.backgroundColor = Colors.black,
      this.showSuggestedVideosWhenEnd = true,
      this.radius = 10,
      this.useAutoSize = true,
      this.progressColor = Colors.blue,
      this.startAt,
      this.intro,
      this.skipIntroButton,
      this.videos,
      this.showVideos = false,
      required this.url,
      this.videoSize,
      this.errorWidget,
      this.loader,
      this.onError,
      this.onRotated,
      this.playing,
      this.paused,
      this.onVideoItemClicked,
      this.end,
      this.seeked,
      this.loaded,
      this.start,
      this.isFullScreen = false,
      this.showVideoDuration = true})
      : super(key: key) {
    if (useAutoSize == false) {
      assert(videoSize != null,
          "If useAutoSize props is false. Please use videoSize property. \n Eg: videoSize: const [.95, .27] ");
    }
  }

  @override
  State<FilmPlayer> createState() => _FilmPlayerState();
}

class _FilmPlayerState extends State<FilmPlayer> {
  late VideoPlayerController _controller;
  bool isLoading = true;
  bool isPlaying = false;
  bool isError = false;
  bool isIntroActive = false;
  late bool isFullScreen;
  late bool showVideos;
  String videoDuration = "";
  late bool showIndicators;
  final Duration duration = const Duration(milliseconds: 500);

  void seekEvent(bool isForward) {
    if (widget.seeked != null) {
      widget.seeked!(_controller.value.position, isForward);
    }
  }

  void setupVideo(String url) {
    showVideos = widget.showVideos;
    showIndicators = false;
    isFullScreen = widget.isFullScreen;
    SystemChrome.setPreferredOrientations(widget.isFullScreen
        ? [DeviceOrientation.landscapeLeft]
        : [DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(
        widget.isFullScreen ? SystemUiMode.leanBack : SystemUiMode.edgeToEdge);
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        showIndicators = !widget.autoPlay;

        if (widget.loaded != null) {
          widget.loaded!(_controller);
        }

        _controller.addListener(() {
          if (_controller.value.duration == _controller.value.position) {
            setState(() {
              isPlaying = false;
            });
            if (widget.showSuggestedVideosWhenEnd == true &&
                widget.videos != null) {
              toggleVideoList(true);
            }
            if (widget.end != null) {
              widget.end!();
            }
          } else {
            if (widget.playing != null) {
              widget.playing!(_controller.value.position);
            }
          }
          if (_controller.value.hasError) {
            setState(() {
              isError = true;
            });
            if (widget.onError != null) {
              widget.onError!();
            }
          }
          if (widget.intro != null) {
            if (widget.intro![0].inSeconds <
                    _controller.value.position.inSeconds &&
                widget.intro![1].inSeconds >
                    _controller.value.position.inSeconds) {
              setState(() {
                isIntroActive = true;
              });
            } else {
              setState(() {
                isIntroActive = false;
              });
            }
          }
        });

        if (widget.autoPlay) {
          isPlaying = true;
          _controller.play();
          if (widget.start != null) {
            widget.start!();
          }
        } else {
          isPlaying = false;
        }

        if (widget.startAt != null) {
          _controller.seekTo(widget.startAt!);
        }

        videoDuration =
            "${_controller.value.duration.inMinutes < 9 ? "0" : ""}${_controller.value.duration.inMinutes}:${_controller.value.duration.inSeconds < 9 ? "0" : ""}${_controller.value.duration.inSeconds}";
        setState(() {
          isLoading = false;
        });
      }).onError((error, stackTrace) {
        setState(() {
          isError = true;
        });
        if (widget.onError != null) {
          widget.onError!();
        }
      });
  }

  @override
  void initState() {
    super.initState();
    setupVideo(widget.url);
  }

  void playVideo() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      _controller.play();
      if (widget.start != null) {
        widget.start!();
      }
    } else {
      _controller.pause();
      if (widget.paused != null) {
        widget.paused!();
      }
    }
  }

  void skipIntro() {
    if (widget.intro != null) {
      _controller.seekTo(widget.intro![1]);
      seekEvent(true);
    }
  }

  void forward() {
    Duration currentPosition = _controller.value.position;
    _controller.seekTo(currentPosition + const Duration(seconds: 2));
    seekEvent(true);
  }

  void backward() {
    Duration currentPosition = _controller.value.position;
    _controller.seekTo(currentPosition - const Duration(seconds: 2));
    seekEvent(false);
  }

  void setOrientation() {
    setState(() {
      isFullScreen = !isFullScreen;
    });
    SystemChrome.setPreferredOrientations(isFullScreen
        ? [DeviceOrientation.landscapeLeft]
        : [DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(
        isFullScreen ? SystemUiMode.immersive : SystemUiMode.edgeToEdge);
    if (widget.onRotated != null) {
      widget.onRotated!(
          isFullScreen
              ? DeviceOrientation.landscapeLeft
              : DeviceOrientation.portraitUp,
          isFullScreen ? SystemUiMode.immersive : SystemUiMode.edgeToEdge);
    }
  }

  void toggleVideoList([bool? current]) {
    if (current == null) {
      setState(() {
        showVideos = !showVideos;
      });
    } else {
      setState(() {
        showVideos = current;
      });
    }
    if (showVideos) {
      setState(() {
        isPlaying = false;
      });
      _controller.pause();
      if (widget.paused != null) {
        widget.paused!();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: widget.useAutoSize && !isFullScreen
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: player,
            )
          : SizedBox(
              width: isFullScreen
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width * widget.videoSize![0],
              height: isFullScreen
                  ? MediaQuery.of(context).size.height
                  : MediaQuery.of(context).size.height * widget.videoSize![1],
              child: player),
    );
  }

  Widget get player => GestureDetector(
        onTap: () {
          setState(() {
            showIndicators = !showIndicators;
          });
        },
        child: Stack(
          children: [
            Positioned.fill(
                child: Container(
                    color: widget.backgroundColor,
                    child: Center(
                        child: widget.loader ??
                            const Center(
                              child: CircularProgressIndicator(
                                  strokeWidth: 1, color: Colors.white),
                            )))),
            Positioned.fill(child: VideoPlayer(_controller)),
            AnimatedPositioned(
              top: showIndicators ? 0 : -100,
              left: 0,
              right: 0,
              duration: duration,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black87,
                    Colors.transparent,
                  ],
                )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.title,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20)),
                    Text(videoDuration,
                        style: const TextStyle(color: Colors.white))
                  ],
                ),
              ),
            ),
            AnimatedOpacity(
              duration: duration,
              opacity: showIndicators ? 1 : 0,
              child: Align(
                alignment: Alignment.center,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    IconButton(
                        iconSize: 40,
                        onPressed: () {
                          backward();
                        },
                        icon: const Icon(
                          Icons.replay_10,
                          color: Colors.white,
                        )),
                    IconButton(
                        iconSize: 60,
                        onPressed: () {
                          playVideo();
                        },
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        )),
                    IconButton(
                        iconSize: 40,
                        onPressed: () {
                          forward();
                        },
                        icon: const Icon(
                          Icons.forward_10,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              bottom: showIndicators ? 0 : -100,
              left: 0,
              right: 0,
              duration: duration,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black87,
                    Colors.transparent,
                  ],
                )),
                child: Column(
                  children: [
                    VideoProgressIndicator(_controller,
                        allowScrubbing: true,
                        colors: VideoProgressColors(
                          playedColor: widget.progressPlayedColor,
                          bufferedColor: widget.progressBufferedColor,
                          backgroundColor: widget.progressBackgroundColor,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            tooltip: "Show Other Videos",
                            onPressed: toggleVideoList,
                            icon: const Icon(Icons.video_label,
                                color: Colors.white)),
                        IconButton(
                            tooltip: "Make Fullscreen",
                            onPressed: () {
                              setOrientation();
                            },
                            icon: const Icon(Icons.fullscreen,
                                color: Colors.white)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            if (isError)
              Positioned.fill(
                  child: Center(
                child: widget.errorWidget ??
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Error",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 21)),
                          SizedBox(height: 10),
                          Text("Unexcepted error occured.",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16))
                        ]),
              )),
            if (isIntroActive)
              widget.skipIntroButton != null
                  ? GestureDetector(
                      onTap: skipIntro, child: widget.skipIntroButton)
                  : Positioned(
                      bottom: 10,
                      right: 10,
                      child: ElevatedButton.icon(
                          onPressed: skipIntro,
                          icon: const Icon(Icons.next_plan),
                          label: const Text("Skip Intro")),
                    ),
            if (widget.videos != null && showVideos)
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    margin: const EdgeInsets.all(0),
                    color: Colors.black,
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: GridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemCount: widget.videos!.length,
                                itemBuilder: (context, index) {
                                  return VideoCard(
                                      videoItem: widget.videos![index],
                                      onTap: (videoItem) {
                                        if (widget.onVideoItemClicked != null) {
                                          widget.onVideoItemClicked!(videoItem);
                                          toggleVideoList();
                                          setupVideo(videoItem.url);
                                        }
                                      });
                                })),
                        Positioned(
                          top: -5,
                          left: -5,
                          child: IconButton(
                              iconSize: 40,
                              onPressed: () {
                                toggleVideoList();
                              },
                              icon: const Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ))
          ],
        ),
      );
}

class VideoCard extends StatelessWidget {
  final VideoItem videoItem;
  final Function(VideoItem) onTap;
  const VideoCard({Key? key, required this.videoItem, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(videoItem.imageSrc), fit: BoxFit.cover)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onTap(videoItem);
          },
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black87,
                    Colors.transparent,
                  ],
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (videoItem.title != null)
                      Text(
                        videoItem.title!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    if (videoItem.subtitle != null)
                      Text(
                        videoItem.subtitle!,
                        style: const TextStyle(color: Colors.white),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
