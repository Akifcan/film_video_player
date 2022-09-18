# Film Player Plugin

## This package based on **video_player** package. Provides you some features and listeners.

- Note: Use Network URLs with this package.

![img](https://i.hizliresim.com/edchj9c.gif)
![img](https://i.hizliresim.com/n0srvrw.png)
![img](https://i.hizliresim.com/1fgzs2v.png)
![img](https://i.hizliresim.com/kjke3hr.png)
![img](https://i.hizliresim.com/l5mklgc.png)
![img](https://i.hizliresim.com/eh8y4xw.png)

### Constructor

```
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
```

### Example Usage

```
FilmPlayer(
  progressPlayedColor: Colors.blue,
  useAutoSize: false,
  videoSize: const [.95, .27],
  onVideoItemClicked: (VideoItem videoItem) {
    print(videoItem.title);
  },
  seeked: (duration, isForward) {
    print("event:$isForward");
  },
  loaded: (VideoPlayerController controller) {
    print("event:loaded $controller");
  },
  playing: (duration) {
    print("event:playing");
  },
  end: () {
    print("event:video end");
  },
  start: () {
    print("event:video play");
  },
  paused: () {
    print("event:paused");
  },
  intro: const [Duration(seconds: 5), Duration(seconds: 10)],
  url:
      "https://freetestdata.com/wp-content/uploads/2022/02/Free_Test_Data_7MB_MP4.mp4",
  autoPlay: false,
  title: "This is video caption",
  showVideoDuration: true,
)
```

### About Sizing

- If you set **useAutoSize** to **true**. Video player will wrap with **AspectRatio** widget.
- Also you can give spesific width and height.
  **videoSize: const [.95, .27]**

### Custom Loader

Eg `loader: Text("Please wait")`

### Custom Error Message

Eg `errorWidget: Text("error")`

- If you need to catch error use **onError** property

### Suggested Videos

- Use **videos** property if you want to show some suggested videos end of the video. When user click one of suggested video. Video player controller will reinitialized.

```
videos: [
                  VideoItem(
                      imageSrc:
                          "https://m.media-amazon.com/images/M/MV5BMTUzNTc3MTU3M15BMl5BanBnXkFtZTcwMzIxNTc3NA@@._V1_.jpg",
                      title: "The Cars",
                      subtitle: "The Cars Movie 2",
                      url: "url"),
                  VideoItem(
                      imageSrc:
                          "http://gonewiththetwins.com/new/wp-content/uploads/2017/06/cars.jpg",
                      title: "The Cars",
                      subtitle: "The Cars Movie 11",
                      url: "url"),
                  VideoItem(
                      imageSrc:
                          "https://prod-ripcut-delivery.disney-plus.net/v1/variant/disney/DC0C820B5E4DFBB73C1D5CB97794184C54CA2312AE46EFDCF8DC07F8C94744A7/scale?width=1200&aspectRatio=1.78&format=jpeg",
                      title: "The Cars On The Road",
                      subtitle: "Watch on disney plus",
                      url: "url"),
                  VideoItem(
                      imageSrc:
                          "https://m.media-amazon.com/images/M/MV5BMTUzNTc3MTU3M15BMl5BanBnXkFtZTcwMzIxNTc3NA@@._V1_.jpg",
                      title: "The Cars",
                      subtitle: "The Cars Movie ",
                      url: "url"),
                ],
```

### Custom Bg

- Use _backgrodunColor_ property for new background color

`backgroundColor: Colors.red`
