import 'order_item_add_request.dart';

class OrderAddNewRequest {
  String? channel;
  int? quantity;
  int? price;
  int? fee;
  int? amount;
  String? mobileNumber;
  String? fullName;
  String? pIDNumber;
  String? emailAddress;
  String? desc;
  int? productID;
  int? productTypeID;
  int? bag;
  String? bagBalls;
  int? terminalID;
  String? codePayment;
  int? productDT;
  int? radioID;
  List<OrderAddItemRequest>? items;

  OrderAddNewRequest(
      {this.channel,
      this.quantity,
      this.price,
      this.fee,
      this.amount,
      this.mobileNumber,
      this.fullName,
      this.pIDNumber,
      this.emailAddress,
      this.desc,
      this.productID,
      this.productTypeID,
      this.bag = 0,
      this.bagBalls,
      this.terminalID = 0,
      this.codePayment,
      this.productDT = 0,
      this.items,
      this.radioID = 0});

  OrderAddNewRequest.fromJson(Map<String, dynamic> json) {
    channel = json['Channel'];
    quantity = json['Quantity'];
    price = json['Price'];
    fee = json['Fee'];
    amount = json['Amount'];
    mobileNumber = json['MobileNumber'];
    fullName = json['FullName'];
    pIDNumber = json['PIDNumber'];
    emailAddress = json['EmailAddress'];
    desc = json['Desc'];
    productID = json['ProductID'];
    productTypeID = json['ProductTypeID'];
    bag = json['Bag'];
    bagBalls = json['BagBalls'];
    terminalID = json['TerminalID'];
    codePayment = json['CodePayment'];
    productDT = json['ProductDT'];
    radioID = json['RadioID'];
    if (json['Items'] != null) {
      items = <OrderAddItemRequest>[];
      json['Items'].forEach((v) {
        items!.add(OrderAddItemRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Channel'] = channel;
    data['Quantity'] = quantity;
    data['Price'] = price;
    data['Fee'] = fee;
    data['Amount'] = amount;
    data['MobileNumber'] = mobileNumber;
    data['FullName'] = fullName;
    data['PIDNumber'] = pIDNumber;
    data['EmailAddress'] = emailAddress;
    data['Desc'] = desc;
    data['ProductID'] = productID;
    data['ProductTypeID'] = productTypeID;
    data['Bag'] = bag;
    data['BagBalls'] = bagBalls;
    data['TerminalID'] = terminalID;
    data['CodePayment'] = codePayment;
    data['ProductDT'] = productDT;
    data['RadioID'] = radioID;
    if (items != null) {
      data['Items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
