import 'dart:convert';
import 'package:http/http.dart' as http;

class MusicService {
  /// Fetches a 30-second audio preview from the iTunes API
  Future<String?> getSongPreviewUrl(String searchQuery) async {
    final query = Uri.encodeComponent(searchQuery);
    final url = Uri.parse('https://itunes.apple.com/search?term=$query&entity=song&limit=1');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['resultCount'] > 0) {
          final previewUrl = data['results'][0]['previewUrl'];
          print('Found preview: $previewUrl');
          return previewUrl; 
        } else {
          print('No songs found for that search.');
        }
      }
    } catch (e) {
      print('Error fetching music: $e');
    }
    return null;
  }

  /// Fetches a full list of song results from the iTunes API
  Future<List<dynamic>> searchMusic(String searchQuery, {int limit = 15}) async {
    final query = Uri.encodeComponent(searchQuery);
    final url = Uri.parse('https://itunes.apple.com/search?term=$query&entity=song&limit=$limit');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'] ?? [];
      }
    } catch (e) {
      print('Error searching music: $e');
    }
    return [];
  }

  /// Fetches real trending/popular songs from Apple Music RSS Feed
  Future<List<dynamic>> getTrendingMusic({int limit = 20}) async {
    // Top 50 songs most played
    final url = Uri.parse('https://rss.applemarketingguidelines.com/api/v2/us/music/most-played/$limit/songs.json');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List feeds = data['feed']['results'] ?? [];
        // Map RSS format to match the search results format for compatibility
        return feeds.map((item) => {
          'trackName': item['name'],
          'artistName': item['artistName'],
          'artworkUrl100': item['artworkUrl100'],
          'artworkUrl60': item['artworkUrl100'], // Use 100 for better quality
          'previewUrl': '', // RSS doesn't give previews directly always, but standard search will find them
        }).toList();
      }
    } catch (e) {
      print('Error fetching RSS trending: $e');
    }
    return [];
  }
}
