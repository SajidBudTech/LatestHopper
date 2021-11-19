import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:flutter_hopper/constants/api.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/constants/audio_constant.dart';
import 'package:flutter_hopper/models/audio_player_state.dart';
import 'package:flutter_hopper/models/dialog_data.dart';
import 'package:flutter_hopper/models/home_post.dart';
import 'package:flutter_hopper/utils/custom_dialog.dart';
import 'package:flutter_hopper/utils/file_download.dart';
import 'package:flutter_hopper/utils/flash_alert.dart';
import 'package:flutter_hopper/utils/ui_spacer.dart';
import 'package:flutter_hopper/viewmodels/hopper.viewmodel.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_hopper/models/recenctly_viewed_post.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class MyHopperListViewItem extends StatefulWidget {
  MyHopperListViewItem({Key key, this.onPressed,this.onThreeDotPressed, this.hopper,this.showDownload,
    this.showAddTOPlayer,this.model})
      : super(key: key);

  final Function onPressed;
  final Function onThreeDotPressed;
  //final Function onDownloadPressed;
  final Hopper hopper;
  final bool showDownload;
  final bool showAddTOPlayer;
  final HopperViewModel model;
  @override
  _MyHopperListViewItemState createState() => _MyHopperListViewItemState();
}

class _MyHopperListViewItemState extends State<MyHopperListViewItem> {

  bool _permissionReady = false;
  String _localPath="";
  bool startDownLoad=false;
  DownloadingState downloadingState=DownloadingState.Pending;
  double totalDownLoad=1.0;
  double progressDownload=0.0;
  Dio dio=Dio();
  FileDownload fileDownload;

