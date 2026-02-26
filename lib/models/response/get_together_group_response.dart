class GetTogetherGroupResponse {
  String? code;
  String? name;
  String? email;
  String? mobile;
  String? address;
  int? bagYield;
  int? id;
  int? amount;

  GetTogetherGroupResponse(
      {this.code,
      this.name,
      this.email,
      this.mobile,
      this.address,
      this.bagYield,
      this.id,
      this.amount});

  GetTogetherGroupResponse.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    name = json['Name'];
    email = json['Email'];
    mobile = json['Mobile'];
    address = json['Address'];
    bagYield = json['BagYield'];
    id = json['ID'];
    amount = json['Amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Code'] = code;
    data['Name'] = name;
    data['Email'] = email;
    data['Mobile'] = mobile;
    data['Address'] = address;
    data['BagYield'] = bagYield;
    data['ID'] = id;
    data['Amount'] = amount;
    return data;
  }
}
