import 'package:coffee_app/data/models/delivery_location.dart';

/// Bayi bilgisi: şehir, mahalle, adres. Tüm bayiler "Aromacafe" adıyla.
class BranchInfo {
  const BranchInfo({
    required this.city,
    required this.neighborhood,
    required this.address,
  });

  final String city;
  final String neighborhood;
  final String address;

  static const branchName = 'Aromacafe';

  DeliveryLocation toDeliveryLocation() => DeliveryLocation(
        city: city,
        neighborhood: neighborhood,
        branchName: branchName,
        address: address,
      );
}

/// 10 şehir, her şehirde 5 bayi (mahalle + adres).
final List<BranchInfo> allBranches = [
  // Muğla - 5 bayi
  const BranchInfo(city: 'Muğla', neighborhood: 'Menteşe', address: 'Atatürk Bulvarı No: 42, Menteşe'),
  const BranchInfo(city: 'Muğla', neighborhood: 'Bodrum', address: 'Cumhuriyet Caddesi No: 18, Bodrum'),
  const BranchInfo(city: 'Muğla', neighborhood: 'Marmaris', address: 'Kordon Yolu No: 7, Marmaris'),
  const BranchInfo(city: 'Muğla', neighborhood: 'Fethiye', address: 'Fevzi Çakmak Sokak No: 23, Fethiye'),
  const BranchInfo(city: 'Muğla', neighborhood: 'Dalaman', address: 'Havaalanı Yolu No: 5, Dalaman'),
  // İzmir - 5 bayi
  const BranchInfo(city: 'İzmir', neighborhood: 'Konak', address: 'Alsancak Cumhuriyet Bulvarı No: 88, Konak'),
  const BranchInfo(city: 'İzmir', neighborhood: 'Karşıyaka', address: 'Bostanlı Sahil Yolu No: 12, Karşıyaka'),
  const BranchInfo(city: 'İzmir', neighborhood: 'Bornova', address: 'Ege Üniversitesi Kampüs Karşısı No: 3, Bornova'),
  const BranchInfo(city: 'İzmir', neighborhood: 'Çeşme', address: 'İlica Plaj Yolu No: 15, Çeşme'),
  const BranchInfo(city: 'İzmir', neighborhood: 'Aliağa', address: 'Sanayi Caddesi No: 44, Aliağa'),
  // Ankara - 5 bayi
  const BranchInfo(city: 'Ankara', neighborhood: 'Çankaya', address: 'Tunalı Hilmi Caddesi No: 56, Çankaya'),
  const BranchInfo(city: 'Ankara', neighborhood: 'Kızılay', address: 'Kızılay Meydanı No: 22, Kızılay'),
  const BranchInfo(city: 'Ankara', neighborhood: 'Ulus', address: 'Anafartalar Caddesi No: 31, Ulus'),
  const BranchInfo(city: 'Ankara', neighborhood: 'Bahçelievler', address: '7. Cadde No: 19, Bahçelievler'),
  const BranchInfo(city: 'Ankara', neighborhood: 'Yenimahalle', address: 'İvedik Caddesi No: 8, Yenimahalle'),
  // İstanbul - 5 bayi
  const BranchInfo(city: 'İstanbul', neighborhood: 'Kadıköy', address: 'Caferağa Mah. Moda Caddesi No: 14, Kadıköy'),
  const BranchInfo(city: 'İstanbul', neighborhood: 'Beşiktaş', address: 'Barbaros Bulvarı No: 67, Beşiktaş'),
  const BranchInfo(city: 'İstanbul', neighborhood: 'Bakırköy', address: 'Ataköy 7-8 Mah. No: 2, Bakırköy'),
  const BranchInfo(city: 'İstanbul', neighborhood: 'Şişli', address: 'Mecidiyeköy Yolu No: 33, Şişli'),
  const BranchInfo(city: 'İstanbul', neighborhood: 'Üsküdar', address: 'Altunizade Mah. Kısıklı Caddesi No: 11, Üsküdar'),
  // Antalya - 5 bayi
  const BranchInfo(city: 'Antalya', neighborhood: 'Lara', address: 'Lara Caddesi No: 90, Lara'),
  const BranchInfo(city: 'Antalya', neighborhood: 'Konyaaltı', address: 'Konyaaltı Sahil Yolu No: 4, Konyaaltı'),
  const BranchInfo(city: 'Antalya', neighborhood: 'Kaleiçi', address: 'Kaleiçi İçi Sokak No: 17, Kaleiçi'),
  const BranchInfo(city: 'Antalya', neighborhood: 'Kepez', address: 'Varsak Caddesi No: 25, Kepez'),
  const BranchInfo(city: 'Antalya', neighborhood: 'Muratpaşa', address: 'Sinan Mah. 100. Yıl Bulvarı No: 6, Muratpaşa'),
  // Bursa - 5 bayi
  const BranchInfo(city: 'Bursa', neighborhood: 'Nilüfer', address: 'Özlüce Mah. Beşevler Caddesi No: 9, Nilüfer'),
  const BranchInfo(city: 'Bursa', neighborhood: 'Osmangazi', address: 'Heykel Meydanı No: 21, Osmangazi'),
  const BranchInfo(city: 'Bursa', neighborhood: 'Yıldırım', address: 'Millet Caddesi No: 38, Yıldırım'),
  const BranchInfo(city: 'Bursa', neighborhood: 'Mudanya', address: 'Sahil Yolu No: 12, Mudanya'),
  const BranchInfo(city: 'Bursa', neighborhood: 'İnegöl', address: 'Turgutalp Mah. Sanayi Caddesi No: 55, İnegöl'),
  // Adana - 5 bayi
  const BranchInfo(city: 'Adana', neighborhood: 'Seyhan', address: 'Atatürk Parkı Karşısı No: 13, Seyhan'),
  const BranchInfo(city: 'Adana', neighborhood: 'Çukurova', address: 'Toros Mah. 5. Sokak No: 7, Çukurova'),
  const BranchInfo(city: 'Adana', neighborhood: 'Yüreğir', address: 'Kışla Mah. 100. Yıl No: 29, Yüreğir'),
  const BranchInfo(city: 'Adana', neighborhood: 'Sarıçam', address: 'Çukurova Üniversitesi Yanı No: 1, Sarıçam'),
  const BranchInfo(city: 'Adana', neighborhood: 'Seyhan Merkez', address: 'Tepebağ Mah. Tarihi Bina No: 4, Seyhan'),
  // Konya - 5 bayi
  const BranchInfo(city: 'Konya', neighborhood: 'Selçuklu', address: 'Bosna Hersek Caddesi No: 16, Selçuklu'),
  const BranchInfo(city: 'Konya', neighborhood: 'Meram', address: 'Meram Bağları Yolu No: 20, Meram'),
  const BranchInfo(city: 'Konya', neighborhood: 'Karatay', address: 'Alaeddin Tepesi Karşısı No: 10, Karatay'),
  const BranchInfo(city: 'Konya', neighborhood: 'Meram Yeni', address: 'Havzan Mah. 414. Sokak No: 3, Meram'),
  const BranchInfo(city: 'Konya', neighborhood: 'Selçuklu OSB', address: '2. Organize Sanayi No: 77, Selçuklu'),
  // Gaziantep - 5 bayi
  const BranchInfo(city: 'Gaziantep', neighborhood: 'Şahinbey', address: 'Suburcu Caddesi No: 41, Şahinbey'),
  const BranchInfo(city: 'Gaziantep', neighborhood: 'Şehitkamil', address: 'Mavikent Mah. 100. Yıl No: 8, Şehitkamil'),
  const BranchInfo(city: 'Gaziantep', neighborhood: 'Karataş', address: 'Karataş Mah. Zeugma Sokak No: 22, Karataş'),
  const BranchInfo(city: 'Gaziantep', neighborhood: 'Düztepe', address: 'Düztepe Mah. Atatürk Bulvarı No: 35, Düztepe'),
  const BranchInfo(city: 'Gaziantep', neighborhood: 'Mavikent', address: 'Mavikent Bulvarı No: 19, Mavikent'),
  // Mersin - 5 bayi
  const BranchInfo(city: 'Mersin', neighborhood: 'Mezitli', address: 'Veni Vidi Vici Caddesi No: 6, Mezitli'),
  const BranchInfo(city: 'Mersin', neighborhood: 'Yenişehir', address: 'İstiklal Caddesi No: 48, Yenişehir'),
  const BranchInfo(city: 'Mersin', neighborhood: 'Toroslar', address: 'Toroslar Mah. 45. Sokak No: 11, Toroslar'),
  const BranchInfo(city: 'Mersin', neighborhood: 'Akdeniz', address: 'Limonluk Sahil Yolu No: 27, Akdeniz'),
  const BranchInfo(city: 'Mersin', neighborhood: 'Tece', address: 'Tece Koyu Sahil No: 2, Tece'),
];

/// Şehir listesi (benzersiz, sıralı).
List<String> get cities =>
    allBranches.map((b) => b.city).toSet().toList()..sort();

/// Verilen şehirdeki mahalleler (o şehirdeki bayilerin mahalleleri).
List<String> getNeighborhoodsForCity(String city) =>
    allBranches
        .where((b) => b.city == city)
        .map((b) => b.neighborhood)
        .toList();

/// Şehir + mahalle için bayi bilgisi (tek eşleşme).
BranchInfo? getBranchForCityAndNeighborhood(String city, String neighborhood) {
  try {
    return allBranches.firstWhere(
      (b) => b.city == city && b.neighborhood == neighborhood,
    );
  } catch (_) {
    return null;
  }
}
