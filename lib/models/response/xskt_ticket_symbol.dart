class XSKTTicketSymbol {
  int? iD;
  String? symbol;
  String? isPaid;

  XSKTTicketSymbol({this.iD, this.symbol, this.isPaid});

  XSKTTicketSymbol.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    symbol = json['Symbol'];
    isPaid = json['IsPaid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Symbol'] = symbol;
    data['IsPaid'] = isPaid;
    return data;
  }
}
