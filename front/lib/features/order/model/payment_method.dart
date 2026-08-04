enum PaymentMethodType { cashOnDelivery, online }

extension PaymentMethodTypeX on PaymentMethodType {
  String get label {
    switch (this) {
      case PaymentMethodType.cashOnDelivery:
        return 'Cash on delivery';
      case PaymentMethodType.online:
        return 'Online payment';
    }
  }

  String get apiValue {
    switch (this) {
      case PaymentMethodType.cashOnDelivery:
        return 'cod';
      case PaymentMethodType.online:
        return 'online';
    }
  }

  String get shortLabel {
    switch (this) {
      case PaymentMethodType.cashOnDelivery:
        return 'COD';
      case PaymentMethodType.online:
        return 'Online';
    }
  }
}

PaymentMethodType paymentMethodFromJson(String? value) {
  final normalized = (value ?? '').trim().toLowerCase();

  if (normalized.contains('online') || normalized.contains('manual')) {
    return PaymentMethodType.online;
  }

  return PaymentMethodType.cashOnDelivery;
}
