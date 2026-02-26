class BankResponse {
  int? iD;
  String? code;
  String? shortName;
  String? name;

  BankResponse({this.iD, this.code, this.shortName, this.name});

  BankResponse.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    shortName = json['ShortName'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Code'] = code;
    data['ShortName'] = shortName;
    data['Name'] = name;
    return data;
  }
}
