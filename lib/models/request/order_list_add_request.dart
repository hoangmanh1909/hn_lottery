import 'order_add_request.dart';

class OrderListAddNewRequest {
  int? quantity;
  int? price;
  int? fee;
  int? amount;
  String? mobileNumber;
  String? fullName;
  int? type;
  String? isCancel;
  List<OrderAddNewRequest>? orders;

  OrderListAddNewRequest(
      {this.quantity,
      this.price,
      this.fee,
      this.amount,
      this.mobileNumber,
      this.fullName,
      this.type,
      this.isCancel,
      this.orders});

  OrderListAddNewRequest.fromJson(Map<String, dynamic> json) {
    quantity = json['Quantity'];
    price = json['Price'];
    fee = json['Fee'];
    amount = json['Amount'];
    mobileNumber = json['MobileNumber'];
    fullName = json['FullName'];
    type = json['Type'];
    isCancel = json['IsCancel'];
    if (json['Orders'] != null) {
      orders = <OrderAddNewRequest>[];
      json['Orders'].forEach((v) {
        orders!.add(OrderAddNewRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Quantity'] = quantity;
    data['Price'] = price;
    data['Fee'] = fee;
    data['Amount'] = amount;
    data['MobileNumber'] = mobileNumber;
    data['FullName'] = fullName;
    data['Type'] = type;
    data['IsCancel'] = isCancel;
    if (orders != null) {
      data['Orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
