/// Ürün detay sayfasındaki boyut, süt, şurup seçenekleri.
/// Gerçek uygulamada API'den veya ürüne özel gelebilir.
class ProductOptions {
  ProductOptions._();

  static const List<Map<String, dynamic>> sizes = [
    {'label': 'S', 'price': 85, 'iconSize': 22.0},
    {'label': 'M', 'price': 100, 'iconSize': 28.0},
    {'label': 'L', 'price': 115, 'iconSize': 34.0},
    {'label': 'XL', 'price': 130, 'iconSize': 40.0},
  ];

  static const List<Map<String, dynamic>> milkOptions = [
    {'label': 'Süt istemiyorum', 'price': 0},
    {'label': 'Standart süt', 'price': 0},
    {'label': 'Yağsız süt', 'price': 0},
    {'label': 'Laktozsuz', 'price': 0},
    {'label': 'Badem sütü', 'price': 30},
  ];

  static const List<String> syrupOptions = [
    'Fındık',
    'Karamel',
    'Vanilya',
    'Coconut',
    'Kiraz çiçeği',
    'Nane',
    'Tuzlu karamel',
    'Tarçın',
  ];

  static const int extraShotPrice = 25;
  static const int syrupPrice = 25;
}
