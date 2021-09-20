import 'package:flutter/material.dart';
import 'package:flutter_hopper/repositories/auth.repository.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/validation_messages.dart';
import 'package:flutter_hopper/models/dialog_data.dart';
import 'package:flutter_hopper/utils/validators.dart';
import 'package:rxdart/rxdart.dart';

class ForgotPasswordBloc extends BaseBloc {
  //Auth repository
  AuthRepository _authRepository = new AuthRepository();

  //text editing controller
  TextEditingController emailAddressTEC = new TextEditingController();

  TextEditingController newPasswordTEC = new TextEditingController();
  TextEditingController confirmPasswordTEC = new TextEditingController();

  TextEditingController firstDigitTEC = new TextEditingController();
  TextEditingController secondDigitTEC = new TextEditingController();
  TextEditingController thirdDigitTEC = new TextEditingController();
  TextEditingController fourthDigitTEC = new TextEditingController();
  TextEditingController fifthDigitTEC = new TextEditingController();
  TextEditingController sixthDigitTEC = new TextEditingController();

  //view entered data
  BehaviorSubject<bool> _emailValid = BehaviorSubject<bool>.seeded(false);

  //entered data variables getter
  Stream<bool> get validEmailAddress => _emailValid.stream;


  BehaviorSubject<bool> _firstValid = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get validDigit => _firstValid.stream;

  BehaviorSubject<bool> _passwordValid = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get validPasswordAddress => _passwordValid.stream;

  BehaviorSubject<bool> _confirmpasswordValid = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get validConfirmPasswordAddress => _confirmpasswordValid.stream;

  @override
  void initBloc() {
    super.initBloc();
  }

  //process login when user tap on the login button
  void resetPasswordCheclEmail() async {
    final email = emailAddressTEC.text;

    //check if the user entered email is valid
    if (validateEmailAddress(email)) {
      //update ui state
      setUiState(UiState.loading);
      final resultDialogData = await _authRepository.resetPasswordCheckEmail(
        email: email,
      );

      //update ui state after operation
      setUiState(UiState.done);

      if(resultDialogData.dialogType==DialogType.success){

        dialogData.title = resultDialogData.title;
        dialogData.body = resultDialogData.body;
        dialogData.backgroundColor =AppColor.successfulColor;
        setUiState(UiState.redirect);

      }else{

        dialogData.title = resultDialogData.title;
        dialogData.body = resultDialogData.body;
        dialogData.backgroundColor =AppColor.successfulColor;
        setShowAlert(true);

      }

    /*  //checking if operation was successful before either showing an error or success alert
      //prepare the data model to be used to show the alert on the view
      dialogData.title = resultDialogData.title;
      dialogData.body = resultDialogData.body;
      dialogData.backgroundColor =
          resultDialogData.dialogType != DialogType.success
              ? AppColor.failedColor
              : AppColor.successfulColor;
      dialogData.iconData = resultDialogData.dialogType != DialogType.success
          ? FlutterIcons.error_mdi
          : FlutterIcons.check_box_mdi;
      //notify listners tto show show alert*/

    }
  }


  void resetPasswordValidateCode(String email,String code) async {
    //final code=firstDigitTEC.text+secondDigitTEC.text+thirdDigitTEC.text+fourthDigitTEC.text+fifthDigitTEC.text+sixthDigitTEC.text;

    //check if the user entered email is valid
    if (code.length==4) {
      //update ui state
      setUiState(UiState.loading);

      final resultDialogData = await _authRepository.resetPasswordValidateCode(
        email: email,
        code: code
      );

      //update ui state after operation
      setUiState(UiState.done);

      if(resultDialogData.dialogType==DialogType.success){

        dialogData.title = resultDialogData.title;
        dialogData.body = resultDialogData.body;
        dialogData.backgroundColor =AppColor.successfulColor;
        setUiState(UiState.redirect);

      }else{

        dialogData.title = resultDialogData.title;
        dialogData.body = resultDialogData.body;
        dialogData.backgroundColor =AppColor.successfulColor;
        setShowAlert(true);

      }
    }
  }


  void resetPassword(String email,String code) async {
      final password=newPasswordTEC.text;
    //check if the user entered email is valid
    if (code.length==4 && validatePassword(password)) {
      //update ui state
      setUiState(UiState.loading);

      final resultDialogData = await _authRepository.resetPassword(
          email: email,
          code: code,
          newPassword:newPasswordTEC.text
      );

      //update ui state after operation
      setUiState(UiState.done);

      if(resultDialogData.dialogType==DialogType.success){

        dialogData.title = resultDialogData.title;
        dialogData.body = resultDialogData.body;
        dialogData.backgroundColor =AppColor.successfulColor;
        setUiState(UiState.redirect);

      }else{

        dialogData.title = resultDialogData.title;
        dialogData.body = resultDialogData.body;
        dialogData.backgroundColor =AppColor.successfulColor;
        setShowAlert(true);

      }
    }
  }

  //as user enters email address, we are doing email validation
  bool validateEmailAddress(String value) {
    if (!Validators.isEmailValid(value)) {
      _emailValid.addError(ValidationMessages.invalidEmail);
      return false;
    } else {
      _emailValid.add(true);
      return true;
    }
  }

  bool validateDigit(String value) {
    if (!Validators.validateDigit(value)) {
      _firstValid.addError(ValidationMessages.invalidDigit);
      return false;
    } else {
      _firstValid.add(true);
       return true;
    }
  }

  //as user enters password, we are doing password validation
  bool validatePassword(String value) {
    //validating if password, contains at least one uppercase and length is of 6 minimum charater
    if (!Validators.isPasswordValid(value)) {
      _passwordValid.addError(ValidationMessages.invalidPassword);
      return false;
    } else {
      _passwordValid.add(true);
      return true;
    }
  }
  bool validateConfirmPassword(String value) {
    //validating if password, contains at least one uppercase and length is of 6 minimum charater
    if (!Validators.isPasswordValid(value)) {
      _confirmpasswordValid.addError(ValidationMessages.invalidPassword);
      return false;
    } else {
      _confirmpasswordValid.add(true);
      return true;
    }
  }

}
