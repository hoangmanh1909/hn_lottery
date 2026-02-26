class RewardExchangeAddRequest {
  String? method;
  int? bankID;
  int? walletID;
  String? accountNumber;
  String? accountName;
  String? mobileNumber;
  int? amount;
  int? fee;
  int? totalAmount;
  String? message;

  RewardExchangeAddRequest(
      {this.method,
      this.bankID = 0,
      this.walletID = 0,
      this.accountNumber,
      this.accountName,
      this.mobileNumber,
      this.amount,
      this.fee = 0,
      this.totalAmount,
      this.message});

  RewardExchangeAddRequest.fromJson(Map<String, dynamic> json) {
    method = json['Method'];
    bankID = json['BankID'];
    walletID = json['WalletID'];
    accountNumber = json['AccountNumber'];
    accountName = json['AccountName'];
    mobileNumber = json['MobileNumber'];
    amount = json['Amount'];
    fee = json['Fee'];
    totalAmount = json['TotalAmount'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Method'] = method;
    data['BankID'] = bankID;
    data['WalletID'] = walletID;
    data['AccountNumber'] = accountNumber;
    data['AccountName'] = accountName;
    data['MobileNumber'] = mobileNumber;
    data['Amount'] = amount;
    data['Fee'] = fee;
    data['TotalAmount'] = totalAmount;
    data['Message'] = message;
    return data;
  }
}
