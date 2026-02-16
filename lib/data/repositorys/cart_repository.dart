import 'package:coffee_app/data/models/cart_item.dart';

/// Sepet verisi. Gerçek uygulamada state management veya API ile güncellenecek.
class CartRepository {
  CartRepository._();

  static final CartRepository _instance = CartRepository._();
  static CartRepository get instance => _instance;

  /// Sepetteki ürünler. API/state bağlandığında buradan beslenecek.
  List<CartItem> getItems() => [];

  /// Sepet boş mu?
  bool get isEmpty => getItems().isEmpty;
}
