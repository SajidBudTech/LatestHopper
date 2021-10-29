import 'package:flutter_hopper/models/home_post.dart';

class DownloadItem{
  HomePost homePost;
  String filePath;

  DownloadItem({this.homePost, this.filePath});

  DownloadItem.fromJson(Map<String, dynamic> json){
     homePost=json['home_post'] != null ? HomePost.fromJson(json['info']) : null;;
     filePath=json['file_path'];

  }

 /* Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.homePost != null) {
      data['home_post'] = this.homePost.toJson();
    }
    data['file_path'] = this.filePath;
    return data;
  }*/

}