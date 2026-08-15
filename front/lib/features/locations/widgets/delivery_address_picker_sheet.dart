import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:front/core/theme.dart';
import 'package:front/widgets/app_empty_state.dart';

import '../model/delivery_address_model.dart';
import '../provider/delivery_address_provider.dart';

class DeliveryAddressPickerSheet extends StatefulWidget {
  const DeliveryAddressPickerSheet({super.key});

  @override
  State<DeliveryAddressPickerSheet> createState() =>
      _DeliveryAddressPickerSheetState();
}

class _DeliveryAddressPickerSheetState
    extends State<DeliveryAddressPickerSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeliveryAddressProvider>().fetchAddresses(silent: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryAddressProvider>(
      builder: (context, provider, _) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 520),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadii.xl),
                ),
                color: AppColors.ivory,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.hairline,
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Choose saved address',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: provider.loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.teal,
                            ),
                          )
                        : provider.addresses.isEmpty
                        ? const AppEmptyState(
                            icon: Icons.location_off_rounded,
                            title: 'No saved addresses yet',
                            subtitle: 'Add one from My Addresses.',
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: provider.addresses.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final address = provider.addresses[index];
                              return _AddressPickTile(
                                address: address,
                                onTap: () => Navigator.pop(context, address),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AddressPickTile extends StatelessWidget {
  final DeliveryAddressModel address;
  final VoidCallback onTap;

  const _AddressPickTile({required this.address, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.tealSoft,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: AppColors.deepTeal,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.city,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${address.area}\n${address.deliveryAddress}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
