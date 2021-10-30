import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:flutter_hopper/constants/strings/login.strings.dart';
import 'package:flutter_hopper/constants/strings/register.strings.dart';
import 'package:flutter_hopper/models/register_token.dart';
import 'package:flutter_hopper/repositories/auth.repository.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/models/dialog_data.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/constants/validation_messages.dart';
import 'package:flutter_hopper/utils/validators.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  User firebaseUser;

  final facebookLogin = new FacebookLogin();
  String socialUserName="";
  String socialEmail="";
  String socialPassword="";
  String socialDisplayName="";
  bool social=false;

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

  void processSocialRegiration({String email,String password}) async {

     social=true;
    //if (validateName(name) && validateEmailAddress(email) && validatePassword(password)){
      //update ui state
      setUiState(UiState.loading);
      final resultDialogData = await _authRepository.register(
          name: socialDisplayName,
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
        if(social){
          if(resultDialogData.body == "Sorry, that username already exists!"){
            generateSocialLoginToken(email: email,password: password);
          }
        }else{
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
   // }
  }

  void signUpWithNewFacebook(BuildContext context) async {

    final data= await facebookLogin.logOut();
    //print(data.toString());
    final result = await facebookLogin.logIn(['email']);
    // redirect url  https://hopperaudio-ae4eb.firebaseapp.com/__/auth/handler
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}'));
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        _initiateSocialAccountFacebookLogin(userProfile: profile,context: context);
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
  void signinWithGoogle({BuildContext context}) async {

    //await Firebase.initializeApp();

    try {

      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      //  String _googleUserEmail = googleSignInAccount.email;
      //show the user a loading state
      setUiState(UiState.loading);

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // final UserCredential authResult = await _firebaseAuth.signInWithCredential(credential);
      // final AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
      // authResult.user.updateEmail(_googleUserEmail);

      final UserCredential authResult = await _firebaseAuth.signInWithCredential(credential);

      firebaseUser = authResult.user;

      //final User user = authResult.user;


      assert(!firebaseUser.isAnonymous);
      assert(await firebaseUser.getIdToken() != null);

      final User currentUser = await _firebaseAuth.currentUser;
      assert(firebaseUser.uid == currentUser.uid);
      //firebase user must not be an anonymous user
      assert(!firebaseUser.isAnonymous);
      //firebase user must have token id
      assert(await firebaseUser.getIdToken() != null);

      //call socail login request with our gotten access token
      _initiateSocialAccountLogin(firebaseUser: firebaseUser,context: context);

    } on PlatformException catch (error) {
      //update ui state after operation
      setUiState(UiState.done);
      //show dialog with error message
      //prepare the data model to be used to show the alert on the view
      dialogData.title = RegisterStrings.processTitle;
      dialogData.body = (error != null && error.message.isNotEmpty)
          ? error.message
          : RegisterStrings.processErrorMessage;
      dialogData.backgroundColor = AppColor.failedColor;
      dialogData.iconData = FlutterIcons.error_mdi;
      //notify listners to show show alert
      setShowAlert(true);
    } catch (error) {
      //update ui state after operation
      setUiState(UiState.done);
      //show dialog with error message
      dialogData.title = RegisterStrings.processTitle;
      dialogData.body = (error != null && error.message.isNotEmpty)
          ? error.message
          : RegisterStrings.processErrorMessage;
      dialogData.backgroundColor = AppColor.failedColor;
      dialogData.iconData = FlutterIcons.error_mdi;
      //notify listners to show show alert
      setShowAlert(true);
    }
  }

  //Apple login
  void signinWithApple({BuildContext context}) async {
    setUiState(UiState.loading);
    //await Firebase.initializeApp();
    final isAvailable=await SignInWithApple.isAvailable();

    if(isAvailable){
      try {

        final credential = await SignInWithApple.getAppleIDCredential(

          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
            clientId:'com.application.audiohopper',
            //'com.aboutyou.dart_packages.sign_in_with_apple.example',
            redirectUri: Uri.parse(
              //'https://little-aeolian-gander.glitch.me/callbacks/sign_in_with_apple',
                'https://hopperaudio-ae4eb.firebaseapp.com/__/auth/handler'
            ),
          ),
          // TODO: Remove these if you have no need for them
          nonce: 'example-nonce',
          state: 'hopper-state',
        );

        print(credential);

        final signInWithAppleEndpoint = Uri(
          scheme: 'https',
         // host: 'little-aeolian-gander.glitch.me',
         // path: '/sign_in_with_apple',
          host: 'hopperaudio-ae4eb.firebaseapp.com',
          path: '/__/auth/handler',
          queryParameters: <String, String>{
            'code': credential.authorizationCode,
            if (credential.givenName != null)
              'firstName': credential.givenName,
            if (credential.familyName != null)
              'lastName': credential.familyName,
            'useBundleId':
            Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
            if (credential.state != null) 'state': credential.state,
          },
        );

        final session = await http.Client().post(
           signInWithAppleEndpoint,
        );

        print(session);

        if(session.statusCode==200){
          //var response=json.decode(session.body);
          _initiateSocialAccountAppleLogin(emailid: credential.email,fullname: credential.givenName,context: context);
        }else{
          setUiState(UiState.done);
          //show dialog with error message
          dialogData.title = LoginStrings.processTitle;
          dialogData.body = LoginStrings.processErrorMessage;
          dialogData.backgroundColor = AppColor.failedColor;
          dialogData.iconData = FlutterIcons.error_mdi;
          //notify listners to show show alert
          setShowAlert(true);
        }

        // If we got this far, a session based on the Apple ID credential has been created in your system,
        // and you can now set this as the app's session


        //call socail login request with our gotten access token
        //_initiateSocialAccountLogin(firebaseUser: firebaseUser,context: context);

      } on PlatformException catch (error) {
        //update ui state after operation
        setUiState(UiState.done);
        //show dialog with error message
        //prepare the data model to be used to show the alert on the view
        dialogData.title = LoginStrings.processTitle;
        dialogData.body = (error != null && error.message.isNotEmpty)
            ? error.message
            : LoginStrings.processErrorMessage;
        dialogData.backgroundColor = AppColor.failedColor;
        dialogData.iconData = FlutterIcons.error_mdi;
        //notify listners to show show alert
        setShowAlert(true);
      } catch (error) {
        //update ui state after operation
        setUiState(UiState.done);
        //show dialog with error message
        dialogData.title = LoginStrings.processTitle;
        dialogData.body = (error != null && error.message.isNotEmpty)
            ? error.message
            : LoginStrings.processErrorMessage;
        dialogData.backgroundColor = AppColor.failedColor;
        dialogData.iconData = FlutterIcons.error_mdi;
        //notify listners to show show alert
        setShowAlert(true);
      }
    }
  }

  void _initiateSocialAccountAppleLogin({
    String emailid,String fullname,BuildContext context
  }) async {

    socialDisplayName = fullname??"";
    socialEmail = emailid;

    var name=socialDisplayName!=null?socialDisplayName.toString().split(" "):[];
    for(int i=0;i<name.length;i++){
      socialUserName=socialUserName+name[i].toLowerCase();
      socialPassword = socialPassword+name[i].toLowerCase();
    }

    var random = Random();
    var n1 = random.nextInt(10000);


    String email="appleuser"+((socialUserName.isEmpty)?n1.toString():socialUserName)+"@gmail.com";
    processSocialRegiration(email: email,password: socialPassword.isEmpty?"apple{$n1}":socialPassword);

  }

  void _initiateSocialAccountLogin({
    User firebaseUser,BuildContext context
  }) async {

    socialDisplayName = firebaseUser.displayName;
    socialEmail= firebaseUser.email;
    socialUserName=firebaseUser.phoneNumber;

    var name=socialDisplayName.split(" ");
    for(int i=0;i<name.length;i++){
      socialPassword = socialPassword+name[i].toLowerCase();
    }

    String email=socialEmail;
    processSocialRegiration(email: email,password: socialPassword);

  }

  void _initiateSocialAccountFacebookLogin({
    Map userProfile,BuildContext context
  }) async {

    socialDisplayName = userProfile['name'];
    socialEmail = userProfile['email'];

    var name=userProfile['name'].toString().split(" ");
    for(int i=0;i<name.length;i++){
      socialUserName=socialUserName+name[i].toLowerCase();
      socialPassword = socialPassword+name[i].toLowerCase();
    }

    String email="facebookuser"+socialUserName+"@gmail.com";
    processSocialRegiration(email: email,password: socialPassword);

  }


  void generateSocialLoginToken({String email,String password}) async{
    // if (validateEmailAddress(email)) {

    social=true;
    setUiState(UiState.loading);

    try {

      registerToken = await _authRepository.registerToken(
          username: email,
          password: password
      );

      setUiState(UiState.done);

      if (registerToken != null && registerToken.jwtToken != null) {
        processSocialLogin(email: email,password: password);
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

    //  }
  }
  void processSocialLogin({String email,String password}) async {

    // if (validateEmailAddress(socialEmail)) {
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
    // }
  }

  void getUserDetail() async {

    //update ui state
    setUiState(UiState.loading);

    final resultDialogData = await _authRepository.getUserDetails(
        password: socialPassword
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


