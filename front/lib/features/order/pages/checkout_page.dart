import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
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
import 'package:front/widgets/app_card.dart';
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
          color: AppColors.tealSoft,
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
        child: const Text(
          'No saved address selected',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.tealSoft,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.deepTeal.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: AppColors.deepTeal,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Selected address',
                style: TextStyle(
                  color: AppColors.deepTeal,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _selectedAddress!.deliveryAddress,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              height: 1.45,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_selectedAddress!.city} • ${_selectedAddress!.area}',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            _selectedAddress!.contactPhone,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          if ((_selectedAddress!.notes ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              _selectedAddress!.notes!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
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
      labelStyle: const TextStyle(color: AppColors.textSecondary),
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
    final cart = context.watch<CartProvider>();

    return ChangeNotifierProvider.value(
      value: _orderProvider,
      child: Consumer<OrderProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: AppColors.cream,
            appBar: AppBar(
              backgroundColor: AppColors.cream,
              title: const Text(
                'Checkout',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              centerTitle: false,
              iconTheme: const IconThemeData(color: AppColors.deepTeal),
              surfaceTintColor: Colors.transparent,
              elevation: 0,
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
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Choose a saved location, select a payment method, and confirm the order.',
                          style: TextStyle(
                            color: AppColors.textSecondary.withOpacity(0.95),
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 20),

                        ...cart.items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AppCard(
                              padding: const EdgeInsets.all(14),
                              child: OrderItemTile(
                                title: item.product.name,
                                imageUrl: item.product.imageUrl,
                                quantity: item.quantity,
                                unitPrice: item.product.price,
                                totalPrice: item.totalPrice,
                                showDivider: false,
                              ),
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

                        const SizedBox(height: 24),
                        const Text(
                          'Delivery location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: _chooseSavedAddress,
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.deepTeal,
                            ),
                            icon: const Icon(Icons.location_on_rounded),
                            label: const Text(
                              'Choose saved address',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        _selectedAddressCard(context),

                        const SizedBox(height: 24),

                        const Text(
                          'Payment method',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        PaymentMethodSelector(
                          value: _paymentMethod,
                          onChanged: (value) =>
                              setState(() => _paymentMethod = value),
                        ),

                        const SizedBox(height: 24),
                        const Text(
                          'Order notes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 4,
                          style: const TextStyle(color: AppColors.textPrimary),
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
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      decoration: BoxDecoration(
                        color: AppColors.ivory,
                        boxShadow: AppShadows.card,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppRadii.xl),
                          topRight: Radius.circular(AppRadii.xl),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total ${NumberFormat.currency(symbol: 'ل.س ', decimalDigits: 2).format(cart.subTotal)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.deepTeal,
                              fontSize: 16,
                            ),
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
                            icon: Icons.check_circle_rounded,
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
