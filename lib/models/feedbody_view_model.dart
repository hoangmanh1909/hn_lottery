class FeedBodyViewModel {
  bool? isSelected;
  int? numberDraw;
  double? price;
  double? totalAmount;
  double? prize;
  double? profit;

  FeedBodyViewModel(
      {this.isSelected,
      this.numberDraw,
      this.price,
      this.totalAmount,
      this.prize,
      this.profit});

  FeedBodyViewModel.fromJson(Map<String, dynamic> json) {
    isSelected = json['IsSelected'];
    numberDraw = json['NumberDraw'];
    price = json['Price'];
    totalAmount = json['TotalAmount'];
    prize = json['Prize'];
    profit = json['Profit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IsSelected'] = isSelected;
    data['NumberDraw'] = numberDraw;
    data['Price'] = price;
    data['TotalAmount'] = totalAmount;
    data['Prize'] = prize;
    data['Profit'] = profit;
    return data;
  }
}
