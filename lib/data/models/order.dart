import 'package:coffee_app/data/models/order_delivery.dart';
import 'package:coffee_app/data/models/order_item.dart';

class Order {
  const Order({
    required this.id,
    required this.date,
    required this.time,
    required this.step,
    this.rating = 0,
    this.total = 0,
    this.items = const [],
    this.delivery,
    this.userName,
  });

  final String id;
  final String date;
  final String time;
  final int step;
  final int rating;
  final int total;
  final List<OrderItem> items;
  final OrderDelivery? delivery;
  final String? userName;

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderItem> itemsList = [];
    final itemsRaw = json['items'] as List<dynamic>?;
    if (itemsRaw != null) {
      itemsList = itemsRaw
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    OrderDelivery? delivery;
    final deliveryRaw = json['delivery'];
    if (deliveryRaw is Map<String, dynamic>) {
      delivery = OrderDelivery.fromJson(deliveryRaw);
    }
    return Order(
      id: json['id'] as String? ?? '',
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      step: (json['step'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      items: itemsList,
      delivery: delivery,
      userName: json['userName'] as String?,
    );
  }
}
