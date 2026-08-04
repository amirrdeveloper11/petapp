class ApiResponseParser {
  ApiResponseParser._();

  static dynamic extract(
    dynamic response, {
    List<String> keys = const [
      'data',
      'result',
      'item',
      'order',
      'address',
      'appointment',
      'doctor',
      'user',
      'pet',
      'category',
      'categories',
      'products',
      'orders',
      'appointments',
      'addresses',
      'doctors',
      'specialties',
      'pets',
    ],
  }) {
    if (response == null) return null;

    if (response is Map) {
      final map = Map<String, dynamic>.from(response);

      for (final key in keys) {
        final candidate = map[key];
        if (candidate is Map || candidate is List) {
          return candidate;
        }
      }

      final data = map['data'];
      if (data is Map || data is List) return data;

      final result = map['result'];
      if (result is Map || result is List) return result;
    }

    return response;
  }

  static List<Map<String, dynamic>> list(
    dynamic response, {
    List<String> keys = const [
      'data',
      'items',
      'list',
      'result',
      'categories',
      'products',
      'orders',
      'appointments',
      'addresses',
      'doctors',
      'specialties',
      'pets',
    ],
  }) {
    final extracted = extract(response, keys: keys);

    if (extracted is List) {
      return extracted
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    if (extracted is Map) {
      final map = Map<String, dynamic>.from(extracted);

      for (final key in keys) {
        final candidate = map[key];
        if (candidate is List) {
          return candidate
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        }
      }

      for (final value in map.values) {
        if (value is List) {
          return value
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        }
      }
    }

    return const [];
  }

  static Map<String, dynamic> map(
    dynamic response, {
    List<String> keys = const [
      'data',
      'result',
      'item',
      'order',
      'address',
      'appointment',
      'doctor',
      'user',
      'pet',
      'category',
    ],
  }) {
    final extracted = extract(response, keys: keys);

    if (extracted is Map) {
      return Map<String, dynamic>.from(extracted);
    }

    if (extracted is List &&
        extracted.isNotEmpty &&
        extracted.first is Map) {
      return Map<String, dynamic>.from(extracted.first as Map);
    }

    return <String, dynamic>{};
  }
}