import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/models/coffee.dart';
import 'package:coffee_app/data/repositories/coffee_repository.dart';
import 'package:coffee_app/views/coffee_detail_view.dart';
import 'package:coffee_app/widgets/shared/coffee_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key, this.selectedTabIndex});

  /// Favoriler sekmesi bu index'te (main_shell'den gelir). Sekmeye her geçişte listeyi yeniler.
  final int? selectedTabIndex;

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  final _repo = CoffeeRepository();
  List<Coffee> _favorites = [];
  bool _loading = true;
  static const int _favoritesIndex = 2;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void didUpdateWidget(covariant FavoritesView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTabIndex != _favoritesIndex &&
        widget.selectedTabIndex == _favoritesIndex) {
      _loadFavorites();
    }
  }

  Future<void> _loadFavorites() async {
    setState(() => _loading = true);
    final favorites = await _repo.getFavorites();
    setState(() {
      _favorites = favorites;
      _loading = false;
    });
  }

  Future<void> _removeFavorite(Coffee coffee) async {
    final success = await _repo.removeFavorite(coffee.id);
    if (success) {
      _loadFavorites();
    } else if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kaldırma başarısız')));
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
                onRefresh: _loadFavorites,
                child: _favorites.isEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite_border_rounded,
                                  size: 80.sp,
                                  color: colors.textHint,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'Henüz favori ürün yok',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: colors.textPrimary,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 16.w,
                            right: 16.w,
                            top: 8.h,
                            bottom: 20.h,
                          ),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12.w,
                                  mainAxisSpacing: 12.h,
                                  childAspectRatio: 0.72,
                                ),
                            itemCount: _favorites.length,
                            itemBuilder: (context, index) {
                              final coffee = _favorites[index];
                              return CoffeeCard(
                                coffee: coffee,
                                isFavorite: true,
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CoffeeDetail(coffee: coffee),
                                    ),
                                  );
                                  if (result == true && mounted) {
                                    _loadFavorites();
                                  }
                                },
                                onFavoriteTap: () => _removeFavorite(coffee),
                              );
                            },
                          ),
                        ),
                      ),
              ),
      ),
    );
  }
}
