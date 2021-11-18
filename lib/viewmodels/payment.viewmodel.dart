// ViewModel
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hopper/models/loading_state.dart';
import 'package:flutter_hopper/repositories/payment.repository.dart';
import 'package:flutter_hopper/viewmodels/base.viewmodel.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_ios/in_app_purchase_ios.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_ios/store_kit_wrappers.dart';
import 'package:rxdart/rxdart.dart';

class PaymentViewModel extends MyBaseViewModel {

  PaymentRepository _paymentRepository=PaymentRepository();
  LoadingState paymentLoadingState=LoadingState.Loading;


  final InAppPurchase _inAppPurchase = InAppPurchase.instance;


  BehaviorSubject<List<PurchaseDetails>> _purchaseDetails = BehaviorSubject<List<PurchaseDetails>>.seeded([]);
  Stream<List<PurchaseDetails>> get getPurchaseDetails => _purchaseDetails.stream;


 // StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> notFoundIds = [];
  List<ProductDetails> products = [];

  ProductDetails selectedProduct;
  List<PurchaseDetails> purchases = [];
  bool _kAutoConsume=true;

  final String _kConsumableId = 'consumable';
  final String _kUpgradeId = 'upgrade';
  final String _kSilverSubscriptionId = 'monthly_subscription';
  final String _kGoldSubscriptionId = 'yearly_subscription';
  final String _kSilverSubscriptionIOSId = 'com.hopper.monthlySubscription';
  final String _kGoldSubscriptionIOSId = 'com.hopper.yearly';

  Set<String> _kIds ;

  PaymentViewModel(BuildContext context){
    this.viewContext=context;
  }

  initPayment() async{

    await retrieveProducts();

    _inAppPurchase.purchaseStream.listen((purchaseDetailsList) {
      purchases=purchaseDetailsList;
      purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
        if (purchaseDetails.status == PurchaseStatus.pending) {
          //showPendingUI();
        } else {
          if (purchaseDetails.status == PurchaseStatus.error) {
           // handleError(purchaseDetails.error!);
          } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
             bool valid = await _verifyPurchase(purchaseDetails);
            if (valid) {
              purchases.add(purchaseDetails);
            } else {
              _handleInvalidPurchase(purchaseDetails);
              return;
            }
          }
          if (Platform.isAndroid) {
            if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
              final InAppPurchaseAndroidPlatformAddition androidAddition =
              _inAppPurchase.getPlatformAddition<
                  InAppPurchaseAndroidPlatformAddition>();
              await androidAddition.consumePurchase(purchaseDetails);
            }
          }
          if (purchaseDetails.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
        }
      });

     });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    if(purchaseDetails.pendingCompletePurchase == PurchaseStatus.purchased || purchaseDetails.pendingCompletePurchase == PurchaseStatus.restored)
    {
      return Future<bool>.value(true);
    }else{
      return Future<bool>.value(false);
    }

  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> retrieveProducts() async {

    paymentLoadingState=LoadingState.Loading;
    final bool available = await _inAppPurchase.isAvailable();

    if (!available) {
      // Handle store not available
      paymentLoadingState=LoadingState.Done;
      notifyListeners();
      print("error store not available");
      return;
    }

    if (Platform.isIOS) {
      var iosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseIosPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    if(Platform.isAndroid){
      _kIds = <String>{_kConsumableId,_kSilverSubscriptionId, _kGoldSubscriptionId};
    }else{
      _kIds = <String>{_kConsumableId,_kSilverSubscriptionIOSId, _kGoldSubscriptionIOSId};
    }

    final ProductDetailsResponse productDetailResponse = await InAppPurchase.instance.queryProductDetails(_kIds);
    if (productDetailResponse.error == null) {
      //_queryProductError = productDetailResponse.error.message;
      //_isAvailable = isAvailable;
      products = productDetailResponse.productDetails;
      notFoundIds = productDetailResponse.notFoundIDs;
      //_consumables = [];
      //_purchasePending = false;
      //_loading = false;
      paymentLoadingState=LoadingState.Done;
      notifyListeners();
      return;

    }else{

      paymentLoadingState=LoadingState.Failed;
      notifyListeners();
      return;

    }



  }

  void restorePurchase() async{
    _inAppPurchase.restorePurchases();
  }


  void purchaseSubcription(ProductDetails productDetails) {
    PurchaseParam purchaseParam;
    if (Platform.isAndroid) {
      // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
      // verify the latest status of you your subscription by using server side receipt validation
      // and update the UI accordingly. The subscription purchase status shown
      // inside the app may not be accurate.
      final oldSubscription = null;//_getOldSubscription(productDetails, purchases);

      purchaseParam = GooglePlayPurchaseParam(
          productDetails: productDetails,
          applicationUserName: null,
          changeSubscriptionParam: (oldSubscription != null)
              ? ChangeSubscriptionParam(oldPurchaseDetails: oldSubscription,
                prorationMode: ProrationMode.immediateWithTimeProration,)
              : null);
    } else {
      purchaseParam = PurchaseParam(productDetails: productDetails, applicationUserName: null,);
    }

   // if (productDetails.id == _kConsumableId) {
     // _inAppPurchase.buyConsumable(purchaseParam: purchaseParam, autoConsume: _kAutoConsume || Platform.isIOS);
    //} else {
     _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
   // }
  }


  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isAndroid) {
      final InAppPurchaseAndroidPlatformAddition androidAddition =
      _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      var priceChangeConfirmationResult = await androidAddition.launchPriceChangeConfirmationFlow(
        sku: 'purchaseId',
      );
      if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Price change accepted'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            priceChangeConfirmationResult.debugMessage ??
                "Price change failed with code ${priceChangeConfirmationResult.responseCode}",
          ),
        ));
      }
    }
    if (Platform.isIOS) {
      var iapIosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseIosPlatformAddition>();
      await iapIosPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  GooglePlayPurchaseDetails _getOldSubscription(ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    // This is just to demonstrate a subscription upgrade or downgrade.
    // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
    // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
    // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
    // Please remember to replace the logic of finding the old subscription Id as per your app.
    // The old subscription is only required on Android since Apple handles this internally
    // by using the subscription group feature in iTunesConnect.
    GooglePlayPurchaseDetails oldSubscription;
    if (productDetails.id == _kSilverSubscriptionId && purchases[_kGoldSubscriptionId] != null) {
      oldSubscription = purchases[_kGoldSubscriptionId] as GooglePlayPurchaseDetails;
    } else if (productDetails.id == _kGoldSubscriptionId && purchases[_kSilverSubscriptionId] != null) {
      oldSubscription = purchases[_kSilverSubscriptionId] as GooglePlayPurchaseDetails;
    }
    return oldSubscription;
  }

}



/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper{
  @override
  bool shouldContinueTransaction(SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}

