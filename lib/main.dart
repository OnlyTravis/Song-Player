import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    bool is_playing = false;
    AudioPlayer audio_player = AudioPlayer();
    audio_player.setSource(AssetSource("./a.m4a"));

  void _testButton() {
    if (is_playing) {
      audio_player.pause();
    } else {
      audio_player.resume();
    }
    is_playing = !is_playing;
  }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: TextButton(
          onPressed: _testButton, 
          child: const Text("Press me"),  
        )
      ),
    );
  }
}
