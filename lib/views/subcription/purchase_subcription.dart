
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
import 'package:flutter_hopper/models/loading_state.dart';
import 'package:flutter_hopper/models/state_data_model.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_hopper/viewmodels/payment.viewmodel.dart';
import 'package:flutter_hopper/widgets/appbar/auth_appbar.dart';
import 'package:flutter_hopper/widgets/appbar/subcription_appbar.dart';
import 'package:flutter_hopper/widgets/buttons/custom_button.dart';
import 'package:flutter_hopper/widgets/cool_radio_group/custom_radio_button_group.dart';
import 'package:flutter_hopper/widgets/empty/empty_playing.dart';
import 'package:flutter_hopper/widgets/inputs/custom_text_form_field.dart';
import 'package:flutter_hopper/widgets/platform/platform_circular_progress_indicator.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_hopper/widgets/shimmers/vendor_shimmer_list_view_item.dart';
import 'package:flutter_hopper/widgets/state/state_loading_data.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:stacked/stacked.dart';

class SubcriptionPurchasePage extends StatefulWidget {
  SubcriptionPurchasePage({Key key}) : super(key: key);

  @override
  _SubcriptionPurchasePageState createState() => _SubcriptionPurchasePageState();

}

class _SubcriptionPurchasePageState extends State<SubcriptionPurchasePage> {
  //login bloc
  LoginBloc _loginBloc = LoginBloc();
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
    return ViewModelBuilder<PaymentViewModel>.reactive(
    viewModelBuilder: () => PaymentViewModel(context),
    onModelReady: (model) => model.initPayment(),
    builder: (context, model, child) =>AnnotatedRegion<SystemUiOverlayStyle>(
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
                      margin: EdgeInsets.only(top: 60),
                        child:Image.asset("assets/images/subcrip_img.png",
                          width: double.infinity,
                          height: AppSizes.getScreenheight(context)*0.35,
                          fit: BoxFit.cover,)
                    ),

                    Align(
                      child: SubcriptionAppBar(
                        title: "Unlock\nUnlimited Access",
                        imagePath: "assets/images/appicon_mini.png",
                        backgroundColor: AppColor.accentColor,
                      ),
                    )
                  ],
                ),

                //UiSpacer.verticalSpace(space: 20),
                Expanded(
                 child:model.paymentLoadingState == LoadingState.Loading?
                 Padding(padding:AppPaddings.defaultPadding(),child:VendorShimmerListViewItem())
                     : model.paymentLoadingState == LoadingState.Failed?
                 Padding(padding:AppPaddings.defaultPadding(),
                     child:LoadingStateDataView(
                       stateDataModel: StateDataModel(
                         showActionButton: true,
                         actionButtonStyle: AppTextStyle.h4TitleTextStyle(
                           color: Colors.red,
                         ),
                         actionFunction: model.initPayment,
                       ),
                     )):model.paymentLoadingState == LoadingState.NoIntenet?
                 Padding(padding:AppPaddings.defaultPadding(),
                     child:LoadingStateDataView(
                       stateDataModel: StateDataModel(
                         title: "Internet Connnectivity",
                         description: "Please check your internet connectivity and try again.",
                         showActionButton: true,
                         actionButtonStyle: AppTextStyle.h4TitleTextStyle(
                           color: Colors.red,
                         ),
                         actionFunction: model.initPayment,
                       ),
                     ))
                     :model.products.length==0?
                 Padding(padding:AppPaddings.defaultPadding(),
                     child:LoadingStateDataView(
                       stateDataModel: StateDataModel(
                         showActionButton: true,
                         actionButtonStyle: AppTextStyle.h4TitleTextStyle(
                           color: Colors.red,
                         ),
                         actionFunction: model.initPayment,
                       ),
                     ))
                 :SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 8),
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      CustomRadioGroup(products: model.products,model: model),
                      UiSpacer.verticalSpace(space: 20),
                      Container(
                          child:Text(
                            "Once you purchase, you will automatically be charged the annual fee of \$89.99 after 7 days, unless you cancel by two days before end of subscription.",
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

                                        //Navigator.pushNamed(context, AppRoutes.homeRoute);
                                       // ProductDetails productDetails = ProductDetails(title: "7 Day Free Trial",currencyCode: "USD",description: "Get Free 7 Days Trial",currencySymbol: "\$",price: "59.59",id: "7-day-free",rawPrice: 59.59);
                                        model.purchaseSubcription(model.selectedProduct);

                                     }
                                    : null,
                                child: uiState != UiState.loading
                                    ? Text(
                                  "CONTINUE",
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
                             // Navigator.pushNamed(context, AppRoutes.loginRoute);
                              model.restorePurchase();
                            },
                            child:Text(
                              "Restore Purchase",
                              style: AppTextStyle.h5TitleTextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                  fontStyle: FontStyle.italic,
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
    ));

  }
}
