class TogetherTicketDetail {
  int? iD;
  int? tTID;
  int? productID;
  int? systematic;
  String? drawCode;
  String? drawDate;
  String? numberOfLines;
  String? imgBefore;
  String? imgAfter;
  int? price;
  String? status;
  String? isResult;

  TogetherTicketDetail(
      {this.iD,
      this.tTID,
      this.productID,
      this.systematic,
      this.drawCode,
      this.drawDate,
      this.numberOfLines,
      this.imgBefore,
      this.imgAfter,
      this.price,
      this.status,
      this.isResult});

  TogetherTicketDetail.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    tTID = json['TTID'];
    productID = json['ProductID'];
    systematic = json['Systematic'];
    drawCode = json['DrawCode'];
    drawDate = json['DrawDate'];
    numberOfLines = json['NumberOfLines'];
    imgBefore = json['ImgBefore'];
    imgAfter = json['ImgAfter'];
    price = json['Price'];
    status = json['Status'];
    isResult = json['IsResult'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['TTID'] = tTID;
    data['ProductID'] = productID;
    data['Systematic'] = systematic;
    data['DrawCode'] = drawCode;
    data['DrawDate'] = drawDate;
    data['NumberOfLines'] = numberOfLines;
    data['ImgBefore'] = imgBefore;
    data['ImgAfter'] = imgAfter;
    data['Price'] = price;
    data['Status'] = status;
    data['IsResult'] = isResult;
    return data;
  }
}
