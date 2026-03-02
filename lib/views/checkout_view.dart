import 'package:coffee_app/core/constants/app_constants.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/models/cart_item.dart';
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
        const SnackBar(content: Text('Lütfen dükkan seçin')),
      );
      return;
    }
    final items = _cartRepo.getItems();
    if (items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sepetiniz boş')));
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Siparişiniz alındı')));
    Navigator.pop(context);
  }

  void _showCardPicker() {
    if (_cards.isEmpty) return;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final colors = AppThemeColors.of(ctx);
        return Container(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          decoration: BoxDecoration(
            color: colors.backgroundPrimary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      'Kart seçin',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: AppConstants.fontFamily,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: Icon(Icons.close, color: colors.textPrimary),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                ..._cards.map(
                  (card) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: _SelectRowCard(
                      title: card.maskedNumber,
                      subtitle: card.expiry,
                      trailing: _selectedCard?.id == card.id
                          ? Icon(
                              Icons.check_circle_rounded,
                              color: colors.accent,
                              size: 22.sp,
                            )
                          : Icon(
                              Icons.circle_outlined,
                              color: colors.surfaceBorder,
                              size: 22.sp,
                            ),
                      onTap: () {
                        setState(() => _selectedCard = card);
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      backgroundColor: isLight ? colors.backgroundPrimary : colors.backgroundPrimary,
      appBar: AppBar(
        centerTitle: true,
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
          final subTotal = _cartRepo.grandTotal;
          const deliveryFee = 0;
          final total = subTotal + deliveryFee;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SectionHeader(title: 'Dükkan Seçimi'),
                      SizedBox(height: 10.h),
                      ListenableBuilder(
                        listenable: _locationRepo,
                        builder: (_, __) {
                          final shop = _locationRepo.selected;
                          return _ActionCard(
                            leadingIcon: Icons.storefront_outlined,
                            title: shop?.summary ?? 'Dükkan seç',
                            subtitle: shop?.address ?? 'Şehir ve mahalle seçin',
                            actionLabel: shop == null ? 'Seç' : 'Düzenle',
                            onAction: () => showLocationPickerSheet(context),
                          );
                        },
                      ),
                      SizedBox(height: 20.h),
                      _SectionHeader(title: 'Ödeme Yöntemi'),
                      SizedBox(height: 10.h),
                      if (_loadingCards)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Center(
                            child: SizedBox(
                              width: 22.w,
                              height: 22.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.progressIndicator,
                              ),
                            ),
                          ),
                        )
                      else if (_cards.isEmpty)
                        _ActionCard(
                          leadingIcon: Icons.credit_card_rounded,
                          title: 'Kart eklenmedi',
                          subtitle:
                              'Profil > Ödeme Yöntemleri bölümünden kart ekleyin.',
                          actionLabel: 'Değiştir',
                          onAction: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Önce bir ödeme yöntemi ekleyin'),
                              ),
                            );
                          },
                        )
                      else
                        _ActionCard(
                          leadingIcon: Icons.credit_card_rounded,
                          title: _selectedCard?.maskedNumber ?? _cards.first.maskedNumber,
                          subtitle: _selectedCard?.expiry ?? _cards.first.expiry,
                          actionLabel: 'Değiştir',
                          onAction: _showCardPicker,
                        ),
                      SizedBox(height: 20.h),
                      _SectionHeader(title: 'Sipariş Özeti'),
                      SizedBox(height: 10.h),
                      _SummaryCard(
                        items: currentItems,
                        subTotal: subTotal,
                        deliveryFee: deliveryFee,
                        total: total,
                      ),
                      SizedBox(height: 12.h),
                      _InfoCard(
                        text:
                            'Siparişiniz yaklaşık 20–30 dakika içinde teslim edilecektir. Temassız teslimat seçeneği aktiftir.',
                      ),
                      SizedBox(height: 90.h),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                  16.w,
                  12.h,
                  16.w,
                  12.h + MediaQuery.paddingOf(context).bottom,
                ),
                decoration: BoxDecoration(
                  color: colors.backgroundPrimary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 52.h,
                  child: FilledButton(
                    onPressed: _placingOrder ? null : _placeOrder,
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: _placingOrder
                        ? SizedBox(
                            width: 22.w,
                            height: 22.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Siparişi Tamamla',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppConstants.fontFamily,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Icon(Icons.arrow_forward_rounded, size: 20.sp),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
        fontFamily: AppConstants.fontFamily,
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData leadingIcon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : colors.surfaceDark,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.5)),
        boxShadow: isLight
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: colors.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(leadingIcon, color: colors.accent, size: 22.sp),
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
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                    fontFamily: AppConstants.fontFamily,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colors.textHint,
                    fontFamily: AppConstants.fontFamily,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          FilledButton(
            onPressed: onAction,
            style: FilledButton.styleFrom(
              backgroundColor: isLight
                  ? const Color(0xFFF1F4F8)
                  : colors.surfaceMedium,
              foregroundColor: colors.textPrimary,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: Text(
              actionLabel,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.items,
    required this.subTotal,
    required this.deliveryFee,
    required this.total,
  });

  final List<CartItem> items;
  final int subTotal;
  final int deliveryFee;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : colors.surfaceDark,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.surfaceBorder.withValues(alpha: 0.5)),
        boxShadow: isLight
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: item.imageUrl.isEmpty
                        ? Container(
                            width: 44.w,
                            height: 44.w,
                            color: colors.surfaceBorder.withValues(alpha: 0.4),
                            child: Icon(
                              Icons.coffee_rounded,
                              size: 20.sp,
                              color: colors.textHint,
                            ),
                          )
                        : Image.network(
                            item.imageUrl,
                            width: 44.w,
                            height: 44.w,
                            fit: BoxFit.cover,
                          ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                            fontFamily: AppConstants.fontFamily,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          item.optionsSummary,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: colors.textHint,
                            fontFamily: AppConstants.fontFamily,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    '${item.totalPrice} TL',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      fontFamily: AppConstants.fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: colors.surfaceBorder.withValues(alpha: 0.5)),
          SizedBox(height: 8.h),
          _SummaryLine(label: 'Ara Toplam', value: '$subTotal TL'),
          SizedBox(height: 6.h),
          _SummaryLine(
            label: 'Teslimat Ücreti',
            value: deliveryFee == 0 ? 'Bedava' : '$deliveryFee TL',
            valueColor: deliveryFee == 0 ? Colors.green.shade600 : null,
          ),
          SizedBox(height: 10.h),
          Divider(color: colors.surfaceBorder.withValues(alpha: 0.5)),
          SizedBox(height: 10.h),
          _SummaryLine(
            label: 'Toplam',
            value: '$total TL',
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 14.sp : 12.sp,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? colors.textPrimary : colors.textHint,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16.sp : 12.sp,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: valueColor ?? (isTotal ? colors.accent : colors.textPrimary),
            fontFamily: AppConstants.fontFamily,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.accent.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: colors.accent, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: colors.textPrimary,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectRowCard extends StatelessWidget {
  const _SelectRowCard({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: colors.surfaceDark,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: colors.surfaceBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        fontFamily: AppConstants.fontFamily,
                      ),
                    ),
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
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
