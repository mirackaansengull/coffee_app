import 'dart:math';

import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/models/cart_item.dart';
import 'package:coffee_app/data/models/coffee.dart';
import 'package:coffee_app/data/repositories/cart_repository.dart';
import 'package:coffee_app/data/repositories/coffee_repository.dart';
import 'package:coffee_app/data/repositories/location_repository.dart';
import 'package:coffee_app/views/coffee_detail_view.dart';
import 'package:coffee_app/widgets/home/banner_slider.dart';
import 'package:coffee_app/widgets/home/home_categories.dart';
import 'package:coffee_app/widgets/home/location_bar.dart';
import 'package:coffee_app/widgets/home/location_picker_sheet.dart';
import 'package:coffee_app/widgets/shared/coffee_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _repo = CoffeeRepository();
  List<Coffee> _coffees = [];
  Map<String, bool> _favorites = {};
  bool _loading = true;
  int _selectedCategoryIndex = 0;

  List<Coffee> get _filteredCoffees {
    if (_selectedCategoryIndex == 0) return _coffees;
    final label = coffeeTypes[_selectedCategoryIndex].label;
    return _coffees.where((c) => c.categories.contains(label)).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final coffees = await _repo.getCoffees();
    final favorites = await _repo.getFavorites();
    final favIds = favorites.map((e) => e.id).toSet();
    final favMap = <String, bool>{};
    for (final c in coffees) {
      favMap[c.id] = favIds.contains(c.id);
    }
    setState(() {
      _coffees = coffees;
      _favorites = favMap;
      _loading = false;
    });
  }

  Future<void> _addToCart(Coffee coffee) async {
    final unitPrice = coffee.getPriceForSizeIndex(1);
    final item = CartItem(
      id:
          '${DateTime.now().millisecondsSinceEpoch}_${coffee.id}_${Random().nextInt(9999)}',
      productId: coffee.id,
      name: coffee.name,
      imageUrl: coffee.imageUrl,
      unitPrice: unitPrice,
      quantity: 1,
      sizeLabel: 'M',
      milkLabel: 'Standart süt',
      extraShot: false,
      syrupNames: const [],
    );
    await CartRepository.instance.addItem(item);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sepete eklendi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundSecondary,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: colors.gradientBackground),
        child: _loading
            ? Center(
                child: CircularProgressIndicator(
                  color: colors.progressIndicator,
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadData,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListenableBuilder(
                        listenable: LocationRepository.instance,
                        builder: (_, __) => GetLocation(
                          selectedSummary:
                              LocationRepository.instance.selected?.summary,
                          onTap: () => showLocationPickerSheet(context),
                        ),
                      ),
                      BannerSlider(),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Kategoriler',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Tümünü Gör',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: colors.accent,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 44.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          itemCount: coffeeTypes.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 12.w),
                          itemBuilder: (context, index) {
                            final category = coffeeTypes[index];
                            return Categories(
                              icon: category.icon,
                              label: category.label,
                              isSelected: _selectedCategoryIndex == index,
                              onTap: () => setState(
                                () => _selectedCategoryIndex = index,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Şimdi Popüler',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextButton(
                              onPressed: _loadData,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Yenile',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: colors.accent,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          bottom: 20.h,
                        ),
                        child: _filteredCoffees.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32.w),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.coffee_outlined,
                                        size: 64.sp,
                                        color: colors.textHint,
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        'Henüz kahve yok',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: colors.textHint,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12.w,
                                      mainAxisSpacing: 12.h,
                                      childAspectRatio: 0.68,
                                    ),
                                itemCount: _filteredCoffees.length,
                                itemBuilder: (context, index) {
                                  final coffee = _filteredCoffees[index];
                                  final isFav = _favorites[coffee.id] ?? false;
                                  return CoffeeCard(
                                    coffee: coffee,
                                    onTap: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CoffeeDetail(coffee: coffee),
                                        ),
                                      );
                                      if (result == true) {
                                        _loadData();
                                      }
                                    },
                                    onAddToCart: () => _addToCart(coffee),
                                    isFavorite: isFav,
                                  );
                                },
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
