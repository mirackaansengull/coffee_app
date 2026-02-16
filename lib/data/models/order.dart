/// Sipariş modeli. Gerçek veri API'den gelecek.
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

  /// 0: Onay, 1: Hazırlanıyor, 2: Hazır, 3: Teslim edildi
  final int step;
  final int rating;
}
