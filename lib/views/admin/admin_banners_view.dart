import 'package:coffee_app/core/constants/app_constants.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/repositories/banner_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminBannersView extends StatefulWidget {
  const AdminBannersView({super.key});

  @override
  State<AdminBannersView> createState() => _AdminBannersViewState();
}

class _AdminBannersViewState extends State<AdminBannersView> {
  final _repo = BannerRepository.instance;
  late List<TextEditingController> _controllers;
  bool _loading = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initUrls();
  }

  void _initUrls() {
    final urls = _repo.getBannerImageUrls();
    _controllers = urls.map((u) => TextEditingController(text: u)).toList();
    _initialized = true;
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    final urls = _controllers
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (urls.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('En az bir banner URL girin')),
        );
        setState(() => _loading = false);
      }
      return;
    }
    await _repo.setBannerImageUrls(urls);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bannerlar kaydedildi')),
      );
      setState(() => _loading = false);
    }
  }

  void _addBanner() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _removeBanner(int index) {
    if (_controllers.length <= 1) return;
    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    if (!_initialized) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      appBar: AppBar(
        title: Text(
          'Bannerlar',
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
        actions: [
          if (_loading)
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: SizedBox(
                width: 24.w,
                height: 24.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.progressIndicator,
                ),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: const Text('Kaydet'),
            ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 100.h),
        children: [
          Text(
            'Ana sayfadaki üst banner görsellerinin URL\'lerini düzenleyin.',
            style: TextStyle(
              fontSize: 13.sp,
              color: colors.textHint,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          SizedBox(height: 20.h),
          ...List.generate(_controllers.length, (index) {
            return _BannerTile(
              controller: _controllers[index],
              onRemove: _controllers.length > 1
                  ? () => _removeBanner(index)
                  : null,
            );
          }),
          SizedBox(height: 16.h),
          OutlinedButton.icon(
            onPressed: _addBanner,
            icon: const Icon(Icons.add),
            label: const Text('Banner Ekle'),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.textPrimary,
              side: BorderSide(color: colors.surfaceBorder),
              padding: EdgeInsets.symmetric(vertical: 14.h),
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerTile extends StatelessWidget {
  const _BannerTile({
    required this.controller,
    this.onRemove,
  });

  final TextEditingController controller;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colors.surfaceDark,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: colors.textPrimary,
                    fontFamily: AppConstants.fontFamily,
                  ),
                  decoration: InputDecoration(
                    hintText: 'https://...',
                    hintStyle: TextStyle(color: colors.textHint),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: colors.surfaceBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: colors.textPrimary),
                    ),
                  ),
                ),
              ),
              if (onRemove != null) ...[
                SizedBox(width: 8.w),
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded, color: Colors.red.shade400),
                  onPressed: onRemove,
                ),
              ],
            ],
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              final u = value.text.trim();
              if (u.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    u,
                    height: 80.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 80.h,
                        color: colors.surfaceBorder,
                        child: Center(
                          child: SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.progressIndicator,
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      height: 80.h,
                      color: colors.surfaceBorder,
                      child: Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: colors.textHint,
                          size: 32.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
