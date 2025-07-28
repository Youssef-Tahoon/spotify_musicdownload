import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String?> searchYouTube(String query, String apiKey) async {
  var url = Uri.parse('https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&key=$apiKey');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return 'https://www.youtube.com/watch?v=${data['items'][0]['id']['videoId']}';
  }
  return null;
}