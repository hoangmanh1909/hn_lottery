// ignore_for_file: prefer_collection_literals

class PlayerBaseRequest {
  String? mobileNumber;

  PlayerBaseRequest({this.mobileNumber});

  PlayerBaseRequest.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['MobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['MobileNumber'] = mobileNumber;
    return data;
  }
}
