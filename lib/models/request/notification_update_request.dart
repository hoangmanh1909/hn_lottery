class NotificationUpdateReadRequest {
  int? iD;
  String? mobileNumber;

  NotificationUpdateReadRequest({this.iD = 0, this.mobileNumber});

  NotificationUpdateReadRequest.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    mobileNumber = json['MobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['MobileNumber'] = mobileNumber;
    return data;
  }
}
