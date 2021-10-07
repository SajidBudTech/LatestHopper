class Hopper{
  PostCustom postCustom;
  Post post;

  Hopper({this.postCustom, this.post});

  Hopper.fromJson(Map<String, dynamic> json) {
    postCustom = json['post_custom'] != null
        ? new PostCustom.fromJson(json['post_custom'])
        : null;
    post = json['post'] != null ? new Post.fromJson(json['post']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.postCustom != null) {
      data['post_custom'] = this.postCustom.toJson();
    }
    if (this.post != null) {
      data['post'] = this.post.toJson();
    }
    return data;
  }
}


class PostCustom {
  //List<String> lEditLock;
  //List<String> lEditLast;
  //List<String> pmsContentRestrictCustomRedirectUrl;
  //List<String> pmsContentRestrictCustomNonMemberRedirectUrl;
  //List<String> pmsContentRestrictMessageLoggedOut;
  //List<String> pmsContentRestrictMessageNonMembers;
  List<String> subHeader;
 // List<String> lSubHeader;
  List<String> author;
  //List<String> lAuthor;
  List<String> narrator;
  //List<String> lNarrator;
  List<String> publication;
 // List<String> lPublication;
  List<String> publicationDate;
  //List<String> lPublicationDate;
  List<String> url;
 // List<String> lUrl;
  List<String> audioFile;
 // List<String> lAudioFile;
  List<String> audioFileDuration;
 // List<String> lAudioFileDuration;
  List<String> postDescription;
  //List<String> lPostDescription;
  List<String> coverImageUrl;
 // List<String> lCoverImageUrl;
  List<String> postReadedBy;
  //List<String> lEncloseme;
 // List<String> pmsContentRestrictType;
  List<String> myHopper;
  List<String> myDownload;

  PostCustom(
      {
        //this.lEditLock,
        //this.lEditLast,
       // this.pmsContentRestrictCustomRedirectUrl,
        //this.pmsContentRestrictCustomNonMemberRedirectUrl,
        //this.pmsContentRestrictMessageLoggedOut,
       // this.pmsContentRestrictMessageNonMembers,
        this.subHeader,
       // this.lSubHeader,
        this.author,
       // this.lAuthor,
        this.narrator,
       // this.lNarrator,
        this.publication,
        //this.lPublication,
        this.publicationDate,
      //  this.lPublicationDate,
        this.url,
      //  this.lUrl,
        this.audioFile,
       // this.lAudioFile,
        this.audioFileDuration,
       // this.lAudioFileDuration,
        this.postDescription,
       // this.lPostDescription,
        this.coverImageUrl,
      //  this.lCoverImageUrl,
        this.postReadedBy,
        //this.lEncloseme,
       // this.pmsContentRestrictType,
        this.myHopper,
        this.myDownload});

  PostCustom.fromJson(Map<String, dynamic> json) {
   // lEditLock = json['_edit_lock'].cast<String>();
  //  lEditLast = json['_edit_last'].cast<String>();
    //pmsContentRestrictCustomRedirectUrl =
     //   json['pms-content-restrict-custom-redirect-url'].cast<String>();
   // pmsContentRestrictCustomNonMemberRedirectUrl =
     //   json['pms-content-restrict-custom-non-member-redirect-url']
     //       .cast<String>();
 //   pmsContentRestrictMessageLoggedOut =
        json['pms-content-restrict-message-logged_out'].cast<String>();
   // pmsContentRestrictMessageNonMembers =
    //    json['pms-content-restrict-message-non_members'].cast<String>();
    subHeader = json['sub_header']!=null?json['sub_header'].cast<String>():null;
   // lSubHeader = json['_sub_header'].cast<String>();
    author = json['author']!=null?json['author'].cast<String>():null;
   // lAuthor = json['_author'].cast<String>();
    narrator = json['narrator']!=null?json['narrator'].cast<String>():null;
   // lNarrator = json['_narrator'].cast<String>();
    publication = json['publication']!=null?json['publication'].cast<String>():null;
    //lPublication = json['_publication'].cast<String>();
    publicationDate = json['publication_date']!=null?json['publication_date'].cast<String>():null;
  //  lPublicationDate = json['_publication_date'].cast<String>();
    url = json['url'].cast<String>();
   // lUrl = json['_url'].cast<String>();
    audioFile = json['audio_file']!=null?json['audio_file'].cast<String>():null;
   // lAudioFile = json['_audio_file'].cast<String>();
    audioFileDuration = json['audio_file_duration']!=null?json['audio_file_duration'].cast<String>():null;
    //lAudioFileDuration = json['_audio_file_duration'].cast<String>();
    postDescription = json['post_description']!=null?json['post_description'].cast<String>():null;
   // lPostDescription = json['_post_description'].cast<String>();
    coverImageUrl = json['cover_image_url']!=null?json['cover_image_url'].cast<String>():null;
   // lCoverImageUrl = json['_cover_image_url'].cast<String>();
    postReadedBy = json['post_readed_by']!=null?json['post_readed_by'].cast<String>():null;
  //  lEncloseme = json['_encloseme'].cast<String>();
   // pmsContentRestrictType = json['pms-content-restrict-type'].cast<String>();
    myHopper = json['my_hopper']!=null?json['my_hopper'].cast<String>():null;
    myDownload = json['my_download']!=null?json['my_download'].cast<String>():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    ///data['_edit_lock'] = this.lEditLock;
    //data['_edit_last'] = this.lEditLast;
    //data['pms-content-restrict-custom-redirect-url'] =
     //   this.pmsContentRestrictCustomRedirectUrl;
   // data['pms-content-restrict-custom-non-member-redirect-url'] =
        //this.pmsContentRestrictCustomNonMemberRedirectUrl;
    //data['pms-content-restrict-message-logged_out'] =
     //   this.pmsContentRestrictMessageLoggedOut;
   // data['pms-content-restrict-message-non_members'] =
    //    this.pmsContentRestrictMessageNonMembers;
    data['sub_header'] = this.subHeader;
   // data['_sub_header'] = this.lSubHeader;
    data['author'] = this.author;
   // data['_author'] = this.lAuthor;
    data['narrator'] = this.narrator;
  //  data['_narrator'] = this.lNarrator;
    data['publication'] = this.publication;
   // data['_publication'] = this.lPublication;
    data['publication_date'] = this.publicationDate;
   // data['_publication_date'] = this.lPublicationDate;
    data['url'] = this.url;
    //data['_url'] = this.lUrl;
    data['audio_file'] = this.audioFile;
   // data['_audio_file'] = this.lAudioFile;
    data['audio_file_duration'] = this.audioFileDuration;
   // data['_audio_file_duration'] = this.lAudioFileDuration;
    data['post_description'] = this.postDescription;
    //data['_post_description'] = this.lPostDescription;
    data['cover_image_url'] = this.coverImageUrl;
   // data['_cover_image_url'] = this.lCoverImageUrl;
    data['post_readed_by'] = this.postReadedBy;
   // data['_encloseme'] = this.lEncloseme;
   // data['pms-content-restrict-type'] = this.pmsContentRestrictType;
    data['my_hopper'] = this.myHopper;
    data['my_download'] = this.myDownload;
    return data;
  }
}

