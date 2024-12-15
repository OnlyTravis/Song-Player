import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';


class PlaySongPage extends StatefulWidget {
  const PlaySongPage({super.key, required this.play_song_path, required });
  final String? play_song_path;
  

  @override
  State<PlaySongPage> createState() => PlaySongPageState();
}

class PlaySongPageState extends State<PlaySongPage> {
  static AudioPlayer audio_player = AudioPlayer();
  static bool is_playing = false;
  static String now_playing = "";

  @override
  void initState() {

    audio_player.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          is_playing = false;
        });
      }
    });

    if (widget.play_song_path != null) {
      String song_path = widget.play_song_path!;
      audio_player.setSource(DeviceFileSource(song_path));
      if (!is_playing) {
        audio_player.resume();
        setState(() {
          is_playing = !is_playing;
        });
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Song"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(now_playing),
          ],
        ),
      ),
    );
  }
}