import 'package:flutter/material.dart';
import 'video_item.dart';

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
