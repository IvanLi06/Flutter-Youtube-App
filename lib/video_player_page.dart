import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'videopage.dart';

class VideoPlayerPage extends StatefulWidget {
  final VideoPage videoPage;

  const VideoPlayerPage({Key? key, required this.videoPage}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> { //page to display and play video when it is clicked on the main page
  bool _isLiked = false;
  bool _isDisliked = false;
  bool _isSubscribed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        children: [
          Center(
            child: YoutubePlayer(// Plays the video that was clicked
              controller: YoutubePlayerController(
                initialVideoId: widget.videoPage.videoId!,
                flags: const YoutubePlayerFlags(
                  autoPlay: true,
                  mute: false,
                ),
              ),
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.videoPage.title!, // display all of the information needed for each video
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text('Channel: ${widget.videoPage.channelName}'), // display channel name
                const SizedBox(height: 8),
                Text('Views: ${widget.videoPage.viewCount}'), // display view count
                const SizedBox(height: 4),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined, //like button
                        color: _isLiked ? Colors.blue : null,
                      ),
                      onPressed: () { //switches the state of the like button
                        setState(() {
                          _isLiked = true;
                          _isDisliked = false;
                        });
                      },
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: Icon(
                        _isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined, //dislike button
                        color: _isDisliked ? Colors.blue : null,
                      ),
                      onPressed: () { // switches the state of the dislike button
                        setState(() {
                          _isDisliked = true;
                          _isLiked = false;
                        });
                      },
                    ),
                    const SizedBox(width: 4),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isSubscribed = !_isSubscribed; // switches the state of the subscribe button
                        });
                      },
                      child: Text(_isSubscribed ? 'Subscribed' : 'Subscribe'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}