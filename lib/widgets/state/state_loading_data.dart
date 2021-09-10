import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/models/state_data_model.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_hopper/widgets/buttons/custom_button.dart';

class LoadingStateDataView extends StatefulWidget {
  final StateDataModel stateDataModel;
  final double padding;
  LoadingStateDataView({
    Key key,
    this.stateDataModel,
    this.padding,
  }) : super(key: key);

  @override
  _LoadingStateDataViewState createState() => _LoadingStateDataViewState();
}

class _LoadingStateDataViewState extends State<LoadingStateDataView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widget.padding ?? AppPaddings.contentPaddingSize),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            widget.stateDataModel.imageAssetPath,
            width: (widget.stateDataModel.imageWidth != null)
                ? widget.stateDataModel.imageWidth
                : MediaQuery.of(context).size.width * 0.3,
            height: (widget.stateDataModel.imageHeight != null)
                ? widget.stateDataModel.imageHeight
                : MediaQuery.of(context).size.height * 0.2,
          ),
          (widget.stateDataModel.title.isNotEmpty)
              ? UiSpacer.verticalSpace(space: 10)
              : SizedBox.shrink(),
          (widget.stateDataModel.title.isNotEmpty)
              ? Text(
                  widget.stateDataModel.title,
                  textAlign: TextAlign.center,
                  style: widget.stateDataModel.titleStyle ??
                      AppTextStyle.h2TitleTextStyle(),
                )
              : SizedBox.shrink(),
          (widget.stateDataModel.description.isNotEmpty)
              ? UiSpacer.verticalSpace(space: 5)
              : SizedBox.shrink(),
          (widget.stateDataModel.description.isNotEmpty)
              ? Text(
                  widget.stateDataModel.description,
                  textAlign: TextAlign.center,
                  style: widget.stateDataModel.descriptionStyle ??
                      AppTextStyle.h4TitleTextStyle(),
                )
              : SizedBox.shrink(),
          UiSpacer.verticalSpace(space: 10),
          (widget.stateDataModel.showActionButton)
              ? CustomButton(
                  onPressed: widget.stateDataModel.actionFunction,
                  // title: widget.stateDataModel.actionButtonTitle,
                  child: Text(
                    widget.stateDataModel.actionButtonTitle,
                    style: widget.stateDataModel.actionButtonStyle ??
                        AppTextStyle.h3TitleTextStyle(
                          color: Colors.white,
                        ),
                  ),
                )
              : SizedBox.shrink(),
          // UiSpacer.verticalSpace(space: 10),
        ],
      ),
    );
  }
}
