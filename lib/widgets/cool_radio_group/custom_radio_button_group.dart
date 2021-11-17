import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/viewmodels/payment.viewmodel.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:in_app_purchase/in_app_purchase.dart';


class CustomRadioGroup extends StatefulWidget {

  CustomRadioGroup({Key key,this.products,this.model}) : super(key: key);

  List<ProductDetails> products;
  PaymentViewModel model;

  @override
  _CustomRadioGroupState createState() => _CustomRadioGroupState();


}

/*class PaymentList {
  String title;
  String subtitle;
  int index;
  PaymentList({this.title,this.subtitle, this.index});
}*/

class _CustomRadioGroupState extends State<CustomRadioGroup> {


  // Default Radio Button Item
  String radioItem = '\$6.99/month';

  // Group Value for Radio Button.
  int index = 0;
  String selectedProId="";
  bool platform;

  @override
  void initState() {
    selectedProId=widget.products[0].id;
    widget.model.selectedProduct=widget.products[0];
    if(Platform.isAndroid){
      platform=true;
    }else{
      platform=false;
    }
  }

  Widget build(BuildContext context) {
    return  Column(
                children:
                widget.products.map((data) => Container(
                    margin: EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: selectedProId==data.id?Border.all(color: AppColor.accentColor,width: 1):null,
                      borderRadius: BorderRadius.circular(selectedProId==data.id?10:0)
                    ),
                   child: RadioListTile(
                   title: Column(
                     mainAxisSize: MainAxisSize.min,
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                          Text("${data.price}/${platform?data.id=="monthly_subscription"?"month":"year":(data.id=="com.hopper.monthlySubscription"?"month":"year")}",style: AppTextStyle.h4TitleTextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
                          Text("${data.description}",style: AppTextStyle.h6TitleTextStyle(color: Colors.grey[400],fontWeight: FontWeight.w400),),
                     ],
                   ),
                  groupValue: selectedProId,
                  value: data.id,
                  dense: false,
                  activeColor: AppColor.accentColor,
                  onChanged: (val) {
                    setState(() {
                      radioItem = data.id;
                      selectedProId=data.id;
                      widget.model.selectedProduct=data;
                    });
                  },
                ))).toList(),
              );

  }
}
