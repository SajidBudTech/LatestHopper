import 'package:flutter/material.dart';

class EmptyAppBar extends AppBar with PreferredSizeWidget {
  @override
  get preferredSize => Size.fromHeight(0);

  EmptyAppBar({
    Key key,
    Color backgroundColor,
    Brightness brightness,
  }) : super(
          key: key,
          backgroundColor: backgroundColor,
          brightness: brightness,
          automaticallyImplyLeading: false, // hides leading widget
          flexibleSpace: SizedBox.shrink(),
          elevation: 0,
        );
}
