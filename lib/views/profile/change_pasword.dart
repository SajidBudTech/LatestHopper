import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/utils/custom_dialog.dart';
import 'package:flutter_hopper/utils/flash_alert.dart';
import 'package:flutter_hopper/utils/validators.dart';
import 'package:flutter_hopper/viewmodels/main_home_viewmodel.dart';
import 'package:flutter_hopper/widgets/appbar/common_app_bar.dart';
import 'package:flutter_hopper/widgets/buttons/custom_button.dart';
import 'package:flutter_hopper/widgets/inputs/custom_text_form_field.dart';
import 'package:flutter_hopper/widgets/platform/platform_circular_progress_indicator.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_hopper/bloc/change_password.bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({Key key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  //SearchVendorsBloc instance

  ChangePasswordBloc _changePasswordBloc = ChangePasswordBloc();

  @override
  void initState() {
    super.initState();
    _changePasswordBloc.initBloc();
    _changePasswordBloc.showDialogAlert.listen(
          (show) {
        //when asked to show an alert
        if (show) {
          CustomDialog.showAlertDialog(
            context,
            _changePasswordBloc.dialogData,
            isDismissible: _changePasswordBloc.dialogData.isDismissible,
          );
          Future.delayed(Duration(milliseconds: 1500), (){
             CustomDialog.dismissDialog(context);
          });

        } else {
          CustomDialog.dismissDialog(context);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _changePasswordBloc.dispose();
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
                  title: "Change Password",
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
                      stream: _changePasswordBloc.validCurrentPassword,
                      builder: (context, snapshot) {
                        return CustomTextFormField(
                          hintText: "Current Password",
                          isFixedHeight: false,
                          borderRadius: 32,
                          padding: EdgeInsets.only(top: 3,bottom: 3,left: 20,right: 10),
                          fillColor: AppColor.textFieldColor,
                          togglePassword: true,
                          obscureText: true,
                          textEditingController: _changePasswordBloc.currentPasswordTEC,
                          errorText: snapshot.error,
                          //onChanged: _changePasswordBloc.changeCurrentPassword,
                        );
                      },
                    ),
                    UiSpacer.verticalSpace(),
                    StreamBuilder<bool>(
                      stream: _changePasswordBloc.validNewPassword,
                      builder: (context, snapshot) {
                        return CustomTextFormField(
                          hintText: "New Password",
                          isFixedHeight: false,
                          borderRadius: 32,
                          padding: EdgeInsets.only(top: 3,bottom: 3,left: 20,right: 10),
                          fillColor: AppColor.textFieldColor,
                          togglePassword: true,
                          obscureText: true,
                          textEditingController: _changePasswordBloc.newPasswordTEC,
                          errorText: snapshot.error,
                          onChanged: _changePasswordBloc.changeNewPassword,
                        );
                      },
                    ),
                    UiSpacer.verticalSpace(),
                    StreamBuilder<String>(
                      stream: _changePasswordBloc.validConfirmPassword,
                      builder: (context, snapshot) {
                        return CustomTextFormField(
                          hintText: "Confirm Password",
                          isFixedHeight: false,
                          borderRadius: 32,
                          padding: EdgeInsets.only(top: 3,bottom: 3,left: 20,right: 10),
                          fillColor: AppColor.textFieldColor,
                          togglePassword: true,
                          obscureText: true,
                          textEditingController: _changePasswordBloc.confirmPasswordTEC,
                          errorText: snapshot.error,
                          onChanged: _changePasswordBloc.changeConfirmPassword,
                        );
                      },
                    ),
                    UiSpacer.verticalSpace(space: 30),
                    StreamBuilder<UiState>(
                      stream: _changePasswordBloc.uiState,
                      builder: (context, snapshot) {
                        final uiState = snapshot.data;
                        return Container(
                            width: double.infinity,
                            child: CustomButton(
                              padding: AppPaddings.mediumButtonPadding(),
                              color: AppColor.accentColor,
                              onPressed: uiState != UiState.loading ? () {
                                if(_changePasswordBloc.currentPassword ==_changePasswordBloc.currentPasswordTEC.text){
                                  if((Validators.isPasswordValid(_changePasswordBloc.newPasswordTEC.text)) && (Validators.isPasswordValid(_changePasswordBloc.confirmPasswordTEC.text))&&(_changePasswordBloc.newPasswordTEC.text==_changePasswordBloc.confirmPasswordTEC.text)){
                                    _changePasswordBloc.processUpdatePassword();
                                  }else{
                                    ShowFlash(
                                        context,
                                        title: "New password does not match with confirm password",
                                        message: "Please try again",
                                        flashType: FlashType.failed
                                    ).show();
                                  }
                                }else{
                                  ShowFlash(
                                      context,
                                      title: "Current password is invalid",
                                      message: "Please try again",
                                      flashType: FlashType.failed
                                  ).show();
                                }
                              } : (){},
                              child: uiState != UiState.loading
                                  ? Text(
                                "SUBMIT",
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
