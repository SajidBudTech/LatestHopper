import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';

class BottomDialogListViewItem extends StatefulWidget {
  const BottomDialogListViewItem({
    Key key,
    @required this.title,
    this.onPressed,
  }) : super(key: key);

  // final NotificationModel notification;
  final String title;
  final Function(String) onPressed;

  @override
  _BottomDialogListViewItemState createState() => _BottomDialogListViewItemState();

}
class _BottomDialogListViewItemState extends State<BottomDialogListViewItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: ()=>widget.onPressed(widget.title),
        child:Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: 10,bottom: 10),
            child:Text(
              widget.title??"",
              style: AppTextStyle.h4TitleTextStyle(
                  color:AudioConstant.sleeperActiveTime==widget.title?AppColor.accentColor:Colors.grey,
                  fontWeight: FontWeight.w500
              ),
              textAlign: TextAlign.start,
              textDirection: AppTextDirection.defaultDirection,
            )
        ));
  }

}
