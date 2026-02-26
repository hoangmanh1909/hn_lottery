// ignore_for_file: unnecessary_getters_setters, prefer_collection_literals

class GetJackpotHomeResponse {
  int? _mega;
  int? _power;
  int? _lotto;

  GetJackpotHomeResponse({int? mega, int? power, int? lotto}) {
    if (mega != null) {
      _mega = mega;
    }
    if (power != null) {
      _power = power;
    }
    if (lotto != null) {
      _lotto = lotto;
    }
  }

  int? get mega => _mega;
  set mega(int? mega) => _mega = mega;
  int? get power => _power;
  set power(int? power) => _power = power;
  int? get lotto => _lotto;
  set lotto(int? lotto) => _lotto = lotto;

  GetJackpotHomeResponse.fromJson(Map<String, dynamic> json) {
    _mega = json['Mega'];
    _power = json['Power'];
    _lotto = json['Lotto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Mega'] = _mega;
    data['Power'] = _power;
    data['Lotto'] = _lotto;
    return data;
  }
}
