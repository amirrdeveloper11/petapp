import 'package:flutter/material.dart';
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
          child: Card(
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: selected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.35)
                    : Theme.of(
                        context,
                      ).colorScheme.outlineVariant.withOpacity(0.45),
              ),
            ),
            child: RadioListTile<PaymentMethodType>(
              value: option,
              groupValue: value,
              onChanged: (newValue) {
                if (newValue != null) onChanged(newValue);
              },
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              title: Text(
                option.label,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                option == PaymentMethodType.cashOnDelivery
                    ? 'Pay when the order arrives'
                    : 'Pay With Sham Cash ',
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
