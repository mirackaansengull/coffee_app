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
                        SizedBox(height: 100.h),
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
                    color: colors.surfaceDark,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
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
                              fontSize: 20.sp,
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
                          backgroundColor: const Color(0xFF8B4513),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 14.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: const Text('Ödemeye Geç'),
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
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colors.surfaceDark,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.surfaceBorder),
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
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
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
                SizedBox(height: 6.h),
                Text(
                  '${item.unitPrice} TL x ${item.quantity} = ${item.totalPrice} TL',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    InkWell(
                      onTap: onDecrease,
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: colors.backgroundPrimary,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: colors.surfaceBorder),
                        ),
                        child: Icon(
                          Icons.remove_rounded,
                          size: 18.sp,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        '${item.quantity}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                          fontFamily: AppConstants.fontFamily,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: onIncrease,
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: colors.backgroundPrimary,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: colors.surfaceBorder),
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          size: 18.sp,
                          color: colors.textPrimary,
                        ),
                      ),
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
