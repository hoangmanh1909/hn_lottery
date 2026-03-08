// ignore_for_file: unnecessary_this, prefer_collection_literals

class SoMoResponse {
  String? title;
  String? value;

  SoMoResponse({this.title, this.value});

  SoMoResponse.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Title'] = this.title;
    data['Value'] = this.value;
    return data;
  }
}
