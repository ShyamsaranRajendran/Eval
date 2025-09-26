import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../models/user_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _accessToken;
  String? _refreshToken;

  // Set authentication tokens
  void setTokens(String accessToken, [String? refreshToken]) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  // Clear authentication tokens
  void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
  }

  // Get headers for authenticated requests
  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

    return headers;
  }

  // Generic GET request
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse(endpoint), headers: _headers);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic POST request
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: _headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic PUT request
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(endpoint),
        headers: _headers,
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic DELETE request
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse(endpoint),
        headers: _headers,
      );

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Handle HTTP responses
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return jsonDecode(response.body);
      } else {
        return {'success': true};
      }
    } else {
      throw ApiException(
        message: _getErrorMessage(response),
        statusCode: response.statusCode,
      );
    }
  }

  // Get error message from response
  String _getErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return body['message'] ?? body['error'] ?? 'Unknown error occurred';
    } catch (e) {
      return 'HTTP ${response.statusCode}: ${response.reasonPhrase}';
    }
  }

  // Handle various types of errors
  Exception _handleError(dynamic error) {
    if (error is SocketException) {
      return const ApiException(message: 'No internet connection');
    } else if (error is HttpException) {
      return ApiException(message: 'HTTP error: ${error.message}');
    } else if (error is FormatException) {
      return const ApiException(message: 'Invalid response format');
    } else if (error is ApiException) {
      return error;
    } else {
      return ApiException(message: 'Unexpected error: ${error.toString()}');
    }
  }

  // Authentication API calls
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    final response = await post(ApiEndpoints.login, loginRequest.toJson());
    final loginResponse = LoginResponse.fromJson(response);

    // Store tokens after successful login
    setTokens(loginResponse.accessToken, loginResponse.refreshToken);

    return loginResponse;
  }

  Future<void> logout() async {
    try {
      await post(ApiEndpoints.logout, {});
    } finally {
      clearTokens();
    }
  }

  Future<String> refreshAccessToken() async {
    if (_refreshToken == null) {
      throw const ApiException(message: 'No refresh token available');
    }

    final response = await post(ApiEndpoints.refreshToken, {
      'refresh_token': _refreshToken,
    });

    final newAccessToken = response['access_token'];
    if (newAccessToken != null) {
      _accessToken = newAccessToken;
      return newAccessToken;
    } else {
      throw const ApiException(message: 'Failed to refresh token');
    }
  }

  // User API calls
  Future<List<UserModel>> getUsers() async {
    final response = await get(ApiEndpoints.users);
    final List<dynamic> usersJson = response['users'] ?? response['data'] ?? [];
    return usersJson.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<UserModel> getUserProfile() async {
    final response = await get(ApiEndpoints.userProfile);
    return UserModel.fromJson(response);
  }

  // Admin API calls
  Future<List<Map<String, dynamic>>> getBatches() async {
    final response = await get(ApiEndpoints.batches);
    return List<Map<String, dynamic>>.from(
      response['batches'] ?? response['data'] ?? [],
    );
  }

  Future<List<Map<String, dynamic>>> getPanels() async {
    final response = await get(ApiEndpoints.panels);
    return List<Map<String, dynamic>>.from(
      response['panels'] ?? response['data'] ?? [],
    );
  }

  Future<Map<String, dynamic>> getReports() async {
    return await get(ApiEndpoints.reports);
  }

  // Reviewer API calls
  Future<List<Map<String, dynamic>>> getReviewerPanels() async {
    final response = await get(ApiEndpoints.reviewerPanels);
    return List<Map<String, dynamic>>.from(
      response['panels'] ?? response['data'] ?? [],
    );
  }

  Future<List<Map<String, dynamic>>> getTeamReviews() async {
    final response = await get(ApiEndpoints.teamReviews);
    return List<Map<String, dynamic>>.from(
      response['reviews'] ?? response['data'] ?? [],
    );
  }
}

// Custom exception class for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException({required this.message, this.statusCode});

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}
