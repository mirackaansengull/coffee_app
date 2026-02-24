class SavedCard {
  const SavedCard({
    required this.id,
    required this.holderName,
    required this.lastFour,
    required this.expiryMonth,
    required this.expiryYear,
  });

  final String id;
  final String holderName;
  final String lastFour;
  final int expiryMonth;
  final int expiryYear;

  String get maskedNumber => '**** **** **** $lastFour';
  String get expiry {
    final y = expiryYear.toString();
    final yearShort = y.length >= 2 ? y.substring(y.length - 2) : y;
    return '${expiryMonth.toString().padLeft(2, '0')}/$yearShort';
  }

  factory SavedCard.fromJson(Map<String, dynamic> json) {
    return SavedCard(
      id: json['id'] as String? ?? '',
      holderName: json['holderName'] as String? ?? '',
      lastFour: json['lastFour'] as String? ?? '',
      expiryMonth: (json['expiryMonth'] as num?)?.toInt() ?? 0,
      expiryYear: (json['expiryYear'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'holderName': holderName,
    'lastFour': lastFour,
    'expiryMonth': expiryMonth,
    'expiryYear': expiryYear,
  };
}
