class TogetherTicketPaymentRequest {
  String? mobileNumber;
  int? fee;
  String? transDes;
  String? retRefNumber;

  TogetherTicketPaymentRequest(
      {this.mobileNumber, this.fee, this.transDes, this.retRefNumber});

  TogetherTicketPaymentRequest.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['MobileNumber'];
    fee = json['Fee'];
    transDes = json['TransDes'];
    retRefNumber = json['RetRefNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MobileNumber'] = mobileNumber;
    data['Fee'] = fee;
    data['TransDes'] = transDes;
    data['RetRefNumber'] = retRefNumber;
    return data;
  }
}
