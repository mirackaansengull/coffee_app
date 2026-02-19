import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/models/coffee.dart';
import 'package:coffee_app/data/repositories/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _repo = CoffeeRepository();
  bool _loading = false;

  bool get _isEdit => widget.coffee != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final c = widget.coffee!;
      _nameController.text = c.name;
      _imageUrlController.text = c.imageUrl;
      _priceController.text = c.price.toString();
      _descriptionController.text = c.description ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final name = _nameController.text.trim();
    final imageUrl = _imageUrlController.text.trim();
    final price = int.tryParse(_priceController.text.trim()) ?? 0;
    final description = _descriptionController.text.trim();
    Coffee? result;
    if (_isEdit) {
      result = await _repo.updateCoffee(
        id: widget.coffee!.id,
        name: name,
        imageUrl: imageUrl,
        price: price,
        description: description.isEmpty ? null : description,
      );
    } else {
      result = await _repo.createCoffee(
        name: name,
        imageUrl: imageUrl,
        price: price,
        description: description.isEmpty ? null : description,
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
            SizedBox(height: 16.h),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Fiyat (TL)',
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
              validator: (v) {
                final p = int.tryParse(v?.trim() ?? '');
                return p == null || p <= 0 ? 'Geçerli fiyat girin' : null;
              },
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
