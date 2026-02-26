// ignore_for_file: prefer_collection_literals

class GetResultKenoResponse {
  String? drawCode;
  String? drawDate;
  String? drawTime;
  String? result;
  int? even;
  int? odd;
  int? big;
  int? small;

  GetResultKenoResponse(
      {this.drawCode,
      this.drawDate,
      this.drawTime,
      this.result,
      this.even,
      this.odd,
      this.big,
      this.small});

  GetResultKenoResponse.fromJson(Map<String, dynamic> json) {
    drawCode = json['DrawCode'];
    drawDate = json['DrawDate'];
    drawTime = json['DrawTime'];
    result = json['Result'];
    even = json['Even'];
    odd = json['Odd'];
    big = json['Big'];
    small = json['Small'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['DrawCode'] = drawCode;
    data['DrawDate'] = drawDate;
    data['DrawTime'] = drawTime;
    data['Result'] = result;
    data['Even'] = even;
    data['Odd'] = odd;
    data['Big'] = big;
    data['Small'] = small;
    return data;
  }
}
