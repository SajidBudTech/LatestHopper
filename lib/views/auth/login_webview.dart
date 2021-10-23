
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/bloc/login.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebView extends StatefulWidget {
  LoginWebView({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginWebView> {
  //login bloc
  LoginBloc _loginBloc = LoginBloc();
  //email focus node
  final emailFocusNode = new FocusNode();
  //password focus node
  final passwordFocusNode = new FocusNode();

  String fileHtmlContents = "<a href=\"https://lookwhatwemadeyou.com/audiohopper/wp-login.php?loginSocial=facebook\" data-plugin=\"nsl\" data-action=\"connect\" data-redirect=\"current\" data-provider=\"facebook\" data-popupwidth=\"475\" data-popupheight=\"175\">Click here to login or register</a>";
  WebViewController _webViewController;
  @override
  void initState() {
    super.initState();
 /*   _loginBloc.initBloc();
    //listen to the need to show a dialog alert or a normal snackbar alert type
    _loginBloc.showAlert.listen((show) {
      //when asked to show an alert
      if (show) {
        ShowFlash(
            context,
            title: _loginBloc.dialogData.title,
            message: _loginBloc.dialogData.body,
            flashType: FlashType.failed
        ).show();
      }
    });

    //listen to state of the ui
    _loginBloc.uiState.listen((uiState) async {
      if (uiState == UiState.redirect) {
        // await Navigator.popUntil(context, (route) => false);
        //Navigator.pushNamed(context, AppRoutes.homeRoute);
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.homeRoute,
              (route) => false,
        );
      }
    });*/
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<
        SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColor.accentColor,
      ),
      child:Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child:Column(
              children: [
              Expanded(child: WebView(
              initialUrl: '',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController){
                _webViewController=webViewController;
                 loadAsset();
              },
              )),
              ],
            )
        ),
      ),
    );

  }
  loadAsset() async {
    //String fileHtmlContents = await rootBundle.loadString('assets/demo.html');
    _webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }



}
