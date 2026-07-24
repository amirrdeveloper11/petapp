import 'order_item_model.dart';
import 'payment_method.dart';

class OrderRequest {
  final List<OrderItemModel> items;
  final PaymentMethodType paymentMethod;
  final String deliveryAddress;
  final String city;
  final String area;
  final String contactPhone;
  final String? paymentReference;
  final String? notes;

  const OrderRequest({
    required this.items,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.city,
    required this.area,
    required this.contactPhone,
    this.paymentReference,
    this.notes,
  });

  double get subtotal => items.fold<double>(0, (sum, item) => sum + item.totalPrice);

  Map<String, dynamic> toJson() {
    return {
      'payment_method': paymentMethod.apiValue,
      'payment_reference': _clean(paymentReference),
      'delivery_address': deliveryAddress.trim(),
      'city': city.trim(),
      'area': area.trim(),
      'contact_phone': contactPhone.trim(),
      'notes': _clean(notes),
      'items': items
          .map(
            (item) => {
              'product_id': item.productId,
              'quantity': item.quantity,
            },
          )
          .toList(),
    };
  }

  String? _clean(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? null : text;
  }
}
