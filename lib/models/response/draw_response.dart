class DrawResponse {
  String? drawCode;
  String? drawDate;

  DrawResponse({this.drawCode, this.drawDate});

  DrawResponse.fromJson(Map<String, dynamic> json) {
    drawCode = json['DrawCode'];
    drawDate = json['DrawDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DrawCode'] = drawCode;
    data['DrawDate'] = drawDate;
    return data;
  }
}
