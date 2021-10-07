import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_hopper/constants/validation_messages.dart';

class Validators {
  static bool isEmailValid(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  static bool isPhoneNumberValid(String phone) {
    if (phone.length >= 10 && phone.length <= 15) {
      return true;
    } else {
      return false;
    }
  }
  //RegExp(r".*[A-Z].*")
  //^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$
  static bool isPasswordValid(String password, {bool includeCaps = true, int minLength = 8}) {
    if (password.length >= minLength && RegExp(r"^(?=.*?[A-Z])(?=.*?[!@#\$&*~]).{8,}$").hasMatch(password)) {
      return true;
    } else {
      return false;
    }
  }

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 8 && RegExp(r"^(?=.*?[A-Z])(?=.*?[!@#\$&*~]).{8,}$").hasMatch(password)) {
      sink.add(password);
    } else {
      sink.addError(ValidationMessages.invalidPassword);
    }
  });

  final validatePasswordBool = StreamTransformer<String, bool>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 8 && RegExp(r"^(?=.*?[A-Z])(?=.*?[!@#\$&*~]).{8,}$").hasMatch(password)) {
      sink.add(true);
    } else {
      sink.addError(ValidationMessages.invalidPassword);
    }
  });

  static bool validateDigit(String digit)
     {
        if (digit.length ==1) {
          return true;
        } else {
          return false;
        }
    }
}
