class DailyTarget {
  final String date;
  final int amount;

  DailyTarget({required this.date, required this.amount});

  factory DailyTarget.fromJson(Map<String, dynamic> json) {
    return DailyTarget(date: json["date"], amount: json["amount"]);
  }
}
