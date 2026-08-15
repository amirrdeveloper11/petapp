import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:front/core/theme.dart';
import 'package:front/widgets/custom_button.dart';
import 'package:front/widgets/custom_text_field.dart';
import '../model/delivery_address_model.dart';
import '../provider/delivery_address_provider.dart';

class DeliveryAddressFormPage extends StatefulWidget {
  final DeliveryAddressModel? address;

  const DeliveryAddressFormPage({
    super.key,
    this.address,
  });

  @override
  State<DeliveryAddressFormPage> createState() =>
      _DeliveryAddressFormPageState();
}

class _DeliveryAddressFormPageState extends State<DeliveryAddressFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _deliveryAddressCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _areaCtrl;
  late final TextEditingController _contactPhoneCtrl;
  late final TextEditingController _notesCtrl;

  bool get _isEdit => widget.address != null;

  @override
  void initState() {
    super.initState();
    _deliveryAddressCtrl = TextEditingController(
      text: widget.address?.deliveryAddress ?? '',
    );
    _cityCtrl = TextEditingController(text: widget.address?.city ?? '');
    _areaCtrl = TextEditingController(text: widget.address?.area ?? '');
    _contactPhoneCtrl = TextEditingController(
      text: widget.address?.contactPhone ?? '',
    );
    _notesCtrl = TextEditingController(text: widget.address?.notes ?? '');
  }

  @override
  void dispose() {
    _deliveryAddressCtrl.dispose();
    _cityCtrl.dispose();
    _areaCtrl.dispose();
    _contactPhoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<DeliveryAddressProvider>();

    final payload = DeliveryAddressModel(
      id: widget.address?.id,
      deliveryAddress: _deliveryAddressCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      area: _areaCtrl.text.trim(),
      contactPhone: _contactPhoneCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );

    try {
      if (_isEdit) {
        await provider.updateAddress(widget.address!.id!, payload);
      } else {
        await provider.createAddress(payload);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  InputDecoration _decoration(
    BuildContext context, {
    required String label,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
      filled: true,
      fillColor: AppColors.ivory,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: const BorderSide(color: AppColors.hairline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: const BorderSide(color: AppColors.hairline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: const BorderSide(color: AppColors.deepTeal, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DeliveryAddressProvider>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.deepTeal),
        title: Text(
          _isEdit ? 'Edit Address' : 'Add Address',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _deliveryAddressCtrl,
              maxLines: 3,
              textInputAction: TextInputAction.next,
              decoration: _decoration(
                context,
                label: 'Delivery address',
                hintText: 'Street, building, floor, apartment...',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Delivery address is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _cityCtrl,
                    hintText: 'City',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'City is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: _areaCtrl,
                    hintText: 'Area',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Area is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            CustomTextField(
              controller: _contactPhoneCtrl,
              hintText: 'Contact phone',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Contact phone is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 4,
              decoration: _decoration(
                context,
                label: 'Notes (optional)',
                hintText: 'Example: Ring the bell, call before arrival...',
              ),
            ),
            const SizedBox(height: 28),
            CustomButton(
              text: _isEdit ? 'Update address' : 'Save address',
              onPressed: provider.saving ? null : _save,
              isLoading: provider.saving,
              icon: Icons.save_rounded,
            ),
          ],
        ),
      ),
    );
  }
}