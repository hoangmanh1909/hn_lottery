// ignore_for_file: unnecessary_getters_setters, prefer_collection_literals

class ResponseObject {
  String? _code;
  String? _message;
  String? _data;
  String? _accessToken;

  ResponseObject(
      {String? code, String? message, String? data, String? accessToken}) {
    if (code != null) {
      _code = code;
    }
    if (message != null) {
      _message = message;
    }
    if (data != null) {
      _data = data;
    }
    if (accessToken != null) {
      _accessToken = accessToken;
    }
  }

  String? get code => _code;
  set code(String? code) => _code = code;
  String? get message => _message;
  set message(String? message) => _message = message;
  String? get data => _data;
  set data(String? data) => _data = data;
  String? get accessToken => _accessToken;
  set accessToken(String? accessToken) => _accessToken = accessToken;

  ResponseObject.fromJson(Map<String, dynamic> json) {
    _code = json['code'];
    _message = json['message'];
    _data = json['data'];
    _accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = _code;
    data['message'] = _message;
    data['data'] = _data;
    data['accessToken'] = _accessToken;
    return data;
  }
}
