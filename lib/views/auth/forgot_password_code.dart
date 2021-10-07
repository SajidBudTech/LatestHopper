

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/bloc/forgot_password.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/utils/flash_alert.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_hopper/widgets/appbar/common_app_bar.dart';
import 'package:flutter_hopper/widgets/appbar/empty_appbar.dart';
import 'package:flutter_hopper/widgets/buttons/custom_button.dart';
import 'package:flutter_hopper/widgets/inputs/custom_otp_field_input.dart';
import 'package:flutter_hopper/widgets/inputs/custom_text_form_field.dart';
import 'package:flutter_hopper/widgets/platform/platform_circular_progress_indicator.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class VerifyCodePage extends StatefulWidget {
  VerifyCodePage({Key key, this.email}) : super(key: key);

  String email;
  @override
  _VerifyCodePageState createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  //login bloc
  ForgotPasswordBloc _forgotPasswordBloc = ForgotPasswordBloc();
  //email focus node

  final firstFocusNode = new FocusNode();
  //password focus node
  final secondFocusNode = new FocusNode();
  final threeFocusNode = new FocusNode();
  final fourthFocusNode = new FocusNode();
  final fifthFocusNode = new FocusNode();
  final sixthFocusNode = new FocusNode();

  String pin="";
  @override
  void initState() {
    super.initState();

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
        Navigator.pushNamed(context, AppRoutes.forgotPasswordReset,
         arguments: [widget.email,pin]);
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   AppRoutes.homeRoute,
        //   (route) => false,
        // );
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
    return

      /*    Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFDBB6), Color(0xFFFFFFFF)])),
        child: */
      Scaffold(
          /*  primary: false,
            appBar: EmptyAppBar(),
            extendBodyBehindAppBar: true,*/
            backgroundColor: Colors.white,
            body: SafeArea(child:
            Column(
              children: [
                //body
                CommonAppBar(
                  title: "Verify Code",
                  backgroundColor: AppColor.accentColor,
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                UiSpacer.verticalSpace(),
                Expanded(child:CustomScrollView(
                  slivers: <Widget>[
                    /*   SliverPadding(
                      padding: EdgeInsets.only(),
                      sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            //page title*/
                    SliverToBoxAdapter(
                        child: UiSpacer.verticalSpace(space: 89)),
                    SliverPadding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              Text(
                                "Enter Your Code",
                                style: AppTextStyle.h1TitleTextStyle(
                                  color: AppColor.textColor(context),
                                ),
                                textAlign: TextAlign.start,
                                textDirection: AppTextDirection.defaultDirection,
                              ),
                              UiSpacer.verticalSpace(space: 9),
                              Text(
                                "A password reset email has been sent to your email address",
                                style: AppTextStyle.h4TitleTextStyle(
                                    color: AppColor.hintTextColor(context),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.start,
                                textDirection: AppTextDirection.defaultDirection,
                              )
                            ]))),
                    SliverPadding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              UiSpacer.verticalSpace(space: 24),
                              OTPTextField(
                                length: 4,
                                width: (MediaQuery.of(context).size.width)-40,
                                textFieldAlignment: MainAxisAlignment.spaceEvenly,
                                fieldWidth: 56,
                                fieldStyle: FieldStyle.underline,
                               // outlineBorderRadius: 15,
                                style: AppTextStyle.h3TitleTextStyle(
                                  color: Colors.black
                                ),
                                onChanged: (pin) {
                                  this.pin=pin;
                                  print("Changed: " + pin);
                                },
                                onCompleted: (pin) {
                                   this.pin=pin;
                                   _verifyOtp(pin);
                                },
                              ),

                             /* Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 *//* Expanded(
                                      flex: 1,
                                      child:*//* StreamBuilder<bool>(
                                        stream: _forgotPasswordBloc.validDigit,
                                        builder: (context, snapshot) {
                                          return CustomTextOTPField(
                                            hintText: "0",
                                            isFixedHeight: true,
                                            isFixedWidth: true,
                                            hintTextStyle: AppTextStyle.h2TitleTextStyle(color: AppColor.hintTextColor(context), fontWeight: FontWeight.w100),
                                            keyboardType: TextInputType.phone,
                                            textInputAction: TextInputAction.next,
                                            textStyle: AppTextStyle.h1TitleTextStyle(fontWeight: FontWeight.w400),
                                            textEditingController: _forgotPasswordBloc.firstDigitTEC,
                                            errorText: snapshot.error,
                                            onChanged: (value) {
                                              if (value.toString().length == 1) {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                    secondFocusNode);
                                              }
                                            },
                                            focusNode: firstFocusNode,
                                            nextFocusNode: secondFocusNode,
                                          );
                                        },
                                      ),
                        //),
                                 *//* Expanded(
                                      flex: 1,
                                      child:*//* StreamBuilder<bool>(
                                        stream: _forgotPasswordBloc.validDigit,
                                        builder: (context, snapshot) {
                                          return CustomTextOTPField(
                                            hintText: "0",
                                            isFixedHeight: true,
                                            isFixedWidth: true,
                                            hintTextStyle: AppTextStyle.h2TitleTextStyle(color: AppColor.hintTextColor(context), fontWeight: FontWeight.w100),
                                            keyboardType: TextInputType.phone,
                                            textInputAction: TextInputAction.next,
                                            textStyle: AppTextStyle.h1TitleTextStyle(fontWeight: FontWeight.w400),
                                            textEditingController: _forgotPasswordBloc.secondDigitTEC,
                                            errorText: snapshot.error,
                                            onChanged: (value) {
                                              if (value.toString().length == 1) {
                                                FocusScope.of(context)
                                                    .requestFocus(threeFocusNode);
                                              }
                                            },
                                            focusNode: secondFocusNode,
                                            nextFocusNode: threeFocusNode,
                                          );
                                        },
                                      ),
                        //),
                                  *//*Expanded(
                                      flex: 1,
                                      child:*//* StreamBuilder<bool>(
                                        stream: _forgotPasswordBloc.validDigit,
                                        builder: (context, snapshot) {
                                          return CustomTextOTPField(
                                            hintText: "0",
                                            isFixedHeight: true,
                                            isFixedWidth: true,
                                            hintTextStyle: AppTextStyle.h2TitleTextStyle(color: AppColor.hintTextColor(context), fontWeight: FontWeight.w100),
                                            keyboardType: TextInputType.phone,
                                            textInputAction: TextInputAction.next,
                                            textStyle: AppTextStyle.h1TitleTextStyle(fontWeight: FontWeight.w400),
                                            textEditingController: _forgotPasswordBloc.thirdDigitTEC,
                                            errorText: snapshot.error,
                                            onChanged: (value) {
                                              if (value.toString().length == 1) {
                                                FocusScope.of(context)
                                                    .requestFocus(fourthFocusNode);
                                              }
                                            },
                                            focusNode: threeFocusNode,
                                            nextFocusNode: fourthFocusNode,
                                          );
                                        },
                                      ),
                    //),
                                  *//*Expanded(
                                      flex: 1,
                                      child:*//* StreamBuilder<bool>(
                                        stream: _forgotPasswordBloc.validDigit,
                                        builder: (context, snapshot) {
                                          return CustomTextOTPField(
                                            hintText: "0",
                                            isFixedHeight: true,
                                            isFixedWidth: true,
                                            hintTextStyle: AppTextStyle.h2TitleTextStyle(color: AppColor.hintTextColor(context), fontWeight: FontWeight.w100),
                                            keyboardType: TextInputType.phone,
                                            textInputAction: TextInputAction.next,
                                            textStyle: AppTextStyle.h1TitleTextStyle(fontWeight: FontWeight.w400),
                                            textEditingController: _forgotPasswordBloc.fourthDigitTEC,
                                            errorText: snapshot.error,
                                            onChanged: (value) {
                                              if (value.toString().length == 1) {
                                                FocusScope.of(context)
                                                    .requestFocus(fifthFocusNode);
                                              }
                                            },
                                            focusNode: fourthFocusNode,
                                            nextFocusNode: fifthFocusNode,
                                          );
                                        },
                                      ),
                    //),
                                 *//* Expanded(
                                      flex: 1,
                                      child: *//*StreamBuilder<bool>(
                                        stream: _forgotPasswordBloc.validDigit,
                                        builder: (context, snapshot) {
                                          return CustomTextOTPField(
                                            hintText: "0",
                                            isFixedHeight: true,
                                            isFixedWidth: true,
                                            hintTextStyle: AppTextStyle.h2TitleTextStyle(color: AppColor.hintTextColor(context), fontWeight: FontWeight.w100),
                                            keyboardType: TextInputType.phone,
                                            textInputAction: TextInputAction.next,
                                            textStyle: AppTextStyle.h1TitleTextStyle(fontWeight: FontWeight.w400),
                                            textEditingController: _forgotPasswordBloc.fifthDigitTEC,
                                            errorText: snapshot.error,
                                            onChanged: (value) {
                                              if (value.toString().length == 1) {
                                                FocusScope.of(context)
                                                    .requestFocus(sixthFocusNode);
                                              }
                                            },
                                            focusNode: fifthFocusNode,
                                            nextFocusNode: sixthFocusNode,
                                          );
                                        },
                                      ),
                    //),
                                  *//*Expanded(
                                      flex: 1,
                                      child:*//* StreamBuilder<bool>(
                                        stream: _forgotPasswordBloc.validDigit,
                                        builder: (context, snapshot) {
                                          return CustomTextOTPField(
                                            hintText: "0",
                                            isFixedHeight: true,
                                            isFixedWidth: true,
                                            hintTextStyle: AppTextStyle.h2TitleTextStyle(color: AppColor.hintTextColor(context), fontWeight: FontWeight.w100),
                                            keyboardType: TextInputType.phone,
                                            textInputAction: TextInputAction.next,
                                            textStyle: AppTextStyle.h1TitleTextStyle(fontWeight: FontWeight.w400),
                                            textEditingController: _forgotPasswordBloc.sixthDigitTEC,
                                            errorText: snapshot.error,
                                            onChanged: (value) {
                                                _verifyOtp();
                                            },
                                          );
                                        },
                                      ),
                    //),
                                ],
                              ),*/
                            ]))),
                    //email/phone number textformfield
                    SliverToBoxAdapter(
                        child: UiSpacer.verticalSpace(space: 30)),
                    SliverToBoxAdapter(
                        child: Container(
                            padding: EdgeInsets.only(left: 32, right: 32),
                            color: Colors.transparent,
                            child: StreamBuilder<UiState>(
                              stream: _forgotPasswordBloc.uiState,
                              builder: (context, snapshot) {
                                final uiState = snapshot.data;
                                return CustomButton(
                                  padding: AppPaddings.mediumButtonPadding(),
                                  color: AppColor.accentColor,
                                  onPressed: uiState != UiState.loading
                                      ? () {
                                            _verifyOtp(this.pin);
                                         }
                                      : (){},
                                  child: uiState != UiState.loading
                                      ? Text(
                                      "Submit",
                                    style:
                                    AppTextStyle.h4TitleTextStyle(
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight.w500),
                                    textAlign: TextAlign.start,
                                    textDirection: AppTextDirection
                                        .defaultDirection,
                                  )
                                      : PlatformCircularProgressIndicator(),
                                );
                              },
                            ))),
                    //])))
                  ],
                )),
              ],
            ),
          ));

    //);
  }

  void _verifyOtp(String pin) {
    final code = pin;
    if (code.length == 4) {
       _forgotPasswordBloc.resetPasswordValidateCode(widget.email,code);
    }
  }

}
