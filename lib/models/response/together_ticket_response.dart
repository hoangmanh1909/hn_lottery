class TogetherTicketSearchResponse {
  int? iD;
  String? code;
  int? createdID;
  int? productID;
  int? systematic;
  String? drawCode;
  String? drawDate;
  String? numberOfLines;
  String? imgBefore;
  String? imgAfter;
  int? price;
  int? fee;
  int? amount;
  String? status;
  int? quantity;
  double? percent;
  String? isResult;
  int? payout;
  int? tax;
  int? prize;
  String? createdDate;
  int? cancelledBy;
  String? cancelledDate;
  String? result;

  TogetherTicketSearchResponse(
      {this.iD,
      this.code,
      this.createdID,
      this.productID,
      this.systematic,
      this.drawCode,
      this.drawDate,
      this.numberOfLines,
      this.imgBefore,
      this.imgAfter,
      this.price,
      this.fee,
      this.amount,
      this.status,
      this.quantity,
      this.percent,
      this.isResult,
      this.payout,
      this.tax,
      this.prize,
      this.createdDate,
      this.cancelledBy,
      this.cancelledDate,
      this.result});

  TogetherTicketSearchResponse.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    createdID = json['CreatedID'];
    productID = json['ProductID'];
    systematic = json['Systematic'];
    drawCode = json['DrawCode'];
    drawDate = json['DrawDate'];
    numberOfLines = json['NumberOfLines'];
    imgBefore = json['ImgBefore'];
    imgAfter = json['ImgAfter'];
    price = json['Price'];
    fee = json['Fee'];
    amount = json['Amount'];
    status = json['Status'];
    quantity = json['Quantity'];
    percent = json['Percent'];
    isResult = json['IsResult'];
    payout = json['Payout'];
    tax = json['Tax'];
    prize = json['Prize'];
    createdDate = json['CreatedDate'];
    cancelledBy = json['CancelledBy'];
    cancelledDate = json['CancelledDate'];
    result = json['Result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Code'] = code;
    data['CreatedID'] = createdID;
    data['ProductID'] = productID;
    data['Systematic'] = systematic;
    data['DrawCode'] = drawCode;
    data['DrawDate'] = drawDate;
    data['NumberOfLines'] = numberOfLines;
    data['ImgBefore'] = imgBefore;
    data['ImgAfter'] = imgAfter;
    data['Price'] = price;
    data['Fee'] = fee;
    data['Amount'] = amount;
    data['Status'] = status;
    data['Quantity'] = quantity;
    data['Percent'] = percent;
    data['IsResult'] = isResult;
    data['Payout'] = payout;
    data['Tax'] = tax;
    data['Prize'] = prize;
    data['CreatedDate'] = createdDate;
    data['CancelledBy'] = cancelledBy;
    data['CancelledDate'] = cancelledDate;
    data['Result'] = result;
    return data;
  }
}
