import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(99),
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
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: provider.loading
                        ? const Center(child: CircularProgressIndicator())
                        : provider.addresses.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24),
                                  child: Text(
                                    'No saved addresses yet.\nAdd one from My Addresses.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
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
                                    onTap: () => Navigator.pop(
                                      context,
                                      address,
                                    ),
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

  const _AddressPickTile({
    required this.address,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.location_on_rounded),
        title: Text(
          address.city,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${address.area}\n${address.deliveryAddress}',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: true,
      ),
    );
  }
}