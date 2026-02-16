import 'package:coffee_app/data/models/order.dart';

/// Sipariş geçmişi. Gerçek uygulamada API'den gelecek.
class OrderRepository {
  OrderRepository._();

  static final OrderRepository _instance = OrderRepository._();
  static OrderRepository get instance => _instance;

  /// Tüm siparişler (tarih sıralı). API bağlandığında bu metot güncellenecek.
  List<Order> getOrders() => [];

  /// Profil sayfasındaki "son sipariş" kartı için. Yoksa null.
  Order? getLastOrder() => null;
}
