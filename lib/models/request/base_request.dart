class BaseRequest {
  int? id;

  BaseRequest({this.id});

  BaseRequest.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    return data;
  }
}
