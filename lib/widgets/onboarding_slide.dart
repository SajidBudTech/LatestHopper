import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/widgets/buttons/custom_button.dart';
import 'package:lottie/lottie.dart';

class OnboardingSlide extends StatefulWidget {
  OnboardingSlide({
    Key key,
    @required this.asset,
    @required this.title,
    @required this.description,
    this.titleTextStyle,
    this.descriptionTextStyle,
    this.backgroundColor,
  }) : super(key: key);

  final String asset;
  final String title;
  final TextStyle titleTextStyle;
  final String description;
  final TextStyle descriptionTextStyle;
  final Color backgroundColor;

  @override
  _OnboardingSlideState createState() => _OnboardingSlideState();
}

class _OnboardingSlideState extends State<OnboardingSlide> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 30),
      color: widget.backgroundColor ?? Colors.white,
      child: SafeArea(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
         // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                textDirection: AppTextDirection.defaultDirection,
                style: widget.titleTextStyle ?? AppTextStyle.h2TitleTextStyle(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
           Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.description,
                textAlign: TextAlign.center,
                textDirection: AppTextDirection.defaultDirection,
                style: widget.descriptionTextStyle ??
                    AppTextStyle.h4TitleTextStyle(
                      fontWeight: FontWeight.w300,
                    ),
              ),
            ),
            Visibility(
              visible: widget.title=="TITLE 02",
              child:Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 30),
                child:CustomButton(
                padding: AppPaddings.mediumButtonPadding(),
              color: AppColor.accentColor,
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.loginRoute,
                      (route) => false,
                );
              },
              child: Text(
               "GET STARTED",
                style: AppTextStyle.h4TitleTextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
            ))
          ],
        ),
      ),
    );
  }
}
