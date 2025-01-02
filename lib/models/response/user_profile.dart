class UserProfile {
  int? iD;
  String? phoneNumber;
  String? name;
  String? subSystem;
  String? email;
  int? agentID;
  String? agentShortName;
  String? agentName;
  int? merchantID;
  String? merchantName;
  int? shopID;
  String? shopName;
  String? status;
  int? counterID;

  UserProfile(
      {this.iD,
      this.phoneNumber,
      this.name,
      this.subSystem,
      this.email,
      this.agentID,
      this.agentShortName,
      this.agentName,
      this.merchantID,
      this.merchantName,
      this.shopID,
      this.shopName,
      this.status,
      this.counterID});

  UserProfile.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    phoneNumber = json['PhoneNumber'];
    name = json['Name'];
    subSystem = json['SubSystem'];
    email = json['Email'];
    agentID = json['AgentID'];
    agentShortName = json['AgentShortName'];
    agentName = json['AgentName'];
    merchantID = json['MerchantID'];
    merchantName = json['MerchantName'];
    shopID = json['ShopID'];
    shopName = json['ShopName'];
    status = json['Status'];
    counterID = json['CounterID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['PhoneNumber'] = phoneNumber;
    data['Name'] = name;
    data['SubSystem'] = subSystem;
    data['Email'] = email;
    data['AgentID'] = agentID;
    data['AgentShortName'] = agentShortName;
    data['AgentName'] = agentName;
    data['MerchantID'] = merchantID;
    data['MerchantName'] = merchantName;
    data['ShopID'] = shopID;
    data['ShopName'] = shopName;
    data['Status'] = status;
    data['CounterID'] = counterID;
    return data;
  }
}
