class VerifyOTPRequest {
  String? otp;
  String? code;
  String? refCode;
  String? phoneNumber;
  String? accountNumber;
  int? bankID;
  String? type; // "A" - Liên kết, "C" - Hủy liên kết

  VerifyOTPRequest({
    this.otp,
    this.code,
    this.refCode,
    this.phoneNumber,
    this.accountNumber,
    this.bankID,
    this.type,
  });

  // Chuyển từ JSON sang đối tượng Dart
  factory VerifyOTPRequest.fromJson(Map<String, dynamic> json) {
    return VerifyOTPRequest(
      otp: json['OTP'] as String?,
      code: json['Code'] as String?,
      refCode: json['RefCode'] as String?,
      phoneNumber: json['PhoneNumber'] as String?,
      accountNumber: json['AccountNumber'] as String?,
      bankID: json['BankID'] as int?,
      type: json['Type'] as String?,
    );
  }

  // Chuyển từ đối tượng Dart sang JSON
  Map<String, dynamic> toJson() {
    return {
      'OTP': otp,
      'Code': code,
      'RefCode': refCode,
      'PhoneNumber': phoneNumber,
      'AccountNumber': accountNumber,
      'BankID': bankID,
      'Type': type,
    };
  }
}
