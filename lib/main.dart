import 'dart:io';
import 'package:flutter/material.dart';
import 'dwonload_song_mp3.dart';
import 'spotifyapi.dart';
import 'youtube_search.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/shell.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SpotifyDownloaderUI(),
    );
  }
}

class SpotifyDownloaderUI extends StatefulWidget {
  @override
  _SpotifyDownloaderUIState createState() => _SpotifyDownloaderUIState();
}

class _SpotifyDownloaderUIState extends State<SpotifyDownloaderUI> {
  TextEditingController _controller = TextEditingController();
  String _status = "Paste Spotify song URL to download.";

  void _startDownload() async {
    setState(() => _status = "Fetching song details...");

    String spotifyUrl = _controller.text.trim();

    if (!spotifyUrl.contains("spotify.com/track/")) {
      setState(() => _status = "Invalid Spotify URL!");
      return;
    }

    var songDetails = await getSongDetailsFromLink(spotifyUrl);
    if (songDetails == null) {
      setState(()
       => _status = "Failed to fetch Song Details."
      );
      return;
    }

    String query = "${songDetails?['title']} ${songDetails?['artist']} official audio";

    setState(() => _status = "Searching YouTube...");
    String? youtubeUrl = await searchYouTube(query, "AIzaSyBqsyJEi6U2itow_CQL_Qaobyeo1RIGiKA");

    if (youtubeUrl != null) {
      setState(() => _status = "Downloading... Please Wait!");

      List<ProcessResult> result = await (downloadMP3(youtubeUrl));
      if (result.isNotEmpty){
        setState(() => _status = "Download Complete!");
      } else {
        setState(() => _status = "Download failed.");
      }
    } else {
      setState(() => _status = "Song not found on Youtube.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Spotify to MP3")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "Enter Spotify Track ID"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _startDownload,
              child: Text("Download MP3"),
            ),
            SizedBox(height: 10),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
