class DictionaryResponse {
  int? iD;
  String? code;
  String? name;

  DictionaryResponse({this.iD, this.code, this.name});

  DictionaryResponse.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Code'] = code;
    data['Name'] = name;
    return data;
  }
}
