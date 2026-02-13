import 'package:coffee_app/core/constants/order_constants.dart';
import 'package:coffee_app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LastOrderCard extends StatefulWidget {
  const LastOrderCard({
    super.key,
    required this.orderStep,
    required this.orderDate,
    required this.orderTime,
  });

  final int orderStep;
  final String orderDate;
  final String orderTime;

  @override
  State<LastOrderCard> createState() => _LastOrderCardState();
}

class _LastOrderCardState extends State<LastOrderCard> {
  static const Color _orange = Color(0xFFFF9800);
  int _orderRating = 0;

  @override
  Widget build(BuildContext context) {
    final step = widget.orderStep;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.surfaceMedium, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Son sipariş',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                '${widget.orderDate} · ${widget.orderTime}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textHint,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            OrderConstants.statusLabels[step],
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: _orange,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 14.h),
          _buildProgressBar(step),
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (i) => Text(
                  OrderConstants.stepLabels[i],
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: AppColors.textHint,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),
          if (step == 3) ..._buildRatingSection(),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int step) {
    return Row(
      children: List.generate(4, (i) {
        final isFilled = i <= step;
        return Expanded(
          child: Container(
            height: 6.h,
            margin: EdgeInsets.only(right: i < 3 ? 2.w : 0),
            decoration: BoxDecoration(
              color: isFilled ? _orange : AppColors.surfaceMedium,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(i == 0 ? 3.r : 0),
                right: Radius.circular(i == 3 ? 3.r : 0),
              ),
            ),
          ),
        );
      }),
    );
  }

  List<Widget> _buildRatingSection() {
    return [
      SizedBox(height: 16.h),
      Text(
        '5 yıldız üzerinden puan verin',
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.textHint,
          fontFamily: 'Poppins',
        ),
      ),
      SizedBox(height: 8.h),
      Row(
        children: List.generate(5, (i) {
          final star = i + 1;
          final selected = _orderRating >= star;
          return Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: InkWell(
              onTap: () => setState(() => _orderRating = star),
              borderRadius: BorderRadius.circular(8.r),
              child: Icon(
                selected ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 28.sp,
                color: selected ? _orange : AppColors.textHint,
              ),
            ),
          );
        }),
      ),
    ];
  }
}
