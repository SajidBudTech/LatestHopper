import 'package:flutter/rendering.dart';
import 'package:flutter_hopper/constants/app_images.dart';

class StateDataModel {
  String imageAssetPath;

  double imageWidth;

  double imageHeight;

  String title;
  TextStyle titleStyle;

  String description;
  TextStyle descriptionStyle;

  bool showActionButton;

  Function actionFunction;

  String actionButtonTitle;
  TextStyle actionButtonStyle;

  StateDataModel({
    this.imageAssetPath = AppImages.ic_caution,
    this.imageWidth = 50,
    this.imageHeight = 50,
    this.title = "An error occurred",
    this.titleStyle,
    this.description =
        "There was an error while processing your request. Please try again",
    this.descriptionStyle,
    this.actionButtonTitle = "Re-try",
    this.actionButtonStyle,
    this.showActionButton = false,
    this.actionFunction,
  });
}
