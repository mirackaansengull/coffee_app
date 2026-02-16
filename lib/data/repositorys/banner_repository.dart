/// Banner slider görselleri. Gerçek uygulamada API'den gelecek.
class BannerRepository {
  BannerRepository._();

  static final BannerRepository _instance = BannerRepository._();
  static BannerRepository get instance => _instance;

  /// Banner görsel URL listesi. API bağlandığında bu metot güncellenecek.
  List<String> getBannerImageUrls() => [
    'https://r.resimlink.com/g-5eUFwuD.webp',
    'https://r.resimlink.com/gmkvRDO.webp',
    'https://r.resimlink.com/pbYv9M.webp',
  ];
}
