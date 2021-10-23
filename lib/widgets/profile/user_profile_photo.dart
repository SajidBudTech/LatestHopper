import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_images.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_icons/flutter_icons.dart';

class UserProfilePhoto extends StatelessWidget {
  const UserProfilePhoto({
    Key key,
    this.userProfileImageUrl = "",
    this.isFile = false,
    this.userProfileImage,
    this.onCameraPressed
  }) : super(key: key);

  final String userProfileImageUrl;
  final bool isFile;
  final File userProfileImage;
  final Function onCameraPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
        alignment: Alignment.center,
        child:ClipOval(
          child: isFile
              ? Image.file(
                  userProfileImage,
                  height: AppSizes.userProfilePictureImageHeight,
                  width: AppSizes.userProfilePictureImageWidth,
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  imageUrl: userProfileImageUrl,
                  placeholder: (context, url) => Container(
                    height: AppSizes.userProfilePictureImageHeight,
                    width: AppSizes.userProfilePictureImageWidth,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    //error occurred due to no profile show a default profile
                    if (url.isEmpty) {
                      return Container(
                        height: AppSizes.userProfilePictureImageHeight,
                        width: AppSizes.userProfilePictureImageWidth,
                        child: Image.asset(
                          AppImages.defaultProfile,
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                    //maybe caused by network or server issue
                    else {
                      return Container(
                        height: AppSizes.userProfilePictureImageHeight,
                        width: AppSizes.userProfilePictureImageWidth,
                        child: Center(
                          child: Icon(Icons.error),
                        ),
                      );
                    }
                  },
                  height: AppSizes.userProfilePictureImageHeight,
                  width: AppSizes.userProfilePictureImageWidth,
                  fit: BoxFit.cover,
                ),
        )),
        Positioned.fill(child: Align(
          alignment: Alignment.center,
          child:InkWell(
              onTap: onCameraPressed,
              child:CircleAvatar(
              backgroundColor: Color(0xFFFFFFFF).withOpacity(0.5),
              child: Icon(FlutterIcons.camera_ant,color: Colors.white,size: 24,)
          )),
        ))
      ],
    );
  }
}
