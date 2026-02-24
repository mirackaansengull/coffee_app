class Order {
  const Order({
    required this.id,
    required this.date,
    required this.time,
    required this.step,
    this.rating = 0,
  });

  final String id;
  final String date;
  final String time;
  final int step;
  final int rating;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String? ?? '',
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      step: (json['step'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toInt() ?? 0,
    );
  }
}
