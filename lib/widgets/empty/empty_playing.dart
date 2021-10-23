import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/home.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_images.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_hopper/widgets/buttons/custom_button.dart';

class EmptyPlayingPage extends StatefulWidget {

  EmptyPlayingPage({Key key}) : super(key: key);

  @override
  _EmptyPlayingPageState createState() => _EmptyPlayingPageState();
}

class _EmptyPlayingPageState extends State<EmptyPlayingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //image
          Image.asset(
            AppImages.appMiniLogo,
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width * 0.20,
          ),

          //title
          Text(
            "Hopper",
            style: AppTextStyle.h2TitleTextStyle(
              color: AppColor.textColor(context),
            ),
          ),
          //body/description
          UiSpacer.verticalSpace(space: 10),
          Text(
            "Choose an article from our various articles.",
            style: AppTextStyle.h4TitleTextStyle(
              color: AppColor.textColor(context),
            ),
          ),

          //
          UiSpacer.verticalSpace(),
          //Login button
          CustomButton(
            color: AppColor.accentColor,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text(
              "Select Article",
              style: AppTextStyle.h4TitleTextStyle(
                color: AppColor.primaryColor,
              ),
            ),
            onPressed: (){
              HomeBloc.switchPageToHome();
            }
          ),
        ],
      ),
    );
  }
}
