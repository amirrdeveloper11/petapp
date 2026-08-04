import 'package:flutter/material.dart';
import 'package:front/features/order/model/payment_method.dart';
import 'package:intl/intl.dart';


class OrderSummaryCard extends StatelessWidget {
  final int itemCount;
  final double subtotal;
  final PaymentMethodType paymentMethod;
  final String? note;

  const OrderSummaryCard({
    super.key,
    required this.itemCount,
    required this.subtotal,
    required this.paymentMethod,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: 'ل.س ', decimalDigits: 2);
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            _RowValue(
              label: 'Items',
              value: '$itemCount',
            ),
            const SizedBox(height: 8),
            _RowValue(
              label: 'Payment',
              value: paymentMethod.label,
            ),
            const SizedBox(height: 8),
            _RowValue(
              label: 'Subtotal',
              value: currency.format(subtotal),
            ),
            if (note != null && note!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              _RowValue(
                label: 'Note',
                value: note!.trim(),
              ),
            ],
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withOpacity(0.28),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    currency.format(subtotal),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
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

class _RowValue extends StatelessWidget {
  final String label;
  final String value;

  const _RowValue({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: TextStyle(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 6,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}