import 'thumbnail.dart'; //interface to display videos data

class Video {
  final String videoId; 
  final String title;
  final String channelName;
  final Thumbnail? thumbnail;

  Video({
    required this.videoId, 
    required this.title,
    required this.channelName,
    this.thumbnail,
  });

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      title: map['compactVideoRenderer']['title']['simpleText'] ?? 'Unknown',
      channelName: map['compactVideoRenderer']['longBylineText']['runs'][0]['text'] ?? 'Unknown',
      thumbnail: Thumbnail(
        url: map['compactVideoRenderer']['thumbnail']['thumbnails'][0]['url'],
        width: map['compactVideoRenderer']['thumbnail']['thumbnails'][0]['width'],
        height: map['compactVideoRenderer']['thumbnail']['thumbnails'][0]['height'],
      ), videoId: '',
    );
  }
}