import 'dart:convert';

import 'package:coffee_app/core/constants/api_constants.dart';
import 'package:coffee_app/data/models/cart_item.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String _keyCart = 'cart_items';
const String _keyToken = 'auth_token';

class CartRepository extends ChangeNotifier {
  CartRepository._();

  static final CartRepository _instance = CartRepository._();
  static CartRepository get instance => _instance;

  List<CartItem> _items = [];
  bool _loaded = false;
  String get _base => ApiConstants.baseUrl;

  List<CartItem> getItems() => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  int get totalItemCount =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  int get grandTotal =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// Backend'den sepeti çeker (token varsa).
  Future<bool> _fetchFromApi() async {
    final token = await _getToken();
    if (token == null) return false;
    try {
      final res = await http
          .get(
            Uri.parse('$_base/api/cart'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(ApiConstants.apiTimeout);
      if (res.statusCode != 200) return false;
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      final list = data?['items'] as List<dynamic>?;
      if (list == null) return true;
      _items = list
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// İlk kullanımda sepeti backend veya yerelden yükler.
  Future<void> ensureLoaded() async {
    if (_loaded) return;
    final fromApi = await _fetchFromApi();
    if (!fromApi) {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_keyCart);
      if (json != null) {
        try {
          final list = jsonDecode(json) as List<dynamic>;
          _items = list
              .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
              .toList();
        } catch (_) {
          _items = [];
        }
      }
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _saveLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _keyCart,
      jsonEncode(_items.map((e) => e.toJson()).toList()),
    );
  }

  /// Aynı seçenek varsa adedi artırır, yoksa yeni satır ekler.
  /// Önce yerel sepete ekler (anında tepki), API'yi arka planda senkronize eder.
  Future<void> addItem(CartItem item) async {
    await ensureLoaded();
    final existingIndex = _items.indexWhere((e) => e.hasSameOptions(item));
    if (existingIndex >= 0) {
      final existing = _items[existingIndex];
      _items[existingIndex] =
          existing.copyWith(quantity: existing.quantity + item.quantity);
    } else {
      _items.add(item);
    }
    await _saveLocal();
    notifyListeners();

    final token = await _getToken();
    if (token != null) {
      Future<void>.microtask(() async {
        try {
          final res = await http
              .post(
                Uri.parse('$_base/api/cart'),
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
                body: jsonEncode(item.toJson()),
              )
              .timeout(ApiConstants.apiTimeout);
          if (res.statusCode == 200 || res.statusCode == 201) {
            await _fetchFromApi();
            notifyListeners();
          }
        } catch (_) {}
      });
    }
  }

  Future<void> removeItem(String id) async {
    await ensureLoaded();
    _items.removeWhere((e) => e.id == id);
    await _saveLocal();
    notifyListeners();
    final token = await _getToken();
    if (token != null) {
      Future<void>.microtask(() async {
        try {
          final res = await http
              .delete(
                Uri.parse('$_base/api/cart/item/$id'),
                headers: {'Authorization': 'Bearer $token'},
              )
              .timeout(ApiConstants.apiTimeout);
          if (res.statusCode == 200) {
            await _fetchFromApi();
            notifyListeners();
          }
        } catch (_) {}
      });
    }
  }

  Future<void> updateQuantity(String id, int newQuantity) async {
    if (newQuantity < 1) {
      await removeItem(id);
      return;
    }
    await ensureLoaded();
    final i = _items.indexWhere((e) => e.id == id);
    if (i >= 0) {
      _items[i] = _items[i].copyWith(quantity: newQuantity);
      await _saveLocal();
      notifyListeners();
    }
    final token = await _getToken();
    if (token != null) {
      Future<void>.microtask(() async {
        try {
          final res = await http
              .put(
                Uri.parse('$_base/api/cart/item/$id'),
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
                body: jsonEncode({'quantity': newQuantity}),
              )
              .timeout(ApiConstants.apiTimeout);
          if (res.statusCode == 200) {
            await _fetchFromApi();
            notifyListeners();
          }
        } catch (_) {}
      });
    }
  }
}
