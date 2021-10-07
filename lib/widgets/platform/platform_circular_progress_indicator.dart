import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';

class PlatformCircularProgressIndicator extends StatelessWidget {
  const PlatformCircularProgressIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoActivityIndicator()
        : SizedBox(
            child: CircularProgressIndicator(
              backgroundColor: AppColor.primaryColor,
            ),
            width: 32,
            height: 32,
          );
  }
}
