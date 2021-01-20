import 'package:better_player/better_player.dart';
import 'package:fit_mart/constants.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ExerciseCard extends StatefulWidget {
  final String exerciseName;
  final int sets;
  final Widget more;
  final Function onTap;
  final double elevation;
  final Color color;
  final String url;
  final BetterPlayerListVideoPlayerController controller;

  const ExerciseCard(
      {Key key,
      this.exerciseName,
      this.sets,
      this.more,
      this.onTap,
      this.elevation,
      this.color,
      this.url,
      this.controller})
      : super(key: key);
  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Card(
          color: widget.color,
          elevation: widget.elevation,
          child: ListTile(
            onTap: widget.onTap,
            trailing: widget.more,
            leading: widget.url != null
                ? Container(
                    height: 100,
                    width: 56,
                    child: BetterPlayerListVideoPlayer(
                      BetterPlayerDataSource(
                          BetterPlayerDataSourceType.network, widget.url),
                      configuration: BetterPlayerConfiguration(
                        controlsConfiguration:
                            BetterPlayerControlsConfiguration(
                          showControls: false,
                        ),
                        aspectRatio: 1,
                      ),
                      betterPlayerListVideoPlayerController: widget.controller,
                      autoPlay: false,
                    ),
                  )
                : null,
            title: Text(widget.exerciseName),
            subtitle: Text(widget.sets.toString() + ' ' + kSets),
          ),
        ),
      ],
    );
  }
}
