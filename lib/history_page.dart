import 'package:flutter/material.dart';
import 'favorites_page.dart';
import 'main.dart'; 
import 'package:youtube_data_api/models/video.dart'; 
import 'package:youtube_data_api/models/thumbnail.dart';

List<Video> clickedVideos = [];

class HistoryPage extends StatelessWidget {
  final List<Video> clickedVideos;

  const HistoryPage({super.key, required this.clickedVideos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: ListView.builder( // display the videos in the list
        itemCount: clickedVideos.length,
        itemBuilder: (context, index) {
          Video video = clickedVideos.reversed.toList()[index];
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
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(// navigation bar
        currentIndex: 2,
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
        onTap: (int index) {//functionality to switch pages
          if (index == 0) {
            // Trending page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TrendingPage()),
            );
          } else if (index == 1) {
            // Favorites page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FavoritesPage(favoritedVideos: favoritedVideos)),
            );
          }
        },
      ),
    );
  }
}