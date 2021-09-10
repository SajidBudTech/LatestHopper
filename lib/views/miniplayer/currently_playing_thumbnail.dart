
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';

class CurrentlyPlayingThumbnail extends StatelessWidget{
  final double height;
  final double width;

  const CurrentlyPlayingThumbnail({Key key, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final currentlyPlaying = watch(currentlyPlayingProvider);
    return /*currentlyPlaying.when(
        data: (audioTrackModel) =>*/
      Container(
        padding: EdgeInsets.only(left:10,top: 6,right: 10,bottom: 6),
          child:
          ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
              child:Image.asset("assets/images/home_list.png",
        height: height,
        width: width,
        fit: BoxFit.cover)));
      CachedNetworkImage(
        imageUrl: "assets/images/player_image.jpg",
        placeholder: (context, url) => Container(
          height: AppSizes.productImageHeight,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        height: height,
        width: width,
        fit: BoxFit.cover,
      );

  }

}