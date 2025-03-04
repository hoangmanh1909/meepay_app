class VerifyOTPRequest {
  String? oTP;
  String? code;
  int? bankID;
  String? phoneNumber;

  VerifyOTPRequest({this.oTP, this.code, this.bankID = 0, this.phoneNumber});

  VerifyOTPRequest.fromJson(Map<String, dynamic> json) {
    oTP = json['OTP'];
    code = json['Code'];
    bankID = json['BankID'];
    phoneNumber = json['PhoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OTP'] = oTP;
    data['Code'] = code;
    data['BankID'] = bankID;
    data['PhoneNumber'] = phoneNumber;
    return data;
  }
}
