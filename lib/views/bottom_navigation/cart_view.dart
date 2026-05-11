import 'package:coffee_app/core/constants/app_constants.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/models/cart_item.dart';
import 'package:coffee_app/data/repositories/cart_repository.dart';
import 'package:coffee_app/views/checkout_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartEmptyView extends StatelessWidget {
  const CartEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80.sp,
              color: colors.textHint,
            ),
            SizedBox(height: 16.h),
            Text(
              'Sepetiniz boş',
              style: TextStyle(
                fontSize: 18.sp,
                color: colors.textPrimary,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final _repo = CartRepository.instance;

  @override
  void initState() {
    super.initState();
    _repo.ensureLoaded();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return ListenableBuilder(
      listenable: _repo,
      builder: (context, _) {
        final items = _repo.getItems();
        if (items.isEmpty) {
          return const CartEmptyView();
        }
        return Scaffold(
          backgroundColor: colors.backgroundPrimary,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Sepetim',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                            fontFamily: AppConstants.fontFamily,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        ...items.map(
                          (item) => _CartItemRow(
                            item: item,
                            onIncrease: () => _repo.updateQuantity(
                              item.id,
                              item.quantity + 1,
                            ),
                            onDecrease: () => _repo.updateQuantity(
                              item.id,
                              item.quantity - 1,
                            ),
                            onRemove: () => _repo.removeItem(item.id),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).maybePop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: colors.accent.withValues(alpha: 0.7),
                              width: 1.5,
                            ),
                            foregroundColor: colors.accent,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: Text(
                            'Daha fazla ürün ekle',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppConstants.fontFamily,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
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
                        color: Colors.black.withValues(alpha: 0.16),
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Toplam',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: colors.textHint,
                              fontFamily: AppConstants.fontFamily,
                            ),
                          ),
                          Text(
                            '${_repo.grandTotal} TL',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                              fontFamily: AppConstants.fontFamily,
                            ),
                          ),
                        ],
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CheckoutView(),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.accent,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 14.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Ödemeye Geç',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppConstants.fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CartItemRow extends StatelessWidget {
  const _CartItemRow({
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final isLight = Theme.of(context).brightness == Brightness.light;
    final accent = colors.accent;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : colors.surfaceDark,
        borderRadius: BorderRadius.circular(16.r),
        border: isLight ? null : Border.all(color: colors.surfaceBorder),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: item.imageUrl.isEmpty
                ? Container(
                    width: 80.w,
                    height: 80.h,
                    color: colors.surfaceBorder,
                    child: Icon(
                      Icons.coffee_rounded,
                      size: 36.sp,
                      color: colors.textHint,
                    ),
                  )
                : Image.network(
                    item.imageUrl,
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80.w,
                      height: 80.h,
                      color: colors.surfaceBorder,
                      child: Icon(
                        Icons.coffee_rounded,
                        size: 36.sp,
                        color: colors.textHint,
                      ),
                    ),
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${item.unitPrice} TL',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: accent,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  item.optionsSummary,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: colors.textHint,
                    fontFamily: AppConstants.fontFamily,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _CircleButton(
                      icon: Icons.remove_rounded,
                      onTap: onDecrease,
                      accent: accent,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      '${item.quantity}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        fontFamily: AppConstants.fontFamily,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    _CircleButton(
                      icon: Icons.add_rounded,
                      onTap: onIncrease,
                      accent: accent,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 22.sp,
                        color: Colors.red.shade300,
                      ),
                      onPressed: onRemove,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    required this.accent,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 26.w,
        height: 26.w,
        decoration: BoxDecoration(
          color: accent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(icon, size: 14.sp, color: Colors.white),
      ),
    );
  }
}
