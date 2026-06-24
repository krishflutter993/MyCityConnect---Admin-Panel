import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/service_model.dart';

class ApiService {
  // ================= BASE URL =================

  static const String baseUrl = 'https://prakrutitech.xyz/krish';

  // ================= GET ALL SERVICES =================

  static Future<List<ServiceModel>> getServices() async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_all_services.php'),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded['status'] == true) {
        final List data = decoded['data'];

        return data
            .map(
              (e) => ServiceModel.fromJson(e),
            )
            .toList();
      } else {
        throw Exception(
          decoded['message'] ?? 'Failed to load services',
        );
      }
    } else {
      throw Exception(
        'Server Error ${response.statusCode}',
      );
    }
  }

  // ================= ADD SERVICE =================

  static Future<void> addService({
    required String name,
    required String category,
    required String phone,
    required String description,
    required String image,
  }) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/add_service.php',
      ),
      body: {
        'name': name,
        'category': category,
        'phone': phone,
        'description': description,
        'image': image,
      },
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode != 200 || decoded['status'] != true) {
      throw Exception(
        decoded['message'] ?? 'Failed to add service',
      );
    }
  }

  // ================= UPDATE SERVICE =================

  static Future<void> updateService({
    required String id,
    required String name,
    required String category,
    required String phone,
    required String description,
    required String image,
  }) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/update_service.php',
      ),
      body: {
        'id': id,
        'name': name,
        'category': category,
        'phone': phone,
        'description': description,
        'image': image,
      },
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode != 200 || decoded['status'] != true) {
      throw Exception(
        decoded['message'] ?? 'Failed to update service',
      );
    }
  }

  // ================= DELETE SERVICE =================

  static Future<void> deleteService(String id) async {
    if (id.isEmpty) {
      throw Exception("ID is required");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/delete_service.php?id=$id'),
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode != 200 || decoded['status'] != true) {
      throw Exception(decoded['message'] ?? 'Failed to delete service');
    }
  }

  // ================= GET CATEGORIES =================

  static Future<List<String>> getCategories() async {
    final services = await getServices();

    final categories = services.map((e) => e.category).toSet().toList();

    return categories;
  }

  // ================= TOTAL SERVICES =================

  static Future<int> getTotalServices() async {
    final services = await getServices();

    return services.length;
  }

  // ================= TOTAL CATEGORIES =================

  static Future<int> getTotalCategories() async {
    final categories = await getCategories();

    return categories.length;
  }

  // ================= TOTAL BOOKINGS =================

  static Future<int> getTotalBookings() async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_bookings.php'),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded['status'] == true) {
        final List data = decoded['data'] ?? [];
        return data.length;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  // ================= GET ALL BOOKINGS =================

  static Future<List<Map<String, dynamic>>> getAllBookings() async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_bookings.php'),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded['status'] == true) {
        final List data = decoded['data'] ?? [];
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception(decoded['message'] ?? 'Failed to load bookings');
      }
    } else {
      throw Exception('Server Error ${response.statusCode}');
    }
  }

  // ================= DELETE BOOKING =================

  static Future<void> deleteBooking(String id) async {
    if (id.isEmpty) {
      throw Exception("ID is required");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/delete_booking.php?id=$id'),
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode != 200 || decoded['status'] != true) {
      throw Exception(decoded['message'] ?? 'Failed to delete booking');
    }
  }
}
