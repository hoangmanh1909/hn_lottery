// ignore_for_file: prefer_collection_literals

class GetBalanceResponse {
  int? amount;
  String? mobileNumber;
  String? accountType;

  GetBalanceResponse({this.amount, this.mobileNumber, this.accountType});

  GetBalanceResponse.fromJson(Map<String, dynamic> json) {
    amount = json['Amount'];
    mobileNumber = json['MobileNumber'];
    accountType = json['AccountType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Amount'] = amount;
    data['MobileNumber'] = mobileNumber;
    data['AccountType'] = accountType;
    return data;
  }
}
