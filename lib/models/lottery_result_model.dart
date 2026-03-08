class LotteryResultModel {
  final String title;
  final List<String> numbers;
  final String prize;
  final String date;
  final String type; // Để quyết định màu sắc
  final String bonus;

  LotteryResultModel({
    required this.title,
    required this.numbers,
    required this.prize,
    required this.date,
    required this.type,
    required this.bonus,
  });
}
