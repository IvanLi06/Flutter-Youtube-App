import 'package:flutter/material.dart';
import 'package:flutter_hybrid_app/video_player_page.dart';
import 'package:flutter_hybrid_app/videopage.dart';
import 'favorites_page.dart';
import 'history_page.dart';
import 'package:youtube_data_api/models/thumbnail.dart';
import 'package:youtube_data_api/models/video.dart';
import 'package:youtube_data_api/youtube_data_api.dart';
import 'package:vibration/vibration.dart';


List<Video> clickedVideos = [];
List<Video> favoritedVideos = [];
String key = 'youtube api key';
void main() {
  runApp(const MyApp());  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Trending',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TrendingPage(),
    );
  }
}

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  int _currentPageIndex = 0;
  final YoutubeDataApi youtubeDataApi = YoutubeDataApi();
  List<Video?> trendingVideos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTrendingVideos();
  }

  Future<void> fetchTrendingVideos() async {//function to get trending videos from the api
    setState(() {
      _isLoading = true;
    });
    List<Video?>? videos = await youtubeDataApi.fetchTrendingVideo();
    setState(() {
      trendingVideos = videos;
      _isLoading = false;
    });
  }

  Future<void> refreshVideos() async {//function to refresh the data of the trending page
    await fetchTrendingVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending'),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshVideos,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(), // loading circle to display before data is loaded
            )
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                   onSubmitted: (query) async {
                      setState(() {
                        _isLoading = true;
                        trendingVideos.clear(); // Clear existing videos before a new search
                      });
                      List? results;
                      try {
                        results = await youtubeDataApi.fetchSearchVideo(query, key);
                      } catch (e) {
                        print('Error fetching search results: $e');//If no results are found from searching, say no results found
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No search results found'),
                          ),
                        );
                      }
                      
                      List<Video?> videos = [];
                      if (results != null && results.isNotEmpty) {//if there are results from the search, display on the page
                        for (var result in results) {
                          if (result is Video) {
                            videos.add(result);
                          }
                        }
                      } else {
                        // No search results found
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No search results found'),
                          ),
                        );
                      }
                      print('Search Results: $videos');
                      setState(() {
                        trendingVideos = videos;
                        _isLoading = false;
                      });
                    },
                  ),
                ),
                // Trending videos
                Expanded(
                  child: ListView.builder(// display trending videos from the api based off the users location
                    itemCount: trendingVideos.length,
                    itemBuilder: (context, index) {
                      Video? video = trendingVideos[index];
                      if (video == null) return Container();
                      String? videoTitle = video.title;
                      String? videoChannelName = video.channelName;
                      List<Thumbnail>? videoThumbnails = video.thumbnails;
                      String? videoChannelThumbnail =
                          videoThumbnails != null && videoThumbnails.isNotEmpty
                              ? videoThumbnails[0].url
                              : null;
                      bool isFavorited = favoritedVideos.contains(video);
                      return ListTile(
                        title: Text(videoTitle ?? 'Unknown'),
                        subtitle: Text(videoChannelName ?? 'Unknown'),
                        leading: videoChannelThumbnail != null
                            ? Image.network(videoChannelThumbnail)
                            : Container(),
                        trailing: IconButton(//favorite button
                          icon: Icon(
                            isFavorited ? Icons.favorite : Icons.favorite_border,
                            color: isFavorited ? Colors.red : null,
                          ),
                          onPressed: () {//functionality to add or remove videos from favorites
                            setState(() {
                              if (isFavorited) {
                                favoritedVideos.remove(video);
                              } else {
                                favoritedVideos.add(video);
                              }

                            });
                            // Vibrate the device
                            Vibration.vibrate(duration: 100);
                          },
                        ),
                        onTap: () {//onTap, send the necessary data for the video to the VideoPlayerPage
                          clickedVideos.add(video);
                          VideoPage videoPage = VideoPage(
                            videoId: video.videoId,
                            title: video.title,
                            channelName: video.channelName,
                            viewCount: video.views, 
                            channelId: '', 
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerPage(videoPage: videoPage),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(// navigation bar
        currentIndex: _currentPageIndex,
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
        onTap: (int index) {// functionality to switch pages
          setState(() {
            _currentPageIndex = index;
          });
          if (index == 0) {
            // Trending page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TrendingPage()),
            );
          } else if (index == 1) {
            // Favorites page
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FavoritesPage(favoritedVideos: favoritedVideos)),
            );
          } else if (index == 2) {
            // History page
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HistoryPage(clickedVideos: clickedVideos)),
            );
          }
        },
      ),
    );
  }
}