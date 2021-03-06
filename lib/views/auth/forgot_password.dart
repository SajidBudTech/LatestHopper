
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/bloc/forgot_password.bloc.dart';
import 'package:flutter_hopper/bloc/login.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_images.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_strings.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/constants/strings/forgot_password.strings.dart';
import 'package:flutter_hopper/constants/strings/general.strings.dart';
import 'package:flutter_hopper/constants/strings/login.strings.dart';
import 'package:flutter_hopper/utils/flash_alert.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_hopper/widgets/appbar/auth_appbar.dart';
import 'package:flutter_hopper/widgets/buttons/custom_button.dart';
import 'package:flutter_hopper/widgets/inputs/custom_text_form_field.dart';
import 'package:flutter_hopper/widgets/platform/platform_circular_progress_indicator.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();

}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  //login bloc
  ForgotPasswordBloc _forgotPasswordBloc = ForgotPasswordBloc();
  //email focus node
  final emailFocusNode = new FocusNode();
  //password focus node
  final passwordFocusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    _forgotPasswordBloc.initBloc();
    //listen to the need to show a dialog alert or a normal snackbar alert type
    _forgotPasswordBloc.showAlert.listen((show) {
      //when asked to show an alert
      if (show) {
        ShowFlash(
            context,
            title: _forgotPasswordBloc.dialogData.title,
            message: _forgotPasswordBloc.dialogData.body,
            flashType: FlashType.failed
        ).show();
      }
    });

    //listen to state of the ui
    _forgotPasswordBloc.uiState.listen((uiState) async {
      if (uiState == UiState.redirect) {
        // await Navigator.popUntil(context, (route) => false);
         Navigator.pushNamed(context, AppRoutes.forgotPasswordCodeRoute,
             arguments: _forgotPasswordBloc.emailAddressTEC.text);
      }
    });
  }

  @override
  void dispose() {
    _forgotPasswordBloc.dispose();
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
                  title: "FORGOT PASSWORD?",
                  imagePath: "assets/images/appicon_mini.png",
                  backgroundColor: AppColor.accentColor,
                ),
                UiSpacer.verticalSpace(space: 20),
                Expanded(child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: AlwaysScrollableScrollPhysics(),
                    child:Container(
                        padding: AppPaddings.defaultPadding(),
                        child: Column(
                          children: [
                            Hero(
                              tag: AppStrings.authImageHeroTag,
                              child: Image.asset(
                                AppImages.forgotPasswordImage,
                              ),
                            ),
                            Container(
                                child:Text(
                                 ForgotPasswordStrings.instruction,
                                  style: AppTextStyle.h5TitleTextStyle(
                                    color:Colors.grey[400],
                                  ),
                                  textAlign: TextAlign.center,
                                  textDirection: AppTextDirection.defaultDirection,
                                )),
                            UiSpacer.verticalSpace(space: 20),
                            StreamBuilder<bool>(
                              stream: _forgotPasswordBloc.validEmailAddress,
                              builder: (context, snapshot) {
                                return CustomTextFormField(
                                  hintText: GeneralStrings.email,
                                  isFixedHeight: false,
                                  borderRadius: 32,
                                  padding: EdgeInsets.only(top: 3,bottom: 3,left: 20,right: 10),
                                  fillColor: AppColor.textFieldColor,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  textEditingController: _forgotPasswordBloc.emailAddressTEC,
                                  errorText: snapshot.error,
                                  onChanged: _forgotPasswordBloc.validateEmailAddress,
                                  focusNode: emailFocusNode,
                                  nextFocusNode: passwordFocusNode,
                                );
                              },
                            ),
                            UiSpacer.verticalSpace(space: 20),
                            StreamBuilder<UiState>(
                              stream: _forgotPasswordBloc.uiState,
                              builder: (context, snapshot) {
                                final uiState = snapshot.data;
                                return Container(
                                    width: double.infinity,
                                    child:CustomButton(
                                      padding: AppPaddings.mediumButtonPadding(),
                                      color: AppColor.accentColor,
                                      onPressed: uiState != UiState.loading
                                          ? (){
                                               _forgotPasswordBloc.resetPasswordCheclEmail();
                                             }
                                          : (){},
                                      child: uiState != UiState.loading
                                          ? Text(
                                        "SEND PASSWORD RESET LINK",
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
                          ],
                        )))),
              ],
            )
        ),
      ),
    );

  }
}
