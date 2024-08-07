import 'video.dart';
import 'videopage.dart'; 

class VideoData {// interface for videodata from api, we did not use this
  final VideoPage? video;
  final List<Video> videosList;

  VideoData({this.video, required this.videosList});
}