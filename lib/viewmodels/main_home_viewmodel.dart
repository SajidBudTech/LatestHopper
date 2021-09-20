// ViewModel
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/strings/general.strings.dart';
import 'package:flutter_hopper/models/home_category.dart';
import 'package:flutter_hopper/models/home_post.dart';
import 'package:flutter_hopper/models/loading_state.dart';
import 'package:flutter_hopper/repositories/home.repository.dart';
import 'package:flutter_hopper/viewmodels/base.viewmodel.dart';

class MainHomeViewModel extends MyBaseViewModel {

  HomePageRepository _homePageRepository= HomePageRepository();

  //

  LoadingState mainHomeLoadingState = LoadingState.Loading;
  int listingStyle = 2;


  List<String> homeList=[];

  List<HomePost> mainhomeList=[];
  List<HomeCategory> mainhomeCategory=[];

  Map<String, bool> filterCategoryMap = {};



  MainHomeViewModel(BuildContext context) {
    this.viewContext = context;
  }

  initialise()async{
    getHomeList();
  }

  void getHomePostDetails() async{
    //add null data so listener can show shimmer widget to indicate loading
    mainHomeLoadingState = LoadingState.Loading;
    notifyListeners();

    try {
      mainhomeList = await _homePageRepository.getHomePostList();
      mainHomeLoadingState = LoadingState.Done;
      notifyListeners();
    } catch (error) {
      mainHomeLoadingState = LoadingState.Failed;
      notifyListeners();
    }
  }

  void getHomeCategoryDetails() async{
    //add null data so listener can show shimmer widget to indicate loading
    mainHomeLoadingState = LoadingState.Loading;
    notifyListeners();

    try {
      mainhomeCategory = await _homePageRepository.getFilterCategoryList();

      for(HomeCategory homeCategory in mainhomeCategory){
        filterCategoryMap.putIfAbsent(homeCategory.name??"", () => false);
      }
      mainHomeLoadingState = LoadingState.Done;
      notifyListeners();
    } catch (error) {
      mainHomeLoadingState = LoadingState.Failed;
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


  }


