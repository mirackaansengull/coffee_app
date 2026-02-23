import 'dart:convert';

import 'package:coffee_app/data/models/saved_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _keyCards = 'saved_cards';

class CardRepository {
  CardRepository._();

  static final CardRepository _instance = CardRepository._();
  static CardRepository get instance => _instance;

  Future<List<SavedCard>> getCards() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keyCards);
    if (json == null) return [];
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map((e) => SavedCard.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> addCard(SavedCard card) async {
    final list = await getCards();
    list.add(card);
    await _save(list);
  }

  Future<void> removeCard(String id) async {
    final list = await getCards();
    list.removeWhere((c) => c.id == id);
    await _save(list);
  }

  Future<void> _save(List<SavedCard> list) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_keyCards, json);
  }
}
