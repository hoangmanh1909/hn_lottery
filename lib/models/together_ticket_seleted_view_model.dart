class TogetherSelectedPercentViewModel {
  String? text;
  String? value;
  bool? selected;
  String? price;

  TogetherSelectedPercentViewModel(
      {this.text, this.value, this.selected, this.price});

  TogetherSelectedPercentViewModel.fromJson(Map<String, dynamic> json) {
    text = json['Text'];
    value = json['Value'];
    selected = json['Selected'];
    price = json['Price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Text'] = text;
    data['Value'] = value;
    data['Selected'] = selected;
    data['Price'] = price;
    return data;
  }
}
