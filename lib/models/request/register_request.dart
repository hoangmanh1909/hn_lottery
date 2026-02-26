class RegisterRequest {
  String? mobileNumber;
  String? password;
  String? oTP;
  String? sourceNumber;

  RegisterRequest(
      {this.mobileNumber, this.password, this.oTP, this.sourceNumber});

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['MobileNumber'];
    password = json['Password'];
    oTP = json['OTP'];
    sourceNumber = json['SourceNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MobileNumber'] = mobileNumber;
    data['Password'] = password;
    data['OTP'] = oTP;
    data['SourceNumber'] = sourceNumber;
    return data;
  }
}
