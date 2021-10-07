import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:flutter_hopper/constants/api.dart';
import 'package:flutter_hopper/constants/app_strings.dart';
import 'package:flutter_hopper/constants/strings/forgot_password.strings.dart';
import 'package:flutter_hopper/constants/strings/login.strings.dart';
import 'package:flutter_hopper/constants/strings/register.strings.dart';
import 'package:flutter_hopper/constants/strings/update_password.strings.dart';
import 'package:flutter_hopper/constants/strings/update_profile.strings.dart';
import 'package:flutter_hopper/models/api_response.dart';
import 'package:flutter_hopper/models/dialog_data.dart';
import 'package:flutter_hopper/models/register_token.dart';
import 'package:flutter_hopper/services/http.service.dart';
import 'package:flutter_hopper/utils/api_response.utils.dart';

class AuthRepository extends HttpService {
  //FirebaseMessaging instance
  // FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  //process user account login
  Future<DialogData> login({String email, String password}) async {
    //instance of the model to be returned
    final resultDialogData = DialogData();
    final apiResult = await get(Api.login+email);

    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);

    if (apiResponse.allGood) {
      resultDialogData.title = LoginStrings.processCompleteTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.success;

      LoginStrings.loginUserId=apiResponse.body[0]['id'];
      //save the user data to hive box
      /* saveuserData(
        apiResponse.body[0],
        password,
      );*/

    } else {
      resultDialogData.title = LoginStrings.processFailedTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;

      /*saveuserData(
        apiResponse.body["user"],
        apiResponse.body["token"],
        apiResponse.body["type"],
      );*/
    }

