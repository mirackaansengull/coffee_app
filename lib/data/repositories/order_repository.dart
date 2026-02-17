import 'package:coffee_app/data/models/order.dart';

class OrderRepository {
  OrderRepository._();

  static final OrderRepository _instance = OrderRepository._();
  static OrderRepository get instance => _instance;

  List<Order> getOrders() => [];

  Order? getLastOrder() => null;
}
