/// Sepet kalemi. Gerçek veri API/state'ten gelecek.
class CartItem {
  const CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
  });

  final String id;
  final String productId;
  final String name;
  final String imageUrl;
  final int unitPrice;
  final int quantity;

  int get totalPrice => unitPrice * quantity;
}
