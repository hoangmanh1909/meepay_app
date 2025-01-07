class ChangeLinkRequest {
  int? deviceID;
  String? isLink;

  ChangeLinkRequest({this.deviceID, this.isLink});

  ChangeLinkRequest.fromJson(Map<String, dynamic> json) {
    deviceID = json['DeviceID'];
    isLink = json['IsLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DeviceID'] = deviceID;
    data['IsLink'] = isLink;
    return data;
  }
}