class Post {
  int iD;
  String postAuthor;
  String postDate;
  String postDateGmt;
  String postContent;
  String postTitle;
  String postExcerpt;
  String postStatus;
  String commentStatus;
  String pingStatus;
  String postPassword;
  String postName;
  String toPing;
  String pinged;
  String postModified;
  String postModifiedGmt;
  String postContentFiltered;
  int postParent;
  String guid;
  int menuOrder;
  String postType;
  String postMimeType;
  String commentCount;
  String filter;

  Post(
      {this.iD,
        this.postAuthor,
        this.postDate,
        this.postDateGmt,
        this.postContent,
        this.postTitle,
        this.postExcerpt,
        this.postStatus,
        this.commentStatus,
        this.pingStatus,
        this.postPassword,
        this.postName,
        this.toPing,
        this.pinged,
        this.postModified,
        this.postModifiedGmt,
        this.postContentFiltered,
        this.postParent,
        this.guid,
        this.menuOrder,
        this.postType,
        this.postMimeType,
        this.commentCount,
        this.filter});

  Post.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    postAuthor = json['post_author'];
    postDate = json['post_date'];
    postDateGmt = json['post_date_gmt'];
    postContent = json['post_content'];
    postTitle = json['post_title'];
    postExcerpt = json['post_excerpt'];
    postStatus = json['post_status'];
    commentStatus = json['comment_status'];
    pingStatus = json['ping_status'];
    postPassword = json['post_password'];
    postName = json['post_name'];
    toPing = json['to_ping'];
    pinged = json['pinged'];
    postModified = json['post_modified'];
    postModifiedGmt = json['post_modified_gmt'];
    postContentFiltered = json['post_content_filtered'];
    postParent = json['post_parent'];
    guid = json['guid'];
    menuOrder = json['menu_order'];
    postType = json['post_type'];
    postMimeType = json['post_mime_type'];
    commentCount = json['comment_count'];
    filter = json['filter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['post_author'] = this.postAuthor;
    data['post_date'] = this.postDate;
    data['post_date_gmt'] = this.postDateGmt;
    data['post_content'] = this.postContent;
    data['post_title'] = this.postTitle;
    data['post_excerpt'] = this.postExcerpt;
    data['post_status'] = this.postStatus;
    data['comment_status'] = this.commentStatus;
    data['ping_status'] = this.pingStatus;
    data['post_password'] = this.postPassword;
    data['post_name'] = this.postName;
    data['to_ping'] = this.toPing;
    data['pinged'] = this.pinged;
    data['post_modified'] = this.postModified;
    data['post_modified_gmt'] = this.postModifiedGmt;
    data['post_content_filtered'] = this.postContentFiltered;
    data['post_parent'] = this.postParent;
    data['guid'] = this.guid;
    data['menu_order'] = this.menuOrder;
    data['post_type'] = this.postType;
    data['post_mime_type'] = this.postMimeType;
    data['comment_count'] = this.commentCount;
    data['filter'] = this.filter;
    return data;
  }
}