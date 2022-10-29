enum VideoOrientationType { fullScreen, normal }

class VideoScreenState {
  static VideoOrientationType videoOrientation = VideoOrientationType.normal;
  static bool isPlaying = true;
  static Duration? currentTime;
}
