import 'dart:convert';

import 'package:meepay_app/models/response/device_search_response.dart';

class AccountSearchResponse {
  int? iD;
  int? merchantID;
  int? shopID;
  int? counterID;
  int? bankID;
  String? bankName;
  String? accoumtNumber;
  String? name;
  String? pIDNumber;
  String? mobileNumber;
  String? status;
  String? token;
  String? refCode;
  DeviceSearchResponse? device;

  AccountSearchResponse(
      {this.iD,
      this.merchantID,
      this.shopID,
      this.counterID,
      this.bankID,
      this.bankName,
      this.accoumtNumber,
      this.name,
      this.pIDNumber,
      this.mobileNumber,
      this.status,
      this.token,
      this.device,
      this.refCode});

  AccountSearchResponse.fromJson(Map<String, dynamic> json) {
    refCode = json['RefCode'];
    iD = json['ID'];
    merchantID = json['MerchantID'];
    shopID = json['ShopID'];
    counterID = json['CounterID'];
    bankID = json['BankID'];
    bankName = json['BankName'];
    accoumtNumber = json['AccoumtNumber'];
    name = json['Name'];
    pIDNumber = json['PIDNumber'];
    mobileNumber = json['MobileNumber'];
    status = json['Status'];
    token = json['Token'];
    if (json['Device'] != null) {
      device =
          DeviceSearchResponse.fromJson(jsonDecode(jsonEncode(json['Device'])));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RefCode'] = refCode;
    data['ID'] = iD;
    data['MerchantID'] = merchantID;
    data['ShopID'] = shopID;
    data['CounterID'] = counterID;
    data['BankID'] = bankID;
    data['BankName'] = bankName;
    data['AccoumtNumber'] = accoumtNumber;
    data['Name'] = name;
    data['PIDNumber'] = pIDNumber;
    data['MobileNumber'] = mobileNumber;
    data['Status'] = status;
    data['Token'] = token;
    if (device != null) {
      data['Device'] = device!.toJson();
    }

    return data;
  }
}
