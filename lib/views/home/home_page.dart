import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hopper/views/home/main_home_page.dart';
import 'package:flutter_hopper/views/hopper/hopper_page.dart';
import 'package:flutter_hopper/views/miniplayer/mini_player.dart';
import 'package:flutter_hopper/views/playing/playing_page.dart';
import 'package:flutter_hopper/views/profile/profile_page.dart';
import 'package:flutter_hopper/widgets/custom_bottom_navigation_appbar.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_hopper/bloc/home.bloc.dart';
import 'package:flutter_hopper/views/home/home_warning_widget.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //current bottom navigation bar index
  int currentPageIndex = 0;
  final PageController _pageController = PageController();
  bool showing=true;
  @override
  void initState() {
    super.initState();
    //switch page from bloc, this allow another page/bloc to determine the page for the home page

    HomeBloc.initiBloc();
    HomeBloc.currentPageIndex.listen((currentPageIndex) {
      _updateCurrentPageIndex(currentPageIndex);
    });
  }



  @override
  void dispose() {
    super.dispose();
    HomeBloc.closeListener();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
                visible: showing,
                child:WarningPage()),
            Visibility(
                visible: showing,
                child:MiniPlayer()),
            CustomBottomNavigationBar(
              currentPageIndex: currentPageIndex,
              onItemTap: _updateCurrentPageIndex,
            )
          ],
        ),
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            //new home page
            MainHomePage(),
            PlayingPage(),
            HopperPage(),
            ProfilePage(),
          ],
          onPageChanged: _updateCurrentPageIndex,
        ),
      );
  }

  //update the current page index
  void _updateCurrentPageIndex(int pageIndex) {
    setState(() {
      if(pageIndex==0){
        showing=true;
      }else{
        showing=false;
      }
      currentPageIndex = pageIndex;
    });
    _pageController.animateToPage(
      pageIndex,
      curve: Curves.ease,
      duration: Duration(
        microseconds: 10,
      ),
    );
  }
}
