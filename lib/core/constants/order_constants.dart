/// Sipariş durumu ve adım etiketleri.
class OrderConstants {
  OrderConstants._();

  static const List<String> statusLabels = [
    'Onay bekliyor',
    'Hazırlanıyor',
    'Sipariş hazır',
    'Teslim edildi',
  ];

  static const List<String> stepLabels = [
    'Onay',
    'Hazırlanıyor',
    'Hazır',
    'Teslim',
  ];
}
