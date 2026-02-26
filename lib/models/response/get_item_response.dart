class GetItemResponse {
  int? iD;
  String? orderCode;
  int? productID;
  int? productTypeID;
  int? bag;
  String? drawCode;
  String? drawDate;
  String? lineA;
  String? lineB;
  String? lineC;
  String? lineD;
  String? lineE;
  String? lineF;
  int? systemA;
  int? systemB;
  int? systemC;
  int? systemD;
  int? systemE;
  int? systemF;
  int? priceA;
  int? priceB;
  int? priceC;
  int? priceD;
  int? priceE;
  int? priceF;

  // Bổ sung các thuộc tính Symbol
  String? symbolA;
  String? symbolB;
  String? symbolC;
  String? symbolD;
  String? symbolE;
  String? symbolF;

  int? price;
  int? resultID;
  String? isResult;
  String? isWin;
  String? status;
  String? imgBefore;
  String? imgAfter;
  String? itemResult;
  String? result;

  GetItemResponse(
      {this.iD,
      this.orderCode,
      this.productID,
      this.productTypeID,
      this.bag,
      this.drawCode,
      this.drawDate,
      this.lineA,
      this.lineB,
      this.lineC,
      this.lineD,
      this.lineE,
      this.lineF,
      this.systemA,
      this.systemB,
      this.systemC,
      this.systemD,
      this.systemE,
      this.systemF,
      this.priceA,
      this.priceB,
      this.priceC,
      this.priceD,
      this.priceE,
      this.priceF,
      // Bổ sung trong constructor
      this.symbolA,
      this.symbolB,
      this.symbolC,
      this.symbolD,
      this.symbolE,
      this.symbolF,
      this.price,
      this.resultID,
      this.isResult,
      this.isWin,
      this.status,
      this.imgBefore,
      this.imgAfter,
      this.itemResult,
      this.result});

  GetItemResponse.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    orderCode = json['OrderCode'];
    productID = json['ProductID'];
    productTypeID = json['ProductTypeID'];
    bag = json['Bag'];
    drawCode = json['DrawCode'];
    drawDate = json['DrawDate'];
    lineA = json['LineA'];
    lineB = json['LineB'];
    lineC = json['LineC'];
    lineD = json['LineD'];
    lineE = json['LineE'];
    lineF = json['LineF'];
    systemA = json['SystemA'];
    systemB = json['SystemB'];
    systemC = json['SystemC'];
    systemD = json['SystemD'];
    systemE = json['SystemE'];
    systemF = json['SystemF'];
    priceA = json['PriceA'];
    priceB = json['PriceB'];
    priceC = json['PriceC'];
    priceD = json['PriceD'];
    priceE = json['PriceE'];
    priceF = json['PriceF'];

    // Bổ sung trong fromJson
    symbolA = json['SymbolA'];
    symbolB = json['SymbolB'];
    symbolC = json['SymbolC'];
    symbolD = json['SymbolD'];
    symbolE = json['SymbolE'];
    symbolF = json['SymbolF'];

    price = json['Price'];
    resultID = json['ResultID'];
    isResult = json['IsResult'];
    isWin = json['IsWin'];
    status = json['Status'];
    imgBefore = json['ImgBefore'];
    imgAfter = json['ImgAfter'];
    itemResult = json['ItemResult'];
    result = json['Result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['OrderCode'] = orderCode;
    data['ProductID'] = productID;
    data['ProductTypeID'] = productTypeID;
    data['Bag'] = bag;
    data['DrawCode'] = drawCode;
    data['DrawDate'] = drawDate;
    data['LineA'] = lineA;
    data['LineB'] = lineB;
    data['LineC'] = lineC;
    data['LineD'] = lineD;
    data['LineE'] = lineE;
    data['LineF'] = lineF;
    data['SystemA'] = systemA;
    data['SystemB'] = systemB;
    data['SystemC'] = systemC;
    data['SystemD'] = systemD;
    data['SystemE'] = systemE;
    data['SystemF'] = systemF;
    data['PriceA'] = priceA;
    data['PriceB'] = priceB;
    data['PriceC'] = priceC;
    data['PriceD'] = priceD;
    data['PriceE'] = priceE;
    data['PriceF'] = priceF;

    // Bổ sung trong toJson
    data['SymbolA'] = symbolA;
    data['SymbolB'] = symbolB;
    data['SymbolC'] = symbolC;
    data['SymbolD'] = symbolD;
    data['SymbolE'] = symbolE;
    data['SymbolF'] = symbolF;

    data['Price'] = price;
    data['ResultID'] = resultID;
    data['IsResult'] = isResult;
    data['IsWin'] = isWin;
    data['Status'] = status;
    data['ImgBefore'] = imgBefore;
    data['ImgAfter'] = imgAfter;
    data['ItemResult'] = itemResult;
    data['Result'] = result;
    return data;
  }
}
