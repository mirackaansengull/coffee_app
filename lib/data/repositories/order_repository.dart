import 'dart:convert';

import 'package:coffee_app/core/constants/api_constants.dart';
import 'package:coffee_app/data/models/cart_item.dart';
import 'package:coffee_app/data/models/delivery_location.dart';
import 'package:coffee_app/data/models/order.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String _keyToken = 'auth_token';

class OrderRepository extends ChangeNotifier {
  OrderRepository._();

  static final OrderRepository _instance = OrderRepository._();
  static OrderRepository get instance => _instance;

  List<Order> _orders = [];
  String get _base => ApiConstants.baseUrl;

  List<Order> getOrders() => List.unmodifiable(_orders);

  Order? getLastOrder() =>
      _orders.isNotEmpty ? _orders.first : null;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// Backend'den siparişleri çeker.
  Future<void> loadOrders() async {
    final token = await _getToken();
    if (token == null) {
      _orders = [];
      notifyListeners();
      return;
    }
    try {
      final res = await http.get(
        Uri.parse('$_base/api/orders'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode != 200) {
        _orders = [];
      } else {
        final list = jsonDecode(res.body) as List<dynamic>?;
        _orders = (list ?? [])
            .map((e) => Order.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      _orders = [];
    }
    notifyListeners();
  }

  /// Sipariş oluşturur (backend'e POST), başarılıysa true döner.
  Future<bool> createOrder({
    required List<CartItem> items,
    required int total,
    required DeliveryLocation delivery,
  }) async {
    final token = await _getToken();
    if (token == null) return false;
    final body = {
      'items': items
          .map((e) => {
                'productId': e.productId,
                'name': e.name,
                'quantity': e.quantity,
                'unitPrice': e.unitPrice,
                'sizeLabel': e.sizeLabel,
                'milkLabel': e.milkLabel,
                'extraShot': e.extraShot,
                'syrupNames': e.syrupNames,
              })
          .toList(),
      'total': total,
      'delivery': {
        'city': delivery.city,
        'neighborhood': delivery.neighborhood,
        'branchName': delivery.branchName,
        'address': delivery.address,
      },
    };
    try {
      final res = await http.post(
        Uri.parse('$_base/api/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        await loadOrders();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
