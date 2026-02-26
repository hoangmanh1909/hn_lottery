class GetItemResultResponse {
  int? prize;
  int? prizeF;
  String? statusF;
  int? prizeE;
  String? statusE;
  int? prizeD;
  String? statusD;
  int? prizeC;
  String? statusC;
  int? prizeB;
  String? statusB;
  int? prizeA;
  String? statusA;
  int? itemID;
  int? iD;
  int? resultID;
  int? productID;

  GetItemResultResponse(
      {this.prize,
      this.prizeF,
      this.statusF,
      this.prizeE,
      this.statusE,
      this.prizeD,
      this.statusD,
      this.prizeC,
      this.statusC,
      this.prizeB,
      this.statusB,
      this.prizeA,
      this.statusA,
      this.itemID,
      this.iD,
      this.resultID,
      this.productID});

  GetItemResultResponse.fromJson(Map<String, dynamic> json) {
    prize = json['Prize'];
    prizeF = json['PrizeF'];
    statusF = json['StatusF'];
    prizeE = json['PrizeE'];
    statusE = json['StatusE'];
    prizeD = json['PrizeD'];
    statusD = json['StatusD'];
    prizeC = json['PrizeC'];
    statusC = json['StatusC'];
    prizeB = json['PrizeB'];
    statusB = json['StatusB'];
    prizeA = json['PrizeA'];
    statusA = json['StatusA'];
    itemID = json['ItemID'];
    iD = json['ID'];
    resultID = json['ResultID'];
    productID = json['ProductID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Prize'] = prize;
    data['PrizeF'] = prizeF;
    data['StatusF'] = statusF;
    data['PrizeE'] = prizeE;
    data['StatusE'] = statusE;
    data['PrizeD'] = prizeD;
    data['StatusD'] = statusD;
    data['PrizeC'] = prizeC;
    data['StatusC'] = statusC;
    data['PrizeB'] = prizeB;
    data['StatusB'] = statusB;
    data['PrizeA'] = prizeA;
    data['StatusA'] = statusA;
    data['ItemID'] = itemID;
    data['ID'] = iD;
    data['ResultID'] = resultID;
    data['ProductID'] = productID;
    return data;
  }
}
