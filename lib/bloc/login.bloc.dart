
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:flutter_hopper/models/dialog_data.dart';
import 'package:flutter_hopper/repositories/auth.repository.dart';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/validation_messages.dart';
import 'package:flutter_hopper/utils/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_hopper/models/register_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;


class LoginBloc extends BaseBloc {
  //Auth repository
  AuthRepository _authRepository = new AuthRepository();
  TextEditingController emailAddressTEC = new TextEditingController();
  TextEditingController passwordTEC = new TextEditingController();

  //view entered data
  BehaviorSubject<bool> _mobileValid = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> _emailValid = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> _passwordValid = BehaviorSubject<bool>.seeded(false);

  //entered data variables getter
  Stream<bool> get validMobileNumber => _mobileValid.stream;

  Stream<bool> get validEmailAddress => _emailValid.stream;

  Stream<bool> get validPasswordAddress => _passwordValid.stream;

  RegisterToken registerToken;
  final facebookLogin = FacebookLogin();

  @override
  void initBloc() {
    super.initBloc();
    // initApp();
  }

  void initApp() async {
    // FirebaseApp defaultApp = await Firebase.initializeApp();
    //_firebaseAuth = FirebaseAuth.instanceFor(app: defaultApp);
  }

  void generateLoginToken() async{
    final email =emailAddressTEC.text;
    final password=passwordTEC.text;
    if (validateEmailAddress(email)) {

      setUiState(UiState.loading);

      try {

        registerToken = await _authRepository.registerToken(
            username: email,
            password: password
        );

        setUiState(UiState.done);

        if (registerToken != null && registerToken.jwtToken != null) {
           processLogin();
        } else {
          dialogData.title = "Login failed!";
          dialogData.body = "Invalid credential";
          dialogData.backgroundColor = AppColor.failedColor;
          dialogData.iconData = FlutterIcons.error_mdi;
          //notify listners to show show alert
          setShowAlert(true);
        }
      }catch(error){
        setUiState(UiState.done);
        dialogData.title = "Login failed!";
        dialogData.body = error[0];
        dialogData.backgroundColor = AppColor.failedColor;
        dialogData.iconData = FlutterIcons.error_mdi;
        //notify listners to show show alert
        setShowAlert(true);
      }

    }
  }
  //process login when user tap on the login button
  void processLogin() async {
    final email = emailAddressTEC.text;
    final password = passwordTEC.text;

    //check if the user entered email & password are valid
    if (validateEmailAddress(email)) {
      //update ui state
      setUiState(UiState.loading);

      final resultDialogData = await _authRepository.login(
        email: email,
        password: password,
      );

      //update ui state after operation
      setUiState(UiState.done);

      //checking if operation was successful before either showing an error or redirect to home page
      if (resultDialogData.dialogType == DialogType.success) {
        //setUiState(UiState.redirect);
        getUserDetail();
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

  void getUserDetail() async {

    final password = passwordTEC.text;
    //check if the user entered email & password are valid

      //update ui state
      setUiState(UiState.loading);

      final resultDialogData = await _authRepository.getUserDetails(
        password: password
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

  void signinWithNewFacebook(BuildContext context) async {

    
    final result = await facebookLogin.logIn(['email']);
    // redirect url  https://hopperaudio-ae4eb.firebaseapp.com/__/auth/handler
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
       // _initiateSocialAccountFacebookLogin(userProfile: profile,context: context);
        break;
      case FacebookLoginStatus.cancelledByUser:
        setUiState(UiState.done);
        //prepare the data model to be used to show the alert on the view
        dialogData.title = "Authenticating";
        dialogData.body = "There was an error while authenticating your account. Please try again later";
        dialogData.backgroundColor = AppColor.failedColor;
        dialogData.iconData = FlutterIcons.error_mdi;
        //notify listners to show show alert
        setShowAlert(true);
        break;
      case FacebookLoginStatus.error:
        setUiState(UiState.done);
        //prepare the data model to be used to show the alert on the view
        dialogData.title = "Authenticating";
        dialogData.body = result.errorMessage;
        dialogData.backgroundColor = AppColor.failedColor;
        dialogData.iconData = FlutterIcons.error_mdi;
        //notify listners to show show alert
        setShowAlert(true);
        break;
    }

  }

  void _initiateSocialAccountFacebookLogin({
    Map userProfile,BuildContext context
  }) async {
    setUiState(UiState.loading);
    final resultDialogData = await _authRepository.loginSocial(
      name: userProfile['name'],
      email: userProfile['email'],
      phone: userProfile['phone'],
      password: userProfile['password'],
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
      //notify listners tto show show alert
      setShowAlert(true);
    }
  }
}