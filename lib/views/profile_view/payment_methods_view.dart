import 'dart:math';

import 'package:coffee_app/core/constants/app_constants.dart';
import 'package:coffee_app/core/theme/app_theme_colors.dart';
import 'package:coffee_app/data/models/saved_card.dart';
import 'package:coffee_app/data/repositories/card_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Her 4 rakamda boşluk ekler (örn. 1234 5678 9012 3456).
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 16) return oldValue;
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    int digitCount = 0;
    for (int i = 0; i < newValue.selection.baseOffset && i < newValue.text.length; i++) {
      if (RegExp(r'\d').hasMatch(newValue.text[i])) digitCount++;
    }
    if (digitCount > 16) digitCount = 16;
    int newCursor = 0;
    int d = 0;
    for (int i = 0; i < formatted.length; i++) {
      if (formatted[i] != ' ') d++;
      newCursor = i + 1;
      if (d >= digitCount) break;
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursor),
    );
  }
}

/// Formun üstünde, yazdıkça güncellenen kredi kartı görseli.
class _LiveCardVisual extends StatelessWidget {
  const _LiveCardVisual({
    required this.holderName,
    required this.cardNumber,
    required this.expiry,
  });

  final String holderName;
  final String cardNumber;
  final String expiry;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final digits = cardNumber.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < 4; i++) {
      final start = i * 4;
      final end = (i + 1) * 4;
      if (end <= digits.length) {
        buffer.write(digits.substring(start, end));
      } else {
        if (start < digits.length) {
          buffer.write(digits.substring(start));
          for (int j = digits.length; j < end; j++) buffer.write('•');
        } else {
          buffer.write('••••');
        }
      }
      if (i < 3) buffer.write(' ');
    }
    final cardNumberDisplay = buffer.toString();
    final holderDisplay = holderName.isEmpty ? 'KART SAHİBİ' : holderName.toUpperCase();
    final expiryDisplay = expiry.isEmpty ? 'AA/YY' : expiry;

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2C2C2E),
            const Color(0xFF1C1C1E),
            const Color(0xFF0D0D0F),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            // Hafif ışık efekti
            Positioned(
              top: -40.h,
              right: -40.w,
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Chip
                  Container(
                    width: 40.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFD4AF37),
                          const Color(0xFFAA8B2C),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Kart numarası
                  Text(
                    cardNumberDisplay,
                    style: TextStyle(
                      fontSize: 16.sp,
                      letterSpacing: 3.w,
                      fontWeight: FontWeight.w500,
                      color: cardNumber.isEmpty
                          ? colors.textHint.withValues(alpha: 0.7)
                          : colors.textPrimary,
                      fontFamily: 'monospace',
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'KART SAHİBİ',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: colors.textHint.withValues(alpha: 0.8),
                                letterSpacing: 1.2,
                                fontFamily: AppConstants.fontFamily,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              holderDisplay,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: holderName.isEmpty
                                    ? colors.textHint.withValues(alpha: 0.6)
                                    : colors.textPrimary,
                                letterSpacing: 1.5,
                                fontFamily: AppConstants.fontFamily,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'SON KULLANMA',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: colors.textHint.withValues(alpha: 0.8),
                              letterSpacing: 1.2,
                              fontFamily: AppConstants.fontFamily,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            expiryDisplay,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: expiry.isEmpty
                                  ? colors.textHint.withValues(alpha: 0.6)
                                  : colors.textPrimary,
                              letterSpacing: 1.5,
                              fontFamily: AppConstants.fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// İlk 2 rakamdan sonra otomatik "/" ekler (MM/YY).
class _ExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 4) return oldValue;
    String formatted = digits;
    if (digits.length >= 2) {
      formatted = '${digits.substring(0, 2)}/${digits.substring(2)}';
    }
    int digitCount = 0;
    for (int i = 0; i < newValue.selection.baseOffset && i < newValue.text.length; i++) {
      if (RegExp(r'\d').hasMatch(newValue.text[i])) digitCount++;
    }
    if (digitCount > 4) digitCount = 4;
    int newCursor = digitCount <= 2 ? digitCount : digitCount + 1;
    if (newCursor > formatted.length) newCursor = formatted.length;
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursor),
    );
  }
}

class PaymentMethodsView extends StatefulWidget {
  const PaymentMethodsView({super.key});

  @override
  State<PaymentMethodsView> createState() => _PaymentMethodsViewState();
}

