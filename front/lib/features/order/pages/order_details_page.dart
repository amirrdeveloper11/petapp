import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/order/model/order_model.dart';
import 'package:front/core/services/order_service.dart';
import 'package:front/features/order/model/payment_method.dart';
import 'package:front/features/order/widgets/order_item_tile.dart';
import 'package:intl/intl.dart';

import 'package:front/widgets/app_card.dart';
import 'package:front/widgets/app_confirm_dialog.dart';
import 'package:front/widgets/app_labeled_value.dart';
import 'package:front/widgets/app_status_chip.dart';

class OrderDetailsPage extends StatefulWidget {
  final OrderModel order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final OrderService _service = OrderService();
  late OrderModel _order;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  Future<void> _cancelOrder() async {
    if (_order.id == null) return;

    final confirmed = await showAppConfirmDialog(
      context: context,
      title: 'Cancel order?',
      message: 'This order will be cancelled if it has not been processed yet.',
      confirmText: 'Cancel order',
      destructive: true,
    );

    if (!confirmed) return;

    setState(() => _busy = true);
    try {
      final updated = await _service.cancelOrder(_order.id!);
      if (!mounted) return;
      setState(() => _order = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order cancelled successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: 'ل.س ', decimalDigits: 2);
    final dateFormat = DateFormat('EEEE, MMM d, yyyy • h:mm a');

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        title: Text(
          _order.orderNumber != null
              ? 'Order #${_order.orderNumber}'
              : 'Order Details',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.deepTeal),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          AppCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _order.orderNumber != null
                            ? 'Order #${_order.orderNumber}'
                            : 'Order #${_order.id ?? '-'}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    AppStatusChip(status: _order.status),
                  ],
                ),
                const SizedBox(height: 14),
                AppLabeledValue(
                  label: 'Created at',
                  value: dateFormat.format(
                    _order.createdAt ?? DateTime.now(),
                  ),
                ),
                AppLabeledValue(
                  label: 'Payment method',
                  value: _order.paymentMethod.label,
                ),
                if ((_order.deliveryAddress ?? '').trim().isNotEmpty)
                  AppLabeledValue(
                    label: 'Delivery address',
                    value: _order.deliveryAddress!.trim(),
                    valueBold: false,
                  ),
                if ((_order.city ?? '').trim().isNotEmpty)
                  AppLabeledValue(
                    label: 'City',
                    value: _order.city!.trim(),
                    valueBold: false,
                  ),
                if ((_order.area ?? '').trim().isNotEmpty)
                  AppLabeledValue(
                    label: 'Area',
                    value: _order.area!.trim(),
                    valueBold: false,
                  ),
                if ((_order.contactPhone ?? '').trim().isNotEmpty)
                  AppLabeledValue(
                    label: 'Contact phone',
                    value: _order.contactPhone!.trim(),
                    valueBold: false,
                  ),
                if ((_order.paymentReference ?? '').trim().isNotEmpty)
                  AppLabeledValue(
                    label: 'Payment reference',
                    value: _order.paymentReference!.trim(),
                    valueBold: false,
                  ),
                AppLabeledValue(label: 'Items', value: '${_order.itemCount}'),
                AppLabeledValue(
                  label: 'Subtotal',
                  value: currency.format(_order.subtotal),
                ),
                AppLabeledValue(
                  label: 'Delivery fee',
                  value: currency.format(_order.deliveryFee),
                ),
                AppLabeledValue(
                  label: 'Total',
                  value: currency.format(_order.effectiveTotal),
                ),
                if ((_order.notes ?? '').trim().isNotEmpty)
                  AppLabeledValue(
                    label: 'Notes',
                    value: _order.notes!.trim(),
                    valueBold: false,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Order items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ..._order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                padding: const EdgeInsets.all(14),
                child: OrderItemTile(
                  title: item.productName,
                  imageUrl: item.imageUrl,
                  quantity: item.quantity,
                  unitPrice: item.unitPrice,
                  totalPrice: item.totalPrice,
                  showDivider: false,
                ),
              ),
            ),
          ),
          if (_order.canCancel) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: _busy ? null : _cancelOrder,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                ),
                child: _busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.danger,
                          ),
                        ),
                      )
                    : const Text(
                        'Cancel pending order',
                        style: TextStyle(
                          color: AppColors.danger,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
