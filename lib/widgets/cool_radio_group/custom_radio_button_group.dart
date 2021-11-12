import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_hopper/constants/app_color.dart';


class CustomRadioGroup extends StatefulWidget {
  @override
  _CustomRadioGroupState createState() => _CustomRadioGroupState();
}

class PaymentList {
  String title;
  String subtitle;
  int index;
  PaymentList({this.title,this.subtitle, this.index});
}

class _CustomRadioGroupState extends State<CustomRadioGroup> {


  // Default Radio Button Item
  String radioItem = '\$6.99/month';

  // Group Value for Radio Button.
  int id = 1;

  int selected_index=1;

  List<PaymentList> fList = [
    PaymentList(
      index: 1,
      title: "\$6.99/month",
      subtitle: "Premium"
    ),
    PaymentList(
      index: 2,
      title: "\$59.99/year",
      subtitle: "Premium"
    ),
    PaymentList(
      index: 3,
      title: "Free Trial",
      subtitle: "7-day trial"
    ),
  ];


  @override
  void initState() {

  }

  Widget build(BuildContext context) {
    return  Column(
                children:
                fList.map((data) => Container(
                    margin: EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: selected_index==data.index?Border.all(color: AppColor.accentColor,width: 1):null,
                      borderRadius: BorderRadius.circular(selected_index==data.index?10:0)
                    ),
                   child: RadioListTile(
                   title: Column(
                     mainAxisSize: MainAxisSize.min,
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                          Text("${data.title}",style: AppTextStyle.h4TitleTextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
                          Text("${data.subtitle}",style: AppTextStyle.h6TitleTextStyle(color: Colors.grey[400],fontWeight: FontWeight.w400),),
                     ],
                   ),
                  groupValue: id,
                  value: data.index,
                  dense: false,
                  activeColor: AppColor.accentColor,
                  onChanged: (val) {
                    setState(() {
                      radioItem = data.title ;
                      id = data.index;
                      selected_index=data.index;
                    });
                  },
                ))).toList(),
              );

  }
}
