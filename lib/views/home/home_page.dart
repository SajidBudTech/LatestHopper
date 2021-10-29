import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';
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

  final PageStorageBucket bucket = PageStorageBucket();
  int currentPageNumber;
  final List<Widget> pages = [
    MainHomePage(),
    PlayingPage(),
    HopperPage(),
    ProfilePage(),
  ];
  Widget currentPage = MainHomePage();
  bool showing=true;
  @override
  void initState() {
    super.initState();
    //switch page from bloc, this allow another page/bloc to determine the page for the home page
    currentPageNumber=0;
    this.initDynamicLinks();

    HomeBloc.initiBloc();
    HomeBloc.currentPageIndex.listen((currentPageIndex) {
      //_updateCurrentPageIndex(currentPageIndex);
      /*if(AudioConstant.FROM_MINI_PLAYER){
        AudioConstant.FROM_BOTTOM=true;
      }else {
        AudioConstant.FROM_BOTTOM = false;
      }*/
      _showPage(currentPageIndex);

    });
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;

          if (deepLink != null) {
            var postID = deepLink.queryParameters['postID'];
            if(postID!=null) {
              if(AudioConstant.audioViewModel!=null){
                AudioConstant.audioViewModel.player.stop();
                AudioConstant.FROM_BOTTOM=false;
              }
              HomeBloc.postID=int.parse(postID);
              _showPage(1);
            }
          }
        },
        onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
        }
    );

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      var postID = deepLink.queryParameters['postID'];
      if(postID!=null) {
        if(AudioConstant.audioViewModel!=null){
          AudioConstant.audioViewModel.player.stop();
          AudioConstant.FROM_BOTTOM=false;
        }
        HomeBloc.postID=int.parse(postID);
        _showPage(1);
      }
    }
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
                visible: AudioConstant.audioIsPlaying && currentPageNumber!=1,
                child:MiniPlayer(model: AudioConstant.audioViewModel)),
            CustomBottomNavigationBar(
              currentPageIndex: currentPageNumber,
              onItemTap: (index){
                AudioConstant.FROM_BOTTOM=true;
                AudioConstant.OFFLINECHANGE=false;
               _showPage(index);
              },
            )
          ],
        ),
        body:
        PageStorage(bucket: bucket, child: currentPage),
        /*IndexedStack(
          index: currentPageIndex,
          children: [
            MainHomePage(),
            PlayingPage(),
            HopperPage(),
            ProfilePage(),
          ],
        )*/


       /*PageView(
          controller: _pageController,
          children: <Widget>[
            //new home page
            MainHomePage(),
            PlayingPage(),
            HopperPage(),
            ProfilePage(),
          ],
          onPageChanged: _updateCurrentPageIndex,
        ),*/
      );
  }
  void _showPage(int index) {
    setState(() {
      switch (index) {
        case 0:
          currentPage = MainHomePage();
          currentPageNumber = 0;
          break;
        case 1:
          currentPage = PlayingPage();
          currentPageNumber = 1;
          break;
        case 2:
          currentPage = HopperPage();
          currentPageNumber = 2;
          break;
        case 3:
          currentPage = ProfilePage();
          currentPageNumber = 3;
          break;
      }
    });
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
    /*if(pageIndex==0){
      Navigator.pushNamed(context, AppRoutes.maiHomeRoute);
    }else if(pageIndex==1){
      Navigator.pushNamed(context, AppRoutes.playingRoute);
    }else if(pageIndex==2){
      Navigator.pushNamed(context, AppRoutes.hopperRoute);
    }else if(pageIndex==3){
      Navigator.pushNamed(context, AppRoutes.profileRoute);
    }*/
    _pageController.animateToPage(
      pageIndex,
      curve: Curves.ease,
      duration: Duration(
        microseconds: 10,
      ),
    );

  }
}
