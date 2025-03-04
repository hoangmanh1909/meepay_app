class ChangePasswordRequest {
  String? phoneNumber;
  String? password;
  String? passwordOld;

  ChangePasswordRequest({this.phoneNumber, this.password, this.passwordOld});

  ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['PhoneNumber'];
    password = json['Password'];
    passwordOld = json['PasswordOld'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PhoneNumber'] = phoneNumber;
    data['Password'] = password;
    data['PasswordOld'] = passwordOld;
    return data;
  }
}
