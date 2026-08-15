import 'package:flutter/material.dart';
import 'package:front/core/theme.dart';
import 'package:front/features/order/provider/order_provider.dart';
import 'package:front/features/order/widgets/order_card.dart';
import 'package:provider/provider.dart';

import 'package:front/routes/app_routes.dart';
import 'package:front/widgets/app_empty_state.dart';
import 'package:front/widgets/app_loading_states.dart';

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
            backgroundColor: AppColors.cream,
            appBar: AppBar(
              backgroundColor: AppColors.cream,
              title: const Text(
                'My Orders',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              iconTheme: const IconThemeData(color: AppColors.deepTeal),
              surfaceTintColor: Colors.transparent,
              elevation: 0,
            ),
            body: RefreshIndicator(
              color: AppColors.teal,
              onRefresh: provider.refresh,
              child: _buildBody(provider),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(OrderProvider provider) {
    if (provider.isLoading && provider.orders.isEmpty) {
      return const AppListShimmer();
    }

    if (provider.errorMessage != null && provider.orders.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppEmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Could not load orders',
            subtitle: provider.errorMessage ?? 'Try again.',
            actionLabel: 'Retry',
            onAction: provider.fetchOrders,
          ),
        ],
      );
    }

    if (provider.orders.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 100),
          AppEmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'No orders yet',
            subtitle: 'Placed orders will appear here.',
          ),
        ],
      );
    }

    return ListView.separated(
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
    );
  }
}
