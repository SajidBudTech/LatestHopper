import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';

class MenuItem extends StatefulWidget {
  MenuItem({
    Key key,
    this.title,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;
  //final IconData iconData;
  final String title;
  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: widget.onPressed,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          0,
          16,
          0,
          16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: AppTextDirection.defaultDirection,
          children: <Widget>[
            /*Expanded(
              flex: 1,
              child: Icon(
                widget.iconData,
                color: AppColor.primaryColorDark,
              ),
            ),
            SizedBox(
              width: 10,
            ),*/
            Expanded(
              flex: 8,
              child: Text(
                widget.title,
                textDirection: AppTextDirection.defaultDirection,
                style: AppTextStyle.h4TitleTextStyle(
                  color: AppColor.textColor(context),
                ),
              ),
            ),
           /* SizedBox(
              width: 10,
            ),*/
            /*Expanded(
              flex: 1,
              child: Icon(
                SimpleLineIcons.arrow_right,
                size: 18,
                color: AppColor.primaryColorDark,
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
