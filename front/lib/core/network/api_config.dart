class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  static String get apiBaseUrl => '${baseUrl.replaceAll(RegExp(r'/$'), '')}/api';

  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authRefresh = '/auth/refresh';
  static const String authLogout = '/auth/logout';
  static const String authUpdateProfile = '/auth/update-profile';
  static const String authDeleteAccount = '/auth/delete-account';

  static const String categories = '/categories';
  static const String products = '/products';

  static const String pets = '/pets';

  static const String orders = '/orders';
  static const String deliveryAddresses = '/delivery-addresses';

  static const String doctors = '/doctors';
  static const String specialties = '/specialties';
  static const String appointments = '/appointments';

  static String petById(int id) => '$pets/$id';
  static String orderById(int id) => '$orders/$id';
  static String orderCancel(int id) => '$orders/$id/cancel';

  static String deliveryAddressById(int id) => '$deliveryAddresses/$id';

  static String doctorById(int id) => '$doctors/$id';
  static String doctorSchedule(int id) => '$doctors/$id/schedule';

  static String appointmentById(int id) => '$appointments/$id';
  static String appointmentCancel(int id) => '$appointments/$id/cancel';
  static String appointmentReschedule(int id) => '$appointments/$id/reschedule';
}