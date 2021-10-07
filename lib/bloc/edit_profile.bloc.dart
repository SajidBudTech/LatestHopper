import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:flutter_hopper/repositories/auth.repository.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/constants/validation_messages.dart';
import 'package:flutter_hopper/utils/validators.dart';
import 'package:rxdart/rxdart.dart';

class EditProfileBloc extends BaseBloc {
  //auth repository
  AuthRepository _authRepository = AuthRepository();

  //text editing controller
  TextEditingController nameTEC = new TextEditingController();
  TextEditingController emailAddressTEC = new TextEditingController();


  //view entered data
  BehaviorSubject<dynamic> _profilePhoto = BehaviorSubject<dynamic>();


  BehaviorSubject<bool> _nameValid = BehaviorSubject<bool>.seeded(true);
  BehaviorSubject<bool> _emailValid = BehaviorSubject<bool>.seeded(true);

  //entered data variables getter
  Stream<dynamic> get profilePhoto => _profilePhoto.stream;

  Stream<bool> get validName => _nameValid.stream;
  Stream<bool> get validEmailAddress => _emailValid.stream;



  int userId;
  String password;
  @override
  void initBloc(){
    super.initBloc();
    nameTEC.text = AuthBloc.getUserFullName();
    emailAddressTEC.text = AuthBloc.getUserEmail();
    userId=AuthBloc.getUserId();
    password=AuthBloc.getUserPassword();
  }

  void editProfile() async{

    if(validateName(nameTEC.text)){
       setUiState(UiState.loading);
       final resultDialogData = await _authRepository.updateProfile(
         name: nameTEC.text,
         userId: userId,
         password: password,
         email: emailAddressTEC.text,
         userName: emailAddressTEC.text,
       );

       setUiState(UiState.done);

       dialogData = resultDialogData;
       dialogData.isDismissible = true;
       //notify listners tto show show alert
       setShowDialogAlert(true);

     }
  }


  //pick new profile
  void pickNewProfilePhoto() async {
    try {

      FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.image);
      if(result != null) {
        File file = File(result.files.single.path);
        _profilePhoto.add(file);
      } else {
        // User canceled the picker
        _profilePhoto.add(null);
      }
       /*File image = await FilePicker.getFile(type: FileType.image);
      _profilePhoto.add(image);*/
    } catch (error) {
      print("Error picking profile photo");
      _profilePhoto.addError(error);
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


}
