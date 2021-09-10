// ViewModel
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/strings/general.strings.dart';
import 'package:flutter_hopper/models/loading_state.dart';
import 'package:flutter_hopper/repositories/home.repository.dart';
import 'package:flutter_hopper/viewmodels/base.viewmodel.dart';

class MainHomeViewModel extends MyBaseViewModel {

  HomePageRepository _homePageRepository= HomePageRepository();

  //

  LoadingState mainHomeLoadingState = LoadingState.Loading;
  int listingStyle = 2;


  List<String> homeList=[];

  Map<String, bool> filterMap = {
    'Egges' : false,
    'Chocolates' : false,
    'Flour' : false,
    'Fllower' : false,
    'Fruits' : false,
  };



  MainHomeViewModel(BuildContext context) {
    this.viewContext = context;
  }

  initialise() async{
    getHomeList();
  }

  /*void getBookDetails({int iSBN,String serachID}) async{
    //add null data so listener can show shimmer widget to indicate loading
    bookDetailsLoadingState = LoadingState.Loading;
    notifyListeners();

    try {
      bookData = await _homePageRepository.getBookDetails(iSBN,serachID);
      bookDetailsLoadingState = LoadingState.Done;
      notifyListeners();
    } catch (error) {
      bookDetailsLoadingState = LoadingState.Failed;
      notifyListeners();
    }
  }*/

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


