// ignore_for_file: unnecessary_this

class GetResultLotoMBResponse {
  int? iD;
  String? drawCode;
  String? drawDate;
  String? result;
  String? result01;
  String? result02;
  String? result03;
  String? result04;
  String? result05;
  String? result06;
  String? result07;
  String? result08;
  String? symbols;
  String? radioName;

  GetResultLotoMBResponse(
      {this.iD,
      this.drawCode,
      this.drawDate,
      this.result,
      this.result01,
      this.result02,
      this.result03,
      this.result04,
      this.result05,
      this.result06,
      this.result07,
      this.result08,
      this.symbols,
      this.radioName});

  GetResultLotoMBResponse.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    drawCode = json['DrawCode'];
    drawDate = json['DrawDate'];
    result = json['Result'];
    result01 = json['Result01'];
    result02 = json['Result02'];
    result03 = json['Result03'];
    result04 = json['Result04'];
    result05 = json['Result05'];
    result06 = json['Result06'];
    result07 = json['Result07'];
    result08 = json['Result08'];
    symbols = json['Symbols'];
    radioName = json['RadioName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = this.iD;
    data['DrawCode'] = this.drawCode;
    data['DrawDate'] = this.drawDate;
    data['Result'] = this.result;
    data['Result01'] = this.result01;
    data['Result02'] = this.result02;
    data['Result03'] = this.result03;
    data['Result04'] = this.result04;
    data['Result05'] = this.result05;
    data['Result06'] = this.result06;
    data['Result07'] = this.result07;
    data['Result08'] = this.result08;
    data['Symbols'] = this.symbols;
    data['RadioName'] = this.radioName;
    return data;
  }
}
