/// Siparişteki tek kalem (ürün adı, adet, özellikler).
class OrderItem {
  const OrderItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    this.sizeLabel = 'M',
    this.milkLabel = 'Standart süt',
    this.extraShot = false,
    this.syrupNames = const [],
  });

  final String name;
  final int quantity;
  final int unitPrice;
  final String sizeLabel;
  final String milkLabel;
  final bool extraShot;
  final List<String> syrupNames;

  int get totalPrice => unitPrice * quantity;

  String get optionsSummary {
    final parts = <String>['Boyut: $sizeLabel', 'Süt: $milkLabel'];
    if (extraShot) parts.add('Ekstra shot');
    if (syrupNames.isNotEmpty) {
      parts.add('Şurup: ${syrupNames.join(", ")}');
    }
    return parts.join(' · ');
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      unitPrice: (json['unitPrice'] as num?)?.toInt() ?? 0,
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
