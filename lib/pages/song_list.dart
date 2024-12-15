import 'package:flutter/material.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import './display_song.dart';

final MusicFileExtensions = [".mp3", ".m4a"];


class SongListPage extends StatefulWidget {
  const SongListPage({super.key});

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  static String folder_directory = "";
  static List<String> music_list = [];


  bool isMusicFile(String file_name) {
    for (final file_extension in MusicFileExtensions) {
      if (file_name.endsWith(file_extension)) return true;
    }
    return false;
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      PermissionStatus result = await permission.request();
      return (result == PermissionStatus.granted);
    }
  }

  Future<void> updateSongList() async {
    // 1. Fetch & Filter for audio files.
    List files = Directory(folder_directory).listSync();
    files = files.where((file) => (file is File && isMusicFile(file.path))).toList();
    
    setState(() {
      music_list = files.cast<File>().map((file) => file.path.substring(folder_directory.length+1)).toList();
    });
  }

  void initDirectory() async {// Fetches folder directory and updates objects
    String folder_path = "";
    
    // 1. Get Main External Storage Directory
    if (await requestPermission(Permission.manageExternalStorage)) {
      Directory? directory;
      directory = await getExternalStorageDirectory();
      if (directory == null) return;

      for (final path in directory.path.split("/")) {
        if (path != "Android") {
          folder_path += "$path/";
        } else {
          break;
        }
      }
    } else {
      print("Permission Request Failed");
      return;
    }

    // 2. Create Song Folder if not exist
    Directory song_dir = Directory("${folder_path}Music");
    if (!song_dir.existsSync()) {
      song_dir.createSync();
    }

    // 3. Update "folder_directory" & display
    setState(() {
      folder_directory = "${folder_path}Music";
    });
    await updateSongList();
  }

  void button_songOnClick(String song_name) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DisplaySongPage(song_name: song_name, dir: folder_directory)
      )
    );
  }

  @override
  void initState() {
    // 1. Find file directory for music folder
    initDirectory();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Song List"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Song List",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue_music),
            label: "Queue",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: "Playing",
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(10),
        itemCount: music_list.length,
        itemBuilder: (BuildContext context, int index) {
          return TextButton(
            style: TextButton.styleFrom(backgroundColor: const Color.fromARGB(255, 216, 255, 228)),
            onPressed: () => button_songOnClick(music_list[index]),
            child: Container(
              padding: EdgeInsets.only(left: 8),
              height: 50,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(music_list[index]),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
