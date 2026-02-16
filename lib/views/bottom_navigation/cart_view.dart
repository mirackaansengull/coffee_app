import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/repositorys/cart_repository.dart';
import 'package:coffee_app/data/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartEmptyView extends StatelessWidget {
  const CartEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundSecondary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: colors.textHint,
            ),
            const SizedBox(height: 16),
            Text(
              'Sepetiniz boş',
              style: TextStyle(
                fontSize: 18,
                color: colors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final items = CartRepository.instance.getItems();
    if (items.isEmpty) {
      return const CartEmptyView();
    }
    return Scaffold(
      backgroundColor: colors.backgroundSecondary,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: colors.gradientBackground),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(12.w, 20.h, 20.w, 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sepetim', style: TextTheme.of(context).titleLarge),
                SizedBox(height: 24.h),
                Column(
                  children: items
                      .map((item) => _CartItemRow(item: item))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  const _CartItemRow({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        decoration: BoxDecoration(
          color: colors.backgroundPrimary,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image(
                  image: NetworkImage(item.imageUrl),
                  width: 80.w,
                  height: 80.h,
                  fit: BoxFit.cover,
                ),
              ),
              Spacer(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: TextTheme.of(context).titleLarge),
                    Text(
                      '${item.unitPrice} TL x ${item.quantity}',
                      style: TextTheme.of(context).bodyLarge,
                    ),
                    Text(
                      '${item.totalPrice} TL',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
