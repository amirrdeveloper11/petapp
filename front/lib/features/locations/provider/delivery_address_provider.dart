import 'package:flutter/material.dart';

import '../model/delivery_address_model.dart';
import '../../../core/services/delivery_address_service.dart';

class DeliveryAddressProvider extends ChangeNotifier {
  final DeliveryAddressService _service;

  DeliveryAddressProvider({DeliveryAddressService? service})
      : _service = service ??  DeliveryAddressService();

  List<DeliveryAddressModel> _addresses = [];
  bool _loading = false;
  bool _saving = false;
  String? _errorMessage;
  int? _selectedAddressId;

  List<DeliveryAddressModel> get addresses => _addresses;
  bool get loading => _loading;
  bool get saving => _saving;
  String? get errorMessage => _errorMessage;

  DeliveryAddressModel? get selectedAddress {
    if (_selectedAddressId == null) return null;
    for (final address in _addresses) {
      if (address.id == _selectedAddressId) return address;
    }
    return null;
  }

  Future<void> fetchAddresses({bool silent = false}) async {
    if (!silent) {
      _loading = true;
      notifyListeners();
    }

    try {
      _errorMessage = null;
      _addresses = await _service.fetchAddresses();
      if (_selectedAddressId != null &&
          !_addresses.any((e) => e.id == _selectedAddressId)) {
        _selectedAddressId = null;
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('[DeliveryAddressProvider] fetchAddresses error: $e');
      _addresses = [];
    } finally {
      if (!silent) {
        _loading = false;
      }
      notifyListeners();
    }
  }

  Future<DeliveryAddressModel> createAddress(
    DeliveryAddressModel address,
  ) async {
    _saving = true;
    notifyListeners();

    try {
      _errorMessage = null;
      final created = await _service.createAddress(address);
      _addresses = [created, ..._addresses];
      return created;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('[DeliveryAddressProvider] createAddress error: $e');
      rethrow;
    } finally {
      _saving = false;
      notifyListeners();
    }
  }

  Future<DeliveryAddressModel> updateAddress(
    int id,
    DeliveryAddressModel address,
  ) async {
    _saving = true;
    notifyListeners();

    try {
      _errorMessage = null;
      final updated = await _service.updateAddress(id, address);
      final index = _addresses.indexWhere((item) => item.id == id);
      if (index != -1) {
        _addresses[index] = updated;
      }
      if (_selectedAddressId == id) {
        _selectedAddressId = updated.id;
      }
      return updated;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('[DeliveryAddressProvider] updateAddress error: $e');
      rethrow;
    } finally {
      _saving = false;
      notifyListeners();
    }
  }

  Future<void> deleteAddress(int id) async {
    _saving = true;
    notifyListeners();

    try {
      _errorMessage = null;
      await _service.deleteAddress(id);
      _addresses.removeWhere((item) => item.id == id);

      if (_selectedAddressId == id) {
        _selectedAddressId = _addresses.isNotEmpty ? _addresses.first.id : null;
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('[DeliveryAddressProvider] deleteAddress error: $e');
      rethrow;
    } finally {
      _saving = false;
      notifyListeners();
    }
  }

  void selectAddress(DeliveryAddressModel? address) {
    _selectedAddressId = address?.id;
    notifyListeners();
  }

  void clearSelection() {
    _selectedAddressId = null;
    notifyListeners();
  }
}