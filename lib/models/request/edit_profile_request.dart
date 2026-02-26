class EditProfileRequest {
  int? iD;
  String? name;
  String? pIDNumber;
  String? emailAddress;
  int? provinceID;
  int? terminalID;

  EditProfileRequest(
      {this.iD,
      this.name,
      this.pIDNumber,
      this.emailAddress,
      this.provinceID = 0,
      this.terminalID = 0});

  EditProfileRequest.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    pIDNumber = json['PIDNumber'];
    emailAddress = json['EmailAddress'];
    provinceID = json['ProvinceID'];
    terminalID = json['TerminalID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Name'] = name;
    data['PIDNumber'] = pIDNumber;
    data['EmailAddress'] = emailAddress;
    data['ProvinceID'] = provinceID;
    data['TerminalID'] = terminalID;
    return data;
  }
}
