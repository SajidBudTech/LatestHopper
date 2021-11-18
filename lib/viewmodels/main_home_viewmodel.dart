// ViewModel
import 'package:flutter/material.dart';
import 'package:flutter_hopper/bloc/auth.bloc.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_hopper/models/dialog_data.dart';
import 'package:flutter_hopper/models/home_category.dart';
import 'package:flutter_hopper/models/home_post.dart';
import 'package:flutter_hopper/models/loading_state.dart';
import 'package:flutter_hopper/models/notification.dart';
import 'package:flutter_hopper/models/recenctly_viewed_post.dart';
import 'package:flutter_hopper/repositories/home.repository.dart';
import 'package:flutter_hopper/viewmodels/base.viewmodel.dart';
import 'package:intl/intl.dart';

class MainHomeViewModel extends MyBaseViewModel {

  HomePageRepository _homePageRepository= HomePageRepository();

  //

  LoadingState mainHomeLoadingState = LoadingState.Loading;
  LoadingState mainHomeCategoryLoadingState = LoadingState.Loading;
  LoadingState mainHomeAuthorLoadingState = LoadingState.Loading;
  LoadingState mainHomePublicationLoadingState = LoadingState.Loading;
  LoadingState mainNotificationLoadingState = LoadingState.Loading;

  int listingStyle = 2;


  List<String> homeList=[];

  List<HomePost> mainhomeList=[];
  List<HomePost> mainhomeFilterList=[];
  List<HomeCategory> mainhomeCategory=[];
  List<String> mainhomeAuthor=[];
  List<String> mainhomePublication=[];

  List<NotificationData> notificationList=[];

  List<Hopper> myHopperList=[];


  Map<String, bool> filterCategoryMap = {};
  Map<String, bool> filterAuthorMap = {};
  Map<String, bool> filterPublicationMap = {};



  MainHomeViewModel(BuildContext context) {
    this.viewContext = context;
  }

  initialise()async{
    getHomeList();
  }

