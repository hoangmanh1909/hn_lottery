class ParamsResponse {
  int? iD;
  String? groupCode;
  String? parameter;
  String? value;

  ParamsResponse({this.iD, this.groupCode, this.parameter, this.value});

  ParamsResponse.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    groupCode = json['GroupCode'];
    parameter = json['Parameter'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['GroupCode'] = groupCode;
    data['Parameter'] = parameter;
    data['Value'] = value;
    return data;
  }
}
