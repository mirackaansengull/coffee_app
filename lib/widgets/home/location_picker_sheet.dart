import 'package:coffee_app/core/constants/app_constants.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/constants/branch_data.dart';
import 'package:coffee_app/data/repositories/location_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Konum seçim bottom sheet: önce şehir, sonra mahalle; seçilince Aromacafe ve adres otomatik atanır.
void showLocationPickerSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _LocationPickerSheet(),
  );
}

class _LocationPickerSheet extends StatefulWidget {
  const _LocationPickerSheet();

  @override
  State<_LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<_LocationPickerSheet> {
  String? _selectedCity;
  final _cityList = cities;

  List<String> get _neighborhoods => _selectedCity != null
      ? getNeighborhoodsForCity(_selectedCity!)
      : <String>[];

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: BoxDecoration(
        color: colors.backgroundPrimary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Text(
                  _selectedCity == null ? 'Şehir seçin' : 'Mahalle seçin',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
                const Spacer(),
                if (_selectedCity != null)
                  TextButton(
                    onPressed: () => setState(() => _selectedCity = null),
                    child: Text(
                      'Geri',
                      style: TextStyle(color: colors.textPrimary),
                    ),
                  ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: colors.textPrimary),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
              itemCount: _selectedCity == null
                  ? _cityList.length
                  : _neighborhoods.length,
              itemBuilder: (context, index) {
                if (_selectedCity == null) {
                  final city = _cityList[index];
                  return _Tile(
                    title: city,
                    onTap: () => setState(() => _selectedCity = city),
                  );
                }
                final neighborhood = _neighborhoods[index];
                return _Tile(
                  title: neighborhood,
                  subtitle: BranchInfo.branchName,
                  onTap: () => _onNeighborhoodSelected(neighborhood),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onNeighborhoodSelected(String neighborhood) {
    final city = _selectedCity!;
    final branch = getBranchForCityAndNeighborhood(city, neighborhood);
    if (branch != null) {
      LocationRepository.instance.setLocation(branch.toDeliveryLocation());
      if (mounted) Navigator.pop(context);
    }
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.title, this.subtitle, required this.onTap});

  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
          margin: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            color: colors.surfaceDark,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colors.surfaceBorder),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 22.sp,
                color: colors.textHint,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        fontFamily: AppConstants.fontFamily,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colors.textHint,
                          fontFamily: AppConstants.fontFamily,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.textHint,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
