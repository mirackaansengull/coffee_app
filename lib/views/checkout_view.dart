import 'package:coffee_app/core/constants/app_constants.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/models/cart_item.dart';
import 'package:coffee_app/data/models/delivery_location.dart';
import 'package:coffee_app/data/models/saved_card.dart';
import 'package:coffee_app/data/repositories/card_repository.dart';
import 'package:coffee_app/data/repositories/cart_repository.dart';
import 'package:coffee_app/data/repositories/location_repository.dart';
import 'package:coffee_app/data/repositories/order_repository.dart';
import 'package:coffee_app/widgets/home/location_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final _cartRepo = CartRepository.instance;
  final _locationRepo = LocationRepository.instance;
  final _cardRepo = CardRepository.instance;

  List<SavedCard> _cards = [];
  SavedCard? _selectedCard;
  bool _loadingCards = true;
  bool _placingOrder = false;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final cards = await _cardRepo.getCards();
    if (mounted) {
      setState(() {
        _cards = cards;
        _loadingCards = false;
        if (_selectedCard == null && cards.isNotEmpty) {
          _selectedCard = cards.first;
        }
      });
    }
  }

  Future<void> _placeOrder() async {
    final location = _locationRepo.selected;
    if (location == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen teslimat konumu seçin')),
      );
      return;
    }
    final items = _cartRepo.getItems();
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sepetiniz boş')),
      );
      return;
    }
    if (_placingOrder) return;
    setState(() => _placingOrder = true);
    final total = _cartRepo.grandTotal;
    final success = await OrderRepository.instance.createOrder(
      items: items,
      total: total,
      delivery: location,
    );
    if (!mounted) return;
    setState(() => _placingOrder = false);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sipariş gönderilemedi. Bağlantı zaman aşımı veya sunucu yanıt vermiyor olabilir; tekrar deneyin.',
          ),
        ),
      );
      return;
    }
    for (final item in List<CartItem>.from(items)) {
      _cartRepo.removeItem(item.id);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Siparişiniz alındı')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      appBar: AppBar(
        title: Text(
          'Ödeme',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
        backgroundColor: colors.backgroundPrimary,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListenableBuilder(
        listenable: _cartRepo,
        builder: (context, _) {
          final currentItems = _cartRepo.getItems();
          final currentTotal = _cartRepo.grandTotal;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SectionTitle(title: 'Teslimat adresi'),
                SizedBox(height: 8.h),
                ListenableBuilder(
                  listenable: _locationRepo,
                  builder: (_, __) => _AddressCard(
                    location: _locationRepo.selected,
                    onTap: () => showLocationPickerSheet(context),
                  ),
                ),
                SizedBox(height: 24.h),
                _SectionTitle(title: 'Sipariş özeti'),
                SizedBox(height: 8.h),
                ...currentItems.map(
                  (item) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${item.name} x${item.quantity}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: colors.textPrimary,
                              fontFamily: AppConstants.fontFamily,
                            ),
                          ),
                        ),
                        Text(
                          '${item.totalPrice} TL',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                            fontFamily: AppConstants.fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(color: colors.surfaceBorder, height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Toplam',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        fontFamily: AppConstants.fontFamily,
                      ),
                    ),
                    Text(
                      '$currentTotal TL',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: AppConstants.fontFamily,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                _SectionTitle(title: 'Ödeme yöntemi'),
                SizedBox(height: 8.h),
                if (_loadingCards)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Center(
                      child: SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.progressIndicator,
                        ),
                      ),
                    ),
                  )
                else if (_cards.isEmpty)
                  _PaymentTile(
                    title: 'Kart bilgisi kayıtlı değil',
                    subtitle: 'Profil > Ödeme Yöntemleri\'nden kart ekleyebilir veya kapıda ödeyebilirsiniz.',
                    isSelected: true,
                    onTap: () {},
                  )
                else
                  ..._cards.map(
                    (card) => _PaymentTile(
                      title: '${card.maskedNumber} · ${card.holderName}',
                      subtitle: card.expiry,
                      isSelected: _selectedCard?.id == card.id,
                      onTap: () => setState(() => _selectedCard = card),
                    ),
                  ),
                SizedBox(height: 32.h),
                FilledButton(
                  onPressed: _placingOrder ? null : _placeOrder,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF8B4513),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: _placingOrder
                      ? SizedBox(
                          height: 22.h,
                          width: 22.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Siparişi tamamla'),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: colors.textHint,
        fontFamily: AppConstants.fontFamily,
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.location,
    required this.onTap,
  });

  final DeliveryLocation? location;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: colors.surfaceDark,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colors.surfaceBorder),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 28.sp,
                color: colors.textHint,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: location == null
                    ? Text(
                        'Konumunuzu seçin (şehir → mahalle)',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colors.textHint,
                          fontFamily: AppConstants.fontFamily,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location!.summary,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                              fontFamily: AppConstants.fontFamily,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            location!.address,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: colors.textHint,
                              fontFamily: AppConstants.fontFamily,
                            ),
                          ),
                        ],
                      ),
              ),
              Icon(Icons.chevron_right_rounded, color: colors.textHint),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: colors.surfaceDark,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? const Color(0xFF8B4513) : colors.surfaceBorder,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  size: 22.sp,
                  color: isSelected ? const Color(0xFF8B4513) : colors.textHint,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                          fontFamily: AppConstants.fontFamily,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colors.textHint,
                            fontFamily: AppConstants.fontFamily,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
