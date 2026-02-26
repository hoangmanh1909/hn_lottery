import 'package:lottery_flutter_application/models/response/xskt_ticket_symbol.dart';

class XSKTTickeResponse {
  int? iD;
  int? amndID;
  int? type;
  String? value;
  int? total;
  String? images;
  int? drawlerID;
  int? providerID;
  int? radioID;
  String? symbol;
  String? drawDate;
  String? createdDate;
  String? status;
  int? remainingTicket;
  String? errorReason;
  String? drawlerIndex;
  String? lockerCode;
  String? radioName;
  String? radioLogo;
  List<XSKTTicketSymbol>? symbols;

  XSKTTickeResponse(
      {this.iD,
      this.amndID,
      this.type,
      this.value,
      this.total,
      this.images,
      this.drawlerID,
      this.providerID,
      this.radioID,
      this.symbol,
      this.drawDate,
      this.createdDate,
      this.status,
      this.remainingTicket,
      this.errorReason,
      this.drawlerIndex,
      this.lockerCode,
      this.radioName,
      this.radioLogo,
      this.symbols});

  XSKTTickeResponse.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    amndID = json['AmndID'];
    type = json['Type'];
    value = json['Value'];
    total = json['Total'];
    images = json['Images'];
    drawlerID = json['DrawlerID'];
    providerID = json['ProviderID'];
    radioID = json['RadioID'];
    symbol = json['Symbol'];
    drawDate = json['DrawDate'];
    createdDate = json['CreatedDate'];
    status = json['Status'];
    remainingTicket = json['RemainingTicket'];
    errorReason = json['ErrorReason'];
    drawlerIndex = json['DrawlerIndex'];
    lockerCode = json['LockerCode'];
    radioName = json['RadioName'];
    radioLogo = json['RadioLogo'];
    if (json['Symbols'] != null) {
      symbols = <XSKTTicketSymbol>[];
      json['Symbols'].forEach((v) {
        symbols!.add(XSKTTicketSymbol.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['AmndID'] = amndID;
    data['Type'] = type;
    data['Value'] = value;
    data['Total'] = total;
    data['Images'] = images;
    data['DrawlerID'] = drawlerID;
    data['ProviderID'] = providerID;
    data['RadioID'] = radioID;
    data['Symbol'] = symbol;
    data['DrawDate'] = drawDate;
    data['CreatedDate'] = createdDate;
    data['Status'] = status;
    data['RemainingTicket'] = remainingTicket;
    data['ErrorReason'] = errorReason;
    data['DrawlerIndex'] = drawlerIndex;
    data['LockerCode'] = lockerCode;
    data['RadioName'] = radioName;
    data['RadioLogo'] = radioLogo;
    if (symbols != null) {
      data['Symbols'] = symbols!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
