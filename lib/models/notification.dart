class NotificationData {
  String notificationTitle;
  String notificationArticle;
  String notificationImage;
  String notificationSentOn;

  NotificationData(
      {this.notificationTitle,
        this.notificationArticle,
        this.notificationImage,
        this.notificationSentOn});

  NotificationData.fromJson(Map<String, dynamic> json) {
    notificationTitle = json['notification_title'];
    notificationArticle = json['notification_article'];
    notificationImage = json['notification_image'];
    notificationSentOn = json['notification_sent_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_title'] = this.notificationTitle;
    data['notification_article'] = this.notificationArticle;
    data['notification_image'] = this.notificationImage;
    data['notification_sent_on'] = this.notificationSentOn;
    return data;
  }
}