// ignore_for_file: unnecessary_this, prefer_collection_literals

class GetDrawKenoResponse {
  String? drawCode;
  int? closeTime;
  String? drawTime;
  String? drawDate;
  int? iD;

  GetDrawKenoResponse(
      {this.drawCode, this.closeTime, this.drawTime, this.drawDate, this.iD});

  GetDrawKenoResponse.fromJson(Map<String, dynamic> json) {
    drawCode = json['DrawCode'];
    closeTime = json['CloseTime'];
    drawTime = json['DrawTime'];
    drawDate = json['DrawDate'];
    iD = json['ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['DrawCode'] = this.drawCode;
    data['CloseTime'] = this.closeTime;
    data['DrawTime'] = this.drawTime;
    data['DrawDate'] = this.drawDate;
    data['ID'] = this.iD;
    return data;
  }
}
