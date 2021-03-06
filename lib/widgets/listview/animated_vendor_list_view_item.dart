import 'package:flutter/material.dart';
import 'package:flutter_hopper/models/home_post.dart';
import 'package:flutter_hopper/widgets/listview/main_home_listview_item.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimatedVendorListViewItem extends StatelessWidget {
  final int index;
  final HomePost homePost;
  final Widget listViewItem;
  final Function OnPressed;
  const AnimatedVendorListViewItem(
      {this.index, this.listViewItem,this.homePost,this.OnPressed,Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 100),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: listViewItem ??
          HomeListViewItem(
            homePost: homePost,
            onPressed: this.OnPressed,
          ),
        ),
      ),
    );
  }
}
