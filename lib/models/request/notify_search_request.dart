class NotifySearchRequest {
  String? fromDate;
  String? toDate;
  int? iD;
  int? accountID;
  String? transID;

  NotifySearchRequest(
      {this.fromDate,
      this.toDate,
      this.iD = 0,
      this.accountID = 0,
      this.transID});

  NotifySearchRequest.fromJson(Map<String, dynamic> json) {
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
    iD = json['ID'];
    accountID = json['AccountID'];
    transID = json['TransID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FromDate'] = fromDate;
    data['ToDate'] = toDate;
    data['ID'] = iD;
    data['AccountID'] = accountID;
    data['TransID'] = transID;
    return data;
  }
}
