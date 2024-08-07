import 'package:flutter/material.dart';
import 'package:youtube_data_api/models/thumbnail.dart';
import 'history_page.dart' as History;
import 'main.dart';
import 'package:youtube_data_api/models/video.dart';
import 'package:vibration/vibration.dart';

class FavoritesPage extends StatefulWidget {
  final List<Video> favoritedVideos;

  const FavoritesPage({super.key, required this.favoritedVideos});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late List<Video> _favoritedVideos;

  @override
  void initState() {
    super.initState();
    _favoritedVideos = widget.favoritedVideos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: ListView.builder( // display the videos in the list
        itemCount: _favoritedVideos.length,
        itemBuilder: (context, index) {
          Video video = _favoritedVideos[index];
          String? videoTitle = video.title;
          String? videoChannelName = video.channelName;
          List<Thumbnail>? videoThumbnails = video.thumbnails;
          String? videoChannelThumbnail =
              videoThumbnails != null && videoThumbnails.isNotEmpty
                  ? videoThumbnails[0].url
                  : null;
          return ListTile(
            title: Text(videoTitle ?? 'Unknown'),
            subtitle: Text(videoChannelName ?? 'Unknown'),
            leading: videoChannelThumbnail != null
                ? Image.network(videoChannelThumbnail)
                : Container(),
            trailing: IconButton(//favorite button
              icon: Icon(Icons.favorite),
              color: Colors.red,
              onPressed: () { //functionality to add and remove favorited videos
                setState(() {
                  if (_favoritedVideos.contains(video)) {
                    _favoritedVideos.remove(video);
                  } else {
                    _favoritedVideos.add(video);
                  }
                });
              Vibration.vibrate(duration: 100); // vibrate the device
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(//navigation bar
        currentIndex: 1,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        onTap: (int index) { //functionality to switch pages
          if (index == 0) {
            // Trending page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TrendingPage()),
            );
          } else if (index == 2) {
            // History page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => History.HistoryPage(clickedVideos: clickedVideos)),
            );
          }
        },
      ),
    );
  }
}
