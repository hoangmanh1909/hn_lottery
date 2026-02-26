class RewardExchangeSearchResponse {
  String? status;
  String? approveDate;
  String? approveName;
  String? message;
  int? totalAmount;
  int? fee;
  int? amount;
  String? retRefNumber;
  String? mobileNumber;
  String? accountName;
  String? accountNumber;
  String? walletName;
  int? walletID;
  String? bankName;
  int? bankID;
  String? method;
  int? iD;
  String? createdDate;
  String? reason;

  RewardExchangeSearchResponse(
      {this.status,
      this.approveDate,
      this.approveName,
      this.message,
      this.totalAmount,
      this.fee,
      this.amount,
      this.retRefNumber,
      this.mobileNumber,
      this.accountName,
      this.accountNumber,
      this.walletName,
      this.walletID,
      this.bankName,
      this.bankID,
      this.method,
      this.iD,
      this.createdDate,
      this.reason});

  RewardExchangeSearchResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    approveDate = json['ApproveDate'];
    approveName = json['ApproveName'];
    message = json['Message'];
    totalAmount = json['TotalAmount'];
    fee = json['Fee'];
    amount = json['Amount'];
    retRefNumber = json['RetRefNumber'];
    mobileNumber = json['MobileNumber'];
    accountName = json['AccountName'];
    accountNumber = json['AccountNumber'];
    walletName = json['WalletName'];
    walletID = json['WalletID'];
    bankName = json['BankName'];
    bankID = json['BankID'];
    method = json['Method'];
    iD = json['ID'];
    createdDate = json['CreatedDate'];
    reason = json['Reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['ApproveDate'] = approveDate;
    data['ApproveName'] = approveName;
    data['Message'] = message;
    data['TotalAmount'] = totalAmount;
    data['Fee'] = fee;
    data['Amount'] = amount;
    data['RetRefNumber'] = retRefNumber;
    data['MobileNumber'] = mobileNumber;
    data['AccountName'] = accountName;
    data['AccountNumber'] = accountNumber;
    data['WalletName'] = walletName;
    data['WalletID'] = walletID;
    data['BankName'] = bankName;
    data['BankID'] = bankID;
    data['Method'] = method;
    data['ID'] = iD;
    data['CreatedDate'] = createdDate;
    data['Reason'] = reason;
    return data;
  }
}
