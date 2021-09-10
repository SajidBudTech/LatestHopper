import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';

class HopperSortListViewItem extends StatefulWidget {
  const HopperSortListViewItem({
    Key key,
    @required this.notification,
    this.onPressed,
  }) : super(key: key);

  // final NotificationModel notification;
  final String notification;
  final Function onPressed;

  @override
  _HopperSortListViewItemState createState() => _HopperSortListViewItemState();

}
class _HopperSortListViewItemState extends State<HopperSortListViewItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onPressed,
        child:Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: 10,bottom: 10),
            child:Text(
              widget.notification,
              style: AppTextStyle.h4TitleTextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500
              ),
              textAlign: TextAlign.start,
              textDirection: AppTextDirection.defaultDirection,
            )
        ));
  }

}
