// ignore_for_file: prefer_collection_literals

class PlayerProfile {
  String? mobileNumber;
  int? iD;
  String? name;
  String? pIDNumber;
  String? emailAddress;
  int? provinceID;
  String? provinceName;
  String? isRef;
  int? terminalID;
  String? terminalName;

  PlayerProfile(
      {this.mobileNumber,
      this.iD,
      this.name,
      this.pIDNumber,
      this.emailAddress,
      this.provinceID,
      this.provinceName,
      this.isRef,
      this.terminalID,
      this.terminalName});

  PlayerProfile.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['MobileNumber'];
    iD = json['ID'];
    name = json['Name'];
    pIDNumber = json['PIDNumber'];
    emailAddress = json['EmailAddress'];
    provinceID = json['ProvinceID'];
    provinceName = json['ProvinceName'];
    isRef = json['IsRef'];
    terminalID = json['TerminalID'];
    terminalName = json['TerminalName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['MobileNumber'] = mobileNumber;
    data['ID'] = iD;
    data['Name'] = name;
    data['PIDNumber'] = pIDNumber;
    data['EmailAddress'] = emailAddress;
    data['ProvinceID'] = provinceID;
    data['ProvinceName'] = provinceName;
    data['IsRef'] = isRef;
    data['TerminalID'] = terminalID;
    data['TerminalName'] = terminalName;
    return data;
  }
}
