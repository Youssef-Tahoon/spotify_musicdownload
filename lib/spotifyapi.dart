import 'package:spotify/spotify.dart';

String? extractSpotifyTrackId(String url){
  Uri? uri = Uri.tryParse(url);
  if (uri != null && uri.host.contains("spotify.com")){
    List<String> segments = uri.pathSegments;
    if (segments.isNotEmpty && segments.first == "track"){
      return segments.last; //Track ID
    }
  }
  return null;
}

Future<Map<String, String>?> getSongDetailsFromLink(String spotifyUrl) async {
  String? trackId = extractSpotifyTrackId(spotifyUrl);

  if (trackId == null){
    print("INVALID SPOTIFY URL. ");
    return null;
  }

  var credentials = SpotifyApiCredentials(
      'ff7442356bff489d9566015a5701b239',
      '9ddf271ce0c04a1089b3f0b7856422bc'
  );
  var spotify = SpotifyApi(credentials);

  try {
    var track = await spotify.tracks.get(trackId);

    return {
      'title': track.name ?? "Unknown",
      'artist': track.artists?.first.name ?? "Unknown",
      'trackId': track.id ?? "Unknown",
    };
  } catch (e) {
    print("❌ Error fetching track: $e");
    return null;
  }
}