import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/constants/strings/search.strings.dart';
import 'package:flutter_hopper/models/home_post.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_hopper/repositories/home.repository.dart';

class SearchDoctorsBloc extends BaseBloc {
  //
  int queryCategoryId;
  //VendorRepository instance
  HomePageRepository _homePageRepository = HomePageRepository();

  //BehaviorSubjects
  BehaviorSubject<List<HomePost>> _searchPost = BehaviorSubject<List<HomePost>>();

  //BehaviorSubject stream getters
  Stream<List<HomePost>> get searchPosts => _searchPost.stream;

  @override
  void initBloc() {
    super.initBloc();
    _searchPost.addError("");
  }

  void initSearch(String value, {bool forceSearch = false}) async {
    //making sure user entered something before doing an api call
    if (value.isNotEmpty || forceSearch) {
      //add null data so listener can show shimmer widget to indicate loading
      _searchPost.add(null);

      try {
        final vendors = await _homePageRepository.getHomePostSearch(value);

        if (vendors.length > 0) {
          _searchPost.add(vendors);
        } else {
          _searchPost.addError(SearchStrings.emptyTitle);
        }
      } catch (error) {
        _searchPost.addError(error);
      }
    }
  }

  /*void initSearchSpecial(String value, {bool forceSearch = false}) async {
    //making sure user entered something before doing an api call
    if (value.isNotEmpty || forceSearch) {
      //add null data so listener can show shimmer widget to indicate loading
      _searchVendors.add(null);

      try {
        final vendors = await _doctorRepository.getDoctorsSpecilityWise(queryCategoryId);

        if (vendors.length > 0) {
          _searchVendors.add(vendors);
        } else {
          _searchVendors.addError(SearchStrings.emptyTitle);
        }
      } catch (error) {
        _searchVendors.addError(error);
      }
    }
  }

  void noVendorProcess(){
    _searchVendors.addError(SearchStrings.emptyTitle);
  }*/
}
