class BaseRequest {
  int? iD;
  String? code;

  BaseRequest({this.iD = 0, this.code});

  BaseRequest.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Code'] = code;
    return data;
  }
}
