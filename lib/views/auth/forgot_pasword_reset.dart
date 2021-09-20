import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/bloc/edit_profile.bloc.dart';
import 'package:flutter_hopper/bloc/forgot_password.bloc.dart';
import 'package:flutter_hopper/constants/app_images.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/models/loading_state.dart';
import 'package:flutter_hopper/models/state_data_model.dart';
import 'package:flutter_hopper/utils/flash_alert.dart';
import 'package:flutter_hopper/viewmodels/main_home_viewmodel.dart';
import 'package:flutter_hopper/widgets/appbar/common_app_bar.dart';
import 'package:flutter_hopper/widgets/buttons/custom_button.dart';
import 'package:flutter_hopper/widgets/inputs/custom_text_form_field.dart';
import 'package:flutter_hopper/widgets/platform/platform_circular_progress_indicator.dart';
import 'package:flutter_hopper/widgets/profile/user_profile_photo.dart';
import 'package:flutter_hopper/widgets/shimmers/vendor_shimmer_list_view_item.dart';
import 'package:flutter_hopper/widgets/state/state_loading_data.dart';
import 'package:flutter_hopper/bloc/login.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:stacked/stacked.dart';

class SetNewPasswordPage extends StatefulWidget {
  SetNewPasswordPage({Key key,this.email,this.code}) : super(key: key);

  String email;
  String code;
  @override
  _SetNewPasswordPageState createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends State<SetNewPasswordPage> {
  //SearchVendorsBloc instance

  ForgotPasswordBloc _forgotPasswordBloc = ForgotPasswordBloc();

  @override
  void initState() {
    super.initState();

    _forgotPasswordBloc.showAlert.listen((show) {
      //when asked to show an alert
      if (show) {
        ShowFlash(
            context,
            title: _forgotPasswordBloc.dialogData.title,
            message: _forgotPasswordBloc.dialogData.body
        ).show();
      }
    });

    //listen to state of the ui
    _forgotPasswordBloc.uiState.listen((uiState) async {
      if (uiState == UiState.redirect) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.loginRoute,
              (route) => false,
        );
      }
    });

  }

  @override
  void dispose() {
    super.dispose();
    _forgotPasswordBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainHomeViewModel>.reactive(
      viewModelBuilder: () => MainHomeViewModel(context),
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) => Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                CommonAppBar(
                  title: "Set New Password",
                  backgroundColor: AppColor.accentColor,
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                UiSpacer.verticalSpace(space: 20),
                Expanded(child: ListView(
                  shrinkWrap: true,
                  padding: AppPaddings.defaultPadding(),
                  children: [
                    UiSpacer.verticalSpace(),
                    StreamBuilder<bool>(
                      stream: _forgotPasswordBloc.validPasswordAddress,
                      builder: (context, snapshot) {
                        return CustomTextFormField(
                          hintText: "New Password",
                          isFixedHeight: false,
                          borderRadius: 32,
                          padding: EdgeInsets.only(top: 3,bottom: 3,left: 20,right: 10),
                          fillColor: AppColor.textFieldColor,
                          togglePassword: true,
                          obscureText: true,
                          textEditingController: _forgotPasswordBloc.newPasswordTEC,
                          errorText: snapshot.error,
                          onChanged: _forgotPasswordBloc.validatePassword,
                        );
                      },
                    ),
                    UiSpacer.verticalSpace(),
                    StreamBuilder<bool>(
                      stream: _forgotPasswordBloc.validConfirmPasswordAddress,
                      builder: (context, snapshot) {
                        return CustomTextFormField(
                          hintText: "Confirm Password",
                          isFixedHeight: false,
                          borderRadius: 32,
                          padding: EdgeInsets.only(top: 3,bottom: 3,left: 20,right: 10),
                          fillColor: AppColor.textFieldColor,
                          togglePassword: true,
                          obscureText: true,
                          textEditingController: _forgotPasswordBloc.confirmPasswordTEC,
                          errorText: snapshot.error,
                          onChanged: _forgotPasswordBloc.validateConfirmPassword,
                        );
                      },
                    ),
                    UiSpacer.verticalSpace(space: 30),
                    StreamBuilder<UiState>(
                      stream: _forgotPasswordBloc.uiState,
                      builder: (context, snapshot) {
                        final uiState = snapshot.data;
                        return Container(
                            width: double.infinity,
                            child: CustomButton(
                              padding: AppPaddings.mediumButtonPadding(),
                              color: AppColor.accentColor,
                              onPressed: uiState != UiState.loading ? () {
                                if(_forgotPasswordBloc.newPasswordTEC.text==_forgotPasswordBloc.confirmPasswordTEC.text){
                                  _forgotPasswordBloc.resetPassword(widget.email,widget.code);
                                }else{
                                  ShowFlash(
                                      context,
                                      title: "Password does not match woth confirm password!",
                                      message: "Please try again"
                                  ).show();
                                  }
                                 } : null,
                              child: uiState != UiState.loading
                                  ? Text(
                                "Reset Password",
                                style: AppTextStyle.h4TitleTextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.start,
                                textDirection:
                                AppTextDirection.defaultDirection,
                              )
                                  : PlatformCircularProgressIndicator(),
                            ));
                      },
                    ),
                  ],
                ))
              ],
            ),
          )),
    );
  }
}
