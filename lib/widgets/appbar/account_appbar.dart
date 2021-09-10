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


class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({
    Key key,
    this.backgroundColor,
    this.imagePath,
    this.onPressed,
  }) : super(key: key);

  final Color backgroundColor;
  final String imagePath;
  final Function onPressed;

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
            UiSpacer.verticalSpace(),
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
            UiSpacer.verticalSpace(space: 16),
             Row(
                  textDirection: AppTextDirection.defaultDirection,
                  children: <Widget>[
                    ClipOval(
                              //clipBehavior: Clip.antiAliasWithSaveLayer,
                             child:Image.asset("assets/images/propic.png",
                              height: 100,
                              fit: BoxFit.cover,
                              width: 100,
                            )
                    ),
                    Expanded(
                        child: Container(
                              margin: EdgeInsets.only(left: 8,right: 8),
                              padding: EdgeInsets.only(left: 8,right: 8,top: 12,bottom: 12),
                              child:  RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Shadrias Pearson\n',
                                      style: AppTextStyle.h4TitleTextStyle(color: Colors.white),
                                    ),
                                    TextSpan(
                                        text: 'shadrias@domain.com',
                                        style:AppTextStyle.h4TitleTextStyle(color: Colors.white)
                                       /* recognizer: TapGestureRecognizer()
                                          ..onTap = () async{
                                            //https://testbud.in/sab-trek/terms
                                            var url = "https://187courts.com/terms";
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          }*/
                                    )
                                  ],

                                ),

                              )
                        )
                    ),

                  ],
                ),

          ],
        )
    );
  }
}
