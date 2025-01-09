class AccountAddNewRequest {
  int? merchantID;
  int? shopID;
  int? counterID;
  String? accountNumber;
  int? bankID;
  String? name;
  String? pIDNumber;
  String? mobileNumber;
  String? token;
  String? serial;
  String? email;

  AccountAddNewRequest(
      {this.merchantID,
      this.shopID = 0,
      this.counterID = 0,
      this.accountNumber,
      this.bankID = 0,
      this.name,
      this.pIDNumber,
      this.mobileNumber,
      this.token,
      this.serial,
      this.email});

  AccountAddNewRequest.fromJson(Map<String, dynamic> json) {
    merchantID = json['MerchantID'];
    shopID = json['ShopID'];
    counterID = json['CounterID'];
    accountNumber = json['AccountNumber'];
    bankID = json['BankID'];
    name = json['Name'];
    pIDNumber = json['PIDNumber'];
    mobileNumber = json['MobileNumber'];
    token = json['Token'];
    serial = json['Serial'];
    email = json['Email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MerchantID'] = merchantID;
    data['ShopID'] = shopID;
    data['CounterID'] = counterID;
    data['AccountNumber'] = accountNumber;
    data['BankID'] = bankID;
    data['Name'] = name;
    data['PIDNumber'] = pIDNumber;
    data['MobileNumber'] = mobileNumber;
    data['Token'] = token;
    data['Serial'] = serial;
    data['Email'] = email;
    return data;
  }
}
