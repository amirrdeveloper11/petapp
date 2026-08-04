import 'package:flutter/material.dart';

import 'package:front/features/order/model/order_item_model.dart';
import 'package:front/features/order/model/order_model.dart';
import 'package:front/features/order/model/order_request.dart';
import 'package:front/features/order/model/payment_method.dart';
import 'package:front/core/services/order_service.dart';
import 'package:front/features/store/models/cart_item_model.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _service;

  OrderProvider({OrderService? service}) : _service = service ??  OrderService();

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  Future<void> fetchOrders() async {
    _setLoading(true);
    try {
      _errorMessage = null;
      _orders = await _service.fetchOrders();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<OrderModel> submitCartOrder({
    required List<CartItemModel> cartItems,
    required PaymentMethodType paymentMethod,
    required String deliveryAddress,
    required String city,
    required String area,
    required String contactPhone,
    String? paymentReference,
    String? notes,
  }) async {
    _setSubmitting(true);
    try {
      _errorMessage = null;

      final request = OrderRequest(
        items: cartItems.map(OrderItemModel.fromCartItem).toList(),
        paymentMethod: paymentMethod,
        deliveryAddress: deliveryAddress,
        city: city,
        area: area,
        contactPhone: contactPhone,
        paymentReference: paymentReference,
        notes: notes,
      );

      final created = await _service.createOrder(request);
      _orders = [created, ..._orders.where((order) => order.id != created.id)];
      return created;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _setSubmitting(false);
    }
  }

  Future<OrderModel> cancelOrder(OrderModel order) async {
    final id = order.id;
    if (id == null) {
      throw Exception('Order id is missing.');
    }

    _setSubmitting(true);
    try {
      _errorMessage = null;
      final updated = await _service.cancelOrder(id);
      _orders = _orders.map((item) => item.id == updated.id ? updated : item).toList();
      return updated;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _setSubmitting(false);
    }
  }

  Future<void> refresh() => fetchOrders();

  void replaceLocal(OrderModel order) {
    if (order.id == null) return;
    _orders = _orders.map((item) => item.id == order.id ? order : item).toList();
    notifyListeners();
  }

  void _setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  void _setSubmitting(bool value) {
    if (_isSubmitting == value) return;
    _isSubmitting = value;
    notifyListeners();
  }
}
