import 'package:flutter_hopper/bloc/base.bloc.dart';
import 'package:flutter_hopper/constants/strings/search.strings.dart';
import 'package:rxdart/rxdart.dart';

class SearchHopperBloc extends BaseBloc {
  //
  int queryCategoryId;

  //VendorRepository instance

  //BehaviorSubjects
  // BehaviorSubject<List<Product>> _searchVendors = BehaviorSubject<List<Product>>();
  BehaviorSubject<List<String>> _searchVendors = BehaviorSubject<
      List<String>>();

  //BehaviorSubject stream getters
  Stream<List<String>> get searchVendors => _searchVendors.stream;


  @override
  void initBloc() {
    super.initBloc();
    _searchVendors.addError("");
  }

  void initSearch(String value, {bool forceSearch = false}) async {
    //making sure user entered something before doing an api call
    if (value.isNotEmpty || forceSearch) {
      //add null data so listener can show shimmer widget to indicate loading
      _searchVendors.add(null);

      /* try {

        final vendors = await _vendorRepository.getSearchProduct(
          type: "productSearch",
          keyword: value,
          categoryId: queryCategoryId,
        );

        if (vendors.length > 0) {
          _searchVendors.add(vendors);
        } else {
          _searchVendors.addError(SearchStrings.emptyTitle);
        }
      } catch (error) {
        _searchVendors.addError(error);
      }*/
    }
  }

  void noVendorProcess() {
    _searchVendors.addError(SearchStrings.emptyTitle);
  }


  void sendEmail() async {
    //making sure user entered something before doing an api call
    //add null data so listener can show shimmer widget to indicate loading
    /* setUiState(UiState.loading);
    try {

      dialogData = await _vendorRepository.sendEmail();

    } catch (error) {
      _searchVendors.addError(error);
    }
    setUiState(UiState.done);
  }*/

  }
}