    return resultDialogData;
  }

  Future<DialogData> getUserDetails({String password}) async {
    //instance of the model to be returned
    final resultDialogData = DialogData();
    final apiResult = await get(Api.userDetails+"/"+LoginStrings.loginUserId.toString()+"?context=edit");

    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);

    if (apiResponse.allGood) {
      resultDialogData.title = LoginStrings.processCompleteTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.success;

      saveuserData(
        apiResponse.body,
        password,
      );

    } else {

      resultDialogData.title = LoginStrings.processFailedTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;

      /*saveuserData(
        apiResponse.body["user"],
        apiResponse.body["token"],
        apiResponse.body["type"],
      );*/
    }

    return resultDialogData;
  }

  Future<RegisterToken> registerToken({String username,String password}) async {
    //instance of the model to be returned
    RegisterToken registerToken = RegisterToken();
    final apiResult = await post(
      Api.registerToken,
      {
        "username": username,
        "password": password,
      },
    );

    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    registerToken = RegisterToken.fromJson(json.decode(apiResponse.body));
    AuthBloc.SaveUserToken(registerToken.jwtToken??"");

    return registerToken;

  }

    Future<DialogData> register({
      String name,
      String email,
      String password,
    }) async {
      //instance of the model to be returned
      final resultDialogData = DialogData();

      final Map<String, dynamic> bodyPayload =
      {
        "username": email,
        "name":name,
        "first_name":name,
        "last_name":"",
        "email": email,
        "password": password,
        "role": "subscriber",
      };

      final apiResult = await post(
          Api.register,
          bodyPayload
      );

      // print("Api Result ==> $apiResult");
      ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);

      if (apiResponse.allGood) {
        resultDialogData.title = RegisterStrings.processCompleteTitle;
        resultDialogData.body = apiResponse.message;
        resultDialogData.dialogType = DialogType.success;

        //save the user data to hive box
        saveuserData(
        apiResponse.body,
        password,
        );

      } else {
        resultDialogData.title = RegisterStrings.processFailedTitle;
        resultDialogData.body = apiResponse.message;
        resultDialogData.dialogType = DialogType.failed;
      }

      return resultDialogData;

    }

    Future<DialogData> loginSocial({
      String name,
      String email,
      String phone,
      String password,
      String serverotp,
      String userotp
    }) async {
      //instance of the model to be returned
      final resultDialogData = DialogData();
      final apiResult = await post(
        Api.loginSocial,
        {
          "name": name,
          "email": email,
          "phone": phone,
          "password": password,
          "server_otp": serverotp,
          "user_otp": userotp,
        },
      );

      // print("Api Result ==> $apiResult");
      ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);

      if (apiResponse.allGood) {
        resultDialogData.title = RegisterStrings.processCompleteTitle;
        resultDialogData.body = apiResponse.message;
        resultDialogData.dialogType = DialogType.success;

        //save the user data to hive box
        /* saveuserData(
        apiResponse.body["user"],
        apiResponse.body["token"],
        apiResponse.body["type"],
      );*/
      } else {
        resultDialogData.title = RegisterStrings.processFailedTitle;
        resultDialogData.body = apiResponse.message;
        resultDialogData.dialogType = DialogType.failed;
      }

      return resultDialogData;
    }

  Future<DialogData> resetPasswordCheckEmail({
    @required String email,
  }) async {
    //instance of the model to be returned
    final resultDialogData = DialogData();
    final apiResult = await post(Api.forgotPasswordCheckEmail,
      {
        "email": email,
      },
    );

    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);

    if (apiResponse.allGood) {
      resultDialogData.title = ForgotPasswordStrings.processCompleteTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.success;
    } else {
      resultDialogData.title = ForgotPasswordStrings.processFailedTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;
  }

  Future<DialogData> resetPasswordValidateCode({
    @required String email,
    @required String code,
  }) async {
    //instance of the model to be returned
    final resultDialogData = DialogData();
    final apiResult = await post(Api.forgotPasswordValidateCode,
      {
        "email": email,
        "code": code,
      },
    );

    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);

    if (apiResponse.allGood) {
      resultDialogData.title = ForgotPasswordStrings.processCompleteTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.success;
    } else {
      resultDialogData.title = ForgotPasswordStrings.processFailedTitle;
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;
  }

    //reset password
    Future<DialogData> resetPassword({
      @required String email,
      @required String code,
      @required String newPassword,

    }) async {
      //instance of the model to be returned
      final resultDialogData = DialogData();
      final apiResult = await post(Api.forgotPasswordReset,
        {
          "email": email,
          "code": code,
          "password": newPassword,
        },
      );

      ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);

      if (apiResponse.allGood) {
        resultDialogData.title = ForgotPasswordStrings.processCompleteTitle;
        resultDialogData.body = apiResponse.message;
        resultDialogData.dialogType = DialogType.success;
      } else {
        resultDialogData.title = ForgotPasswordStrings.processFailedTitle;
        resultDialogData.body = apiResponse.message;
        resultDialogData.dialogType = DialogType.failed;
      }

      return resultDialogData;
    }

    //update account profile
    Future<DialogData> updateProfile({
      int userId,
      String name,
      String userName,
      String email,
      String password
    }) async {
      //instance of the model to be returned
      final resultDialogData = DialogData();

      final Map<String, dynamic> bodyPayload =
      {

       /* "id":userId,
        "username": userName,
        "email": email,
        "password": password,*/
        "name": name,

      };

      //adding photo file to the payload if photo was selected
     /* if (photo != null) {
        final photoFile = await MultipartFile.fromFile(
          photo.path,
        );

        bodyPayload.addAll({
          "photo": photoFile,
        });
      }*/

      final apiResult = await postWithFiles(
        Api.updateProfile+"/"+userId.toString(),
        bodyPayload,
      );

      ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
      if (apiResponse.allGood) {
        resultDialogData.title = UpdateProfileStrings.processCompleteTitle;
        resultDialogData.body = "";
        resultDialogData.dialogType = DialogType.successThenClosePage;
        AuthBloc.setUserFullName(name);

        //get the local version of user data
        /*final currentUser = await appDatabase.userDao.findCurrent();
      final mUser = User.formJson(userJSONObject: apiResponse.body["user"]);
      mUser.token = currentUser.token;
      mUser.tokenType = currentUser.tokenType;
      mUser.role = currentUser.role;

      //change the data/info
      // currentUser.name = apiResponse.body["user"]["name"];
      // currentUser.email = apiResponse.body["user"]["email"];
      // currentUser.phone = apiResponse.body["user"]["phone"];
      // currentUser.photo = apiResponse.body["user"]["photo"];

      //update the local version of user data
      await appDatabase.userDao.updateItem(mUser);*/

      } else {
        //the error message
        var errorMessage = apiResponse.message;

        try {
          errorMessage += "\n" + apiResponse.body["errors"]["name"][0];
        } catch (error) {
          print("Name Validation ===> $error");
        }
        try {
          errorMessage += "\n" + apiResponse.body["errors"]["email"][0];
        } catch (error) {
          print("Email Validation ===> $error");
        }

        resultDialogData.title = UpdateProfileStrings.processFailedTitle;
        resultDialogData.body = errorMessage ?? apiResponse.message;
        resultDialogData.dialogType = DialogType.failed;
      }

      return resultDialogData;
    }

    //update user password
    Future<DialogData> updatePassword({
      String newPassword,
      int userId
    }) async {
      //instance of the model to be returned
      final resultDialogData = DialogData();
      final apiResult = await post(
        Api.changePassword+"/"+userId.toString(),
        {
          //"current_password": currentPassword,
          "password": newPassword,
          //"new_password_confirmation": confirmNewPassword,
        },
      );

      ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);

      if (apiResponse.allGood) {
        resultDialogData.title = UpdatePasswordStrings.processCompleteTitle;
        resultDialogData.body = "Your password updated successfully!";
        resultDialogData.dialogType = DialogType.successThenClosePage;
        AuthBloc.setUserPassword(newPassword);

      } else {
        //the error message
        var errorMessage = apiResponse.message;

        try {
          errorMessage +=
              "\n" + apiResponse.body["errors"]["current_password"][0];
        } catch (error) {
          print("Current Password ===> $error");
        }
        try {
          errorMessage += "\n" + apiResponse.body["errors"]["new_password"][0];
        } catch (error) {
          print("New Password ===> $error");
        }

        try {
          errorMessage +=
              "\n" + apiResponse.body["errors"]["new_password_confirmation"][0];
        } catch (error) {
          print("New Password Confirmation ===> $error");
        }

        resultDialogData.title = UpdatePasswordStrings.processFailedTitle;
        resultDialogData.body = errorMessage ?? apiResponse.message;
        resultDialogData.dialogType = DialogType.failed;
      }

      return resultDialogData;
    }

    //save user data
    void saveuserData(dynamic userObject, String password) async {
      //this is variable is inherited from HttpService
      /* final mUser = User.formJson(userJSONObject: userObject);
    mUser.token = token;
    mUser.tokenType = tokenType;
    await appDatabase.userDao.deleteAll();
    await appDatabase.userDao.insertItem(mUser);*/

      //save to tellam
      /* TellamUser tellamUser = TellamUser(
      id: mUser.id,
      firstName: mUser.name,
      lastName: mUser.lname,
      emailAddress: mUser.email,
      photo: mUser.photo,
    );

    Tellam.client().register(tellamUser);*/

      //
      /* _firebaseMessaging.subscribeToTopic("all");
    _firebaseMessaging.subscribeToTopic(mUser.role);
    _firebaseMessaging.subscribeToTopic(mUser.id.toString());*/

      //save to shared pref
      AuthBloc.prefs.setBool(AppStrings.authenticated, true);
      AuthBloc.saveUserData(userObject, password);
    }

    //logout
    void logout() async {
      //get current user data
      /* final currentUser = await appDatabase.userDao.findCurrent();
    //delete current user data from local storage
    await appDatabase.userDao.deleteAll();*/

      /* _firebaseMessaging.unsubscribeFromTopic("all");
    try {
      _firebaseMessaging.unsubscribeFromTopic(currentUser.role);
      _firebaseMessaging.unsubscribeFromTopic(currentUser.id.toString());
    } catch (error) {
      print("Error Unsubscribing user");
    }*/
      //logout of tellam
      //  Tellam.client().logout();
      //save to shared pref
      AuthBloc.prefs.setBool(AppStrings.authenticated, false);
    }

    Future<ApiResponse> generateOTP({
      String phone,
      String appSignature
    }) async {
      //instance of the model to be returned
      appSignature = appSignature.replaceAll("/", "");
      final apiResult = await get(
        "${Api.otp}/$phone/$appSignature",
      );

      //format the resposne
      ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
      if (!apiResponse.allGood) {
        throw apiResponse.errors;
      }

      //final vendor = Vendor.fromJSON(jsonObject: apiResponse.body);
      //final currencies = await appDatabase.currencyDao.findAllCurrencys();
      //vendor.currency = currencies[0];
      return apiResponse;
    }


    // OTP Related Functions...
    //OTP Related functions
    Future<ApiResponse> verifyPhoneNumber({
      String code,
      String phone,
    }) async {
      final apiResult = await post(
        Api.phoneValidation,
        {
          "code": code,
          "phone": phone,
        },
      );

      //
      return ApiResponseUtils.parseApiResponse(apiResult);
    }

    Future<ApiResponse> otpLogin({
      String token,
      String phone,
    }) async {
      final apiResult = await post(
        Api.otpLogin,
        {
          "token": token,
          "phone": phone,
        },
      );

      //
      final apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
      if (apiResponse.allGood) {
        saveuserData(
          apiResponse.body["user"],
          apiResponse.body["type"],
        );
      }
      return apiResponse;
    }

    Future<DialogData> sendEmail({
      @required String name,
      @required String toMailId,
      @required String fromEmail,
      @required String subject,
      @required String message,
      String attachment
    }) async {
      //instance of the model to be returned
      final resultDialogData = DialogData();
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['origin'] = 'http://localhost';
      final apiResult = await dio.post(
        "https://api.emailjs.com/api/v1.0/email/send",
        data: {
          "service_id": "service_immq6nl",
          "template_id": "template_baxt3tl",
          "user_id": "user_2KjoviSGCn7bcWQMH3QdQ",
          "template_params": {
            "user_name": name,
            "user_subject": subject,
            "user_message": message,
            "user_email": fromEmail,
            "to_email": toMailId,
          }
        },
      );

      ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);

      if (apiResponse.allGood) {
        resultDialogData.title = "Email sent successfully!";
        resultDialogData.body = "";
        resultDialogData.dialogType = DialogType.success;
      } else {
        resultDialogData.title = "Email sent failed!";
        resultDialogData.body = apiResponse.message;
        resultDialogData.dialogType = DialogType.failed;
      }

      return resultDialogData;
    }
  }

