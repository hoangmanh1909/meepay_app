class DeviceSearchResponse {
  int? iD;
  String? type;
  String? serial;
  String? clientID;
  String? subTopic;
  String? pubTopic;
  String? createdDate;
  String? status;
  String? pIN;
  int? merchantID;
  String? merchantCode;
  String? merhcantName;
  String? isLink;

  DeviceSearchResponse(
      {this.iD,
      this.type,
      this.serial,
      this.clientID,
      this.subTopic,
      this.pubTopic,
      this.createdDate,
      this.status,
      this.pIN,
      this.merchantID,
      this.merchantCode,
      this.merhcantName,
      this.isLink});

  DeviceSearchResponse.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    type = json['Type'];
    serial = json['Serial'];
    clientID = json['ClientID'];
    subTopic = json['SubTopic'];
    pubTopic = json['PubTopic'];
    createdDate = json['CreatedDate'];
    status = json['Status'];
    pIN = json['PIN'];
    merchantID = json['MerchantID'];
    merchantCode = json['MerchantCode'];
    merhcantName = json['MerhcantName'];
    isLink = json['IsLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Type'] = type;
    data['Serial'] = serial;
    data['ClientID'] = clientID;
    data['SubTopic'] = subTopic;
    data['PubTopic'] = pubTopic;
    data['CreatedDate'] = createdDate;
    data['Status'] = status;
    data['PIN'] = pIN;
    data['MerchantID'] = merchantID;
    data['MerchantCode'] = merchantCode;
    data['MerhcantName'] = merhcantName;
    data['IsLink'] = isLink;
    return data;
  }
}
