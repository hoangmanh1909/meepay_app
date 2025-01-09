class VerifyOTPRequest {
  String? oTP;
  String? code;

  VerifyOTPRequest({this.oTP, this.code});

  VerifyOTPRequest.fromJson(Map<String, dynamic> json) {
    oTP = json['OTP'];
    code = json['Code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OTP'] = oTP;
    data['Code'] = code;
    return data;
  }
}
