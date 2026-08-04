import 'package:flutter/material.dart';
import 'package:front/features/locations/model/delivery_address_model.dart';
import 'package:front/features/locations/provider/delivery_address_provider.dart';
import 'package:front/features/locations/widgets/delivery_address_picker_sheet.dart';
import 'package:front/features/order/model/payment_method.dart';
import 'package:front/features/order/provider/order_provider.dart';
import 'package:front/features/order/widgets/order_item_tile.dart';
import 'package:front/features/order/widgets/order_summary_card.dart';
import 'package:front/features/order/widgets/payment_method_selector.dart';
import 'package:front/features/store/provider/cart_provider.dart';
import 'package:front/routes/app_routes.dart';
import 'package:front/widgets/app_empty_state.dart';
import 'package:front/widgets/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  final _paymentReferenceController = TextEditingController();
  final _notesController = TextEditingController();

  late final OrderProvider _orderProvider;

  PaymentMethodType _paymentMethod = PaymentMethodType.cashOnDelivery;
  DeliveryAddressModel? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _orderProvider = OrderProvider();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DeliveryAddressProvider>().fetchAddresses(silent: true);
    });
  }

  @override
  void dispose() {
    _paymentReferenceController.dispose();
    _notesController.dispose();
    _orderProvider.dispose();
    super.dispose();
  }

  Future<void> _chooseSavedAddress() async {
    final selected = await showModalBottomSheet<DeliveryAddressModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const DeliveryAddressPickerSheet(),
    );

    if (selected == null) return;

    setState(() {
      _selectedAddress = selected;
    });
  }

  Future<void> _submitOrder(BuildContext context) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final cart = context.read<CartProvider>();
    if (cart.items.isEmpty) return;

    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a saved address first.')),
      );
      return;
    }

    final provider = context.read<OrderProvider>();

    try {
      final order = await provider.submitCartOrder(
        cartItems: cart.items,
        paymentMethod: _paymentMethod,
        deliveryAddress: _selectedAddress!.deliveryAddress,
        city: _selectedAddress!.city,
        area: _selectedAddress!.area,
        contactPhone: _selectedAddress!.contactPhone,
        paymentReference: _paymentReferenceController.text.trim().isEmpty
            ? null
            : _paymentReferenceController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      if (!context.mounted) return;

      cart.clear();
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.orderDetails,
        arguments: order,
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget _selectedAddressCard(BuildContext context) {
    if (_selectedAddress == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withOpacity(0.35),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Text(
          'No saved address selected',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    }

    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_rounded, color: cs.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Selected address',
                style: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _selectedAddress!.deliveryAddress,
            style: const TextStyle(fontWeight: FontWeight.w600, height: 1.45),
          ),
          const SizedBox(height: 4),
          Text(
            '${_selectedAddress!.city} • ${_selectedAddress!.area}',
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            _selectedAddress!.contactPhone,
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          if ((_selectedAddress!.notes ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              _selectedAddress!.notes!,
              style: TextStyle(color: cs.onSurfaceVariant, height: 1.4),
            ),
          ],
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration(
    BuildContext context, {
    required String label,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      filled: true,
      fillColor: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withOpacity(0.65),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return ChangeNotifierProvider.value(
      value: _orderProvider,
      child: Consumer<OrderProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Checkout',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              centerTitle: false,
              surfaceTintColor: Colors.transparent,
            ),
            body: cart.items.isEmpty
                ? const AppEmptyState(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Your cart is empty',
                    subtitle: 'Add products before continuing to checkout.',
                  )
                : Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                      children: [
                        const Text(
                          'Review your cart',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Choose a saved location, select a payment method, and confirm the order.',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 20),

                        ...cart.items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: OrderItemTile(
                              title: item.product.name,
                              imageUrl: item.product.imageUrl,
                              quantity: item.quantity,
                              unitPrice: item.product.price,
                              totalPrice: item.totalPrice,
                            ),
                          );
                        }),

                        const SizedBox(height: 8),
                        OrderSummaryCard(
                          itemCount: cart.totalItemsCount,
                          subtotal: cart.subTotal,
                          paymentMethod: _paymentMethod,
                          note: _notesController.text,
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          'Delivery location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: _chooseSavedAddress,
                            icon: const Icon(Icons.location_on_rounded),
                            label: const Text('Choose saved address'),
                          ),
                        ),

                        const SizedBox(height: 10),
                        _selectedAddressCard(context),

                        const SizedBox(height: 20),

                        const Text(
                          'Payment method',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        PaymentMethodSelector(
                          value: _paymentMethod,
                          onChanged: (value) =>
                              setState(() => _paymentMethod = value),
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          'Order notes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 4,
                          decoration: _fieldDecoration(
                            context,
                            label: 'Notes',
                            hintText:
                                'Optional notes for the clinic or delivery team',
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
            bottomNavigationBar: cart.items.isEmpty
                ? null
                : SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total ${NumberFormat.currency(symbol: 'ل.س ', decimalDigits: 2).format(cart.subTotal)}',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 12),
                          CustomButton(
                            text: provider.isSubmitting
                                ? 'Confirming...'
                                : 'Confirm order',
                            onPressed: provider.isSubmitting
                                ? null
                                : () => _submitOrder(context),
                            isLoading: provider.isSubmitting,
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
