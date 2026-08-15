import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/order/model/payment_method.dart';

class PaymentMethodSelector extends StatelessWidget {
  final PaymentMethodType value;
  final ValueChanged<PaymentMethodType> onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = PaymentMethodType.values;

    return Column(
      children: options.map((option) {
        final selected = option == value;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadii.lg),
              onTap: () => onChanged(option),
              child: Container(
                decoration: BoxDecoration(
                  color: selected ? AppColors.tealSoft : AppColors.ivory,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  border: Border.all(
                    color: selected ? AppColors.deepTeal : AppColors.hairline,
                    width: selected ? 1.4 : 1,
                  ),
                  boxShadow: AppShadows.soft,
                ),
                child: RadioListTile<PaymentMethodType>(
                  value: option,
                  groupValue: value,
                  activeColor: AppColors.deepTeal,
                  onChanged: (newValue) {
                    if (newValue != null) onChanged(newValue);
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  title: Text(
                    option.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    option == PaymentMethodType.cashOnDelivery
                        ? 'Pay when the order arrives'
                        : 'Pay With Sham Cash',
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
