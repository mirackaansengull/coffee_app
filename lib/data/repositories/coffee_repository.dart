import 'dart:convert';

import 'package:coffee_app/core/constants/api_constants.dart';
import 'package:coffee_app/data/models/coffee.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CoffeeRepository {
  CoffeeRepository();

  static const _keyToken = 'auth_token';
  String get _base => ApiConstants.baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  Future<List<Coffee>> getCoffees() async {
    try {
      final res = await http.get(Uri.parse('$_base/api/coffees'));
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body) as List;
        return data.map((e) => Coffee.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<Coffee?> createCoffee({
    required String name,
    required String imageUrl,
    required int price,
    String? description,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) return null;
      final res = await http.post(
        Uri.parse('$_base/api/coffee'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'imageUrl': imageUrl,
          'price': price,
          if (description != null) 'description': description,
        }),
      );
      if (res.statusCode == 200) {
        return Coffee.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<Coffee?> updateCoffee({
    required String id,
    required String name,
    required String imageUrl,
    required int price,
    String? description,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) return null;
      final res = await http.put(
        Uri.parse('$_base/api/coffee/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'imageUrl': imageUrl,
          'price': price,
          if (description != null) 'description': description,
        }),
      );
      if (res.statusCode == 200) {
        return Coffee.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> deleteCoffee(String id) async {
    try {
      final token = await _getToken();
      if (token == null) return false;
      final res = await http.delete(
        Uri.parse('$_base/api/coffee/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<List<Coffee>> getFavorites() async {
    try {
      final token = await _getToken();
      if (token == null) return [];
      final res = await http.get(
        Uri.parse('$_base/api/favorites'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body) as List;
        return data.map((e) => Coffee.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<bool> addFavorite(String coffeeId) async {
    try {
      final token = await _getToken();
      if (token == null) return false;
      final res = await http.post(
        Uri.parse('$_base/api/favorites/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'coffeeId': coffeeId}),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> removeFavorite(String coffeeId) async {
    try {
      final token = await _getToken();
      if (token == null) return false;
      final res = await http.delete(
        Uri.parse('$_base/api/favorites/$coffeeId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isFavorite(String coffeeId) async {
    try {
      final token = await _getToken();
      if (token == null) return false;
      final res = await http.get(
        Uri.parse('$_base/api/favorites/check/$coffeeId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        return data['isFavorite'] as bool? ?? false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
