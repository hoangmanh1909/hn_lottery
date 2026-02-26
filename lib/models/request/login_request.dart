// ignore_for_file: prefer_collection_literals

class LoginRequest {
  String? mobileNumber;
  String? password;
  String? iPAddress;
  String? oS;
  String? modelName;
  String? modelVerson;
  String? fCMToken;
  String? channel;
  String? version;

  LoginRequest(
      {this.mobileNumber,
      this.password,
      this.iPAddress,
      this.oS,
      this.modelName,
      this.modelVerson,
      this.fCMToken,
      this.channel,
      this.version});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['MobileNumber'];
    password = json['Password'];
    iPAddress = json['IPAddress'];
    oS = json['OS'];
    modelName = json['ModelName'];
    modelVerson = json['ModelVerson'];
    fCMToken = json['FCMToken'];
    channel = json['Channel'];
    version = json['Version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['MobileNumber'] = mobileNumber;
    data['Password'] = password;
    data['IPAddress'] = iPAddress;
    data['OS'] = oS;
    data['ModelName'] = modelName;
    data['ModelVerson'] = modelVerson;
    data['FCMToken'] = fCMToken;
    data['Channel'] = channel;
    data['Version'] = version;
    return data;
  }
}
