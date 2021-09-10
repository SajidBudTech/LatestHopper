import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/viewmodels/main_home_viewmodel.dart';
import 'package:flutter_hopper/views/profile/menu_item.dart';
import 'package:flutter_hopper/widgets/appbar/account_appbar.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_hopper/models/loading_state.dart';
import 'package:flutter_hopper/widgets/shimmers/vendor_shimmer_list_view_item.dart';
import 'package:flutter_hopper/models/state_data_model.dart';
import 'package:flutter_hopper/widgets/state/state_loading_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<MainHomeViewModel>.reactive(
        viewModelBuilder: () => MainHomeViewModel(context),
        onModelReady: (model) => model.initialise(),
        builder: (context, model, child) => Scaffold(
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
                        Navigator.pushNamed(context, AppRoutes.editProfileRoute);
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
                        Navigator.pushNamed(context, AppRoutes.privacyPolicyRoute,
                        arguments: "Privacy Policy");
                      },
                    ),
                    MenuItem(
                      title: "Terms & Conditions",
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.privacyPolicyRoute,
                        arguments: "Terms & Conditions");
                      },
                    ),
                    MenuItem(
                      title: "Logout",
                      onPressed: () {

                      },
                    ),

                     ],
                   ))

                  ],
                )
            )));
  }

}
