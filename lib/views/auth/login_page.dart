
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/bloc/login.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_images.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_strings.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/constants/strings/general.strings.dart';
import 'package:flutter_hopper/constants/strings/login.strings.dart';
import 'package:flutter_hopper/utils/custom_dialog.dart';
import 'package:flutter_hopper/utils/termandcondition_utils.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_hopper/widgets/appbar/auth_appbar.dart';
import 'package:flutter_hopper/widgets/buttons/custom_button.dart';
import 'package:flutter_hopper/widgets/inputs/custom_text_form_field.dart';
import 'package:flutter_hopper/widgets/platform/platform_circular_progress_indicator.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_hopper/utils/flash_alert.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  //login bloc
  LoginBloc _loginBloc = LoginBloc();
  //email focus node
  final emailFocusNode = new FocusNode();
  //password focus node
  final passwordFocusNode = new FocusNode();

  bool isAndroid=false;

  @override
  void initState() {
    super.initState();
    _loginBloc.initBloc();
    isAndroid=Platform.isAndroid;
    //listen to the need to show a dialog alert or a normal snackbar alert type
    _loginBloc.showAlert.listen((show) {
      //when asked to show an alert
      if (show) {
        ShowFlash(
            context,
            title: _loginBloc.dialogData.title,
            message: _loginBloc.dialogData.body,
            flashType: FlashType.failed
        ).show();
      }
    });

    //listen to state of the ui
    _loginBloc.uiState.listen((uiState) async {
      if (uiState == UiState.redirect) {
        // await Navigator.popUntil(context, (route) => false);
        //Navigator.pushNamed(context, AppRoutes.homeRoute);
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.homeRoute,
              (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<
        SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
        statusBarColor: AppColor.accentColor,
      ),
    child:Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child:Column(
              children: [
                 AuthAppBar(
                    title: "LOGIN",
                    imagePath: "assets/images/appbar_image.png",
                    backgroundColor: AppColor.accentColor,
                  ),
                UiSpacer.verticalSpace(space: 20),
               Expanded(
                 child:SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                    physics: AlwaysScrollableScrollPhysics(),
                    child:Container(
                        padding: AppPaddings.defaultPadding(),
                        child: Column(
                          children: [
                            StreamBuilder<bool>(
                              stream: _loginBloc.validEmailAddress,
                              builder: (context, snapshot) {
                                return CustomTextFormField(
                                  hintText: GeneralStrings.email,
                                  isFixedHeight: false,
                                  borderRadius: 32,
                                  padding: EdgeInsets.only(top: 3,bottom: 3,left: 20,right: 10),
                                  fillColor: AppColor.textFieldColor,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  textEditingController: _loginBloc.emailAddressTEC,
                                  errorText: snapshot.error,
                                  onChanged: _loginBloc.validateEmailAddress,
                                  focusNode: emailFocusNode,
                                  nextFocusNode: passwordFocusNode,
                                );
                              },
                            ),
                            UiSpacer.verticalSpace(space: 20),
                            //password textformfield
                            StreamBuilder<bool>(
                              stream: _loginBloc.validPasswordAddress,
                              builder: (context, snapshot) {
                                return CustomTextFormField(
                                  hintText: GeneralStrings.password,
                                  isFixedHeight: false,
                                  borderRadius: 32,
                                  padding: EdgeInsets.only(top: 3,bottom: 3,left: 20,right: 10),
                                  fillColor: AppColor.textFieldColor,
                                  togglePassword: true,
                                  obscureText: true,
                                  textEditingController: _loginBloc.passwordTEC,
                                  errorText: snapshot.error,
                                 // onChanged: _loginBloc.validatePassword,
                                  focusNode: passwordFocusNode,
                                );
                              },
                            ),
                            UiSpacer.verticalSpace(space: 20),
                            StreamBuilder<UiState>(
                              stream: _loginBloc.uiState,
                              builder: (context, snapshot) {
                                final uiState = snapshot.data;
                                return Container(
                                    width: double.infinity,
                                    child:CustomButton(
                                  padding: AppPaddings.mediumButtonPadding(),
                                  color: AppColor.accentColor,
                                  onPressed: uiState != UiState.loading
                                      ? (){
                                           _loginBloc.generateLoginToken();
                                       }
                                      : (){},
                                  child: uiState != UiState.loading
                                      ? Text(
                                    LoginStrings.title,
                                    style: AppTextStyle.h4TitleTextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500
                                    ),
                                    textAlign: TextAlign.start,
                                    textDirection:
                                    AppTextDirection.defaultDirection,
                                  )
                                      : PlatformCircularProgressIndicator(),
                                ));
                              },
                            ),
                            UiSpacer.verticalSpace(space: 20),
                           Container(
                             padding: EdgeInsets.only(left: 8,right: 8),
                             child:Row(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 mainAxisSize: MainAxisSize.max,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Expanded(
                                     child: InkWell(
                                       onTap: (){
                                         Navigator.pushNamed(context, AppRoutes.forgotPasswordRoute);
                                       },
                                       child:Text(
                                         "Forgot Password?",
                                         style: AppTextStyle.h4TitleTextStyle(
                                           color: Colors.grey[400],
                                           fontWeight: FontWeight.w500
                                         ),
                                       )
                                     ),
                                   ),
                                   Expanded(
                                     child: InkWell(
                                         onTap: (){
                                           Navigator.pushNamed(context, AppRoutes.registerRoute);
                                         },
                                         child:Text(
                                           "New User?",
                                           textAlign: TextAlign.right,
                                           style: AppTextStyle.h4TitleTextStyle(
                                               color: Colors.black,
                                               fontWeight: FontWeight.w500
                                           ),
                                         )
                                     ),
                                   )
                                 ])
                           ),
                            UiSpacer.verticalSpace(space: 30),
                           Container(
                          alignment: Alignment.center,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: AppTextStyle.h5TitleTextStyle(
                                  color: Colors.grey[400], fontWeight: FontWeight.w400),
                              children: <TextSpan>[
                                TextSpan(text: 'By tapping login, you agree to following\n'),
                                TextSpan(
                                    text: 'Terms & Conditions',
                                    style: AppTextStyle.h5TitleTextStyle(
                                        color: AppColor.primaryColorDark,
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Terms.lunchTermsAndCondition();
                                      }),
                                TextSpan(text: ' & '),
                                TextSpan(
                                    text: 'Privacy Policy',
                                    style: AppTextStyle.h5TitleTextStyle(
                                        color: AppColor.primaryColorDark,
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.underline),
                                     recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Terms.lunchPrivacyPolicy();
                                      }),
                              ],
                            ),
                          )),
                            UiSpacer.verticalSpace(space: AppSizes.getScreenheight(context)*0.14),
                            Container(
                                padding: EdgeInsets.only(left: 20,right: 20),
                                child: Column(
                                  children: [
                                    Container(
                                        child:Text(
                                          "Or login via",
                                          textAlign: TextAlign.right,
                                          style: AppTextStyle.h4TitleTextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500
                                          ),
                                        )
                                    ),
                                    UiSpacer.verticalSpace(space: 30),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                            highlightColor: Colors.white,
                                            splashColor: Colors.white,
                                            onTap: (){
                                              _loginBloc.signinWithGoogle(context: context);
                                            },
                                            child: Image.asset("assets/images/google.png",
                                              height: 72,
                                              width: 72,
                                              fit: BoxFit.cover,)
                                        ),
                                        UiSpacer.horizontalSpace(),
                                        InkWell(
                                            highlightColor: Colors.white,
                                            splashColor: Colors.white,
                                            onTap: (){
                                               _loginBloc.signinWithNewFacebook(context);
                                              //Navigator.pushNamed(context, AppRoutes.loginWebView);
                                            },
                                            child: Image.asset("assets/images/fb.png",
                                              height: 72,
                                              width: 72,
                                            )
                                        ),
                                        Platform.isIOS?
                                        Padding(
                                            padding: EdgeInsets.only(left: 20),
                                            child:InkWell(
                                            highlightColor: Colors.white,
                                            splashColor: Colors.white,
                                            onTap: (){
                                              _loginBloc.signinWithApple(context: context);
                                            },
                                            child: Image.asset("assets/images/apple.png",
                                              height: 72,
                                              width: 72,)
                                        )):SizedBox.shrink()

                                      ],
                                    ),
                                  ],
                                ))
                          ],
                        )))),
                      ],
                    )
                ),
              ),
        );

  }


  

}
