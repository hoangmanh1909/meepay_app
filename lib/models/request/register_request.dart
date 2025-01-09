class RegisterRequest {
  String? name;
  String? phoneNumber;
  String? email;
  String? password;
  String? referralCode;

  RegisterRequest(
      {this.name,
      this.phoneNumber,
      this.email,
      this.password,
      this.referralCode});

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    phoneNumber = json['PhoneNumber'];
    email = json['Email'];
    password = json['Password'];
    referralCode = json['ReferralCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['PhoneNumber'] = phoneNumber;
    data['Email'] = email;
    data['Password'] = password;
    data['ReferralCode'] = referralCode;
    return data;
  }
}
