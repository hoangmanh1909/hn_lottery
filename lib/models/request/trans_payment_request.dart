class TransPaymentRequest {
  int? empID;
  int? fee;
  String? mobileNumber;
  String? orderCode;
  String? transDes;

  TransPaymentRequest(
      {this.empID = 0,
      this.fee = 0,
      this.mobileNumber,
      this.orderCode,
      this.transDes});

  TransPaymentRequest.fromJson(Map<String, dynamic> json) {
    empID = json['EmpID'];
    fee = json['Fee'];
    mobileNumber = json['MobileNumber'];
    orderCode = json['OrderCode'];
    transDes = json['TransDes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['EmpID'] = empID;
    data['Fee'] = fee;
    data['MobileNumber'] = mobileNumber;
    data['OrderCode'] = orderCode;
    data['TransDes'] = transDes;
    return data;
  }
}