class _PaymentMethodsViewState extends State<PaymentMethodsView> {
  final _repo = CardRepository.instance;
  List<SavedCard> _cards = [];
  bool _loading = true;
  bool _showAddForm = false;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    setState(() => _loading = true);
    final cards = await _repo.getCards();
    if (mounted) {
      setState(() {
        _cards = cards;
        _loading = false;
        _showAddForm = cards.isEmpty;
      });
    }
  }

  Future<void> _removeCard(SavedCard card) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kartı Kaldır'),
        content: Text('${card.maskedNumber} kayıtlı kartlarınızdan kaldırılsın mı?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Kaldır', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _repo.removeCard(card.id);
      if (mounted) _loadCards();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      appBar: AppBar(
        title: Text(
          'Ödeme Yöntemleri',
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
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: colors.progressIndicator))
          : SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_showAddForm) ...[
                    Padding(
                      padding: EdgeInsets.only(top: 80.h),
                      child: AddCardForm(
                        onSaved: () {
                          setState(() => _showAddForm = false);
                          _loadCards();
                        },
                        onCancel: () => setState(() => _showAddForm = false),
                      ),
                    ),
                    if (_cards.isNotEmpty) SizedBox(height: 24.h),
                  ],
                  if (!_showAddForm && _cards.isNotEmpty) ...[
                    Text(
                      'Kayıtlı Kartlar',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: colors.textHint,
                        fontFamily: AppConstants.fontFamily,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ..._cards.map((card) => _CardTile(
                          card: card,
                          onRemove: () => _removeCard(card),
                        )),
                    SizedBox(height: 24.h),
                  ],
                  if (!_showAddForm)
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _showAddForm = true),
                      icon: const Icon(Icons.add),
                      label: const Text('Yeni kart ekle'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.textPrimary,
                        side: BorderSide(color: colors.surfaceBorder),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile({required this.card, required this.onRemove});

  final SavedCard card;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surfaceDark,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.surfaceBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.credit_card_rounded, size: 28.sp, color: colors.textHint),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.maskedNumber,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${card.holderName} · ${card.expiry}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: colors.textHint,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: Colors.red.shade300),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class AddCardForm extends StatefulWidget {
  const AddCardForm({
    super.key,
    required this.onSaved,
    required this.onCancel,
  });

  final VoidCallback onSaved;
  final VoidCallback onCancel;

  @override
  State<AddCardForm> createState() => _AddCardFormState();
}

class _AddCardFormState extends State<AddCardForm> {
  final _holderController = TextEditingController();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _repo = CardRepository.instance;

  void _onCardFieldChanged() => setState(() {});

  @override
  void initState() {
    super.initState();
    _holderController.addListener(_onCardFieldChanged);
    _numberController.addListener(_onCardFieldChanged);
    _expiryController.addListener(_onCardFieldChanged);
  }

  @override
  void dispose() {
    _holderController.removeListener(_onCardFieldChanged);
    _numberController.removeListener(_onCardFieldChanged);
    _expiryController.removeListener(_onCardFieldChanged);
    _holderController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final holder = _holderController.text.trim();
    final number = _numberController.text.replaceAll(' ', '');
    final expiry = _expiryController.text.trim();
    final cvv = _cvvController.text.trim();
    if (holder.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kart sahibi adı girin')),
      );
      return;
    }
    if (number.length < 16) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçerli 16 haneli kart numarası girin')),
      );
      return;
    }
    if (expiry.length != 5 || !expiry.contains('/')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Son kullanma tarihi MM/YY formatında girin')),
      );
      return;
    }
    if (cvv.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CVV girin (3 veya 4 hane)')),
      );
      return;
    }
    final parts = expiry.split('/');
    final month = int.tryParse(parts[0]) ?? 0;
    var year = int.tryParse(parts[1]) ?? 0;
    if (year < 100) year += 2000;
    final lastFour = number.length >= 4 ? number.substring(number.length - 4) : number;
    final card = SavedCard(
      id: '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}',
      holderName: holder,
      lastFour: lastFour,
      expiryMonth: month,
      expiryYear: year,
    );
    await _repo.addCard(card);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kart eklendi')),
      );
      widget.onSaved();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: colors.surfaceDark,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: colors.surfaceBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: colors.textPrimary),
      ),
      labelStyle: TextStyle(color: colors.textHint),
    );
    const cardOverlap = 100.0; // Kartın container üzerine taşan kısmı (yukarı)
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Container (arkada, z-index 0)
        Container(
          padding: EdgeInsets.fromLTRB(16.w, cardOverlap.h + 48.h, 16.w, 16.w),
          decoration: BoxDecoration(
            color: colors.surfaceDark,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colors.surfaceBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Yeni Kart Ekle',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                  fontFamily: AppConstants.fontFamily,
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
            controller: _holderController,
            decoration: inputDecoration.copyWith(labelText: 'Kart üzerindeki isim'),
            style: TextStyle(color: colors.textPrimary),
            textCapitalization: TextCapitalization.words,
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _numberController,
            decoration: inputDecoration.copyWith(labelText: 'Kart numarası (16 hane)'),
            style: TextStyle(color: colors.textPrimary),
            keyboardType: TextInputType.number,
            maxLength: 19,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CardNumberInputFormatter(),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expiryController,
                  decoration: inputDecoration.copyWith(labelText: 'MM/YY'),
                  style: TextStyle(color: colors.textPrimary),
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _ExpiryInputFormatter(),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  controller: _cvvController,
                  decoration: inputDecoration.copyWith(labelText: 'CVV'),
                  style: TextStyle(color: colors.textPrimary),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.textPrimary,
                    side: BorderSide(color: colors.surfaceBorder),
                  ),
                  child: const Text('İptal'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF8B4513),
                  ),
                  child: const Text('Kaydet'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
      // Kart görseli üstte (z-index 1)
      Positioned(
        top: -80.h,
        left: 20.w,
        right: 20.w,
        child: ListenableBuilder(
          listenable: Listenable.merge([
            _holderController,
            _numberController,
            _expiryController,
          ]),
          builder: (context, _) => _LiveCardVisual(
            holderName: _holderController.text,
            cardNumber: _numberController.text,
            expiry: _expiryController.text,
          ),
        ),
      ),
    ],
    );
  }
}
