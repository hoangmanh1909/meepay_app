// ignore_for_file: prefer_collection_literals, unnecessary_new, unnecessary_this, non_constant_identifier_names

class BaseResponse {
  String? code;
  String? message;
  String? data;
  String? token;
  BaseResponse({this.code, this.message, this.data, this.token});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    message = json['Message'];
    data = json['Data'];
    token = json['Token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['Message'] = this.message;
    data['Data'] = this.data;
    data['Token'] = this.token;
    return data;
  }
}
