import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class UtubePlayer extends StatefulWidget {
  String id;
  UtubePlayer({required this.id});

  @override
  State<UtubePlayer> createState() => _UtubePlayerState();
}

class _UtubePlayerState extends State<UtubePlayer> {
  YoutubePlayerController? _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.id);
    print("need controller init");
    print("https://www.youtube.com/watch?v="+widget.id);
    // If the requirement is just to play a single video.
     _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.id,
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
  }
  @override
  Widget build(BuildContext context) {
   // return SelectableText(widget.id.trim());

    return YoutubePlayer(
      controller: _controller!,
      aspectRatio: 16 / 9,
    );
  }
}
