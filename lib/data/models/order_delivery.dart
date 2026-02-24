/// Sipariş teslimat bilgisi.
class OrderDelivery {
  const OrderDelivery({
    required this.city,
    required this.neighborhood,
    required this.branchName,
    required this.address,
  });

  final String city;
  final String neighborhood;
  final String branchName;
  final String address;

  String get summary => '$city, $neighborhood · $branchName';

  factory OrderDelivery.fromJson(Map<String, dynamic> json) {
    return OrderDelivery(
      city: json['city'] as String? ?? '',
      neighborhood: json['neighborhood'] as String? ?? '',
      branchName: json['branchName'] as String? ?? '',
      address: json['address'] as String? ?? '',
    );
  }
}
