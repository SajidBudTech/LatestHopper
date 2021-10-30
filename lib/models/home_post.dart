class HomePost{
  int id;
  String date;
  String dateGmt;
  Guid guid;
  String modified;
  String modifiedGmt;
  String slug;
  String status;
  String type;
  String link;
  Guid title;
  Content content;
  Content excerpt;
  String author;
  int featuredMedia;
  String commentStatus;
  String pingStatus;
  bool sticky;
  String template;
  String format;
  List<int> categories;
  String narrator;
  String publication;
  String publicationDate;
  String postDescription;
  String audioFileDuration;
  String audioFile;
  String coverImageUrl;
  String subHeader;
  String url;
  bool isAdded=false;
  String localFilePath;
  int userBy;

  HomePost(
      {this.id,
        this.date,
        this.dateGmt,
        this.guid,
        this.modified,
        this.modifiedGmt,
        this.slug,
        this.status,
        this.type,
        this.link,
        this.title,
        this.content,
        this.excerpt,
        this.author,
        this.featuredMedia,
        this.commentStatus,
        this.pingStatus,
        this.sticky,
        this.template,
        this.format,
        this.categories,
        this.narrator,
        this.publication,
        this.publicationDate,
        this.postDescription,
        this.audioFileDuration,
        this.audioFile,
        this.coverImageUrl,
        this.subHeader,
        this.url,
        this.isAdded,
        this.localFilePath,
        this.userBy});

  HomePost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    dateGmt = json['date_gmt'];
    guid = json['guid'] != null ? new Guid.fromJson(json['guid']) : null;
    modified = json['modified'];
    modifiedGmt = json['modified_gmt'];
    slug = json['slug'];
    status = json['status'];
    type = json['type'];
    link = json['link'];
    title = json['title'] != null ? new Guid.fromJson(json['title']) : null;
    content =
    json['content'] != null ? new Content.fromJson(json['content']) : null;
    excerpt =
    json['excerpt'] != null ? new Content.fromJson(json['excerpt']) : null;
    author = json['author'];
    featuredMedia = json['featured_media'];
    commentStatus = json['comment_status'];
    pingStatus = json['ping_status'];
    sticky = json['sticky'];
    template = json['template'];
    format = json['format'];
    categories = json['categories']!=null?json['categories'].cast<int>():null;
    narrator = json['narrator'];
    publication = json['publication'];
    publicationDate = json['publication_date'];
    postDescription = json['post_description'];
    audioFileDuration = json['audio_file_duration'];
    audioFile = json['audio_file'];
    coverImageUrl = json['cover_image_url'];
    subHeader = json['sub_header'];
    url = json['url'];
    localFilePath = json['localFilePath'];
    userBy = json['userBy'];

  }

  static Map<String, dynamic> toJson(HomePost homePost) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = homePost.id;
    data['date'] = homePost.date;
    data['date_gmt'] = homePost.dateGmt;
    if (homePost.guid != null) {
      data['guid'] = homePost.guid.toJson();
    }
    data['modified'] = homePost.modified;
    data['modified_gmt'] = homePost.modifiedGmt;
    data['slug'] = homePost.slug;
    data['status'] = homePost.status;
    data['type'] = homePost.type;
    data['link'] = homePost.link;
    if (homePost.title != null) {
      data['title'] = homePost.title.toJson();
    }
    if (homePost.content != null) {
      data['content'] = homePost.content.toJson();
    }
    if (homePost.excerpt != null) {
      data['excerpt'] = homePost.excerpt.toJson();
    }
    data['author'] = homePost.author;
    data['featured_media'] = homePost.featuredMedia;
    data['comment_status'] = homePost.commentStatus;
    data['ping_status'] = homePost.pingStatus;
    data['sticky'] = homePost.sticky;
    data['template'] = homePost.template;
    data['format'] = homePost.format;
    data['categories'] = homePost.categories;
    data['narrator'] = homePost.narrator;
    data['publication'] = homePost.publication;
    data['publication_date']= homePost.publicationDate;
    data['post_description']= homePost.postDescription;
    data['audio_file_duration']=homePost.audioFileDuration;
    data['audio_file']=homePost.audioFile;
    data['cover_image_url']=homePost.coverImageUrl;
    data['sub_header']= homePost.subHeader;
    data['url'] = homePost.url;
    data['localFilePath'] = homePost.localFilePath;
    data['userBy'] = homePost.userBy;

    return data;
  }

}

class Guid {
  String rendered;

  Guid({this.rendered});

  Guid.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rendered'] = this.rendered;
    return data;
  }
}

class Content {
  String rendered;
  bool protected;

  Content({this.rendered, this.protected});

  Content.fromJson(Map<String, dynamic> json) {
    rendered = json['rendered'];
    protected = json['protected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rendered'] = this.rendered;
    data['protected'] = this.protected;
    return data;
  }
}