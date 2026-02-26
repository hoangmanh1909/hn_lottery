class RewardExchangeSearchRequest {
  String? mobileNumber;
  String? fromDate;
  String? toDate;
  String? status;
  String? category;

  RewardExchangeSearchRequest(
      {this.mobileNumber,
      this.fromDate,
      this.toDate,
      this.status,
      this.category});

  RewardExchangeSearchRequest.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['MobileNumber'];
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
    status = json['Status'];
    category = json['Category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MobileNumber'] = mobileNumber;
    data['FromDate'] = fromDate;
    data['ToDate'] = toDate;
    data['Status'] = status;
    data['Category'] = category;
    return data;
  }
}
