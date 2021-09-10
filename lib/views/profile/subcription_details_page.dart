
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/bloc/login.bloc.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_images.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_strings.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/constants/strings/general.strings.dart';
import 'package:flutter_hopper/constants/strings/login.strings.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_hopper/widgets/appbar/auth_appbar.dart';
import 'package:flutter_hopper/widgets/appbar/common_app_bar.dart';
import 'package:flutter_hopper/widgets/appbar/subcription_appbar.dart';
import 'package:flutter_hopper/widgets/buttons/custom_button.dart';
import 'package:flutter_hopper/widgets/cool_radio_group/custom_radio_button_group.dart';
import 'package:flutter_hopper/widgets/inputs/custom_text_form_field.dart';
import 'package:flutter_hopper/widgets/platform/platform_circular_progress_indicator.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';

class SubcriptionDetailPage extends StatefulWidget {
  SubcriptionDetailPage({Key key}) : super(key: key);

  @override
  _SubcriptionDetailPageState createState() => _SubcriptionDetailPageState();

}

class _SubcriptionDetailPageState extends State<SubcriptionDetailPage> {
  //login bloc
  LoginBloc _loginBloc = LoginBloc();
  //email focus node
  final emailFocusNode = new FocusNode();
  //password focus node
  final passwordFocusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    _loginBloc.initBloc();
    //listen to the need to show a dialog alert or a normal snackbar alert type
    _loginBloc.showAlert.listen((show) {
      //when asked to show an alert
      if (show) {
        /* EdgeAlert.show(
          context,
          title: _loginBloc.dialogData.title,
          description: _loginBloc.dialogData.body,
          backgroundColor: _loginBloc.dialogData.backgroundColor,
          icon: _loginBloc.dialogData.iconData,
        );*/

        /*Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.homeRoute,
          (route) => false,
        );*/
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
    });
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
                Stack(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 40),
                        child:Image.asset("assets/images/subcrip_img.png",
                          width: double.infinity,
                          height: AppSizes.getScreenheight(context)*0.35,
                          fit: BoxFit.cover,)
                    ),

                    Align(
                      child: CommonAppBar(
                        title: "Subscription details",
                        backgroundColor: AppColor.accentColor,
                        onPressed: (){
                          Navigator.pop(context, false);
                        },
                      ),
                    )
                    /*Positioned(
                        top: 100,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          //margin: EdgeInsets.only(top: 10),
                            child:Image.asset("assets/images/subcrip_img.png",
                              width: double.infinity,
                              height: AppSizes.getScreenheight(context)*0.40,
                              fit: BoxFit.cover,)
                        )
                    )*/
                  ],
                ),

                //UiSpacer.verticalSpace(space: 20),
                Expanded(child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 8),
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Card(
                        elevation: 2,
                        color: AppColor.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child:Container(
                          padding: AppPaddings.defaultPadding(),
                          child: Row(
                            children: [
                              Expanded(child:Container(
                                alignment: Alignment.centerLeft,
                                  child:Text(
                                    "Premium",
                                    textAlign: TextAlign.left,
                                    style: AppTextStyle.h4TitleTextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600
                                    ),
                                  )
                              )),
                              Expanded(child: Container(
                                  alignment: Alignment.centerRight,
                                  child:RichText(
                                    textAlign: TextAlign.right,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(text: ''),
                                        TextSpan(
                                            text: '\$59.99',
                                            style: AppTextStyle.h3TitleTextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        TextSpan(text: '/',style: AppTextStyle.h4TitleTextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text: 'year',
                                            style: AppTextStyle.h5TitleTextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  )
                              )),
                            ],
                          ),
                        ),
                      ),
                      UiSpacer.verticalSpace(space: 10),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        alignment:Alignment.centerLeft,
                          child:Text(
                            "Validity : 1year",
                            textAlign: TextAlign.left,
                            style: AppTextStyle.h6TitleTextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600
                            ),
                          )
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 10),
                          alignment:Alignment.centerLeft,
                          child:Text(
                            "Renews on : 22 Sep 2021",
                            textAlign: TextAlign.left,
                            style: AppTextStyle.h6TitleTextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600
                            ),
                          )
                      ),
                      UiSpacer.verticalSpace(space: 20),
                      Container(
                          child:Text(
                            "Once you purchase, you will automatically be charged the annual fee of \$59.99 after 7 days, unless you cancel by two days before end of subscription.",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.h6TitleTextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400
                            ),
                          )
                      ),
                      UiSpacer.verticalSpace(space: 16),
                      Container(
                          child:Text(
                            "Your subscription will automatically renew 24 hours before the end of each subscription period.",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.h6TitleTextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400
                            ),
                          )
                      ),
                      UiSpacer.verticalSpace(space: 16),
                      Container(
                          child:Text(
                            "7-day free trial available only for first time customers.",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.h6TitleTextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400
                            ),
                          )
                      ),
                      UiSpacer.verticalSpace(space: 20),
                      StreamBuilder<UiState>(
                        stream: _loginBloc.uiState,
                        builder: (context, snapshot) {
                          final uiState = snapshot.data;
                          return Container(
                              width: double.infinity,
                              child:CustomButton(
                                padding: AppPaddings.mediumButtonPadding(),
                                color: AppColor.accentColor,
                                onPressed: uiState != UiState.loading
                                    ? (){
                                  Navigator.pushNamed(context, AppRoutes.homeRoute);
                                }
                                    : null,
                                child: uiState != UiState.loading
                                    ? Text(
                                  "UNSUBSCRIBE",
                                  style: AppTextStyle.h4TitleTextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500
                                  ),
                                  textAlign: TextAlign.start,
                                  textDirection:
                                  AppTextDirection.defaultDirection,
                                )
                                    : PlatformCircularProgressIndicator(),
                              ));
                        },
                      ),
                      UiSpacer.verticalSpace(space: 16),
                      Container(
                        padding: EdgeInsets.only(left: 8,right: 8),
                        child:InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, AppRoutes.loginRoute);
                            },
                            child:Text(
                              "Restore Purchase",
                              style: AppTextStyle.h5TitleTextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                  fontStyle: FontStyle.italic
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            )
        ),
      ),
    );

  }
}
