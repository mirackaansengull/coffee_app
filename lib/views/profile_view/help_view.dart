import 'package:coffee_app/core/constants/app_constants.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      appBar: AppBar(
        title: Text(
          'Yardım',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Section(
              title: 'Sipariş Nasıl Verilir?',
              body:
                  'Kahve detay sayfasından boyut, süt ve şurup seçeneklerinizi belirleyip "Sepete Ekle" butonuna basın. Sepet sayfasından siparişinizi tamamlayabilirsiniz.',
            ),
            SizedBox(height: 24.h),
            _Section(
              title: 'Favoriler Nasıl Kullanılır?',
              body:
                  'Kahve kartlarındaki kalp ikonuna basarak ürünü favorilere ekleyebilir veya çıkarabilirsiniz. Favoriler sekmesinden kaydettiğiniz tüm kahveleri görebilirsiniz.',
            ),
            SizedBox(height: 24.h),
            _Section(
              title: 'Ödeme Yöntemleri',
              body:
                  'Profil sayfasından "Ödeme Yöntemleri"ne girerek kayıtlı kartlarınızı yönetebilir, yeni kart ekleyebilirsiniz.',
            ),
            SizedBox(height: 24.h),
            _Section(
              title: 'İletişim',
              body: 'Sorularınız için: destek@kahveapp.com',
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          body,
          style: TextStyle(
            fontSize: 14.sp,
            height: 1.5,
            color: colors.textHint,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
      ],
    );
  }
}
