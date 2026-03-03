class Coffee {
  const Coffee({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.priceS,
    this.priceM,
    this.priceL,
    this.priceXL,
    this.description,
    this.categories = const [],
    this.rating = 4.5,
    this.reviewCount = 0,
  });

  final String id;
  final String name;
  final String imageUrl;
  final int price;
  final int? priceS;
  final int? priceM;
  final int? priceL;
  final int? priceXL;
  final String? description;
  final List<String> categories;
  final double rating;
  final int reviewCount;

  int getPriceForSizeIndex(int index) {
    switch (index) {
      case 0:
        return priceS ?? price;
      case 1:
        return priceM ?? price;
      case 2:
        return priceL ?? price;
      case 3:
        return priceXL ?? price;
      default:
        return priceM ?? price;
    }
  }

  static String _parseId(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Map && value['\$oid'] != null) return value['\$oid'] as String;
    return value.toString();
  }

  static double _parseRating(dynamic value) {
    if (value == null) return 4.5;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    return 4.5;
  }

  factory Coffee.fromJson(Map<String, dynamic> json) {
    final idVal = json['id'] ?? json['_id'];
    return Coffee(
      id: idVal != null ? _parseId(idVal) : '',
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      priceS: (json['priceS'] as num?)?.toInt(),
      priceM: (json['priceM'] as num?)?.toInt(),
      priceL: (json['priceL'] as num?)?.toInt(),
      priceXL: (json['priceXL'] as num?)?.toInt(),
      description: json['description'] as String?,
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      rating: _parseRating(json['rating']),
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'price': price,
    if (priceS != null) 'priceS': priceS,
    if (priceM != null) 'priceM': priceM,
    if (priceL != null) 'priceL': priceL,
    if (priceXL != null) 'priceXL': priceXL,
    if (description != null) 'description': description,
    'categories': categories,
    'rating': rating,
    'reviewCount': reviewCount,
  };
}
