class TerminalViewModel {
  int? iD;
  String? code;
  String? name;
  int? provinceID;
  int? districtID;
  int? wardID;
  String? street;
  String? address;
  String? isLock;
  String? isKeno;
  String? isMerchant;
  String? mobileNumber;

  TerminalViewModel(
      {this.iD,
      this.code,
      this.name,
      this.provinceID,
      this.districtID,
      this.wardID,
      this.street,
      this.address,
      this.isLock,
      this.isKeno,
      this.isMerchant,
      this.mobileNumber});

  TerminalViewModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    name = json['Name'];
    provinceID = json['ProvinceID'];
    districtID = json['DistrictID'];
    wardID = json['WardID'];
    street = json['Street'];
    address = json['Address'];
    isLock = json['IsLock'];
    isKeno = json['IsKeno'];
    isMerchant = json['IsMerchant'];
    mobileNumber = json['MobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Code'] = code;
    data['Name'] = name;
    data['ProvinceID'] = provinceID;
    data['DistrictID'] = districtID;
    data['WardID'] = wardID;
    data['Street'] = street;
    data['Address'] = address;
    data['IsLock'] = isLock;
    data['IsKeno'] = isKeno;
    data['IsMerchant'] = isMerchant;
    data['MobileNumber'] = mobileNumber;
    return data;
  }
}
