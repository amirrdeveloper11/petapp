import 'package:flutter/material.dart';
import 'package:front/features/order/provider/order_provider.dart';
import 'package:front/features/order/widgets/order_card.dart';
import 'package:provider/provider.dart';

import 'package:front/routes/app_routes.dart';
import 'package:front/widgets/app_empty_state.dart';
import 'package:front/widgets/app_shimmer.dart';
import 'package:front/widgets/custom_button.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late final OrderProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = OrderProvider()..fetchOrders();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<OrderProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'My Orders',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              surfaceTintColor: Colors.transparent,
            ),
            body: RefreshIndicator(
              onRefresh: provider.refresh,
              child: provider.isLoading && provider.orders.isEmpty
                  ? ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (_, __) => const AppShimmer(height: 108, width: double.infinity),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemCount: 5,
                    )
                  : provider.errorMessage != null && provider.orders.isEmpty
                      ? ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            AppEmptyState(
                              icon: Icons.error_outline_rounded,
                              title: 'Could not load orders',
                              subtitle: provider.errorMessage ?? 'Try again.',
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              text: 'Retry',
                              onPressed: provider.fetchOrders,
                            ),
                          ],
                        )
                      : provider.orders.isEmpty
                          ? ListView(
                              padding: const EdgeInsets.all(16),
                              children: const [
                                AppEmptyState(
                                  icon: Icons.receipt_long_outlined,
                                  title: 'No orders yet',
                                  subtitle: 'Placed orders will appear here.',
                                ),
                              ],
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                              itemCount: provider.orders.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final order = provider.orders[index];

                                return OrderCard(
                                  order: order,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.orderDetails,
                                      arguments: order,
                                    );
                                  },
                                );
                              },
                            ),
            ),
          );
        },
      ),
    );
  }
}