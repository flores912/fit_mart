import 'package:fit_mart/constants.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'chewie_player_widget.dart';

class ExerciseCard extends StatefulWidget {
  final String exerciseName;
  final int sets;
  final Widget more;
  final Function onTap;
  final double elevation;
  final Color color;
  final String url;

  const ExerciseCard(
      {Key key,
      this.exerciseName,
      this.sets,
      this.more,
      this.onTap,
      this.elevation,
      this.color,
      this.url,
      })
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
                    child: ChewiePlayerWidget(
                      autoPlay: false,
                      looping: false,
                      showControls: false,
                      videoPlayerController: VideoPlayerController.network(
                          widget.url,
                          videoPlayerOptions:
                          VideoPlayerOptions(mixWithOthers: true)),
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
