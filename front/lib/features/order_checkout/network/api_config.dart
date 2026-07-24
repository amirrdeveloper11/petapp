class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  static const String orders = '/api/orders';
  static const String appointments = '/api/appointments';
  static const String deliveryAddresses = '/api/delivery-addresses';

  static String orderById(int id) => '$orders/$id';
  static String appointmentById(int id) => '$appointments/$id';
  static String deliveryAddressById(int id) => '$deliveryAddresses/$id';
}