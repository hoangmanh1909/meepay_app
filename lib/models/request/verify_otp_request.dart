class VerifyOTPRequest {
  String? oTP;
  String? code;
  int? bankID;

  VerifyOTPRequest({this.oTP, this.code, this.bankID});

  VerifyOTPRequest.fromJson(Map<String, dynamic> json) {
    oTP = json['OTP'];
    code = json['Code'];
    bankID = json['BankID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OTP'] = oTP;
    data['Code'] = code;
    data['BankID'] = bankID;
    return data;
  }
}
