import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/bloc/edit_profile.bloc.dart';
import 'package:flutter_hopper/constants/app_images.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/models/loading_state.dart';
import 'package:flutter_hopper/models/state_data_model.dart';
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

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({Key key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  //SearchVendorsBloc instance

  LoginBloc _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.dispose();
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
                      stream: _loginBloc.validPasswordAddress,
                      builder: (context, snapshot) {
                        return CustomTextFormField(
                          hintText: "Current Password",
                          isFixedHeight: false,
                          borderRadius: 32,
                          padding: EdgeInsets.only(top: 3,bottom: 3,left: 20,right: 10),
                          fillColor: AppColor.textFieldColor,
                          togglePassword: true,
                          obscureText: true,
                         // textEditingController: _loginBloc.passwordTEC,
                          errorText: snapshot.error,
                          onChanged: _loginBloc.validatePassword,
                        );
                      },
                    ),
                    UiSpacer.verticalSpace(),
                    StreamBuilder<bool>(
                      stream: _loginBloc.validPasswordAddress,
                      builder: (context, snapshot) {
                        return CustomTextFormField(
                          hintText: "New Password",
                          isFixedHeight: false,
                          borderRadius: 32,
                          padding: EdgeInsets.only(top: 3,bottom: 3,left: 20,right: 10),
                          fillColor: AppColor.textFieldColor,
                          togglePassword: true,
                          obscureText: true,
                          //textEditingController: _loginBloc.passwordTEC,
                          errorText: snapshot.error,
                          onChanged: _loginBloc.validatePassword,
                        );
                      },
                    ),
                    UiSpacer.verticalSpace(),
                    StreamBuilder<bool>(
                      stream: _loginBloc.validPasswordAddress,
                      builder: (context, snapshot) {
                        return CustomTextFormField(
                          hintText: "Confirm Password",
                          isFixedHeight: false,
                          borderRadius: 32,
                          padding: EdgeInsets.only(top: 3,bottom: 3,left: 20,right: 10),
                          fillColor: AppColor.textFieldColor,
                          togglePassword: true,
                          obscureText: true,
                         // textEditingController: _loginBloc.passwordTEC,
                          errorText: snapshot.error,
                          onChanged: _loginBloc.validatePassword,
                        );
                      },
                    ),
                    UiSpacer.verticalSpace(space: 30),
                    StreamBuilder<UiState>(
                      stream: _loginBloc.uiState,
                      builder: (context, snapshot) {
                        final uiState = snapshot.data;
                        return Container(
                            width: double.infinity,
                            child: CustomButton(
                              padding: AppPaddings.mediumButtonPadding(),
                              color: AppColor.accentColor,
                              onPressed: uiState != UiState.loading ? () {} : null,
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
