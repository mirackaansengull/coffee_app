class CartItem {
  const CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
    this.sizeLabel = 'M',
    this.milkLabel = 'Standart süt',
    this.extraShot = false,
    this.syrupNames = const [],
  });

  final String id;
  final String productId;
  final String name;
  final String imageUrl;
  final int unitPrice;
  final int quantity;
  final String sizeLabel;
  final String milkLabel;
  final bool extraShot;
  final List<String> syrupNames;

  int get totalPrice => unitPrice * quantity;

  /// Sepette aynı seçenekle birleştirme için karşılaştırma.
  bool hasSameOptions(CartItem other) {
    if (productId != other.productId) return false;
    if (sizeLabel != other.sizeLabel) return false;
    if (milkLabel != other.milkLabel) return false;
    if (extraShot != other.extraShot) return false;
    if (syrupNames.length != other.syrupNames.length) return false;
    for (int i = 0; i < syrupNames.length; i++) {
      if (syrupNames[i] != other.syrupNames[i]) return false;
    }
    return true;
  }

  /// Özellik özeti (sepet satırında gösterilecek).
  String get optionsSummary {
    final parts = <String>['Boyut: $sizeLabel', 'Süt: $milkLabel'];
    if (extraShot) parts.add('Ekstra shot');
    if (syrupNames.isNotEmpty) {
      parts.add('Şurup: ${syrupNames.join(", ")}');
    }
    return parts.join(' · ');
  }

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    String? imageUrl,
    int? unitPrice,
    int? quantity,
    String? sizeLabel,
    String? milkLabel,
    bool? extraShot,
    List<String>? syrupNames,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      sizeLabel: sizeLabel ?? this.sizeLabel,
      milkLabel: milkLabel ?? this.milkLabel,
      extraShot: extraShot ?? this.extraShot,
      syrupNames: syrupNames ?? this.syrupNames,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'name': name,
        'imageUrl': imageUrl,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'sizeLabel': sizeLabel,
        'milkLabel': milkLabel,
        'extraShot': extraShot,
        'syrupNames': syrupNames,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      unitPrice: (json['unitPrice'] as num?)?.toInt() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      sizeLabel: json['sizeLabel'] as String? ?? 'M',
      milkLabel: json['milkLabel'] as String? ?? 'Standart süt',
      extraShot: json['extraShot'] as bool? ?? false,
      syrupNames: (json['syrupNames'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
