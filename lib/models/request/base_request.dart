class BaseRequest {
  String? commandCode;
  String? channel;
  String? time;
  String? data;
  String? signature;

  BaseRequest(
      {this.commandCode, this.channel, this.time, this.data, this.signature});

  BaseRequest.fromJson(Map<String, dynamic> json) {
    commandCode = json['Code'];
    channel = json['Channel'];
    time = json['Time'];
    data = json['Data'];
    signature = json['Signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Code'] = commandCode;
    data['Time'] = time;
    data['Data'] = data;
    data['Channel'] = channel;
    data['Signature'] = signature;
    return data;
  }
}
