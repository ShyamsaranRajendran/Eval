import '../datasources/api_client.dart';
import '../models/user_models.dart';
import '../../core/constants/app_constants.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  /// Set access token in API client
  Future<void> setAccessToken(String token) async {
    await _apiClient.setAccessToken(token);
  }

  /// Login user
  Future<LoginResponse> login(LoginRequest request) async {
    // For demo purposes, handle mock logins
    if (_isMockLogin(request.email)) {
      return _mockLogin(request);
    }

    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );

    return LoginResponse.fromJson(response.data);
  }

  /// Check if this is a mock login for demo purposes
  bool _isMockLogin(String email) {
    return email.endsWith('@university.edu') || email.contains('demo');
  }

  /// Handle mock login for demo purposes
  Future<LoginResponse> _mockLogin(LoginRequest request) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    UserRole role;
    String name;
    String department = 'Computer Science';

    // Determine role based on email
    if (request.email.contains('admin')) {
      role = UserRole.admin;
      name = 'System Administrator';
      department = 'Administration';
    } else if (request.email.contains('coordinator')) {
      role = UserRole.coordinator;
      name = 'Dr. Sarah Johnson';
      department = 'Panel Coordination';
    } else {
      role = UserRole.faculty;
      name = 'Prof. John Smith';
      department = 'Computer Science';
    }

    // Mock user data
    final user = UserModel(
      id: 'demo_${role.toString().split('.').last}',
      email: request.email,
      password: '', // Empty password for security
      name: name,
      role: role,
      department: department,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );

    // Mock tokens
    final loginResponse = LoginResponse(
      user: user,
      accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken:
          'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );

    return loginResponse;
  }

  /// Register user (admin only)
  Future<UserModel> register(RegisterRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: request.toJson(),
    );

    return UserModel.fromJson(response.data);
  }

  /// Logout user
  Future<void> logout() async {
    await _apiClient.post(ApiEndpoints.logout);
    await _apiClient.clearTokens();
  }

  /// Get current user profile
  Future<UserModel> getCurrentUser() async {
    final response = await _apiClient.get(ApiEndpoints.profile);
    return UserModel.fromJson(response.data);
  }

  /// Update user profile
  Future<UserModel> updateProfile(
    String userId,
    UpdateUserRequest request,
  ) async {
    final response = await _apiClient.put(
      ApiEndpoints.userById(userId),
      data: request.toJson(),
    );

    return UserModel.fromJson(response.data);
  }

  /// Get faculty users
  Future<List<UserModel>> getFaculty() async {
    final response = await _apiClient.get(ApiEndpoints.faculty);
    final List<dynamic> data = response.data['users'] ?? response.data;
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  /// Get all users (admin only)
  Future<List<UserModel>> getUsers({
    int page = 1,
    int pageSize = 20,
    String? role,
    String? department,
  }) async {
    final queryParams = <String, dynamic>{'page': page, 'page_size': pageSize};

    if (role != null) queryParams['role'] = role;
    if (department != null) queryParams['department'] = department;

    final response = await _apiClient.get(
      ApiEndpoints.users,
      queryParameters: queryParams,
    );

    final List<dynamic> data = response.data['users'] ?? response.data;
    return data.map((json) => UserModel.fromJson(json)).toList();
  }
}
