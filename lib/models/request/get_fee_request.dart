class GetFeeRequest {
  int? amount;
  int? productID;

  GetFeeRequest({this.amount, this.productID});

  GetFeeRequest.fromJson(Map<String, dynamic> json) {
    amount = json['Amount'];
    productID = json['ProductID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Amount'] = amount;
    data['ProductID'] = productID;
    return data;
  }
}
