class DictionaryResponse {
  int? iD;
  String? code;
  String? name;
  String? shortName;
  String? imgLogo;

  DictionaryResponse(
      {this.iD, this.code, this.name, this.shortName, this.imgLogo});

  DictionaryResponse.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    code = json['Code'];
    name = json['Name'];
    shortName = json['ShortName'];
    imgLogo = json['ImgLogo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Code'] = code;
    data['Name'] = name;
    data['ShortName'] = shortName;
    data['ImgLogo'] = imgLogo;
    return data;
  }
}
