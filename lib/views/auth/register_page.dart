
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/bloc/login.bloc.dart';
import 'package:flutter_hopper/bloc/register.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_images.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_strings.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/constants/strings/general.strings.dart';
import 'package:flutter_hopper/constants/strings/login.strings.dart';
import 'package:flutter_hopper/utils/flash_alert.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_hopper/widgets/appbar/auth_appbar.dart';
import 'package:flutter_hopper/widgets/buttons/custom_button.dart';
import 'package:flutter_hopper/widgets/inputs/custom_text_form_field.dart';
import 'package:flutter_hopper/widgets/platform/platform_circular_progress_indicator.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //login bloc
  RegisterBloc _registerBloc = RegisterBloc();
  //email focus node
  final emailFocusNode = new FocusNode();
  final nameFocusNode = new FocusNode();
  final confirmFocusNode = new FocusNode();
  //password focus node
  final passwordFocusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    _registerBloc.initBloc();
    //listen to the need to show a dialog alert or a normal snackbar alert type
    _registerBloc.showAlert.listen((show) {
      //when asked to show an alert
      if (show) {
        ShowFlash(
            context,
            title: _registerBloc.dialogData.title,
            message: _registerBloc.dialogData.body
          ).show();
        /*Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.homeRoute,
          (route) => false,
        );*/
      }
    });

    //listen to state of the ui
    _registerBloc.uiState.listen((uiState) async {
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
    _registerBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext viewcontext) {
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
                  title: "SIGNUP",
                  imagePath: "assets/images/appbar_image.png",
                  backgroundColor: AppColor.accentColor,
                ),
                //UiSpacer.verticalSpace(space: 20),
                Expanded(child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: AlwaysScrollableScrollPhysics(),
                    child:Container(
                        padding: AppPaddings.defaultPadding(),
                        child: Column(
                          children: [
                            StreamBuilder<bool>(
                              stream: _registerBloc.validName,
                              builder: (context, snapshot) {
                                return CustomTextFormField(
                                  hintText: GeneralStrings.fullname,
                                  isFixedHeight: false,
                                  borderRadius: 32,
                                  padding: EdgeInsets.only(top: 3,bottom: 3,left: 20,right: 10),
                                  fillColor: AppColor.textFieldColor,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  textEditingController: _registerBloc.nameTEC,
                                  errorText: snapshot.error,
                                  onChanged: _registerBloc.validateName,
                                  focusNode: nameFocusNode,
                                  nextFocusNode: emailFocusNode,
                                );
                              },
                            ),
                            UiSpacer.verticalSpace(space: 20),
                            StreamBuilder<bool>(
                              stream: _registerBloc.validEmailAddress,
                              builder: (context, snapshot) {
                                return CustomTextFormField(
                                  hintText: GeneralStrings.email,
                                  isFixedHeight: false,
                                  borderRadius: 32,
                                  padding: EdgeInsets.only(top: 3,bottom: 3,left: 20,right: 10),
                                  fillColor: AppColor.textFieldColor,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  textEditingController: _registerBloc.emailAddressTEC,
                                  errorText: snapshot.error,
                                  onChanged: _registerBloc.validateEmailAddress,
                                  focusNode: emailFocusNode,
                                  nextFocusNode: passwordFocusNode,
                                );
                              },
                            ),
                            UiSpacer.verticalSpace(space: 20),
                            //password textformfield
                            StreamBuilder<bool>(
                              stream: _registerBloc.validPassword,
                              builder: (context, snapshot) {
                                return CustomTextFormField(
                                  hintText: GeneralStrings.password,
                                  isFixedHeight: false,
                                  borderRadius: 32,
                                  padding: EdgeInsets.only(top: 3,bottom: 3,left: 20,right: 10),
                                  fillColor: AppColor.textFieldColor,
                                  togglePassword: true,
                                  obscureText: true,
                                  textEditingController: _registerBloc.passwordTEC,
                                  errorText: snapshot.error,
                                  onChanged: _registerBloc.validatePassword,
                                  focusNode: passwordFocusNode,
                                  nextFocusNode: confirmFocusNode,
                                );
                              },
                            ),
                            UiSpacer.verticalSpace(space: 20),
                            StreamBuilder<bool>(
                              stream: _registerBloc.validConfirmPassword,
                              builder: (context, snapshot) {
                                return CustomTextFormField(
                                  hintText: GeneralStrings.confirmpassword,
                                  isFixedHeight: false,
                                  borderRadius: 32,
                                  padding: EdgeInsets.only(top: 3,bottom: 3,left: 20,right: 10),
                                  fillColor: AppColor.textFieldColor,
                                  togglePassword: true,
                                  obscureText: true,
                                  textEditingController: _registerBloc.confirmPaswordTEC,
                                  errorText: snapshot.error,
                                  onChanged: _registerBloc.validatePassword,
                                );
                              },
                            ),
                            UiSpacer.verticalSpace(space: 20),
                            StreamBuilder<UiState>(
                              stream: _registerBloc.uiState,
                              builder: (context, snapshot) {
                                final uiState = snapshot.data;
                                return Container(
                                    width: double.infinity,
                                    child:CustomButton(
                                      padding: AppPaddings.mediumButtonPadding(),
                                      color: AppColor.accentColor,
                                      onPressed: uiState != UiState.loading
                                          ? (){
                                            //Navigator.pushNamed(context, AppRoutes.subcriptionPurchaseRoute);
                                          if(_registerBloc.passwordTEC.text==_registerBloc.confirmPaswordTEC.text){
                                            _registerBloc.processRegiration();
                                          }else{
                                             ShowFlash(
                                                 viewcontext,
                                                 title: "Password does not match with confirmpassword!",
                                                 message: "Please try again"
                                             ).show();
                                          }
                                         }
                                          : null,
                                      child: uiState != UiState.loading
                                          ? Text(
                                        "SIGN UP",
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
                                child:InkWell(
                                    onTap: (){
                                      Navigator.pushNamed(context, AppRoutes.loginRoute);
                                    },
                                    child:Text(
                                      "Back To Login",
                                      style: AppTextStyle.h4TitleTextStyle(
                                          color: AppColor.primaryColorDark,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.underline
                                      ),
                                    )
                                ),
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
                                              print('Terms of Service"');
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
                                              print('Privacy Policy"');
                                            }),
                                    ],
                                  ),
                                )),
                            UiSpacer.verticalSpace(space: 50),
                            Container(
                                child:Text(
                                  "Or signup via",
                                  textAlign: TextAlign.right,
                                  style: AppTextStyle.h4TitleTextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500
                                  ),
                                )
                            ),
                            UiSpacer.verticalSpace(space: 30),
                            Container(
                              padding: EdgeInsets.only(left: 40,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                      highlightColor: Colors.white,
                                      splashColor: Colors.white,
                                      onTap: (){

                                      },
                                      child: Image.asset("assets/images/google.png",
                                        height: 72,
                                        width: 72,)
                                  ),
                                  InkWell(
                                      highlightColor: Colors.white,
                                      splashColor: Colors.white,
                                      onTap: (){

                                      },
                                      child: Image.asset("assets/images/fb.png",
                                        height: 72,
                                        width: 72,)
                                  ),
                                  InkWell(
                                      highlightColor: Colors.white,
                                      splashColor: Colors.white,
                                      onTap: (){

                                      },
                                      child: Image.asset("assets/images/apple.png",
                                        height: 72,
                                        width: 72,)
                                  )

                                ],
                              ),
                            )


                          ],
                        )))),
              ],
            )
        ),
      ),
    );

  }
}
