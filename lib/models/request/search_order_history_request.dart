class SearchOrderHistoryRequest {
  String? mobileNumber;
  String? status;
  String? isWin;
  String? isResult;
  String? fromDate;
  String? toDate;
  int? productType;
  String? codePayment;

  SearchOrderHistoryRequest(
      {this.mobileNumber,
      this.status,
      this.isWin,
      this.isResult,
      this.fromDate,
      this.toDate,
      this.productType,
      this.codePayment});

  SearchOrderHistoryRequest.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['MobileNumber'];
    status = json['Status'];
    isWin = json['IsWin'];
    isResult = json['IsResult'];
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
    productType = json['ProductType'];
    codePayment = json['CodePayment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MobileNumber'] = mobileNumber;
    data['Status'] = status;
    data['IsWin'] = isWin;
    data['IsResult'] = isResult;
    data['FromDate'] = fromDate;
    data['ToDate'] = toDate;
    data['ProductType'] = productType;
    data['CodePayment'] = codePayment;
    return data;
  }
}
