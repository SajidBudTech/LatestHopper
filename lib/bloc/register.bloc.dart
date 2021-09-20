import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:flutter_hopper/models/register_token.dart';
import 'package:flutter_hopper/repositories/auth.repository.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/models/dialog_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/constants/validation_messages.dart';
import 'package:flutter_hopper/utils/validators.dart';

class RegisterBloc extends BaseBloc {
  //Auth repository
  AuthRepository _authRepository = new AuthRepository();
  String appSignature;
  //text editing controller
  TextEditingController nameTEC = new TextEditingController();
  TextEditingController emailAddressTEC = new TextEditingController();
  TextEditingController passwordTEC = new TextEditingController();
  TextEditingController confirmPaswordTEC = new TextEditingController();



  BehaviorSubject<bool> _nameValid = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> _emailValid = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> _passwordValid = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> _confirmPasswordValid = BehaviorSubject<bool>.seeded(false);

  //entered data variables getter
/*  Stream<dynamic> get profilePhoto => _profilePhoto.stream;
  Stream<dynamic> get medicalReport => _medicalReport.stream;*/
  Stream<bool> get validName => _nameValid.stream;
  Stream<bool> get validEmailAddress => _emailValid.stream;
  Stream<bool> get validPassword => _passwordValid.stream;
  Stream<bool> get validConfirmPassword => _confirmPasswordValid.stream;

  RegisterToken registerToken;
  @override
  void initBloc() {
    super.initBloc();
    generateRegisterToken();
  }

  void generateRegisterToken() async{
    registerToken = await _authRepository.registerToken(
      username: "admin",
      password: "admin"
    );
  }

  //process login when user tap on the login button
  void processRegiration() async {

    final name = nameTEC.text;
    final email =emailAddressTEC.text;
    final password =passwordTEC.text;

    //check if the user entered email & password are valid

    if (validateName(name) && validateEmailAddress(email) && validatePassword(password)){
      //update ui state
      setUiState(UiState.loading);
      final resultDialogData = await _authRepository.register(
        name: name,
        email: email,
        password: password
      );

      //update ui state after operation
      //setUiState(UiState.done);

      //checking if operation was successful before either showing an error or redirect to home page
      if (resultDialogData.dialogType == DialogType.success) {
        // setUiState(UiState.redirect);
       // setUiState(UiState.redirect);

        try{

          registerToken = await _authRepository.registerToken(
             username: email,
             password: password
          );

          setUiState(UiState.done);
          setUiState(UiState.redirect);

        }catch(error){
          setUiState(UiState.done);
          dialogData.title = "Registration failed due to usertoken generation!";
          dialogData.body = "Please try again";
          dialogData.backgroundColor = AppColor.failedColor;
          dialogData.iconData = FlutterIcons.error_mdi;
          //notify listners to show show alert
          setShowAlert(true);
        }

      } else {
        setUiState(UiState.done);
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

  //as user enters name, we are doing name validation, error if its empty of less than 3 words
  bool validateName(String value) {
    if (value.isEmpty || value.length < 3) {
      _nameValid.addError(ValidationMessages.invalidName);
      return false;
    } else {
      _nameValid.add(true);
      return true;
    }
  }


  //as user enters email, we are doing email validation
  bool validateEmailAddress(String value) {
    if (!Validators.isEmailValid(value)) {
      _emailValid.addError(ValidationMessages.invalidEmail);
      return false;
    } else {
      _emailValid.add(true);
      return true;
    }
  }

  /*//as user enters phone, we are doing phone nuber validation
  bool validatePhone(String value) {
    if (!Validators.isPhoneNumberValid(value)) {
      _phoneNumberValid.addError(ValidationMessages.invalidPhoneNumber);
      return false;
    } else {
      _phoneNumberValid.add(true);
      return true;
    }
  }*/

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
      _confirmPasswordValid.addError(ValidationMessages.invalidPassword);
      return false;
    } else {
      _confirmPasswordValid.add(true);
      return true;
    }
  }



}


