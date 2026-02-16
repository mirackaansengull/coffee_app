import 'package:coffee_app/data/models/coffee.dart';

/// Kahve listesi. Gerçek uygulamada API veya local DB'den doldurulacak.
class CoffeeRepository {
  CoffeeRepository._();

  static final CoffeeRepository _instance = CoffeeRepository._();
  static CoffeeRepository get instance => _instance;

  /// Tüm kahveleri getirir. Şu an boş liste; API bağlandığında bu metot güncellenecek.
  List<Coffee> getCoffees() => [];

  /// İsteğe bağlı: kategoriye göre filtre (En Çok Satanlar, Sıcak Kahve vb.)
  List<Coffee> getCoffeesByCategory(String categoryId) => [];
}
