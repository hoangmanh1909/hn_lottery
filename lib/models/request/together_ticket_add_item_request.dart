class TogetherTicketItemAddRequest {
  int? togetherTicketID;
  String? mobileNumber;
  String? name;
  String? pidNumber;
  int? productID;
  int? price;
  int? fee;
  int? amount;
  int? percent;
  String? channel;
  int? groupID;

  TogetherTicketItemAddRequest(
      {this.togetherTicketID = 0,
      this.mobileNumber,
      this.name,
      this.pidNumber,
      this.productID = 0,
      this.price,
      this.fee = 0,
      this.amount,
      this.percent = 0,
      this.channel,
      this.groupID = 0});

  TogetherTicketItemAddRequest.fromJson(Map<String, dynamic> json) {
    togetherTicketID = json['TogetherTicketID'];
    mobileNumber = json['MobileNumber'];
    name = json['Name'];
    pidNumber = json['PidNumber'];
    productID = json['ProductID'];
    price = json['Price'];
    fee = json['Fee'];
    amount = json['Amount'];
    percent = json['Percent'];
    channel = json['Channel'];
    groupID = json['GroupID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TogetherTicketID'] = togetherTicketID;
    data['MobileNumber'] = mobileNumber;
    data['Name'] = name;
    data['PidNumber'] = pidNumber;
    data['ProductID'] = productID;
    data['Price'] = price;
    data['Fee'] = fee;
    data['Amount'] = amount;
    data['Percent'] = percent;
    data['Channel'] = channel;
    data['GroupID'] = groupID;
    return data;
  }
}
