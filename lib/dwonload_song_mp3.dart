import 'dart:io';
import 'package:process_run/shell.dart';
import 'package:path_provider/path_provider.dart';

String getDownloadsFolderPath() {
  if (Platform.isWindows) {
    return "${Platform.environment['USERPROFILE']}\\Downloads";
  } else if (Platform.isMacOS || Platform.isLinux) {
    return "${Platform.environment['HOME']}/Downloads";
  } else {
    throw UnsupportedError("Unsupported OS");
  }
}

Future<List<ProcessResult>> downloadMP3(String youtubeUrl) async {
  String downloadsPath = getDownloadsFolderPath(); // Saves in the current directory
  var shell = Shell();

  try {
    print("Downloading to: $downloadsPath");


    var result = await shell.run(
        'yt-dlp -x --audio-format mp3 -o "$downloadsPath/%(title)s.%(ext)s" "$youtubeUrl"'
    );

    // Print the command output to check progress
    print(result.map((r) => r.stdout).join("\n"));
    print("Download Complete! File Saved in: $downloadsPath");
    return result; // Return the ProcessResult list
  } catch (e) {
    print("Download failed: $e");
    return []; // Return an empty list on failure
  }
}
