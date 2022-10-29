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