  @override
  void initState() {
    // TODO: implement initState

    widget.model.downloadedList.forEach((element) {
      if(element.post.iD==widget.hopper.post.iD){
        downloadingState=DownloadingState.Completed;
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              InkWell(
              onTap: widget.onPressed,
              child:Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Stack(
                          children: <Widget>[
                            //vendor feature image
                            ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: widget.hopper.postCustom.coverImageUrl[0] ?? "",
                                  placeholder: (context, url) => Container(
                                    height: 60,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                  height: 60,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )),

                            /*ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child:Image.asset("assets/images/home_list.png",
                          height: 60,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )),*/
                            Positioned.fill(
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/images/play_home.png",
                                      width: 32,
                                      height: 32,
                                    ))),
                          ],
                        )),
                    Expanded(
                        flex: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 8, top: 0),
                              child: Text(
                               // "Roack and Roll Globe",
                                widget.hopper.post.postTitle??"",
                                style: AppTextStyle.h5TitleTextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.accentColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textDirection:
                                    AppTextDirection.defaultDirection,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8, top: 0),
                              child: Text(
                                //"Pediatricians plead with FDA to move quickly on covid vaccine for kids.",
                                widget.hopper.postCustom.postDescription[0]??"",
                                style: AppTextStyle.h5TitleTextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.textColor(context),
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textDirection:
                                    AppTextDirection.defaultDirection,
                              ),
                            ),
                          ],
                        ))
                  ],
                )),
                UiSpacer.verticalSpace(space: 10),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      //padding: EdgeInsets.only(left: 2,top: 0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        //"Aug 05 2021 10 Mins",
                        (parseDate(widget.hopper.postCustom.publicationDate[0]??"19790401"))+("  ${widget.hopper.postCustom.audioFileDuration[0]??"0"} Mins"),
                        style: AppTextStyle.h6TitleTextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black38,
                            fontStyle: FontStyle.italic),
                        textDirection: AppTextDirection.defaultDirection,
                      ),
                    )),
                    Expanded(
                        child: Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                            visible: (widget.showDownload && !widget.showAddTOPlayer),
                            child:Container(
                            margin:EdgeInsets.only(right: 24),
                            child:InkWell(
                               // onTap: widget.onThreeDotPressed,
                                child: Icon(
                                  FlutterIcons.three_bars_oct,
                                  size: 22,
                                  color: Colors.grey,
                                )))),
                        Container(
                            margin:EdgeInsets.only(right: 24),
                            child:InkWell(
                            onTap: widget.onThreeDotPressed,
                            child: Icon(
                              FlutterIcons.dots_three_horizontal_ent,
                              size: 22,
                              color: Colors.grey,
                            ))),
                       /* SizedBox(
                          width: 16,
                        ),*/
                        widget.showDownload?
                        (downloadingState==DownloadingState.Started?
                        SleekCircularSlider(
                          appearance: CircularSliderAppearance(
                            angleRange: 360,
                            startAngle: 270,
                            customColors: CustomSliderColors(
                              trackColor: Colors.black54,
                              progressBarColor: AppColor.accentColor,
                            ),
                            customWidths: CustomSliderWidths(
                              progressBarWidth: 4,
                              trackWidth: 3,
                            ),
                            size: 24,
                          ),
                          min: 0,
                          initialValue: progressDownload,
                          max: totalDownLoad,
                          innerWidget: (checkVakue){

                          },
                        )
                        :downloadingState==DownloadingState.Pending?
                        InkWell(
                            onTap: (){
                              downloadingState==DownloadingState.Pending?
                              checkDownload():null;
                            },
                            child:Image.asset(
                              "assets/images/download _ic.png",
                              width: 22,
                              height: 22,
                              color: Colors.grey,
                            ))
                            :Icon(
                          Icons.clear_sharp,
                          size: 24,
                          color: Colors.grey,
                         )
                        )
                            :SizedBox.shrink(),

                        widget.showAddTOPlayer?
                        ((widget.showAddTOPlayer && widget.showDownload)?
                         Row(
                           children: [
                             SizedBox(width: 24,),
                             InkWell(
                                 onTap:(){
                                   bool check=false;
                                   widget.model.myHopperList.forEach((element) {
                                     if(element.post.iD==widget.hopper.post.iD){
                                       check=true;
                                     }
                                   });
                                   if(!check){
                                     widget.model.addToMyHooper(postId: widget.hopper.post.iD,hopper: widget.hopper);
                                   }else{
                                     ShowFlash(context,
                                         title:
                                         "Already Added In MyHopper",
                                         message:
                                         "Please try with some other article!",
                                         flashType: FlashType.failed)
                                         .show();
                                   }

                                 },
                                 child: Container(
                                   //margin: EdgeInsets.only(left: (widget.showAddTOPlayer && widget.showDownload)?24:0),
                                     child:Image.asset(
                                       "assets/images/play_ic.png",
                                       width: 24,
                                       height: 24,
                                       color: Colors.grey,
                                     )

                                 ))
                           ],
                         )

                        :InkWell(
                            onTap:(){
                                 bool check=false;
                                 widget.model.myHopperList.forEach((element) {
                                 if(element.post.iD==widget.hopper.post.iD){
                                   check=true;
                                  }
                                });
                                 if(!check){
                                   widget.model.addToMyHooper(postId: widget.hopper.post.iD,hopper: widget.hopper);
                                 }else{
                                   ShowFlash(context,
                                       title:
                                       "Already Added In MyHopper",
                                       message:
                                       "Please try with some other article!",
                                       flashType: FlashType.failed)
                                       .show();
                                 }

                            },
                            child: Container(
                              //margin: EdgeInsets.only(left: (widget.showAddTOPlayer && widget.showDownload)?24:0),
                                child:Image.asset(
                              "assets/images/play_ic.png",
                              width: 24,
                              height: 24,
                              color: Colors.grey,
                            )

                            ))):SizedBox.shrink(),

                       /* Visibility(
                          visible: widget.showAddTOPlayer,
                          child:InkWell(
                          onTap:(){

                          },
                          child:Image.asset(
                          "assets/images/play_ic.png",
                          width: 20,
                          height: 20,
                          color: Colors.grey,
                        )))*/
                      ],
                    )),
                  ],
                )
              ],
            ));
  }

  String parseDate(String date) {
    String year = date.substring(0, 4);
    String mm = date.substring(4, 6);
    String dd = date.substring(6, 8);

    String newDate = year + "/" + mm + "/" + dd;

    return DateFormat("MMMM dd, yyyy").format(DateFormat("yyyy/MM/dd").parse(newDate));
  }


  downloadFile(String url,Hopper hopper) async {

    _permissionReady = await _checkPermission();

    if (_permissionReady) {
      await _prepareSaveDir();
    }


    startDownLoad=true;
    downloadingState=DownloadingState.Started;
    String fileName=url.split("/").last;
    File saveFile=File(_localPath+"/"+fileName);

    try {

      await dio.downloadUri(Uri.parse(url), saveFile.path,
          onReceiveProgress: (downloaded, totalSize) {
        if(mounted) {
          setState(() {
            progressDownload = downloaded / totalSize;
            if (downloaded == totalSize) {
              startDownLoad = false;
              downloadingState=DownloadingState.Completed;
            }
          });
        }
      });

      /*fileDownload=FileDownload(context: AudioConstant.navigatorKey.currentContext,url: url,path: saveFile.path,onReceiveProgress:DownloadRecevier);
      await fileDownload.startDownload();*/

         HomePost _homePost = HomePost();
        _homePost.id = hopper.post.iD;
        _homePost.coverImageUrl = hopper.postCustom.coverImageUrl[0] ?? "";
        _homePost.author = hopper.postCustom.author[0] ?? "";
        _homePost.isAdded = true;
        _homePost.publication = hopper.postCustom.publication[0] ?? "";
        _homePost.publicationDate = hopper.postCustom.publicationDate[0] ?? "";
        _homePost.narrator = hopper.postCustom.narrator[0] ?? "";
        _homePost.audioFile = hopper.postCustom.audioFile[0] ?? "";
        _homePost.audioFileDuration =
         hopper.postCustom.audioFileDuration[0] ?? "";
        _homePost.title = Guid();
        _homePost.title.rendered = hopper.post.postTitle ?? "";
        _homePost.subHeader = hopper.postCustom.subHeader[0] ?? "";
        _homePost.postDescription = hopper.postCustom.postDescription[0] ?? "";
        _homePost.url = hopper.postCustom.url[0] ?? "";
        _homePost.localFilePath = saveFile.path;
        _homePost.userBy = widget.model.userId;

        await AuthBloc.addUserDownloadFile(_homePost, saveFile.path);

      if (mounted) {
        bool check = false;
        widget.model.downloadedList.forEach((element) {
          if(_homePost.id==element.post.iD){
            check=true;
          }
        });
        setState(() {
          if(!check){
            widget.model.downloadedList.add(hopper);
            widget.model.notify();
          }
        });
      }



    }catch(e){
      if (mounted) {
        ShowFlash(context,
            title: "Error in file downloading....",
            message: "Please try again!",
            flashType: FlashType.failed)
            .show();
      }
      if (mounted) {
        setState(() {
          startDownLoad = false;
          downloadingState = DownloadingState.Pending;
        });
      }

    }
  }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {

      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      final storageStatus = await Permission.storage.status;

      final accessStatus = androidInfo.version.sdkInt >= 30?await Permission.accessMediaLocation.status:true;
      final manageStatus = androidInfo.version.sdkInt >= 30?await Permission.manageExternalStorage.status:true;


      if (storageStatus != PermissionStatus.granted && accessStatus!=PermissionStatus.granted && manageStatus!=PermissionStatus.granted) {
        final result = await Permission.storage.request();
        final result2 = androidInfo.version.sdkInt >= 30?await Permission.accessMediaLocation.request():PermissionStatus.granted;
        final result3 = androidInfo.version.sdkInt >= 30?await Permission.manageExternalStorage.request():PermissionStatus.granted;

        if (result == PermissionStatus.granted && result2 == PermissionStatus.granted && result3 == PermissionStatus.granted) {
          return true;
        }

      } else {
        return true;
      }
    } else if(Platform.isIOS){
      /*final status = await Permission.photos.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.photos.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }*/
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath());
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create(recursive: true);
    }
  }

  Future<String> _findLocalPath() async {
    var externalStorageDirPath;
    Directory directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
      String newPath="";
      List<String> folders=directory.path.split("/");
      for(int i=1;i<folders.length;i++){
        String folder=folders[i];
        if(folder!="Android"){
          newPath+="/"+folder;
        }else{
          break;
        }
      }
      newPath=newPath+"/AudioHopperApp";
      directory=Directory(newPath);


    } else if (Platform.isIOS) {
       directory = await getTemporaryDirectory();
      //directory=await getApplicationDocumentsDirectory();
      //externalStorageDirPath = (await getApplicationDocumentsDirectory()).absolute.path;
    }

    externalStorageDirPath=directory.path;
    return externalStorageDirPath;

  }

  void DownloadRecevier(int downloaded,int totalSize,bool status){
    setState(() {
      progressDownload = downloaded / totalSize;
      if (status) {
        startDownLoad = false;
        downloadingState=DownloadingState.Completed;
      }
    });
  }

  void checkDownload() async{

    bool check=false;

    widget.model.savedDownLoads.forEach((key) {
      if(widget.hopper.post.iD==key.id){
        check=true;
      }
    });

    if(!check) {

      final int userId = AuthBloc.getUserId();

      var dialogData = DialogData();
      dialogData.title = "Add To Download";
      dialogData.body = "Please wait.......";
      dialogData.dialogType = DialogType.loading;
      dialogData.isDismissible = false;

      //preparing data to be sent to server
      CustomDialog.showAlertDialog(context, dialogData);
      // setUiState(UiState.loading);
      dialogData = await widget.model.homePageRepository.addToDownload(userId, widget.hopper.post.iD);
      CustomDialog.dismissDialog(context);
      //update ui state after operation
      // setUiState(UiState.done);
      //checking if operation was successful before either showing an error or redirect to home page
      if (dialogData.dialogType == DialogType.success) {
        /* dialogData.isDismissible = true;
      dialogData.dialogType = DialogType.success;
      //notify the ui with the newly gotten dialogdata model
      CustomDialog.showAlertDialog(viewContext, dialogData,onDismissAction: (){
        myHopperList.add(hopper);
        notifyListeners();
      });*/

        downloadFile(widget.hopper.postCustom.audioFile[0] ?? "",widget.hopper);

      } else {
        //prepare the data model to be used to show the alert on the view
        dialogData.isDismissible = true;
        dialogData.dialogType = DialogType.failed;
        //notify the ui with the newly gotten dialogdata model
        CustomDialog.showAlertDialog(context, dialogData,
            onDismissAction: () {
              CustomDialog.dismissDialog(context);
            });
      }
    }else{
      ShowFlash(context,
          title: "Already added in Download",
          message: "Please try with some other articles.",
          flashType: FlashType.failed)
          .show();
    }

  }
}
