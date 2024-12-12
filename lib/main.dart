import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Song Player',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class ListNumber extends StatelessWidget {
  final int number;

  const ListNumber({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Text(number.toString());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> test_list = [1,2,3,3,4,1,41,2];

  String display_text = "aa";
  bool is_playing = false;
  AudioPlayer audio_player = AudioPlayer();

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      PermissionStatus result = await permission.request();
      return (result == PermissionStatus.granted);
    }
  }

  void _testButton() async {
    Directory? music_directory;
    if (await Permission.manageExternalStorage.request() == PermissionStatus.granted) {
      music_directory = await getExternalStorageDirectory();
      if (music_directory == null) return;
      setState(() {
        display_text = music_directory!.path;
      });
    } else {
      print("Permission Request Failed");
      setState(() {
        display_text = "Error";
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [...test_list.map((n) => ListTile(
          title: Center(
            child: Text(n.toString()),
          ),
          tileColor: const Color.fromARGB(255, 222, 255, 253),
        )), ListTile(
          title: Center(
            child: Text(display_text),
          ),
          tileColor: const Color.fromARGB(255, 222, 255, 253),
        )],
      ),
      floatingActionButton: TextButton(
        onPressed: _testButton, 
        style: TextButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          backgroundColor: Colors.lightBlue
        ),
        child: Text("Press Me"),
      ),
    );
  }
}
