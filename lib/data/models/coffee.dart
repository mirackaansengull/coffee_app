class Coffee {
  const Coffee({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.description,
  });

  final String id;
  final String name;
  final String imageUrl;
  final int price;
  final String? description;
}
