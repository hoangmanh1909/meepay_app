class NotifyGeneralResponse {
  int? amount;
  int? yield;
  String? transDate;

  NotifyGeneralResponse({this.amount, this.yield, this.transDate});

  NotifyGeneralResponse.fromJson(Map<String, dynamic> json) {
    amount = json['Amount'];
    yield = json['Yield'];
    transDate = json['TransDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Amount'] = amount;
    data['Yield'] = yield;
    data['TransDate'] = transDate;
    return data;
  }
}
