import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/utils/custom_dialog.dart';
import 'package:flutter_hopper/viewmodels/hopper.viewmodel.dart';
import 'package:flutter_hopper/viewmodels/main_home_viewmodel.dart';
import 'package:flutter_hopper/views/hopper/hopper_bottom_sheet_page.dart';
import 'package:flutter_hopper/views/hopper/list_header_widget.dart';
import 'package:flutter_hopper/widgets/appbar/home_appbar.dart';
import 'package:flutter_hopper/widgets/empty/hopper_empty.dart';
import 'package:flutter_hopper/widgets/listview/myhopper_listview_item.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_hopper/models/loading_state.dart';
import 'package:flutter_hopper/widgets/shimmers/vendor_shimmer_list_view_item.dart';
import 'package:flutter_hopper/models/state_data_model.dart';
import 'package:flutter_hopper/widgets/state/state_loading_data.dart';

class WarningPage extends StatefulWidget {
  const WarningPage({Key key}) : super(key: key);

  @override
  _WarningPageState createState() => _WarningPageState();
}

class _WarningPageState extends State<WarningPage> with AutomaticKeepAliveClientMixin<WarningPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
              padding: EdgeInsets.only(left: 20,right: 10,top: 10,bottom: 10),
               color: Colors.grey[200],
                child:Row(
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          //padding: EdgeInsets.only(),
                          child:Text(
                            'You have 3 days of your free trial remaining',
                            style: AppTextStyle.h6TitleTextStyle(
                                color: AppColor.textColor(context),
                                fontWeight: FontWeight.w500
                            ),
                            textAlign: TextAlign.start,
                            textDirection: AppTextDirection.defaultDirection,
                             )),
                          Expanded(
                             child:Row(
                               mainAxisAlignment: MainAxisAlignment.end,
                               children: [
                                 Container(
                                     alignment: Alignment.topLeft,
                                     //padding: EdgeInsets.only(),
                                     child:Text(
                                       'Upgrade',
                                       style: AppTextStyle.h5TitleTextStyle(
                                           color: AppColor.textColor(context),
                                           fontWeight: FontWeight.w600
                                       ),
                                       textAlign: TextAlign.start,
                                       textDirection: AppTextDirection.defaultDirection,
                                     )),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 24,
                                    color: Colors.black,
                                  )
                               ],
                             )
                          )


                              ],
                            ),

            );
  }

  void showSortBottomSheetDialog() {
    CustomDialog.showCustomBottomSheet(
        context,
        backgroundColor: Colors.white,
        content:HopperBottomSheetPage()
    );

  }

}
