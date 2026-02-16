class BannerRepository {
  BannerRepository._();

  static final BannerRepository _instance = BannerRepository._();
  static BannerRepository get instance => _instance;

  List<String> getBannerImageUrls() => [
    'https://r.resimlink.com/g-5eUFwuD.webp',
    'https://r.resimlink.com/gmkvRDO.webp',
    'https://r.resimlink.com/pbYv9M.webp',
  ];
}
