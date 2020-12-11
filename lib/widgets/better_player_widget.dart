import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BetterPlayerWidget extends StatefulWidget {
  final BetterPlayerDataSource betterPlayerDataSource;

  final double aspectRatio;

  final bool autoPlay;

  final bool looping;

  final bool showControls;

  const BetterPlayerWidget({
    Key key,
    this.betterPlayerDataSource,
    this.aspectRatio,
    this.autoPlay,
    this.looping,
    this.showControls,
  }) : super(key: key);
  @override
  _BetterPlayerWidgetState createState() => _BetterPlayerWidgetState();
}

class _BetterPlayerWidgetState extends State<BetterPlayerWidget> {
  BetterPlayerController betterPlayerController;

  @override
  void initState() {
    betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          controlsConfiguration: BetterPlayerControlsConfiguration(
            showControls: widget.showControls,
          ),
          autoPlay: widget.autoPlay,
          placeholder: Icon(
            Icons.play_circle_outline_rounded,
            color: Colors.white,
          ),
          aspectRatio: widget.aspectRatio,
          looping: widget.looping,
        ),
        betterPlayerDataSource: widget.betterPlayerDataSource);
    super.initState();
  }

  @override
  void dispose() {
    betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer(
        controller: betterPlayerController,
      ),
    );
  }
}
