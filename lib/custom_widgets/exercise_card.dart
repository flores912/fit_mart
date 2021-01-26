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

  const ExerciseCard({
    Key key,
    this.exerciseName,
    this.sets,
    this.more,
    this.onTap,
    this.elevation,
    this.color,
    this.url,
  }) : super(key: key);
  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  VideoPlayerController videoPlayerController;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.network(widget.url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

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

            //todo getting rid of this until I fix out of memry leak on lists might need to migrate to betterplayer package
            // leading: widget.url != null
            //     ? Container(
            //         width: 56,
            //         height: 56 * 16 / 9 / 2,
            //         child: ChewiePlayerWidget(
            //             autoPlay: false,
            //             looping: false,
            //             showControls: false,
            //             videoPlayerController: videoPlayerController),
            //       )
            //     : null,
            title: Text(widget.exerciseName),
            subtitle: Text(widget.sets.toString() + ' ' + kSets),
          ),
        ),
      ],
    );
  }
}
