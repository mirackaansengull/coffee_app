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

  factory Coffee.fromJson(Map<String, dynamic> json) {
    return Coffee(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'price': price,
        if (description != null) 'description': description,
      };
}
