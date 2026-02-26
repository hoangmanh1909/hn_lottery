class TogetherTicketSearchRequest {
  String? code;
  String? status;
  int? productID;
  int? systematic;
  String? fromDate;
  String? toDate;
  int? groupID;
  int? type;
  TogetherTicketSearchRequest(
      {this.code,
      this.status,
      this.productID = 0,
      this.systematic = 0,
      this.fromDate,
      this.toDate,
      this.groupID = 0,
      this.type = 0});

  TogetherTicketSearchRequest.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    status = json['Status'];
    productID = json['ProductID'];
    systematic = json['Systematic'];
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
    groupID = json['GroupID'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Code'] = code;
    data['Status'] = status;
    data['ProductID'] = productID;
    data['Systematic'] = systematic;
    data['FromDate'] = fromDate;
    data['ToDate'] = toDate;
    data['GroupID'] = groupID;
    data['Type'] = type;
    return data;
  }
}
