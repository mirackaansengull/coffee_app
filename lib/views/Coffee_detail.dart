import 'package:coffee_app/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoffeeDetail extends StatefulWidget {
  const CoffeeDetail({super.key});

  @override
  State<CoffeeDetail> createState() => _CoffeeDetailState();
}

class _CoffeeDetailState extends State<CoffeeDetail> {
  static const String _imageUrl =
      'https://i.lezzet.com.tr/images-800x600/46cb7ac3-c782-4738-bd67-16bc0733ef34-25a66585-419d-4e34-8547-0650bac57d30';
  static const String _description =
      'Geleneksel yöntemle, cezvede demlenen yoğun ve köpüklü Türk kahvesi. Yanında lokum ile servis edilir.';

  int _selectedSizeIndex = 1;
  int _quantity = 1;
  int _milkIndex = 0;
  bool _extraShot = false;
  final List<bool> _syrups = List.filled(8, false);
  bool _showAppBarTitle = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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

  static const List<Map<String, dynamic>> _sizes = [
    {'label': 'S', 'price': 85, 'iconSize': 22.0},
    {'label': 'M', 'price': 100, 'iconSize': 28.0},
    {'label': 'L', 'price': 115, 'iconSize': 34.0},
    {'label': 'XL', 'price': 130, 'iconSize': 40.0},
  ];

  static const List<Map<String, dynamic>> _milkOptions = [
    {'label': 'Süt istemiyorum', 'price': 0},
    {'label': 'Standart süt', 'price': 0},
    {'label': 'Yağsız süt', 'price': 0},
    {'label': 'Laktozsuz', 'price': 0},
    {'label': 'Badem sütü', 'price': 30},
  ];

