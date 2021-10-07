
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_hopper/viewmodels/playing.viewmodel.dart';

class CurrentlyPlayingThumbnail extends StatefulWidget {
  final double height;
  final double width;
  PlayingViewModel model;

  CurrentlyPlayingThumbnail({Key key, this.height, this.width,this.model}) : super(key: key);
  @override _CurrentlyPlayingThumbnailState createState() => _CurrentlyPlayingThumbnailState();

}

class _CurrentlyPlayingThumbnailState extends State<CurrentlyPlayingThumbnail> {

  String coverImage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coverImage=widget.model.myPlayList[widget.model.currentPlayingIndex].trackImage??"";

  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: widget.model.player.currentIndexStream,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
              coverImage = widget.model.myPlayList[snapshot.data].trackImage ?? "";
            }
          return Container(
              padding: EdgeInsets.only(left: 10, top: 6, right: 10, bottom: 6),
              child:
              /*ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
              child:Image.asset("assets/images/home_list.png",
        height: height,
        width: width,
        fit: BoxFit.cover)));*/
              CachedNetworkImage(
                imageUrl: coverImage ?? "",
                placeholder: (context, url) =>
                    Container(
                      height: widget.height,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                height: widget.height,
                width: widget.width,
                fit: BoxFit.cover,
              ));
        });
  }
}