import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BetterPlayerWidget extends StatefulWidget {
  final BetterPlayerDataSource betterPlayerDataSource;

  final bool autoPlay;

  final bool looping;

  final bool showControls;

  final double aspectRatio;

  const BetterPlayerWidget({
    Key key,
    this.betterPlayerDataSource,
    this.autoPlay,
    this.looping,
    this.showControls,
    this.aspectRatio,
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
          fit: BoxFit.scaleDown,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            showControls: widget.showControls,
          ),
          autoPlay: widget.autoPlay,
          placeholder: Icon(
            Icons.play_circle_outline_rounded,
            color: Colors.white,
          ),
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
    return BetterPlayer(
      controller: betterPlayerController,
    );
  }
}
