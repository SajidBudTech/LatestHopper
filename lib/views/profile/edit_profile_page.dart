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

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key, this.title}) : super(key: key);

  String title;
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  //SearchVendorsBloc instance

  EditProfileBloc _editProfileBloc = EditProfileBloc();

  @override
  void initState() {
    super.initState();
    _editProfileBloc.initBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _editProfileBloc.dispose();
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
              title: "Edit Profile",
              backgroundColor: AppColor.accentColor,
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            UiSpacer.verticalSpace(space: 40),
            Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: UserProfilePhoto(
                  userProfileImageUrl: "",
                  isFile: false,
                  userProfileImage: File(AppImages.defaultProfile),
                ) /*StreamBuilder<dynamic>(
                        stream: _editProfileBloc.profilePhoto,
                        builder: (context, snapshot) {
                          //get the current user for future ref
                          //check if user as selected a new profile picture
                          if (snapshot.hasData && snapshot.data is File) {
                            return UserProfilePhoto(
                              userProfileImageUrl: "",
                              isFile: true,
                              userProfileImage: snapshot.data,
                            );
                          } else if (snapshot.hasData && snapshot.data is String) {
                            return UserProfilePhoto(
                              userProfileImageUrl: snapshot.data ?? "",
                              isFile: false,
                              userProfileImage: null,
                            );
                          } else {
                            return UserProfilePhoto(
                              userProfileImageUrl: "",
                              isFile: false,
                              userProfileImage: File(AppImages.defaultProfile),
                            );
                          }*/
                // },
                // ),
                ),
            Expanded(child: ListView(
              shrinkWrap: true,
              padding: AppPaddings.defaultPadding(),
              children: [
                UiSpacer.verticalSpace(),
                StreamBuilder<bool>(
                  stream: _editProfileBloc.validName,
                  builder: (context, snapshot) {
                    return CustomTextFormField(
                      hintText: "Full Name",
                      isFixedHeight: false,
                      borderRadius: 32,
                      padding: EdgeInsets.only(
                          top: 3, bottom: 3, left: 20, right: 10),
                      fillColor: AppColor.textFieldColor,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      textEditingController: _editProfileBloc.nameTEC,
                      errorText: snapshot.error,
                      onChanged: _editProfileBloc.validateName,
                    );
                  },
                ),
                UiSpacer.verticalSpace(),
                StreamBuilder<bool>(
                  stream: _editProfileBloc.validEmailAddress,
                  builder: (context, snapshot) {
                    return CustomTextFormField(
                      hintText: "Email Address",
                      isFixedHeight: false,
                      borderRadius: 32,
                      isReadOnly: true,
                      padding: EdgeInsets.only(
                          top: 3, bottom: 3, left: 20, right: 10),
                      fillColor: AppColor.primaryColor,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      textEditingController: _editProfileBloc.emailAddressTEC,
                      errorText: snapshot.error,
                      onChanged: _editProfileBloc.validateName,
                    );
                  },
                ),
                UiSpacer.verticalSpace(space: 30),
                StreamBuilder<UiState>(
                  stream: _editProfileBloc.uiState,
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
                                  "UPDATE PROFILE",
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
