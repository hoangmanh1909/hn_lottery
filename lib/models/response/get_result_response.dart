// ignore_for_file: prefer_collection_literals

class GetResultResponse {
  String? drawCode;
  String? drawDate;
  int? drawTime;
  int? jackpot;
  String? result;
  String? bonus;

  GetResultResponse(
      {this.drawCode,
      this.drawDate,
      this.drawTime,
      this.jackpot,
      this.result,
      this.bonus});

  GetResultResponse.fromJson(Map<String, dynamic> json) {
    drawCode = json['DrawCode'];
    drawDate = json['DrawDate'];
    jackpot = json['Jackpot'];
    result = json['Result'];
    bonus = json['Bonus'];
    drawTime = json['DrawTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['DrawCode'] = drawCode;
    data['DrawDate'] = drawDate;
    data['Jackpot'] = jackpot;
    data['Result'] = result;
    data['Bonus'] = bonus;
    data['DrawTime'] = drawTime;
    return data;
  }
}
