import 'package:film_video_player/film_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FilmPlayer(
                onRotated: (DeviceOrientation deviceOrientation,
                    SystemUiMode systemUiMode) {
                  print("rotated $deviceOrientation $systemUiMode");
                },
                onError: () {
                  print("ok");
                },
                progressPlayedColor: Colors.blue,
                useAutoSize: false,
                videoSize: const [.95, .27],
                onVideoItemClicked: (VideoItem videoItem) {
                  print(videoItem.title);
                },
                videos: [
                  VideoItem(
                      imageSrc:
                          "https://m.media-amazon.com/images/M/MV5BMTUzNTc3MTU3M15BMl5BanBnXkFtZTcwMzIxNTc3NA@@._V1_.jpg",
                      title: "The Cars",
                      subtitle: "The Cars Movie 2",
                      url:
                          "https://freetestdata.com/wp-content/uploads/2022/02/Free_Test_Data_7MB_MP4.mp4"),
                  VideoItem(
                      imageSrc:
                          "http://gonewiththetwins.com/new/wp-content/uploads/2017/06/cars.jpg",
                      title: "The Cars",
                      subtitle: "The Cars Movie 11",
                      url:
                          "https://freetestdata.com/wp-content/uploads/2022/02/Free_Test_Data_7MB_MP4.mp4"),
                  VideoItem(
                      imageSrc:
                          "https://prod-ripcut-delivery.disney-plus.net/v1/variant/disney/DC0C820B5E4DFBB73C1D5CB97794184C54CA2312AE46EFDCF8DC07F8C94744A7/scale?width=1200&aspectRatio=1.78&format=jpeg",
                      title: "The Cars On The Road",
                      subtitle: "Watch on disney plus",
                      url:
                          "https://freetestdata.com/wp-content/uploads/2022/02/Free_Test_Data_7MB_MP4.mp4"),
                  VideoItem(
                      imageSrc:
                          "https://m.media-amazon.com/images/M/MV5BMTUzNTc3MTU3M15BMl5BanBnXkFtZTcwMzIxNTc3NA@@._V1_.jpg",
                      title: "The Cars",
                      subtitle: "The Cars Movie ",
                      url:
                          "https://freetestdata.com/wp-content/uploads/2022/02/Free_Test_Data_7MB_MP4.mp4"),
                ],
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
            ],
          ),
        ),
      ),
    );
  }
}
