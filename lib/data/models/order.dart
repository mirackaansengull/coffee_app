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
}
