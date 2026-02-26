class ConfigPrizeResponse {
  int? iD;
  int? area;
  int? price;
  int? yield;
  int? prize;

  ConfigPrizeResponse({this.iD, this.area, this.price, this.yield, this.prize});

  ConfigPrizeResponse.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    area = json['Area'];
    price = json['Price'];
    yield = json['Yield'];
    prize = json['Prize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Area'] = area;
    data['Price'] = price;
    data['Yield'] = yield;
    data['Prize'] = prize;
    return data;
  }
}
