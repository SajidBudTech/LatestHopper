import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/api.dart';
import 'package:flutter_hopper/constants/app_routes.dart';
import 'package:flutter_hopper/models/api_response.dart';
import 'package:flutter_hopper/models/dialog_data.dart';
import 'package:flutter_hopper/models/home_category.dart';
import 'package:flutter_hopper/models/home_post.dart';
import 'package:flutter_hopper/models/notification.dart';
import 'package:flutter_hopper/services/http.service.dart';
import 'package:flutter_hopper/utils/api_response.utils.dart';
import 'package:flutter_hopper/views/auth/login_page.dart';
import 'package:flutter_hopper/models/recenctly_viewed_post.dart';


class HomePageRepository extends HttpService {

  Future<List<HomePost>> getHomePostList() async {
    List<HomePost> categories = [];

    //make http call for vendors data
    final apiResult = await get(Api.homePagePost);

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body as List).forEach((categoryJSONObject) {
      //vendor data
      categories.add(HomePost.fromJson(categoryJSONObject));

    });

    return categories;

  }
  Future<List<HomePost>> getHomePostSearch(String keyword) async {
    List<HomePost> categories = [];

    //make http call for vendors data
    final apiResult = await get(Api.searchPost,queryParameters: {
      "search":keyword
    });

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body as List).forEach((categoryJSONObject) {
      //vendor data
      categories.add(HomePost.fromJson(categoryJSONObject));

    });

    return categories;

  }

  Future<List<HomeCategory>> getFilterCategoryList() async {
    List<HomeCategory> categories = [];

    //make http call for vendors data
    final apiResult = await get(Api.filterCategory);

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body as List).forEach((categoryJSONObject) {
      //vendor data
      categories.add(HomeCategory.fromJson(categoryJSONObject));

    });

    return categories;

  }

  Future<List<String>> getFilterAuhtorList() async {
    List<String> categories = [];

    //make http call for vendors data
    final apiResult = await get(Api.filterAuthor);

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body as List).forEach((categoryJSONObject) {
      //vendor data
      categories.add(categoryJSONObject);

    });

    return categories;

  }
  Future<List<String>> getFilterPublicationList() async {
    List<String> categories = [];

    //make http call for vendors data
    final apiResult = await get(Api.filterPublication);

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body as List).forEach((categoryJSONObject) {
      //vendor data
      categories.add(categoryJSONObject);

    });

    return categories;

  }

  Future<List<NotificationData>> getNotifications(int userId) async {
    List<NotificationData> categories = [];

    //make http call for vendors data
    final apiResult = await get(Api.notifications+"/"+userId.toString());

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body as List).forEach((categoryJSONObject) {
      //vendor data
      categories.add(NotificationData.fromJson(categoryJSONObject));

    });

    return categories;

  }

  Future<HomePost> getPostDetails(int postId) async {
    HomePost homePost = new HomePost();

    //make http call for vendors data
    final apiResult = await get(Api.searchPost+postId.toString());

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    homePost=HomePost.fromJson(apiResponse.body);


    return homePost;

  }

  Future<List<Hopper>> getRecenltyViewedPost(int userId) async {
    List<Hopper> categories = [];

    //make http call for vendors data
    final apiResult = await get(Api.recentlyViewPost+"/"+userId.toString());

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    if(apiResponse.body!="") {
      (apiResponse.body as List).forEach((categoryJSONObject) {
        //vendor data
        categories.add(Hopper.fromJson(categoryJSONObject));
      });
    }

    return categories;

  }
  Future<DialogData> addRecenltyViewedPost(int userId,int postId) async {
    final resultDialogData = DialogData();

    //make http call for vendors data
    final apiResult = await post(Api.addToRecentlyViewed,{
      "post_id":postId,
      "user_id":userId
    });

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    if (apiResponse.allGood) {
      resultDialogData.title = "Successfully added to RecentlyViewed!";
      resultDialogData.body = "";
      resultDialogData.dialogType = DialogType.success;
    } else {
      resultDialogData.title = "Failed to add to RecentlyViewed!";
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;

  }
  Future<DialogData> removeFromRecenttlyViewed(int userId,int postId) async {
    final resultDialogData = DialogData();

    //make http call for vendors data
    final apiResult = await post(Api.removeFromRecentlyViewed,{
      "post_id":postId,
      "user_id":userId
    });

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    if (apiResponse.allGood) {
      resultDialogData.title = "Successfully removed from RecentlyViewed!";
      resultDialogData.body = "";
      resultDialogData.dialogType = DialogType.success;
    } else {
      resultDialogData.title = "Failed to remove from RecentlyViewed!";
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;

  }

  Future<List<Hopper>> getMyHopperPost(int userId) async {
    List<Hopper> categories = [];

    //make http call for vendors data
    final apiResult = await get(Api.myHopperPost+"/"+userId.toString());

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    if(apiResponse.body!="") {
      (apiResponse.body as List).forEach((categoryJSONObject) {
        //vendor data
        categories.add(Hopper.fromJson(categoryJSONObject));
      });
    }

    return categories;

  }

  Future<DialogData> addToMyHooper(int userId,int postId) async {
    final resultDialogData = DialogData();

    //make http call for vendors data
    final apiResult = await post(Api.addToMyHopper,{
      "post_id":postId,
      "user_id":userId
    });

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    if (apiResponse.allGood) {
      resultDialogData.title = "Successfully added to MyHopper!";
      resultDialogData.body = "";
      resultDialogData.dialogType = DialogType.success;
    } else {
      resultDialogData.title = "Failed to add to MyHopper!";
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;

  }

  Future<DialogData> removeFromMyHooper(int userId,int postId) async {
    final resultDialogData = DialogData();

    //make http call for vendors data
    final apiResult = await post(Api.removeFromHopper,{
      "post_id":postId,
      "user_id":userId
    });

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    if (apiResponse.allGood) {
      resultDialogData.title = "Successfully removed from MyHopper!";
      resultDialogData.body = "";
      resultDialogData.dialogType = DialogType.success;
    } else {
      resultDialogData.title = "Failed to remove from MyHopper!";
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;

  }
  Future<List<Hopper>> getDownloadList(int userId) async {
    List<Hopper> categories = [];

    //make http call for vendors data
    final apiResult = await get(Api.downloadedPost+"/"+userId.toString());

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    if(apiResponse.body!="") {
      (apiResponse.body as List).forEach((categoryJSONObject) {
        //vendor data
        categories.add(Hopper.fromJson(categoryJSONObject));
      });
    }

    return categories;

  }

  Future<DialogData> addToDownload(int userId,int postId) async {
    final resultDialogData = DialogData();

    //make http call for vendors data
    final apiResult = await post(Api.addToDownload,{
      "post_id":postId,
      "user_id":userId
    });

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    if (apiResponse.allGood) {
      resultDialogData.title = "Successfully added to Download!";
      resultDialogData.body = "";
      resultDialogData.dialogType = DialogType.success;
    } else {
      resultDialogData.title = "Failed to add to Download!";
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;

  }
  Future<DialogData> removeFromDownload(int userId,int postId) async {
    final resultDialogData = DialogData();

    //make http call for vendors data
    final apiResult = await post(Api.removeFromDownload,{
      "post_id":postId,
      "user_id":userId
    });

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    if (apiResponse.allGood) {
      resultDialogData.title = "Successfully removed from download!";
      resultDialogData.body = "";
      resultDialogData.dialogType = DialogType.success;
    } else {
      resultDialogData.title = "Failed to remove from download!";
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;

  }

  Future<DialogData> getProfilePicture(int userId) async {
    final resultDialogData = DialogData();

    //make http call for vendors data
    final apiResult = await get(Api.getUserAvatar,queryParameters: {"user_id":userId});

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);

    if (apiResponse.allGood) {
      if(apiResponse.body[0]['profile_img_url']!="0") {
        resultDialogData.title = "Successfully removed from download!";
        resultDialogData.body = apiResponse.body[0]['profile_img_url'];
        resultDialogData.dialogType = DialogType.success;
      }else{
        resultDialogData.title = "Failed to remove from download!";
        resultDialogData.body = apiResponse.message;
        resultDialogData.dialogType = DialogType.failed;
      }
    } else {
      resultDialogData.title = "Failed to remove from download!";
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;

  }

  /*Future<List<CommonBook>> getNewReleases() async {
    List<CommonBook> categories = [];

    //make http call for vendors data
    final apiResult = await get(Api.newReleases);

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body as List).forEach((categoryJSONObject) {
      //vendor data
      categories.add(CommonBook.fromJson(categoryJSONObject));

    });

    return categories;

  }

  Future<List<CommonBook>> getBestSeller() async {
    List<CommonBook> categories = [];

    //make http call for vendors data
    final apiResult = await get(Api.bestSeller);

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body as List).forEach((categoryJSONObject) {
      //vendor data
      categories.add(CommonBook.fromJson(categoryJSONObject));

    });

    return categories;

  }

  Future<List<CommonBook>> getAbantuFavorites() async {
    List<CommonBook> categories = [];

    //make http call for vendors data
    final apiResult = await get(Api.abantuFavorites);

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body as List).forEach((categoryJSONObject) {
      //vendor data
      categories.add(CommonBook.fromJson(categoryJSONObject));

    });

    return categories;

  }

  Future<BookData> getBookDetails(int ISBN,String searchID) async {
    BookData bookData = new BookData();

    //make http call for vendors data
    final apiResult = await get(Api.bookDetails+"/"+ISBN.toString()+"/"+searchID);

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    bookData=BookData.fromJson(apiResponse.body['bookData']);


    return bookData;

  }

  Future<List<CommonBook>> getCategoriesDiscover(String category) async {
    List<CommonBook> categories = [];

    //make http call for vendors data
    final apiResult = await get(Api.discoverCategories+"/"+category);

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body['books'] as List).forEach((categoryJSONObject) {
      //vendor data
      categories.add(CommonBook.fromJson(categoryJSONObject));

    });

    return categories;

  }

  Future<List<DiscoverPage>> getDiscoverPage() async {
    List<DiscoverPage> categories = [];

    //make http call for vendors data
    final apiResult = await get(Api.discoverPage);

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body as List).forEach((categoryJSONObject) {
      //vendor data
      categories.add(DiscoverPage.fromJson(categoryJSONObject));

    });

    return categories;

  }

  Future<List<LibraryBook>> getLibaryBooks(String token,BuildContext context) async {
    List<LibraryBook> categories = [];

    //make http call for vendors data
    final apiResult = await post(Api.library,{
      "jwt":token
    });

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      if(apiResponse.message=='jwt expired'){
        ContextKeeper.logout();
      }else{
        throw apiResponse.errors;
      }
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body['library'] as List).forEach((categoryJSONObject) {
      //vendor data
      categories.add(LibraryBook.fromJson(categoryJSONObject));

    });

    return categories;

  }

  Future<List<WishlistBook>> getWishlist(String token,BuildContext context) async {
    List<WishlistBook> categories = [];

    //make http call for vendors data
    final apiResult = await post(Api.wishlist,{
      "jwt":token
    });

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {

      if(apiResponse.message=='jwt expired'){
        ContextKeeper.logout();
      }else{
        throw apiResponse.errors;
      }
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body['wishlist'] as List).forEach((categoryJSONObject) {
      //vendor data
      categories.add(WishlistBook.fromJson(categoryJSONObject));

    });

    return categories;

  }


  Future<DialogData> addtowishlist({
    @required String token,
    @required int isbn,
  }) async {
    //instance of the model to be returned
    final resultDialogData = DialogData();
    final apiResult = await post(
      Api.addToWishlist+"/"+isbn.toString(),
      {
        "jwt": token,
      },
    );

    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);

    if (apiResponse.allGood) {
      resultDialogData.title = "Successfully added to your wishlist!";
      resultDialogData.body = "";
      resultDialogData.dialogType = DialogType.success;
    } else {
      resultDialogData.title = "Failed to add to your wishlist!";
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;
  }


  Future<DialogData> removeFromWishlist({
    @required String token,
    @required int isbn,
  }) async {
    //instance of the model to be returned
    final resultDialogData = DialogData();
    final apiResult = await post(
      Api.removeWishlist+"/"+isbn.toString(),
      {
        "jwt": token,
      },
    );

    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);

    if (apiResponse.allGood) {
      resultDialogData.title = "Successfully removed from your wishlist!";
      resultDialogData.body = "";
      resultDialogData.dialogType = DialogType.success;
    } else {
      resultDialogData.title = "Failed to removed from your wishlist!";
      resultDialogData.body = apiResponse.message;
      resultDialogData.dialogType = DialogType.failed;
    }

    return resultDialogData;
  }*/



 /* Future<List<Category>> getCategories() async {
    List<Category> categories = [];

    //make http call for vendors data
    final apiResult = await post(Api.categories,{});

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body['data'] as List).forEach((categoryJSONObject) {
      //vendor data
      categories.add(Category.fromJson(categoryJSONObject));

    });

    return categories;

  }

  Future<List<Collection>> getCollection() async {
    List<Collection> categories = [];

    //make http call for vendors data
    final apiResult = await post(Api.collections,{});

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body['data'] as List).forEach((categoryJSONObject) {
      //vendor data
      categories.add(Collection.fromJson(categoryJSONObject));

    });

    return categories;
  }





  Future<List<AdvertismentBanner>> getScrollingBanner() async {
    List<AdvertismentBanner> categories = [];

    //make http call for vendors data
    final apiResult = await post(Api.scrollingbanners,{});

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body['data'] as List).forEach((categoryJSONObject) {
      //vendor data
      categories.add(AdvertismentBanner.fromJson(categoryJSONObject));

    });

    return categories;
  }

  Future<List<AdvertismentBanner>> getAdevertismentBanner() async {
    List<AdvertismentBanner> categories = [];

    //make http call for vendors data
    final apiResult = await post(Api.advertismentbanners,{});

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body['data'] as List).forEach((categoryJSONObject) {
      //vendor data
      categories.add(AdvertismentBanner.fromJson(categoryJSONObject));

    });

    return categories;
  }

  Future<List<GoldRate>> getGoldRate() async {
    List<GoldRate> categories = [];

    //make http call for vendors data
    final apiResult = await post(Api.goldRate,{});

    // print("Api result ==> ${apiResult.data}");
    //format the resposne
    ApiResponse apiResponse = ApiResponseUtils.parseApiResponse(apiResult);
    if (!apiResponse.allGood) {
      throw apiResponse.errors;
    }

    // print("About to collect");
    //convert the data to list of category model
    (apiResponse.body['data'] as List).forEach((categoryJSONObject) {
      //vendor data
      categories.add(GoldRate.fromJson(categoryJSONObject));

    });

    return categories;

  }*/



}
