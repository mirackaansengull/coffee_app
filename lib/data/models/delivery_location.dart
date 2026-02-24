/// Teslimat için seçilen konum: şehir, mahalle, bayi ve adres.
class DeliveryLocation {
  const DeliveryLocation({
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
}
