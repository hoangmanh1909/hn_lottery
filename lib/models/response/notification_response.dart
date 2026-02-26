class NotificationSearchResponse {
  int? iD;
  String? mobileNumber;
  String? cate;
  String? title;
  String? content;
  String? createdDate;
  int? navigation;
  String? addInfo;
  String? isRead;
  String? isPush;
  String? pushDate;
  String? isType;

  NotificationSearchResponse(
      {this.iD,
      this.mobileNumber,
      this.cate,
      this.title,
      this.content,
      this.createdDate,
      this.navigation,
      this.addInfo,
      this.isRead,
      this.isPush,
      this.pushDate,
      this.isType});

  NotificationSearchResponse.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    mobileNumber = json['MobileNumber'];
    cate = json['Cate'];
    title = json['Title'];
    content = json['Content'];
    createdDate = json['CreatedDate'];
    navigation = json['Navigation'];
    addInfo = json['AddInfo'];
    isRead = json['IsRead'];
    isPush = json['IsPush'];
    pushDate = json['PushDate'];
    isType = json['IsType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['MobileNumber'] = mobileNumber;
    data['Cate'] = cate;
    data['Title'] = title;
    data['Content'] = content;
    data['CreatedDate'] = createdDate;
    data['Navigation'] = navigation;
    data['AddInfo'] = addInfo;
    data['IsRead'] = isRead;
    data['IsPush'] = isPush;
    data['PushDate'] = pushDate;
    data['IsType'] = isType;
    return data;
  }
}
