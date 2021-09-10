import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_images.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_hopper/widgets/buttons/custom_button.dart';

class UnauthenticatedPage extends StatefulWidget {
  UnauthenticatedPage({Key key}) : super(key: key);

  @override
  _UnauthenticatedPageState createState() => _UnauthenticatedPageState();
}

class _UnauthenticatedPageState extends State<UnauthenticatedPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //image
          Image.asset(
            AppImages.unauthenticatedImage,
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width * 0.20,
          ),

          //title
          Text(
            "Unauthorized",
            style: AppTextStyle.h2TitleTextStyle(
              color: AppColor.textColor(context),
            ),
          ),
          //body/description
          Text(
            "You must sign-in to access this section",
            style: AppTextStyle.h4TitleTextStyle(
              color: AppColor.textColor(context),
            ),
          ),

          //
          UiSpacer.verticalSpace(),
          //Login button
          CustomButton(
            color: AppColor.primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text(
              "Login",
              style: AppTextStyle.h4TitleTextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
             /* Navigator.pushNamed(
                context,
                AppRoutes.OtpLoginRoute,
              );*/
            },
          ),
        ],
      ),
    );
  }
}
