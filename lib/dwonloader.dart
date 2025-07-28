import 'package:spotify_musicdownload/spotifyapi.dart';
import 'dwonload_song_mp3.dart';
import 'youtube_search.dart';

void main() async {
  String searchQuery = "Example Query";  // Replace with any search term
  String youtubeApiKey = "AIzaSyBqsyJEi6U2itow_CQL_Qaobyeo1RIGiKA";    // Replace with your API key

  var result = await searchItem(searchQuery);

  if (result != null) {
    String query = "${result['name']} ${result['author']}";

    String? sourceUrl = await searchYouTube(query, youtubeApiKey);
    if (sourceUrl != null) {
      await downloadMP3(sourceUrl);
      print("Downloaded: ${result['name']} - ${result['author']}");
    } else {
      print("No matching source found.");
    }
  } else {
    print("No matching results.");
  }
}