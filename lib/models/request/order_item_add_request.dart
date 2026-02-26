class OrderAddItemRequest {
  int? priceC;
  int? priceD;
  int? priceE;
  int? priceF;
  int? price;
  String? symbolA;
  String? symbolB;
  String? symbolC;
  String? symbolD;
  String? symbolE;
  String? symbolF;
  int? drawlerA;
  int? drawlerB;
  int? drawlerC;
  int? drawlerD;
  int? priceB;
  int? drawlerE;
  int? priceA;
  int? systemE;
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
  int? systemF;
  int? drawlerF;

  OrderAddItemRequest(
      {this.priceC = 0,
      this.priceD = 0,
      this.priceE = 0,
      this.priceF = 0,
      this.price = 0,
      this.symbolA,
      this.symbolB,
      this.symbolC,
      this.symbolD,
      this.symbolE,
      this.symbolF,
      this.drawlerA = 0,
      this.drawlerB = 0,
      this.drawlerC = 0,
      this.drawlerD = 0,
      this.priceB = 0,
      this.drawlerE = 0,
      this.priceA = 0,
      this.systemE = 0,
      this.productID = 0,
      this.productTypeID = 0,
      this.bag = 0,
      this.drawCode,
      this.drawDate,
      this.lineA,
      this.lineB,
      this.lineC,
      this.lineD,
      this.lineE,
      this.lineF,
      this.systemA = 0,
      this.systemB = 0,
      this.systemC = 0,
      this.systemD = 0,
      this.systemF = 0,
      this.drawlerF = 0});

  OrderAddItemRequest.fromJson(Map<String, dynamic> json) {
    priceC = json['PriceC'];
    priceD = json['PriceD'];
    priceE = json['PriceE'];
    priceF = json['PriceF'];
    price = json['Price'];
    symbolA = json['SymbolA'];
    symbolB = json['SymbolB'];
    symbolC = json['SymbolC'];
    symbolD = json['SymbolD'];
    symbolE = json['SymbolE'];
    symbolF = json['SymbolF'];
    drawlerA = json['DrawlerA'];
    drawlerB = json['DrawlerB'];
    drawlerC = json['DrawlerC'];
    drawlerD = json['DrawlerD'];
    priceB = json['PriceB'];
    drawlerE = json['DrawlerE'];
    priceA = json['PriceA'];
    systemE = json['SystemE'];
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
    systemF = json['SystemF'];
    drawlerF = json['DrawlerF'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PriceC'] = priceC;
    data['PriceD'] = priceD;
    data['PriceE'] = priceE;
    data['PriceF'] = priceF;
    data['Price'] = price;
    data['SymbolA'] = symbolA;
    data['SymbolB'] = symbolB;
    data['SymbolC'] = symbolC;
    data['SymbolD'] = symbolD;
    data['SymbolE'] = symbolE;
    data['SymbolF'] = symbolF;
    data['DrawlerA'] = drawlerA;
    data['DrawlerB'] = drawlerB;
    data['DrawlerC'] = drawlerC;
    data['DrawlerD'] = drawlerD;
    data['PriceB'] = priceB;
    data['DrawlerE'] = drawlerE;
    data['PriceA'] = priceA;
    data['SystemE'] = systemE;
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
    data['SystemF'] = systemF;
    data['DrawlerF'] = drawlerF;
    return data;
  }
}
