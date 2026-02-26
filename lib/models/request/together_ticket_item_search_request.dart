class TogetherTicketSearchItemRequest {
  String? mobileNumber;
  int? iD;
  int? groupID;
  int? type;

  TogetherTicketSearchItemRequest(
      {this.mobileNumber, this.iD = 0, this.groupID = 0, this.type = 0});

  TogetherTicketSearchItemRequest.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['MobileNumber'];
    iD = json['ID'];
    groupID = json['GroupID'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MobileNumber'] = mobileNumber;
    data['ID'] = iD;
    data['GroupID'] = groupID;
    data['Type'] = type;
    return data;
  }
}
