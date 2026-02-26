class TogetherTicketItemSearchResponse {
  String? tTDrawCode;
  int? tTSystematic;
  int? tTQuantity;
  double? tTPercent;
  String? tTStatus;
  String? tTCode;
  String? createdDate;
  String? channel;
  int? prize;
  int? tax;
  int? payout;
  String? tTDrawDate;
  String? status;
  double? percent;
  int? amount;
  int? fee;
  int? price;
  int? productID;
  String? retRefNumber;
  String? pidNumber;
  String? name;
  String? mobileNumber;
  int? togetherTicketID;
  int? iD;
  String? isResult;
  int? tTPrice;
  int? groupID;
  int? type;

  TogetherTicketItemSearchResponse(
      {this.tTDrawCode,
      this.tTSystematic,
      this.tTQuantity,
      this.tTPercent,
      this.tTStatus,
      this.tTCode,
      this.createdDate,
      this.channel,
      this.prize,
      this.tax,
      this.payout,
      this.tTDrawDate,
      this.status,
      this.percent,
      this.amount,
      this.fee,
      this.price,
      this.productID,
      this.retRefNumber,
      this.pidNumber,
      this.name,
      this.mobileNumber,
      this.togetherTicketID,
      this.iD,
      this.isResult,
      this.tTPrice,
      this.groupID,
      this.type});

  TogetherTicketItemSearchResponse.fromJson(Map<String, dynamic> json) {
    tTDrawCode = json['TTDrawCode'];
    tTSystematic = json['TTSystematic'];
    tTQuantity = json['TTQuantity'];
    tTPercent = json['TTPercent'];
    tTStatus = json['TTStatus'];
    tTCode = json['TTCode'];
    createdDate = json['CreatedDate'];
    channel = json['Channel'];
    prize = json['Prize'];
    tax = json['Tax'];
    payout = json['Payout'];
    tTDrawDate = json['TTDrawDate'];
    status = json['Status'];
    percent = json['Percent'];
    amount = json['Amount'];
    fee = json['Fee'];
    price = json['Price'];
    productID = json['ProductID'];
    retRefNumber = json['RetRefNumber'];
    pidNumber = json['PidNumber'];
    name = json['Name'];
    mobileNumber = json['MobileNumber'];
    togetherTicketID = json['TogetherTicketID'];
    iD = json['ID'];
    isResult = json['IsResult'];
    tTPrice = json['TTPrice'];
    groupID = json['GroupID'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TTDrawCode'] = tTDrawCode;
    data['TTSystematic'] = tTSystematic;
    data['TTQuantity'] = tTQuantity;
    data['TTPercent'] = tTPercent;
    data['TTStatus'] = tTStatus;
    data['TTCode'] = tTCode;
    data['CreatedDate'] = createdDate;
    data['Channel'] = channel;
    data['Prize'] = prize;
    data['Tax'] = tax;
    data['Payout'] = payout;
    data['TTDrawDate'] = tTDrawDate;
    data['Status'] = status;
    data['Percent'] = percent;
    data['Amount'] = amount;
    data['Fee'] = fee;
    data['Price'] = price;
    data['ProductID'] = productID;
    data['RetRefNumber'] = retRefNumber;
    data['PidNumber'] = pidNumber;
    data['Name'] = name;
    data['MobileNumber'] = mobileNumber;
    data['TogetherTicketID'] = togetherTicketID;
    data['ID'] = iD;
    data['IsResult'] = isResult;
    data['TTPrice'] = tTPrice;
    data['GroupID'] = groupID;
    data['Type'] = type;
    return data;
  }
}
