import 'package:flutter/material.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class ListNumber extends StatelessWidget {
  final int number;

  const ListNumber({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Text(number.toString());
  }
}

class SongListPage extends StatefulWidget {
  const SongListPage({super.key});

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  String file_directory = "a";
  AudioPlayer audio_player = AudioPlayer();

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      PermissionStatus result = await permission.request();
      return (result == PermissionStatus.granted);
    }
  }

  Future<void> updateSongList() async {
    List file = Directory(file_directory).listSync();
    print(file);
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
          folder_path += "/$path";
        } else {
          break;
        }
      }
    } else {
      print("Permission Request Failed");
      return;
    }

    // 2. Create Song Folder if not exist
    if (!Directory("${folder_path}Music").existsSync()) {

    }

    // 3. Update "file_directory" & display
    setState(() {
      file_directory = folder_path;
    });
    await updateSongList();
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
      body: Column(
        children: [Text(file_directory)],
      ),
      floatingActionButton: TextButton(
        onPressed: initDirectory, 
        child: const Text("For testing")
      ),
    );
  }
}
