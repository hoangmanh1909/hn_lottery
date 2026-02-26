class GetOrderResponse {
  int? iD;
  String? channel;
  String? code;
  int? quantity;
  int? price;
  int? fee;
  int? amount;
  String? retRefNumber;
  String? mobileNumber;
  String? name;
  String? pIDNumber;
  String? email;
  String? status;
  String? des;
  String? createdDate;
  String? paidDate;
  String? isResult;
  String? isWin;
  String? printStatus;
  String? printDate;
  int? productID;
  String? productName;
  int? productTypeID;
  String? productTypeName;
  int? bag;
  String? bagBalls;
  String? terminalCode;
  String? terminalName;
  String? addInfo01;
  String? radioName;
  String? radioLogo;

  GetOrderResponse(
      {this.iD,
      this.channel,
      this.code,
      this.quantity,
      this.price,
      this.fee,
      this.amount,
      this.retRefNumber,
      this.mobileNumber,
      this.name,
      this.pIDNumber,
      this.email,
      this.status,
      this.des,
      this.createdDate,
      this.paidDate,
      this.isResult,
      this.isWin,
      this.printStatus,
      this.printDate,
      this.productID,
      this.productName,
      this.productTypeID,
      this.productTypeName,
      this.bag,
      this.bagBalls,
      this.terminalCode,
      this.terminalName});

  GetOrderResponse.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    channel = json['Channel'];
    code = json['Code'];
    quantity = json['Quantity'];
    price = json['Price'];
    fee = json['Fee'];
    amount = json['Amount'];
    retRefNumber = json['RetRefNumber'];
    mobileNumber = json['MobileNumber'];
    name = json['Name'];
    pIDNumber = json['PIDNumber'];
    email = json['Email'];
    status = json['Status'];
    des = json['Des'];
    createdDate = json['CreatedDate'];
    paidDate = json['PaidDate'];
    isResult = json['IsResult'];
    isWin = json['IsWin'];
    printStatus = json['PrintStatus'];
    printDate = json['PrintDate'];
    productID = json['ProductID'];
    productName = json['ProductName'];
    productTypeID = json['ProductTypeID'];
    productTypeName = json['ProductTypeName'];
    bag = json['Bag'];
    bagBalls = json['BagBalls'];
    terminalCode = json['TerminalCode'];
    terminalName = json['TerminalName'];
    addInfo01 = json['AddInfo01'];
    radioName = json['RadioName'];
    radioLogo = json['RadioLogo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Channel'] = channel;
    data['Code'] = code;
    data['Quantity'] = quantity;
    data['Price'] = price;
    data['Fee'] = fee;
    data['Amount'] = amount;
    data['RetRefNumber'] = retRefNumber;
    data['MobileNumber'] = mobileNumber;
    data['Name'] = name;
    data['PIDNumber'] = pIDNumber;
    data['Email'] = email;
    data['Status'] = status;
    data['Des'] = des;
    data['CreatedDate'] = createdDate;
    data['PaidDate'] = paidDate;
    data['IsResult'] = isResult;
    data['IsWin'] = isWin;
    data['PrintStatus'] = printStatus;
    data['PrintDate'] = printDate;
    data['ProductID'] = productID;
    data['ProductName'] = productName;
    data['ProductTypeID'] = productTypeID;
    data['ProductTypeName'] = productTypeName;
    data['Bag'] = bag;
    data['BagBalls'] = bagBalls;
    data['TerminalCode'] = terminalCode;
    data['TerminalName'] = terminalName;
    data['AddInfo01'] = addInfo01;
    data['RadioName'] = radioName;
    data['RadioLogo'] = radioLogo;
    return data;
  }
}
