import 'package:coffee_app/core/constants/product_options.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/models/coffee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoffeeDetail extends StatefulWidget {
  const CoffeeDetail({super.key, required this.coffee});

  final Coffee coffee;

  @override
  State<CoffeeDetail> createState() => _CoffeeDetailState();
}

class _CoffeeDetailState extends State<CoffeeDetail> {
  int _selectedSizeIndex = 1;
  int _quantity = 1;
  int _milkIndex = 0;
  bool _extraShot = false;
  late final List<bool> _syrups;
  bool _showAppBarTitle = false;
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> get _sizes => ProductOptions.sizes;
  List<Map<String, dynamic>> get _milkOptions => ProductOptions.milkOptions;
  List<String> get _syrupOptions => ProductOptions.syrupOptions;

  @override
  void initState() {
    super.initState();
    _syrups = List.filled(ProductOptions.syrupOptions.length, false);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final threshold = 220.h - 56;
    final show = _scrollController.offset >= threshold;
    if (show != _showAppBarTitle) setState(() => _showAppBarTitle = show);
  }

  int get _basePrice {
    final i = _selectedSizeIndex.clamp(0, _sizes.length - 1);
    final p = _sizes[i]['price'];
    return (p is int) ? p : 0;
  }

  int get _extrasPrice {
    int t = 0;
    final mi = _milkIndex.clamp(0, _milkOptions.length - 1);
    final mp = _milkOptions[mi]['price'];
    if (mp is int) t += mp;
    if (_extraShot) t += ProductOptions.extraShotPrice;
    for (int i = 0; i < _syrups.length; i++) {
      if (_syrups[i]) t += ProductOptions.syrupPrice;
    }
    return t;
  }

  int get _totalPrice => (_basePrice + _extrasPrice) * _quantity;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final brown = const Color(0xFF8B4513);
    final iconColor = Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white;
    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 220.h,
            pinned: true,
            backgroundColor: colors.backgroundPrimary,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20.sp,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
              color: Colors.white,
            ),
            title: _showAppBarTitle
                ? Text(
                    widget.coffee.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  )
                : null,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.coffee.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.coffee.name,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              if (_quantity > 1) setState(() => _quantity--);
                            },
                            borderRadius: BorderRadius.circular(10.r),
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: colors.surfaceDark,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: colors.surfaceBorder,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.remove_rounded,
                                color: colors.textPrimary,
                                size: 18.sp,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Text(
                              '$_quantity',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => setState(() => _quantity++),
                            borderRadius: BorderRadius.circular(10.r),
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: colors.surfaceDark,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: colors.surfaceBorder,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.add_rounded,
                                color: colors.textPrimary,
                                size: 18.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    widget.coffee.description ?? '',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w300,
                      color: colors.textHint,
                      fontFamily: 'Poppins',
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'Boyut',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ...List.generate(_sizes.length, (i) {
                    final sz = _sizes[i];
                    final sizeLabel = sz['label']?.toString() ?? '';
                    final sizePrice = sz['price'] is int
                        ? sz['price'] as int
                        : 0;
                    final iconSz = (sz['iconSize'] is num)
                        ? (sz['iconSize'] as num)
                        : 28.0;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 6.h),
                      child: InkWell(
                        onTap: () => setState(() => _selectedSizeIndex = i),
                        borderRadius: BorderRadius.circular(10.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.h,
                            horizontal: 12.w,
                          ),
                          decoration: BoxDecoration(
                            color: _selectedSizeIndex == i
                                ? brown.withValues(alpha: 0.3)
                                : colors.surfaceDark,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: _selectedSizeIndex == i
                                  ? brown
                                  : colors.surfaceBorder,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: _selectedSizeIndex == i ? 0.12 : 0.06,
                                ),
                                blurRadius: _selectedSizeIndex == i ? 10 : 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 48.w,
                                height: 44.h,
                                child: Center(
                                  child: SizedBox(
                                    width: iconSz.w,
                                    height: iconSz.h,
                                    child: Image.asset(
                                      'assets/icons/boy_secimi.png',
                                      fit: BoxFit.contain,
                                      color: iconColor,
                                      colorBlendMode: BlendMode.srcIn,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                            Icons.coffee_rounded,
                                            size: iconSz.sp,
                                            color: iconColor,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                sizeLabel,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textPrimary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '$sizePrice TL',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: colors.textPrimary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 14.h),
                  Text(
                    'Süt seçimi',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 6.h),
                  ...List.generate(_milkOptions.length, (i) {
                    final opt = _milkOptions[i];
                    final label = opt['label']?.toString() ?? '';
                    final price = opt['price'] is int ? opt['price'] as int : 0;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: InkWell(
                        onTap: () => setState(() => _milkIndex = i),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.h,
                            horizontal: 12.w,
                          ),
                          decoration: BoxDecoration(
                            color: _milkIndex == i
                                ? brown.withValues(alpha: 0.3)
                                : colors.surfaceDark,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: _milkIndex == i
                                  ? brown
                                  : colors.surfaceBorder,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: _milkIndex == i ? 0.12 : 0.06,
                                ),
                                blurRadius: _milkIndex == i ? 10 : 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(
                                label,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: colors.textPrimary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              if (price > 0)
                                Text(
                                  ' (+$price TL)',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: colors.textHint,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 14.h),
                  Text(
                    'Ekstra shot',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 6.h),
                  InkWell(
                    onTap: () => setState(() => _extraShot = !_extraShot),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 12.w,
                      ),
                      decoration: BoxDecoration(
                        color: _extraShot
                            ? brown.withValues(alpha: 0.3)
                            : colors.surfaceDark,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: _extraShot ? brown : colors.surfaceBorder,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: _extraShot ? 0.12 : 0.06,
                            ),
                            blurRadius: _extraShot ? 10 : 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Extra shot klasik içim',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: colors.textPrimary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            ' (+${ProductOptions.extraShotPrice} TL)',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: colors.textHint,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'Ekstra şurup seçimi',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: List.generate(
                      _syrupOptions.length,
                      (i) => FilterChip(
                        label: Text(
                          '${_syrupOptions[i]} (+${ProductOptions.syrupPrice})',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontFamily: 'Poppins',
                            color: colors.textPrimary,
                          ),
                        ),
                        selected: _syrups[i],
                        onSelected: (_) =>
                            setState(() => _syrups[i] = !_syrups[i]),
                        backgroundColor: colors.surfaceDark,
                        selectedColor: brown.withValues(alpha: 0.3),
                        checkmarkColor: brown,
                        labelStyle: TextStyle(
                          fontSize: 11.sp,
                          fontFamily: 'Poppins',
                          color: colors.textPrimary,
                        ),
                        side: BorderSide(
                          color: _syrups[i] ? brown : colors.surfaceBorder,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 60.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Toplam',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: colors.textHint,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    '$_totalPrice TL',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF8B4513),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    textStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  child: const Text('Sepete Ekle'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
