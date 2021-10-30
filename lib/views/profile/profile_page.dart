import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/profile.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/utils/termandcondition_utils.dart';
import 'package:flutter_hopper/viewmodels/main_home_viewmodel.dart';
import 'package:flutter_hopper/views/profile/menu_item.dart';
import 'package:flutter_hopper/widgets/appbar/account_appbar.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:flutter_hopper/constants/app_strings.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  bool get wantKeepAlive => true;
  ProfileBloc _profileBlo=ProfileBloc();
 // String userFullName="";
 // String userEmail="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profileBlo.initBloc();
    //userFullName=AuthBloc.getUserFullName();
    //userEmail=AuthBloc.getUserEmail();
  }

  @override
  Widget build(BuildContext viewcontext) {
    super.build(context);
    return Scaffold(
            body:Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/shape_account.png'),
                        fit: BoxFit.fill)),
                child:Column(
                  children: [

                    ProfileAppBar(
                      imagePath: "assets/images/appbar_image.png",
                      backgroundColor: AppColor.accentColor,
                      name: _profileBlo.userFullName??"",
                      email: _profileBlo.userEmail??"",
                      onPressed: (){
                        Navigator.pop(context, false);
                      },
                    ),
                   //UiSpacer.verticalSpace(),
                   // UiSpacer.verticalSpace(),
            Expanded(
                child: ListView(
                  padding: AppPaddings.defaultPadding(),
                  children: [
                    MenuItem(
                      title: "Edit Profile",
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.editProfileRoute).then((value) {
                             if(AudioConstant.FROM_UPDATE_PROFILE){
                               _profileBlo.initBloc();
                                rebuildWidget();
                             }
                          }
                        );
                      },
                     ),
                    MenuItem(
                      title: "Subscription Details",
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.subscriptionDetailsRoute);
                      },
                    ),
                    MenuItem(
                      title: "Change Password",
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.changePasswordRoute);
                      },
                    ),
                    MenuItem(
                      title: "Privacy Policy",
                      onPressed: () {
                        /*Navigator.pushNamed(context, AppRoutes.privacyPolicyRoute,
                        arguments: "Privacy Policy");*/
                        Terms.lunchPrivacyPolicy();
                      },
                    ),
                    MenuItem(
                      title: "Terms & Conditions",
                      onPressed: () {
                       /* Navigator.pushNamed(context, AppRoutes.privacyPolicyRoute,
                        arguments: "Terms & Conditions");*/
                        Terms.lunchTermsAndCondition();
                      },
                    ),
                    MenuItem(
                      title: "Logout",
                      onPressed: () {
                        _showLogoutDialog(viewcontext);
                      },
                     ),

                     ],
                   ))

                  ],
                )
            ));
  }

  void _processLogout(BuildContext viewcontext) async {

    if(AudioConstant.audioIsPlaying){
      await AudioConstant.audioViewModel.player.stop();
    }

    await AuthBloc.prefs.setBool(AppStrings.authenticated, false);
    Navigator.pushNamedAndRemoveUntil(
      viewcontext,
      AppRoutes.loginRoute,
          (route) => false,
    );

  }

  Future<bool> _showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(
          'Logout',
          style: AppTextStyle.h3TitleTextStyle(
            color: AppColor.accentColor,
          ),
          textDirection: AppTextDirection.defaultDirection,
        ),
        content: new Text('Logout of Hopper Audio?',
            style: AppTextStyle.h4TitleTextStyle(
              color: AppColor.textColor(context),
            ),
            textDirection: AppTextDirection.defaultDirection),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No',
                style: AppTextStyle.h4TitleTextStyle(
                  color: AppColor.primaryColorDark,
                ),
                textDirection: AppTextDirection.defaultDirection),
          ),
          new FlatButton(
            onPressed: () => _processLogout(context),
            child: new Text('Yes',
                style: AppTextStyle.h4TitleTextStyle(
                  color: AppColor.primaryColorDark,
                ),
                textDirection: AppTextDirection.defaultDirection),
          ),
        ],
      ),
    ) ??
        false;
  }
  void rebuildWidget() {
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        AudioConstant.FROM_UPDATE_PROFILE=false;
      });
    });
  }
}
