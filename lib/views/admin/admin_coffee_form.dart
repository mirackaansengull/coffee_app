import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/models/coffee.dart';
import 'package:coffee_app/data/repositories/coffee_repository.dart';
import 'package:coffee_app/widgets/home/home_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Anasayfa kategorileri (En Çok Satanlar hariç - sadece filtre için). Admin'de seçilebilir.
List<String> get adminCategoryOptions =>
    coffeeTypes.skip(1).map((e) => e.label).toList();

class AdminCoffeeForm extends StatefulWidget {
  const AdminCoffeeForm({super.key, this.coffee});

  final Coffee? coffee;

  @override
  State<AdminCoffeeForm> createState() => _AdminCoffeeFormState();
}

class _AdminCoffeeFormState extends State<AdminCoffeeForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceSController = TextEditingController();
  final _priceMController = TextEditingController();
  final _priceLController = TextEditingController();
  final _priceXLController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _repo = CoffeeRepository();
  bool _loading = false;
  List<String> _selectedCategories = [];

  bool get _isEdit => widget.coffee != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final c = widget.coffee!;
      _nameController.text = c.name;
      _imageUrlController.text = c.imageUrl;
      _priceSController.text = (c.priceS ?? c.price).toString();
      _priceMController.text = (c.priceM ?? c.price).toString();
      _priceLController.text = (c.priceL ?? c.price).toString();
      _priceXLController.text = (c.priceXL ?? c.price).toString();
      _descriptionController.text = c.description ?? '';
      _selectedCategories = List.from(c.categories);
    } else {
      _priceSController.text = '85';
      _priceMController.text = '100';
      _priceLController.text = '115';
      _priceXLController.text = '130';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    _priceSController.dispose();
    _priceMController.dispose();
    _priceLController.dispose();
    _priceXLController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  static int? _parsePrice(String? v) {
    final p = int.tryParse(v?.trim() ?? '');
    return (p != null && p > 0) ? p : null;
  }

  Widget _priceField(String label, TextEditingController controller, AppThemeColors colors) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: '$label (TL)',
        labelStyle: TextStyle(color: colors.textHint),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: colors.surfaceBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: colors.surfaceBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: colors.textPrimary),
        ),
        filled: true,
        fillColor: colors.surfaceDark,
      ),
      style: TextStyle(color: colors.textPrimary),
      keyboardType: TextInputType.number,
      validator: (v) => _parsePrice(v) == null ? 'Geçerli fiyat' : null,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final name = _nameController.text.trim();
    final imageUrl = _imageUrlController.text.trim();
    final priceS = _parsePrice(_priceSController.text) ?? 0;
    final priceM = _parsePrice(_priceMController.text) ?? 0;
    final priceL = _parsePrice(_priceLController.text) ?? 0;
    final priceXL = _parsePrice(_priceXLController.text) ?? 0;
    final description = _descriptionController.text.trim();
    Coffee? result;
    if (_isEdit) {
      result = await _repo.updateCoffee(
        id: widget.coffee!.id,
        name: name,
        imageUrl: imageUrl,
        priceS: priceS,
        priceM: priceM,
        priceL: priceL,
        priceXL: priceXL,
        description: description.isEmpty ? null : description,
        categories: _selectedCategories,
      );
    } else {
      result = await _repo.createCoffee(
        name: name,
        imageUrl: imageUrl,
        priceS: priceS,
        priceM: priceM,
        priceL: priceL,
        priceXL: priceXL,
        description: description.isEmpty ? null : description,
        categories: _selectedCategories,
      );
    }
    setState(() => _loading = false);
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEdit ? 'Kahve güncellendi' : 'Kahve eklendi'),
        ),
      );
      Navigator.pop(context, result);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İşlem başarısız')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      appBar: AppBar(
        title: Text(_isEdit ? 'Kahve Düzenle' : 'Kahve Ekle'),
        backgroundColor: colors.backgroundPrimary,
        foregroundColor: colors.textPrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Kahve Adı',
                labelStyle: TextStyle(color: colors.textHint),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: colors.surfaceBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: colors.surfaceBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: colors.textPrimary),
                ),
                filled: true,
                fillColor: colors.surfaceDark,
              ),
              style: TextStyle(color: colors.textPrimary),
              validator: (v) => v?.trim().isEmpty ?? true ? 'Ad gerekli' : null,
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: 'Resim URL',
                labelStyle: TextStyle(color: colors.textHint),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: colors.surfaceBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: colors.surfaceBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: colors.textPrimary),
                ),
                filled: true,
                fillColor: colors.surfaceDark,
              ),
              style: TextStyle(color: colors.textPrimary),
              validator: (v) => v?.trim().isEmpty ?? true ? 'Resim URL gerekli' : null,
            ),
            SizedBox(height: 12.h),
            Text(
              'Boy fiyatları (TL)',
              style: TextStyle(
                fontSize: 13.sp,
                color: colors.textHint,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: _priceField('S', _priceSController, colors),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _priceField('M', _priceMController, colors),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: _priceField('L', _priceLController, colors),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _priceField('XL', _priceXLController, colors),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              'Kategoriler (birden fazla seçebilirsiniz)',
              style: TextStyle(
                fontSize: 13.sp,
                color: colors.textHint,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: adminCategoryOptions.map((label) {
                final isSelected = _selectedCategories.contains(label);
                return FilterChip(
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (v) {
                    setState(() {
                      if (v) {
                        _selectedCategories = [..._selectedCategories, label];
                      } else {
                        _selectedCategories = _selectedCategories.where((c) => c != label).toList();
                      }
                    });
                  },
                  selectedColor: colors.surfaceBorder,
                  checkmarkColor: colors.textPrimary,
                );
              }).toList(),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Açıklama (isteğe bağlı)',
                labelStyle: TextStyle(color: colors.textHint),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: colors.surfaceBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: colors.surfaceBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: colors.textPrimary),
                ),
                filled: true,
                fillColor: colors.surfaceDark,
              ),
              style: TextStyle(color: colors.textPrimary),
              maxLines: 4,
            ),
            SizedBox(height: 32.h),
            FilledButton(
              onPressed: _loading ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF8B4513),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: _loading
                  ? SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _isEdit ? 'Güncelle' : 'Ekle',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
