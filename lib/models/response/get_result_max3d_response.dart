class GetResultMax3DResponse {
  String? drawCode;
  String? drawDate;
  String? resultST;
  String? resultND;
  String? resultRD;
  String? resultENC;

  GetResultMax3DResponse(
      {this.drawCode,
      this.drawDate,
      this.resultST,
      this.resultND,
      this.resultRD,
      this.resultENC});

  GetResultMax3DResponse.fromJson(Map<String, dynamic> json) {
    drawCode = json['DrawCode'];
    drawDate = json['DrawDate'];
    resultST = json['ResultST'];
    resultND = json['ResultND'];
    resultRD = json['ResultRD'];
    resultENC = json['ResultENC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DrawCode'] = drawCode;
    data['DrawDate'] = drawDate;
    data['ResultST'] = resultST;
    data['ResultND'] = resultND;
    data['ResultRD'] = resultRD;
    data['ResultENC'] = resultENC;
    return data;
  }
}
