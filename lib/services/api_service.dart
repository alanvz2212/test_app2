import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.abm4laminate.com'; // Replace with actual API URL
  static const Duration timeout = Duration(seconds: 30);

  // Headers for API requests
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // GET request
  static Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      Uri uri = Uri.parse('$baseUrl$endpoint');
      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await http.get(uri, headers: headers).timeout(timeout);
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // POST request
  static Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(timeout);
      
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // PUT request
  static Future<Map<String, dynamic>> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(timeout);
      
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      ).timeout(timeout);
      
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  // Handle HTTP response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw ApiException(
        data['message'] ?? 'Request failed with status ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  // Authentication endpoints
  static Future<Map<String, dynamic>> login(String phone, String otp) async {
    return await post('/auth/login', body: {
      'phone': phone,
      'otp': otp,
    });
  }

  static Future<Map<String, dynamic>> loginDealer(String dealerId, String password) async {
    return await post('/auth/dealer-login', body: {
      'dealerId': dealerId,
      'password': password,
    });
  }

  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    return await post('/auth/send-otp', body: {
      'phone': phone,
    });
  }

  // Product endpoints
  static Future<Map<String, dynamic>> getProducts({Map<String, String>? filters}) async {
    return await get('/products', queryParams: filters);
  }

  static Future<Map<String, dynamic>> getProduct(String productId) async {
    return await get('/products/$productId');
  }

  // Order endpoints
  static Future<Map<String, dynamic>> getOrders(String dealerId) async {
    return await get('/orders', queryParams: {'dealerId': dealerId});
  }

  static Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    return await post('/orders', body: orderData);
  }

  static Future<Map<String, dynamic>> getOrder(String orderId) async {
    return await get('/orders/$orderId');
  }

  // Enquiry endpoints
  static Future<Map<String, dynamic>> getEnquiries(String customerId) async {
    return await get('/enquiries', queryParams: {'customerId': customerId});
  }

  static Future<Map<String, dynamic>> createEnquiry(Map<String, dynamic> enquiryData) async {
    return await post('/enquiries', body: enquiryData);
  }

  // Loyalty endpoints
  static Future<Map<String, dynamic>> getLoyaltyData(String dealerId) async {
    return await get('/loyalty/$dealerId');
  }

  static Future<Map<String, dynamic>> redeemReward(String dealerId, String rewardId) async {
    return await post('/loyalty/redeem', body: {
      'dealerId': dealerId,
      'rewardId': rewardId,
    });
  }

  // Promotion endpoints
  static Future<Map<String, dynamic>> getPromotions({String? userType}) async {
    Map<String, String>? params;
    if (userType != null) {
      params = {'userType': userType};
    }
    return await get('/promotions', queryParams: params);
  }

  // Dealer endpoints
  static Future<Map<String, dynamic>> getNearbyDealers(double latitude, double longitude) async {
    return await get('/dealers/nearby', queryParams: {
      'lat': latitude.toString(),
      'lng': longitude.toString(),
    });
  }

  static Future<Map<String, dynamic>> getDealersByPincode(String pincode) async {
    return await get('/dealers/by-pincode', queryParams: {'pincode': pincode});
  }

  // Profile endpoints
  static Future<Map<String, dynamic>> updateProfile(String userId, Map<String, dynamic> profileData) async {
    return await put('/users/$userId', body: profileData);
  }

  // Payment endpoints
  static Future<Map<String, dynamic>> getPaymentDues(String dealerId) async {
    return await get('/payments/dues/$dealerId');
  }

  static Future<Map<String, dynamic>> makePayment(Map<String, dynamic> paymentData) async {
    return await post('/payments', body: paymentData);
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message';
}