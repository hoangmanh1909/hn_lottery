class OrderListResponse {
  int? iD;
  String? code;
  String? mobileNumber;
  String? name;
  int? price;
  int? fee;
  int? amount;
  int? quantity;
  int? quantityPrint;
  int? quantityCancel;
  String? status;
  String? createdDate;
  int? type;
  String? isCancel;

  OrderListResponse(
      {this.iD,
      this.code,
      this.mobileNumber,
      this.name,
      this.price,
      this.fee,
      this.amount,
      this.quantity,
      this.quantityPrint,
      this.quantityCancel,
      this.status,
      this.createdDate,
      this.type,
      this.isCancel});

  OrderListResponse.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    mobileNumber = json['MobileNumber'];
    name = json['Name'];
    price = json['Price'];
    fee = json['Fee'];
    amount = json['Amount'];
    quantity = json['Quantity'];
    quantityPrint = json['QuantityPrint'];
    quantityCancel = json['QuantityCancel'];
    status = json['Status'];
    createdDate = json['CreatedDate'];
    type = json['Type'];
    isCancel = json['IsCancel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Code'] = code;
    data['MobileNumber'] = mobileNumber;
    data['Name'] = name;
    data['Price'] = price;
    data['Fee'] = fee;
    data['Amount'] = amount;
    data['Quantity'] = quantity;
    data['QuantityPrint'] = quantityPrint;
    data['QuantityCancel'] = quantityCancel;
    data['Status'] = status;
    data['CreatedDate'] = createdDate;
    data['Type'] = type;
    data['IsCancel'] = isCancel;
    return data;
  }
}
