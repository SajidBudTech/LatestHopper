// ViewModel
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/constants/strings/general.strings.dart';
import 'package:flutter_hopper/models/loading_state.dart';
import 'package:flutter_hopper/repositories/home.repository.dart';
import 'package:flutter_hopper/viewmodels/base.viewmodel.dart';

class HopperViewModel extends MyBaseViewModel {

  HomePageRepository _homePageRepository= HomePageRepository();

  //

  LoadingState myHopperLoadingState = LoadingState.Loading;



  List<String> myHopperList=[];
  List<String> recentlyViewedList=[];
  List<String> downloadedList=[];

  HopperViewModel(BuildContext context) {
    this.viewContext = context;
  }

  initialise() async{
    getMyHopperList();
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

  getMyHopperList()async{
    myHopperLoadingState = LoadingState.Loading;
    notifyListeners();

    for(int i=0;i<3;i++){
      recentlyViewedList.add("");
    }

    myHopperLoadingState = LoadingState.Done;
    notifyListeners();
  }
}


