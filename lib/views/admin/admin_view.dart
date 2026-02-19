import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/models/coffee.dart';
import 'package:coffee_app/data/repositories/coffee_repository.dart';
import 'package:coffee_app/views/admin/admin_coffee_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  final _repo = CoffeeRepository();
  List<Coffee> _coffees = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCoffees();
  }

  Future<void> _loadCoffees() async {
    setState(() => _loading = true);
    final coffees = await _repo.getCoffees();
    setState(() {
      _coffees = coffees;
      _loading = false;
    });
  }

  Future<void> _deleteCoffee(Coffee coffee) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kahve Sil'),
        content: Text('${coffee.name} silinsin mi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final success = await _repo.deleteCoffee(coffee.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kahve silindi')),
        );
        _loadCoffees();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silme başarısız')),
        );
      }
    }
  }

  Future<void> _editCoffee(Coffee coffee) async {
    final result = await Navigator.push<Coffee?>(
      context,
      MaterialPageRoute(
        builder: (ctx) => AdminCoffeeForm(coffee: coffee),
      ),
    );
    if (result != null && mounted) {
      _loadCoffees();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Admin Paneli'),
        backgroundColor: colors.backgroundPrimary,
        foregroundColor: colors.textPrimary,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(color: colors.progressIndicator),
            )
          : RefreshIndicator(
              onRefresh: _loadCoffees,
              child: _coffees.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: _coffees.length,
                      itemBuilder: (ctx, i) {
                        final coffee = _coffees[i];
                        return Card(
                          margin: EdgeInsets.only(bottom: 12.h),
                          color: colors.surfaceDark,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(12.w),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                coffee.imageUrl,
                                width: 60.w,
                                height: 60.h,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 60.w,
                                  height: 60.h,
                                  color: colors.surfaceBorder,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: colors.textHint,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              coffee.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4.h),
                                Text(
                                  '${coffee.price} TL',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: colors.textPrimary,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                if (coffee.description != null &&
                                    coffee.description!.isNotEmpty) ...[
                                  SizedBox(height: 4.h),
                                  Text(
                                    coffee.description!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: colors.textHint,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: colors.textPrimary,
                                  ),
                                  onPressed: () => _editCoffee(coffee),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteCoffee(coffee),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<Coffee?>(
            context,
            MaterialPageRoute(
              builder: (ctx) => const AdminCoffeeForm(),
            ),
          );
          if (result != null && mounted) {
            _loadCoffees();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
