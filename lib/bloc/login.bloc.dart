
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hopper/models/dialog_data.dart';
import 'package:flutter_hopper/repositories/auth.repository.dart';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/validation_messages.dart';
import 'package:flutter_hopper/utils/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class LoginBloc extends BaseBloc {
  //Auth repository
  AuthRepository _authRepository = new AuthRepository();
  TextEditingController emailAddressTEC = new TextEditingController();

  TextEditingController mobileTEC = new TextEditingController();

  TextEditingController passwordTEC = new TextEditingController();

  //view entered data
  BehaviorSubject<bool> _mobileValid = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> _emailValid = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> _passwordValid = BehaviorSubject<bool>.seeded(false);

  //entered data variables getter
  Stream<bool> get validMobileNumber => _mobileValid.stream;

  Stream<bool> get validEmailAddress => _emailValid.stream;

  Stream<bool> get validPasswordAddress => _passwordValid.stream;


  @override
  void initBloc() {
    super.initBloc();

    // initApp();
  }

  void initApp() async {
    // FirebaseApp defaultApp = await Firebase.initializeApp();
    //_firebaseAuth = FirebaseAuth.instanceFor(app: defaultApp);
  }

  //process login when user tap on the login button
  void processLogin() async {
    final mobile = mobileTEC.text;
    final password = passwordTEC.text;

    //check if the user entered email & password are valid
    if (validateMobileNumber(mobile) && validatePassword(password)) {
      //update ui state
      setUiState(UiState.loading);
      final resultDialogData = await _authRepository.login(
        //mobile: mobile,
        password: password,
      );

      //update ui state after operation
      setUiState(UiState.done);

      //checking if operation was successful before either showing an error or redirect to home page
      if (resultDialogData.dialogType == DialogType.success) {
        setUiState(UiState.redirect);
      } else {
        //prepare the data model to be used to show the alert on the view
        dialogData.title = resultDialogData.title;
        dialogData.body = resultDialogData.body;
        dialogData.backgroundColor = AppColor.failedColor;
        dialogData.iconData = FlutterIcons.error_mdi;
        //notify listners to show show alert
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

  bool validateMobileNumber(String value) {
    if (value.isEmpty || value.length != 10) {
      _emailValid.addError(ValidationMessages.invalidEmail);
      return false;
    } else {
      _emailValid.add(true);
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
}