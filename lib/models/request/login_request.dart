class LoginRequest {
  String? phoneNumber;
  String? password;

  LoginRequest({this.phoneNumber, this.password});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['PhoneNumber'];
    password = json['Password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PhoneNumber'] = phoneNumber;
    data['Password'] = password;
    return data;
  }
}
