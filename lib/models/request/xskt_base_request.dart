class XSKTBaseRequest {
  int? warehouseID;
  int? lockerID;
  int? iD;
  String? isLock;
  int? createdByID;
  String? status;

  XSKTBaseRequest(
      {this.warehouseID = 0,
      this.lockerID = 0,
      this.iD = 0,
      this.isLock,
      this.createdByID = 0,
      this.status});

  XSKTBaseRequest.fromJson(Map<String, dynamic> json) {
    warehouseID = json['WarehouseID'];
    lockerID = json['LockerID'];
    iD = json['ID'];
    isLock = json['IsLock'];
    createdByID = json['CreatedByID'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['WarehouseID'] = warehouseID;
    data['LockerID'] = lockerID;
    data['ID'] = iD;
    data['IsLock'] = isLock;
    data['CreatedByID'] = createdByID;
    data['Status'] = status;
    return data;
  }
}
