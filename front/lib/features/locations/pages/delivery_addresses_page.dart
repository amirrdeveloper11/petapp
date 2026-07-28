import 'package:flutter/material.dart';
import 'package:front/features/locations/model/delivery_address_model.dart';
import 'package:provider/provider.dart';
import 'package:front/widgets/app_confirm_dialog.dart';
import 'package:front/widgets/app_empty_state.dart';
import 'package:front/widgets/custom_button.dart';
import '../provider/delivery_address_provider.dart';
import '../widgets/delivery_address_card.dart';
import 'delivery_address_form_page.dart';

class DeliveryAddressesPage extends StatefulWidget {
  const DeliveryAddressesPage({super.key});

  @override
  State<DeliveryAddressesPage> createState() => _DeliveryAddressesPageState();
}

class _DeliveryAddressesPageState extends State<DeliveryAddressesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeliveryAddressProvider>().fetchAddresses();
    });
  }

  Future<void> _openForm({DeliveryAddressModel? address}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DeliveryAddressFormPage(address: address),
      ),
    );
  }

  Future<void> _deleteAddress(int id) async {
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: 'Delete address',
      message: 'Are you sure you want to delete this address?',
      confirmText: 'Delete',
      destructive: true,
    );

    if (!confirmed) return;

    final provider = context.read<DeliveryAddressProvider>();

    try {
      await provider.deleteAddress(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address deleted successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryAddressProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'My Addresses',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),

          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openForm(),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add address'),
          ),

          body: RefreshIndicator(
            onRefresh: provider.fetchAddresses,
            child: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : provider.addresses.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      const SizedBox(height: 80),
                      const AppEmptyState(
                        icon: Icons.location_off_rounded,
                        title: 'No saved addresses yet',
                        subtitle:
                            'Add your first delivery address to reuse it during checkout.',
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Add address',
                        icon: Icons.add_rounded,
                        onPressed: () => _openForm(),
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                    itemCount: provider.addresses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final address = provider.addresses[index];
                      return DeliveryAddressCard(
                        address: address,
                        onTap: () {},
                        onEdit: () => _openForm(address: address),
                        onDelete: () => _deleteAddress(address.id!),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
