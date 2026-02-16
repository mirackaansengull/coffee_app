import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/views/bottom_navigation/cart_view.dart';
import 'package:coffee_app/views/bottom_navigation/favorites_view.dart';
import 'package:coffee_app/views/bottom_navigation/home_view.dart';
import 'package:coffee_app/views/bottom_navigation/profile_view.dart';
import 'package:coffee_app/widgets/shared/app_bar.dart';
import 'package:flutter/material.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.onThemeToggle});

  final VoidCallback onThemeToggle;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final iconColor = Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : colors.textPrimary;
    final pages = [
      const HomeView(),
      const CartView(),
      const FavoritesView(),
      ProfileView(onThemeToggle: widget.onThemeToggle),
    ];
    return Scaffold(
      appBar: Appbar(),
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.backgroundPrimary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 16,
              spreadRadius: 0,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: ColorFiltered(
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    child: Image.asset(
                      'assets/icons/home.png',
                      width: 26,
                      height: 26,
                    ),
                  ),
                  label: 'Ana Sayfa',
                  isSelected: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _NavItem(
                  icon: ColorFiltered(
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    child: Image.asset(
                      'assets/icons/cart.png',
                      width: 26,
                      height: 26,
                    ),
                  ),
                  label: 'Sepet',
                  isSelected: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _NavItem(
                  icon: ColorFiltered(
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    child: Image.asset(
                      'assets/icons/favorites.png',
                      width: 26,
                      height: 26,
                    ),
                  ),
                  label: 'Favoriler',
                  isSelected: _currentIndex == 2,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
                _NavItem(
                  icon: ColorFiltered(
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    child: Image.asset(
                      'assets/icons/profile.png',
                      width: 26,
                      height: 26,
                    ),
                  ),
                  label: 'Profil',
                  isSelected: _currentIndex == 3,
                  onTap: () => setState(() => _currentIndex = 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 26,
              height: 26,
              child: Opacity(opacity: isSelected ? 1.0 : 0.6, child: icon),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppThemeColors.of(context).textPrimary
                    : AppThemeColors.of(context).textHint,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
