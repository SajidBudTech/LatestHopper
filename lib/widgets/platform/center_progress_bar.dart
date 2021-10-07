import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CenterCircularProgressIndicator extends StatelessWidget {
  const CenterCircularProgressIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:Platform.isIOS
            ? CupertinoActivityIndicator()
            : SizedBox(
          child: CircularProgressIndicator(),
          width: 36,
          height: 36,
        ),
      ),
    );
  }
}
