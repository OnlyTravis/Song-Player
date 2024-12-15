import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:song_player/pages/play_song.dart';

class DisplaySongPage extends StatefulWidget {
  const DisplaySongPage({super.key, required this.song_name, required this.dir});

  final String song_name;
  final String dir;

  @override
  State<DisplaySongPage> createState() => _DisplaySongPageState();
}

class _DisplaySongPageState extends State<DisplaySongPage> {
  void button_backButtonPresses() {
    Navigator.of(context).pop();
  }

  void button_playSong() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlaySongPage(play_song_path: "${widget.dir}/${widget.song_name}"),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Song: ${widget.song_name}"),
        automaticallyImplyLeading: false,
        leading: null,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: button_backButtonPresses, 
              icon: Icon(Icons.arrow_back),
              color: const Color.fromARGB(255, 0, 0, 0),
              iconSize: 28,
            ),
          ),
        ],
      ),
      body: Center(
        child: IconButton(
          onPressed: button_playSong, 
          icon: Icon(Icons.play_arrow)
        ),
      ),
    );
  }
}
