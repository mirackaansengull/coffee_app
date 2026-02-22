import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _keyBannerUrls = 'banner_urls';

const List<String> _defaultUrls = [
  'https://r.resimlink.com/g-5eUFwuD.webp',
  'https://r.resimlink.com/gmkvRDO.webp',
  'https://r.resimlink.com/pbYv9M.webp',
];

class BannerRepository extends ChangeNotifier {
  BannerRepository._() {
    _urls = List.from(_defaultUrls);
  }

  static final BannerRepository _instance = BannerRepository._();
  static BannerRepository get instance => _instance;

  List<String> _urls = [];

  List<String> getBannerImageUrls() =>
      _urls.isEmpty ? List.from(_defaultUrls) : List.unmodifiable(_urls);

  Future<void> loadBannerImageUrls() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_keyBannerUrls);
    if (saved != null && saved.isNotEmpty) {
      _urls = saved;
      notifyListeners();
    }
  }

  Future<void> setBannerImageUrls(List<String> urls) async {
    _urls = urls;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyBannerUrls, urls);
    notifyListeners();
  }
}
