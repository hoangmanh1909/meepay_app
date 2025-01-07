class AccountSearchRequest {
  int? merchantID;
  int? shopID;
  int? counterID;
  String? accountNumber;
  int? bankID;
  String? mobileNumber;

  AccountSearchRequest(
      {this.merchantID = 0,
      this.shopID = 0,
      this.counterID = 0,
      this.accountNumber,
      this.bankID = 0,
      this.mobileNumber});

  AccountSearchRequest.fromJson(Map<String, dynamic> json) {
    merchantID = json['MerchantID'];
    shopID = json['ShopID'];
    counterID = json['CounterID'];
    accountNumber = json['AccountNumber'];
    bankID = json['BankID'];
    mobileNumber = json['MobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MerchantID'] = merchantID;
    data['ShopID'] = shopID;
    data['CounterID'] = counterID;
    data['AccountNumber'] = accountNumber;
    data['BankID'] = bankID;
    data['MobileNumber'] = mobileNumber;
    return data;
  }
}
