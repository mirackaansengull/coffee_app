import 'package:coffee_app/data/models/cart_item.dart';

class CartRepository {
  CartRepository._();

  static final CartRepository _instance = CartRepository._();
  static CartRepository get instance => _instance;

  List<CartItem> getItems() => [];

  bool get isEmpty => getItems().isEmpty;
}
