import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/strings/home.string.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';


class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    Key key,
    @required this.currentPageIndex,
    @required this.onItemTap,
  }) : super(key: key);

  final int currentPageIndex;
  final Function(int) onItemTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: AppColor.primaryColorDark,
      currentIndex: currentPageIndex,
      onTap: onItemTap,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      selectedLabelStyle: AppTextStyle.h7TitleTextStyle(
        fontWeight: FontWeight.w600,
        color: AppColor.bottomNavigationItemSelectedColor(
          context,
        ),
      ),
      unselectedLabelStyle: AppTextStyle.h7TitleTextStyle(
        fontWeight: FontWeight.w400,
        color: AppColor.bottomNavigationItemUnselectedColor(
          context,
        ),
      ),
      selectedItemColor: AppColor.bottomNavigationItemSelectedColor(
        context,
      ),
      unselectedItemColor: AppColor.bottomNavigationItemUnselectedColor(
        context,
      ),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon:new Image.asset(
            "assets/images/bbar_home.png",
            height: 30,
            width: 30,
            color: currentPageIndex == 0
                ? AppColor.bottomNavigationItemSelectedColor(
              context,
            )
                : AppColor.bottomNavigationItemUnselectedColor(
              context,
            ),
          ),
          label: HomeStrings.BottomBarhome,
        ),
        BottomNavigationBarItem(
          icon: new Image.asset(
            "assets/images/bbar_playing.png",
            height: 30,
            width: 30,
            color: currentPageIndex == 1
                ? AppColor.bottomNavigationItemSelectedColor(
              context,
            )
                : AppColor.bottomNavigationItemUnselectedColor(
              context,
            ),
          ),
          label: HomeStrings.BottomBarPlaying,
        ),
        BottomNavigationBarItem(
          icon:new Image.asset(
            "assets/images/bbar_hopper.png",
            height: 30,
            width: 30,
            color: currentPageIndex == 2
                ? AppColor.bottomNavigationItemSelectedColor(
              context,
                )
                : AppColor.bottomNavigationItemUnselectedColor(
              context,
            ),
          ),
          label: HomeStrings.BottomBarHopper,
        ),
        BottomNavigationBarItem(
          icon: new Image.asset(
            "assets/images/bbar_profile.png",
            height: 30,
            width: 30,
            color: currentPageIndex == 3
                ? AppColor.bottomNavigationItemSelectedColor(
                    context,
                  )
                : AppColor.bottomNavigationItemUnselectedColor(
                    context,
                  ),
             ),
          label: HomeStrings.BottomBarProfile,
        ),
      ],
    );

    /*BottomAnimation(
     // elevation: 4,
      backgroundColor: AppColor.appBackground(context),
     // currentIndex: currentPageIndex,
      onItemSelect: onItemTap,
      selectedIndex: currentPageIndex,
      itemHoverColor: AppColor.primaryColor,
      itemHoverColorOpacity: .5,
      activeIconColor: AppColor.accentColor,
      deactiveIconColor: AppColor.hintTextColor(context),
      barRadius: 0,
      textStyle: AppTextStyle.h4TitleTextStyle(color: AppColor.accentColor),
      itemHoverWidth: 135,
      itemHoverBorderRadius: 30,
     // onTap: onItemTap,
    //  type: BottomNavigationBarType.fixed,
      //showUnselectedLabels: false,
     */ /* selectedLabelStyle: AppTextStyle.h5TitleTextStyle(
        color: AppColor.bottomNavigationItemSelectedColor(
          context,
        ),
      ),
      unselectedLabelStyle: AppTextStyle.h5TitleTextStyle(
        color: AppColor.bottomNavigationItemUnselectedColor(
          context,
        ),
      ),
      selectedItemColor: AppColor.bottomNavigationItemSelectedColor(
        context,
      ),
      unselectedItemColor: AppColor.bottomNavigationItemUnselectedColor(
        context,
      ),*/ /*
      items:


      <BottomNavItem>[
        BottomNavItem(
            title: HomeStrings.BottomBarhome,
            */ /*widget: */ /**/ /*Image.asset(
              'assets/images/bottom_home.png',
              width: 24,
            )*/ /**/ /*
            Icon(
              FlutterIcons.home_ant,
              size: 24,
            ),*/ /*
          iconData: FlutterIcons.home_ant
        ),
        BottomNavItem(
            title: HomeStrings.BottomBarBookAppointment,
           */ /* widget: Image.asset(
              'assets/images/bottom_book.png',
              width: 24,
            ),*/ /*
          iconData: FlutterIcons.calendar_ant,
        ),
      */ /*  BottomNavItem(
            title: HomeStrings.BottomBarLoyalty,
           */ /**/ /* widget: Image.asset(
              'assets/images/bottom_loyalty.png',
              width: 24,
            )*/ /**/ /*
          iconData: FlutterIcons.star_outlined_ent

        ),*/ /*
        BottomNavItem(
            title: HomeStrings.BottomBarProfile,
           */ /* widget: Image.asset(
              'assets/images/bottom_profile.png',
              width: 24,
            )),*/ /*
            iconData: FlutterIcons.user_sli
        )
       */ /* BottomNavigationBarItem(
          icon: Icon(
            FlutterIcons.home_ant,
            size: 20,
          ),
          label: HomeStrings.BottomBarhome,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FlutterIcons.calendar_ant,
            size: 20,
          ),
          label:HomeStrings.BottomBarBookAppointment,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FlutterIcons.star_ant,
            size: 20,
          ),
          label: HomeStrings.BottomBarLoyalty,
        ),*/ /*
       */ /* BottomNavigationBarItem(
          //listen to stream on list of food in cart
        */ /**/ /*  icon: StreamBuilder<List<Product>>(
            stream: AppDatabaseSingleton.database.productDao
                .findAllProductsAsStream(),
            builder: (context, snapshot) {
              return Badge(
                badgeContent: Text(
                  //if no item in cart, don't even bother showing the cart item count
                  snapshot.hasData ? "${snapshot.data.length}" : "0",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                badgeColor: AppColor.accentColor,
                //if no item in cart, don't even bother showing the badge
                showBadge: snapshot.hasData && snapshot.data.length > 0,
                position: BadgePosition.topEnd(top: -5, end: -5),
                child: Icon(
                  AntDesign.shoppingcart,
                ),
              );*/ /**/ /*
           // },
         // ),
          icon: Icon(
            AntDesign.star,
            size: 20,
          ),
          label: HomeStrings.BottomBarLoyalty,
        ),*/ /*
        */ /*BottomNavigationBarItem(
          icon: Icon(
            FlutterIcons.user_ant,
            size: 20,
          ),
          label:HomeStrings.BottomBarProfile,
        ),*/ /*
      ],
    );*/
  }
}