  static const List<String> _syrupOptions = [
    'Fındık', 'Karamel', 'Vanilya', 'Coconut', 'Kiraz çiçeği', 'Nane', 'Tuzlu karamel', 'Tarçın',
  ];

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
    if (_extraShot) t += 25;
    for (int i = 0; i < _syrups.length; i++) if (_syrups[i]) t += 25;
    return t;
  }

  int get _totalPrice => (_basePrice + _extrasPrice) * _quantity;

  @override
  Widget build(BuildContext context) {
    final brown = const Color(0xFF8B4513);
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 220.h,
            pinned: true,
            backgroundColor: AppColors.backgroundPrimary,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
              onPressed: () => Navigator.pop(context),
              color: AppColors.textPrimary,
            ),
            title: _showAppBarTitle
                ? Text('Türk Kahvesi',
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontFamily: 'Poppins'))
                : null,
            flexibleSpace: FlexibleSpaceBar(background: Image.network(_imageUrl, fit: BoxFit.cover)),
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
                        child: Text('Türk Kahvesi',
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                fontFamily: 'Poppins')),
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
                                    color: AppColors.surfaceDark,
                                    borderRadius: BorderRadius.circular(10.r)),
                                child: Icon(Icons.remove_rounded, color: AppColors.textPrimary, size: 18.sp)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Text('$_quantity',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                    fontFamily: 'Poppins')),
                          ),
                          InkWell(
                            onTap: () => setState(() => _quantity++),
                            borderRadius: BorderRadius.circular(10.r),
                            child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                    color: AppColors.surfaceDark,
                                    borderRadius: BorderRadius.circular(10.r)),
                                child: Icon(Icons.add_rounded, color: AppColors.textPrimary, size: 18.sp)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(_description,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textHint,
                          fontFamily: 'Poppins',
                          height: 1.35)),
                  SizedBox(height: 14.h),
                  Text('Boyut',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins')),
                  SizedBox(height: 8.h),
                  ...List.generate(
                      _sizes.length,
                      (i) {
                        final sz = _sizes[i];
                        final sizeLabel = sz['label']?.toString() ?? '';
                        final sizePrice = sz['price'] is int ? sz['price'] as int : 0;
                        final iconSz = (sz['iconSize'] is num) ? (sz['iconSize'] as num) : 28.0;
                        return Padding(
                            padding: EdgeInsets.only(bottom: 6.h),
                            child: InkWell(
                              onTap: () => setState(() => _selectedSizeIndex = i),
                              borderRadius: BorderRadius.circular(10.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                                decoration: BoxDecoration(
                                    color: _selectedSizeIndex == i
                                        ? brown.withValues(alpha: 0.3)
                                        : AppColors.surfaceDark,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                        color: _selectedSizeIndex == i ? brown : AppColors.surfaceMedium,
                                        width: _selectedSizeIndex == i ? 2 : 1)),
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
                                            errorBuilder: (_, __, ___) => Icon(
                                              Icons.coffee_rounded,
                                              size: iconSz.sp,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(sizeLabel,
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                            fontFamily: 'Poppins')),
                                    const Spacer(),
                                    Text('$sizePrice TL',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textPrimary,
                                            fontFamily: 'Poppins')),
                                  ],
                                ),
                              ),
                            ),
                          );
                      }),
                  SizedBox(height: 14.h),
                  Text('Süt seçimi',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins')),
                  SizedBox(height: 6.h),
                  ...List.generate(
                      _milkOptions.length,
                      (i) {
                        final opt = _milkOptions[i];
                        final label = opt['label']?.toString() ?? '';
                        final price = opt['price'] is int ? opt['price'] as int : 0;
                        return Padding(
                            padding: EdgeInsets.only(bottom: 4.h),
                            child: InkWell(
                              onTap: () => setState(() => _milkIndex = i),
                              borderRadius: BorderRadius.circular(8.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                                decoration: BoxDecoration(
                                    color: _milkIndex == i
                                        ? brown.withValues(alpha: 0.3)
                                        : AppColors.surfaceDark,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                        color: _milkIndex == i ? brown : AppColors.surfaceMedium,
                                        width: _milkIndex == i ? 2 : 1)),
                                child: Row(
                                  children: [
                                    Text(label,
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: AppColors.textPrimary,
                                            fontFamily: 'Poppins')),
                                    if (price > 0)
                                      Text(' (+$price TL)',
                                          style: TextStyle(
                                              fontSize: 11.sp,
                                              color: AppColors.textHint,
                                              fontFamily: 'Poppins')),
                                  ],
                                ),
                              ),
                            ),
                          );
                      }),
                  SizedBox(height: 14.h),
                  Text('Ekstra shot',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins')),
                  SizedBox(height: 6.h),
                  InkWell(
                    onTap: () => setState(() => _extraShot = !_extraShot),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                          color: _extraShot ? brown.withValues(alpha: 0.3) : AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                              color: _extraShot ? brown : AppColors.surfaceMedium,
                              width: _extraShot ? 2 : 1)),
                      child: Row(
                        children: [
                          Text('Extra shot klasik içim',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textPrimary,
                                  fontFamily: 'Poppins')),
                          Text(' (+25 TL)',
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textHint,
                                  fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text('Ekstra şurup seçimi',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins')),
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: List.generate(
                        _syrupOptions.length,
                        (i) => FilterChip(
                              label: Text(
                                  '${_syrupOptions[i]} (+25)',
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      fontFamily: 'Poppins',
                                      color: AppColors.textPrimary)),
                              selected: _syrups[i],
                              onSelected: (_) => setState(() => _syrups[i] = !_syrups[i]),
                              backgroundColor: AppColors.surfaceDark,
                              selectedColor: brown.withValues(alpha: 0.3),
                              checkmarkColor: brown,
                              labelStyle: TextStyle(
                                  fontSize: 11.sp,
                                  fontFamily: 'Poppins',
                                  color: AppColors.textPrimary),
                              side: BorderSide(
                                  color: _syrups[i] ? brown : AppColors.surfaceMedium),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r)),
                            )),
                  ),
                  SizedBox(height: 60.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h + MediaQuery.paddingOf(context).bottom),
        decoration: BoxDecoration(
            color: AppColors.backgroundPrimary,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, -2))
            ]),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Toplam',
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textHint,
                          fontFamily: 'Poppins')),
                  Text('$_totalPrice TL',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins')),
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
                          borderRadius: BorderRadius.circular(10.r)),
                      textStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins')),
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
