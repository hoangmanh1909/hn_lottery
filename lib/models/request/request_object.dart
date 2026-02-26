// ignore_for_file: unnecessary_getters_setters, prefer_collection_literals

class RequestObject {
  String? _channel;
  String? _code;
  String? _data;
  String? _time;
  String? _signature;

  RequestObject(
      {String? channel,
      String? code,
      String? data,
      String? time,
      String? signature}) {
    if (channel != null) {
      _channel = channel;
    }
    if (code != null) {
      _code = code;
    }
    if (data != null) {
      _data = data;
    }
    if (time != null) {
      _time = time;
    }
    if (signature != null) {
      _signature = signature;
    }
  }

  String? get channel => _channel;
  set channel(String? channel) => _channel = channel;
  String? get code => _code;
  set code(String? code) => _code = code;
  String? get data => _data;
  set data(String? data) => _data = data;
  String? get time => _time;
  set time(String? time) => _time = time;
  String? get signature => _signature;
  set signature(String? signature) => _signature = signature;

  RequestObject.fromJson(Map<String, dynamic> json) {
    _channel = json['Channel'];
    _code = json['Code'];
    _data = json['Data'];
    _time = json['Time'];
    _signature = json['Signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Channel'] = _channel;
    data['Code'] = _code;
    data['Data'] = _data;
    data['Time'] = _time;
    data['Signature'] = _signature;
    return data;
  }
}
