import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/views/appbarview/notification_page.dart';
import 'package:flutter_hopper/views/appbarview/search_page.dart';
import 'package:flutter_hopper/views/auth/forgot_password.dart';
import 'package:flutter_hopper/views/auth/forgot_password_code.dart';
import 'package:flutter_hopper/views/auth/forgot_pasword_reset.dart';
import 'package:flutter_hopper/views/auth/login_page.dart';
import 'package:flutter_hopper/views/auth/onboarding_page.dart';
import 'package:flutter_hopper/views/auth/register_page.dart';
import 'package:flutter_hopper/views/home/author_detail_page.dart';
import 'package:flutter_hopper/views/home/home_filter_page.dart';
import 'package:flutter_hopper/views/home/home_page.dart';
import 'package:flutter_hopper/views/profile/change_pasword.dart';
import 'package:flutter_hopper/views/profile/edit_profile_page.dart';
import 'package:flutter_hopper/views/profile/privacy_policy_page.dart';
import 'package:flutter_hopper/views/profile/subcription_details_page.dart';
import 'package:flutter_hopper/views/subcription/purchase_subcription.dart';



Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {

    case AppRoutes.welcomeRoute:
      return MaterialPageRoute(builder: (context) => OnboardingPage());

    case AppRoutes.loginRoute:
      return MaterialPageRoute(builder: (context) => LoginPage());

    case AppRoutes.registerRoute:
      return MaterialPageRoute(builder: (context) => RegisterPage());

    case AppRoutes.forgotPasswordRoute:
      return MaterialPageRoute(builder: (context) => ForgotPasswordPage());

    case AppRoutes.forgotPasswordCodeRoute:
      return MaterialPageRoute(builder: (context) => VerifyCodePage(
        email: settings.arguments,
      ));
    case AppRoutes.forgotPasswordReset:
      List data=settings.arguments as List;
      return MaterialPageRoute(builder: (context) => SetNewPasswordPage(
        email: data[0],
        code: data[1],
      ));

    case AppRoutes.subcriptionPurchaseRoute:
      return MaterialPageRoute(builder: (context) => SubcriptionPurchasePage());

    case AppRoutes.homeRoute:
      return MaterialPageRoute(builder: (context) => HomePage());
    case AppRoutes.filterRoute:
      return MaterialPageRoute(builder: (context) => HomeFilterPage(
        title: settings.arguments,
      ));

    case AppRoutes.editProfileRoute:
      return MaterialPageRoute(builder: (context) => EditProfilePage());
    case AppRoutes.subscriptionDetailsRoute:
      return MaterialPageRoute(builder: (context) => SubcriptionDetailPage());
    case AppRoutes.changePasswordRoute:
      return MaterialPageRoute(builder: (context) => ChangePasswordPage());
    case AppRoutes.privacyPolicyRoute:
      return MaterialPageRoute(builder: (context) => PrivacyPolicyPage(
        title: settings.arguments,
      ));

    case AppRoutes.notificationsRoute:
      return MaterialPageRoute(builder: (context) => NotificationPage());

    case AppRoutes.searchHopperPage:
      return MaterialPageRoute(builder: (context) => SearchHopperPage());

    case AppRoutes.authorDetailRoute:
      return MaterialPageRoute(builder: (context) => AuthorDetailPage());

   /*
    case AppRoutes.welcomeRoute:
      return MaterialPageRoute(builder: (context) => OnboardingPage());

    case AppRoutes.loginRoute:
      return MaterialPageRoute(builder: (context) => LoginPage());
    *//*case AppRoutes.registerRoute:
      return MaterialPageRoute(builder: (context) => NewRegisterPage());*//*

    case AppRoutes.forgotPasswordRoute:
      return MaterialPageRoute(builder: (context) => ForgotPasswordPage());


    case AppRoutes.homeRoute:
      return MaterialPageRoute(
        settings: RouteSettings(name: AppRoutes.homeRoute, arguments: Map()),
        builder: (context) => HomePage(),
      );




    default:
      return MaterialPageRoute(builder: (context) => OnboardingPage());*/
  }
}
