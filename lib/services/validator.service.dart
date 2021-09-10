import 'package:basic_utils/basic_utils.dart';

class FormValidator {
  //For name form validation
  static String validateName(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return 'Invalid name';
    }
    return null;
  }

  //For email address form validation
  static String validateEmail(String value) {
    if (value.isEmpty || !EmailUtils.isEmail(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  //For phone form validation
  static String validatePhone(String value) {
    if (value.isEmpty || value.trim().isEmpty ) {
      return 'Invalid Phone';
    }else  if ( value.length < 9 ) {
      return 'Phone must be more than 9 digists';
    }else  if ( value.length > 13) {
      return 'Phone must be less than 14 digists';
    }
    return null;
  }

  //For email address form validation
  static String validatePassword(String value) {
    if (value.isEmpty || value.trim().isEmpty || value.length < 6) {
      return 'Password must be more than 6 character';
    }
    return null;
  }

  static String validateEmpty(String value, {String errorTitle}) {
    if (value.isEmpty || value.trim().isEmpty || value.length < 1) {
      return '$errorTitle is empty';
    }
    return null;
  }
}