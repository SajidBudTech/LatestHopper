import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_icons/flutter_icons.dart';


class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key key,
    this.backgroundColor,
    this.imagePath,
    this.onPressed,
    this.visibleBottom
  }) : super(key: key);

  final Color backgroundColor;
  final String imagePath;
  final Function(String) onPressed;
  final visibleBottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 10),
      decoration: BoxDecoration(
          color: AppColor.accentColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
          )
      ),
      child: Column(
        children: [
          Row(
            textDirection: AppTextDirection.defaultDirection,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, AppRoutes.notificationsRoute);
                      },
                      child:CircleAvatar(
                          backgroundColor: Color(0xFF168B8A),
                          child: Icon(FlutterIcons.notifications_mdi,color: AppColor.primaryColorDark,size: 24,)
                      )
                  )
              ),
              //Delivery location
              Expanded(
                flex: 5,
                child:Container(
                    alignment: Alignment.center,
                    child:Image.asset(imagePath??"",
                      height:36,
                      fit: BoxFit.cover,))
                ),
              Expanded(
                flex: 1,
                child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, AppRoutes.searchHopperPage);
                    },
                    child:CircleAvatar(
                        backgroundColor: Color(0xFF168B8A),
                        child: Icon(FlutterIcons.search_mdi,color: AppColor.primaryColorDark,size: 24,)
                    )
                )
              ),
            ],
          ),
          UiSpacer.verticalSpace(space: 10),
          Visibility(
              visible: this.visibleBottom,
              child: Row(
            textDirection: AppTextDirection.defaultDirection,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: InkWell(
                      onTap:()=>this.onPressed("PUBLICATION"),
                      child:Container(
                        padding: EdgeInsets.only(left: 4,right: 4,top: 12,bottom: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFF168B8A),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Text(
                           "PUBLICATION",
                          textAlign: TextAlign.center,
                          style: AppTextStyle.h12TitleTextStyle(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w500
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                  )
              ),
              Expanded(
                  flex: 1,
                  child: InkWell(
                      onTap: ()=>this.onPressed("AUTHOR"),
                      child:Container(
                        margin: EdgeInsets.only(left: 5,right: 5),
                        padding: EdgeInsets.only(left: 8,right: 8,top: 12,bottom: 12),
                        decoration: BoxDecoration(
                            color: Color(0xFF168B8A),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Text(
                          "AUTHOR",
                          textAlign: TextAlign.center,
                          style: AppTextStyle.h12TitleTextStyle(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      )
                  )
              ),
              Expanded(
                  flex: 1,
                  child: InkWell(
                      onTap:()=>this.onPressed("CATEGORY"),
                      child:Container(
                        padding: EdgeInsets.only(left: 8,right: 8,top: 12,bottom: 12),
                        decoration: BoxDecoration(
                            color: Color(0xFF168B8A),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Text(
                          "CATEGORY",
                          textAlign: TextAlign.center,
                          style: AppTextStyle.h12TitleTextStyle(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      )
                  )
              ),
              //Delivery location

            ],
          )),

        ],
      )
    );
  }
}
