class ChangePasswordRequest {
  String? mobileNumber;
  String? password;

  ChangePasswordRequest({this.mobileNumber, this.password});

  ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['MobileNumber'];
    password = json['Password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MobileNumber'] = mobileNumber;
    data['Password'] = password;
    return data;
  }
}
