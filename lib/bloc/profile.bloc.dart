
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class ProfileBloc extends BaseBloc {
  //Auth repository
  AuthRepository _authRepository = new AuthRepository();
  TextEditingController emailAddressTEC = new TextEditingController();
  TextEditingController nameTEC = new TextEditingController();


  //view entered data
  BehaviorSubject<bool> _nameValid = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<bool> _emailValid = BehaviorSubject<bool>.seeded(false);

  //entered data variables getter
  Stream<bool> get validMobileNumber => _nameValid.stream;

  Stream<bool> get validEmailAddress => _emailValid.stream;


  RegisterToken registerToken;
  String userFullName="";
  String userEmail="";
  String userImage="";

  @override
  void initBloc() async {
    getUsetData();
    super.initBloc();
  }
  void getUsetData() async{
    userFullName=AuthBloc.getUserFullName();
    userEmail=AuthBloc.getUserEmail();
    userImage=AuthBloc.getUserProfileImage();
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

 /* //as user enters email, we are doing email validation
  bool validateMobile(String value) {
    if (!Validators.isPhoneNumberValid(value)) {
      _mobileValid.addError(ValidationMessages.invalidPhoneNumber);
      return false;
    } else {
      _mobileValid.add(true);
      return true;
    }
  }*/

  //process login when user tap on the login button
  void processAccountUpdate({String dob,String anniver,String gender}) async {
    //get the entered value from the text editing controller
    final name = nameTEC.text;
    final email = emailAddressTEC.text;



    //check if the user entered name & email are valid
    if (validateName(name) &&
        validateEmailAddress(email) ) {
      //update ui state
      setUiState(UiState.loading);

     // final userId= await AuthBloc.getUserID();
      //make the request to the server
      // final profilePhotoValue = _profilePhoto.value;
      //final medicalReportValue = _medicalReport.value;
     /* final resultDialogData = await _authRepository.updateProfile(
          userId: userId,
          name: name,
          email: email,
          mobile: phone,
          gender: gender,
          dob: dob,
          anniversary: anniver
      );*/
      //update ui state after operation
    /*  setUiState(UiState.done);

      //prepare the data model to be used to show the alert on the view
      dialogData = resultDialogData;
      dialogData.isDismissible = true;
      //notify listners tto show show alert
      setShowDialogAlert(true);*/

    }
  }
}