import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hopper/constants/app_animations.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_images.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/constants/strings/onboarding.strings.dart';
import 'package:flutter_hopper/widgets/cool_onboarding.dart';
import 'package:flutter_hopper/widgets/onboarding_slide.dart';

class OnboardingPage extends StatefulWidget {
  OnboardingPage({
    Key key,
  }) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  void _completedOnboarding() {
    //route to login page
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.homeRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CoolOnboarding(
        onSkipPressed: _completedOnboarding,
        onCompletedPressed: _completedOnboarding,
        indicatorDotColor: AppColor.onboardingIndicatorDotColor,
        indicatorActiveDotColor: AppColor.onboardingIndicatorActiveDotColor,
        onBoardingSlides: [
          OnboardingSlide(
            asset: AppImages.onboardingimageone,
            title: OnboardingStrings.onboarding1Title,
            description: OnboardingStrings.onboarding1Body,
            backgroundColor: Colors.white,
            titleTextStyle: AppTextStyle.h2TitleTextStyle(
                fontWeight:FontWeight.w600,
                color: Colors.black
            ),
            descriptionTextStyle: AppTextStyle.h4TitleTextStyle(
                fontWeight:FontWeight.w300
            ),
          ),
          OnboardingSlide(
            asset: AppImages.onboardingimage,
            title: OnboardingStrings.onboarding2Title,
            description: OnboardingStrings.onboarding2Body,
            backgroundColor: Colors.white,
            titleTextStyle: AppTextStyle.h4TitleTextStyle(
                fontWeight:FontWeight.w600,
                color: Colors.black
            ),
            descriptionTextStyle: AppTextStyle.h6TitleTextStyle(
                fontWeight:FontWeight.w300
            ),
          ),
        ],
      ),
    );
  }
}