  initHomeValue()async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      getHomePostDetails();
      getHomeCategoryDetails();
      getUserProfile();
    }else{
      mainHomeLoadingState = LoadingState.NoIntenet;
      notifyListeners();
    }
  }

  void getHomePostDetails() async{
    //add null data so listener can show shimmer widget to indicate loading
    mainHomeLoadingState = LoadingState.Loading;
    notifyListeners();

    try {

      mainhomeList = await _homePageRepository.getHomePostList();
      getMyHopperList();
      mainhomeList.forEach((element) {

        mainhomeAuthor.add(element.author??"");
        mainhomePublication.add(element.publication??"");

      });
      for(String author in mainhomeAuthor){
        filterAuthorMap.putIfAbsent(author??"", () => false);
      }
      for(String author in mainhomePublication){
        filterPublicationMap.putIfAbsent(author??"", () => false);
      }

      //mainHomeLoadingState = LoadingState.Done;
      //notifyListeners();
    } catch (error) {
      mainHomeLoadingState = LoadingState.Failed;
      notifyListeners();
    }
  }

  void getMyHopperList() async{
    //add null data so listener can show shimmer widget to indicate loading
    //mainHomeLoadingState = LoadingState.Loading;
    //notifyListeners();

    final int userId=AuthBloc.getUserId();

    try {

      myHopperList = await _homePageRepository.getMyHopperPost(userId);

      for(int i=0;i<mainhomeList.length;i++){
        myHopperList.forEach((element) {
          if(element.post.iD==mainhomeList[i].id){
            mainhomeList[i].isAdded=true;
          }
        });
      }
      mainhomeFilterList=mainhomeList;
      //notifyListeners();
      mainHomeLoadingState = LoadingState.Done;
      notifyListeners();
    } catch (error) {
      mainHomeLoadingState = LoadingState.Failed;
      notifyListeners();
    }
  }

  void getHomeCategoryDetails() async{
    //add null data so listener can show shimmer widget to indicate loading
    mainHomeCategoryLoadingState = LoadingState.Loading;
    notifyListeners();

    try {
      mainhomeCategory = await _homePageRepository.getFilterCategoryList();

      for(HomeCategory homeCategory in mainhomeCategory){
        filterCategoryMap.putIfAbsent(homeCategory.name??"", () => false);
      }
      mainHomeCategoryLoadingState = LoadingState.Done;
      notifyListeners();
    } catch (error) {
      mainHomeCategoryLoadingState = LoadingState.Failed;
      notifyListeners();
    }
  }

  void getUserProfile() async{
    //add null data so listener can show shimmer widget to indicate loading
   // mainHomeCategoryLoadingState = LoadingState.Loading;
   // notifyListeners();

    final int userId=await AuthBloc.getUserId();

    try {
        final resultDialog = await _homePageRepository.getProfilePicture(userId);
        if(resultDialog.dialogType==DialogType.success){
          AuthBloc.setUserProfileImage(resultDialog.body);
        }
    } catch (error) {
       print("Error in get profile picture");
    }
  }

  void getHomeAuthotDetails() async{
    //add null data so listener can show shimmer widget to indicate loading
    mainHomeAuthorLoadingState = LoadingState.Loading;
    notifyListeners();

    try {

       mainhomeAuthor = await _homePageRepository.getFilterAuhtorList();

      for(String author in mainhomeAuthor){
        filterAuthorMap.putIfAbsent(author??"", () => false);
      }
       mainHomeAuthorLoadingState = LoadingState.Done;
      notifyListeners();
    } catch (error) {
      mainHomeAuthorLoadingState = LoadingState.Failed;
      notifyListeners();
    }

  }

  void getHomePublicationDetails() async{
    //add null data so listener can show shimmer widget to indicate loading
    mainHomePublicationLoadingState = LoadingState.Loading;
    notifyListeners();

    try {

      mainhomePublication = await _homePageRepository.getFilterPublicationList();

      for(String author in mainhomePublication){
        filterPublicationMap.putIfAbsent(author??"", () => false);
      }

      mainHomePublicationLoadingState = LoadingState.Done;
      notifyListeners();
    } catch (error) {
      mainHomePublicationLoadingState = LoadingState.Failed;
      notifyListeners();
    }
  }

   getHomeList()async{
     mainHomeLoadingState = LoadingState.Loading;
     notifyListeners();

     for(int i=0;i<10;i++){
       homeList.add("1");
     }
     mainHomeLoadingState = LoadingState.Done;
     notifyListeners();
   }

   applyFilter()async{

     List<HomePost> newFilterList=[];
     for(HomePost homePost in mainhomeFilterList){

       filterCategoryMap.forEach((key, value) {
         mainhomeCategory.forEach((element) {
           if(homePost.categories[0]==element.id && element.name==key && value){
             bool check=newFilterList.any((item) => item.id == homePost.id);
             if(!check){
               newFilterList.add(homePost);
             }
           }
         /* // if(homePost.categories==key && value){
             bool check=newFilterList.any((item) => item.id == homePost.id);
             if(!check){
               newFilterList.add(homePost);
             }
          // }*/

         });
       });

       filterAuthorMap.forEach((key, value) {
         if(homePost.author==key && value){
           bool check=newFilterList.any((item) => item.id == homePost.id);
           if(!check){
             newFilterList.add(homePost);
           }
         }
       });

       filterPublicationMap.forEach((key, value) {
         if(homePost.publication==key && value){
           bool check=newFilterList.any((item) => item.id == homePost.id);
           if(!check){
             newFilterList.add(homePost);
           }
         }
       });

     }

     mainhomeList=newFilterList;
     notifyListeners();

   }

   clearAll()async{

     filterCategoryMap={};
     filterAuthorMap= {};
     filterPublicationMap= {};

     mainhomeList=mainhomeFilterList;
     notifyListeners();

   }


  void getNotificationList() async{
    //add null data so listener can show shimmer widget to indicate loading
    mainNotificationLoadingState = LoadingState.Loading;
    notifyListeners();

    final userId=AuthBloc.getUserId();
    try {

      notificationList = await _homePageRepository.getNotifications(userId);
      notificationList.sort((a,b){
        var adate = DateFormat("dd-MM-yyyy HH:mm:ss").parse(a.notificationSentOn); //before -> var adate = a.expiry;
        var bdate = DateFormat("dd-MM-yyyy HH:mm:ss").parse(b.notificationSentOn); //before -> var bdate = b.expiry;
        return bdate.compareTo(adate);
      });

      mainNotificationLoadingState = LoadingState.Done;
      notifyListeners();
    } catch (error) {
      mainNotificationLoadingState = LoadingState.Failed;
      notifyListeners();
    }
  }

  }


