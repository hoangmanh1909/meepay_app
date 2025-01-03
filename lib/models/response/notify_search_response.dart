class NotifySearchResponse {
  int? iD;
  int? accountID;
  String? name;
  String? accountNumber;
  String? transID;
  String? transDate;
  String? content;
  int? amount;

  NotifySearchResponse(
      {this.iD,
      this.accountID,
      this.name,
      this.accountNumber,
      this.transID,
      this.transDate,
      this.content,
      this.amount});

  NotifySearchResponse.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    accountID = json['AccountID'];
    name = json['Name'];
    accountNumber = json['AccountNumber'];
    transID = json['TransID'];
    transDate = json['TransDate'];
    content = json['Content'];
    amount = json['Amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['AccountID'] = accountID;
    data['Name'] = name;
    data['AccountNumber'] = accountNumber;
    data['TransID'] = transID;
    data['TransDate'] = transDate;
    data['Content'] = content;
    data['Amount'] = amount;
    return data;
  }
}
