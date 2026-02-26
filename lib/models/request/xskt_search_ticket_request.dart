class XSKTSearchTicketRequest {
  int? iD;
  String? fromDate;
  String? toDate;
  String? fromDrawDate;
  String? toDrawDate;
  String? status;
  int? radioID;
  int? area;

  XSKTSearchTicketRequest(
      {this.iD = 0,
      this.fromDate,
      this.toDate,
      this.fromDrawDate,
      this.toDrawDate,
      this.status,
      this.radioID,
      this.area});

  XSKTSearchTicketRequest.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
    fromDrawDate = json['FromDrawDate'];
    toDrawDate = json['ToDrawDate'];
    status = json['Status'];
    radioID = json['RadioID'];
    area = json['Area'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['FromDate'] = fromDate;
    data['ToDate'] = toDate;
    data['FromDrawDate'] = fromDrawDate;
    data['ToDrawDate'] = toDrawDate;
    data['Status'] = status;
    data['RadioID'] = radioID;
    data['Area'] = area;
    return data;
  }
}
