class TokenResponse {
  String? accessToken;
  String? expires;

  TokenResponse({this.accessToken, this.expires});

  TokenResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['AccessToken'];
    expires = json['Expires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AccessToken'] = accessToken;
    data['Expires'] = expires;
    return data;
  }
}
