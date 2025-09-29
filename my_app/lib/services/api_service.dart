import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../models/user_model.dart';
import '../models/project_model.dart';
import '../models/batch_model.dart';
import '../models/panel_model.dart';
import '../models/review_model.dart';
import '../models/student_model.dart';

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

  // Project API calls
  Future<List<ProjectModel>> getProjects() async {
    final response = await get(ApiEndpoints.projects);
    final List<dynamic> projectsJson =
        response['projects'] ?? response['data'] ?? [];
    return projectsJson.map((json) => ProjectModel.fromJson(json)).toList();
  }

  Future<List<String>> getProjectNames() async {
    final response = await get(ApiEndpoints.projectNames);
    return List<String>.from(response['names'] ?? response['data'] ?? []);
  }

  Future<ProjectModel> getProjectById(String id) async {
    final response = await get(ApiEndpoints.getProjectById(id));
    return ProjectModel.fromJson(response);
  }

  Future<List<ProjectModel>> getProjectsByBatch(String batchId) async {
    final response = await get(ApiEndpoints.getProjectsByBatch(batchId));
    final List<dynamic> projectsJson =
        response['projects'] ?? response['data'] ?? [];
    return projectsJson.map((json) => ProjectModel.fromJson(json)).toList();
  }

  Future<List<ProjectModel>> getProjectsBySupervisor(
    String supervisorId,
  ) async {
    final response = await get(
      ApiEndpoints.getProjectsBySupervisor(supervisorId),
    );
    final List<dynamic> projectsJson =
        response['projects'] ?? response['data'] ?? [];
    return projectsJson.map((json) => ProjectModel.fromJson(json)).toList();
  }

  Future<ProjectModel> createProject(Map<String, dynamic> projectData) async {
    final response = await post(ApiEndpoints.projects, projectData);
    return ProjectModel.fromJson(response);
  }

  Future<ProjectModel> updateProject(
    String id,
    Map<String, dynamic> projectData,
  ) async {
    final response = await put(ApiEndpoints.getProjectById(id), projectData);
    return ProjectModel.fromJson(response);
  }

  Future<void> deleteProject(String id) async {
    await delete(ApiEndpoints.getProjectById(id));
  }

  Future<ProjectModel> updateProjectStudents(
    String id,
    List<String> studentIds,
  ) async {
    final response = await put(ApiEndpoints.updateProjectStudents(id), {
      'student_ids': studentIds,
    });
    return ProjectModel.fromJson(response);
  }

  Future<ProjectModel> updateProjectReviewers(
    String id,
    List<String> reviewerIds,
  ) async {
    final response = await put(ApiEndpoints.updateProjectReviewers(id), {
      'reviewer_ids': reviewerIds,
    });
    return ProjectModel.fromJson(response);
  }

  // Batch API calls
  Future<List<BatchModel>> getBatches() async {
    final response = await get(ApiEndpoints.batches);
    final List<dynamic> batchesJson =
        response['batches'] ?? response['data'] ?? [];
    return batchesJson.map((json) => BatchModel.fromJson(json)).toList();
  }

  Future<BatchModel> getBatchById(String id) async {
    final response = await get(ApiEndpoints.getBatchById(id));
    return BatchModel.fromJson(response);
  }

  Future<List<BatchModel>> getBatchesByDepartment(String department) async {
    final response = await get(ApiEndpoints.getBatchesByDepartment(department));
    final List<dynamic> batchesJson =
        response['batches'] ?? response['data'] ?? [];
    return batchesJson.map((json) => BatchModel.fromJson(json)).toList();
  }

  Future<List<BatchModel>> getBatchesByYear(int year) async {
    final response = await get(ApiEndpoints.getBatchesByYear(year));
    final List<dynamic> batchesJson =
        response['batches'] ?? response['data'] ?? [];
    return batchesJson.map((json) => BatchModel.fromJson(json)).toList();
  }

  Future<BatchModel> createBatch(Map<String, dynamic> batchData) async {
    final response = await post(ApiEndpoints.batches, batchData);
    return BatchModel.fromJson(response);
  }

  Future<BatchModel> updateBatch(
    String id,
    Map<String, dynamic> batchData,
  ) async {
    final response = await put(ApiEndpoints.getBatchById(id), batchData);
    return BatchModel.fromJson(response);
  }

  Future<void> deleteBatch(String id) async {
    await delete(ApiEndpoints.getBatchById(id));
  }

  // Panel API calls
  Future<List<PanelModel>> getPanels() async {
    final response = await get(ApiEndpoints.panels);
    final List<dynamic> panelsJson =
        response['panels'] ?? response['data'] ?? [];
    return panelsJson.map((json) => PanelModel.fromJson(json)).toList();
  }

  Future<PanelModel> getPanelById(String id) async {
    final response = await get(ApiEndpoints.getPanelById(id));
    return PanelModel.fromJson(response);
  }

  Future<List<PanelModel>> getPanelsByCoordinator(String coordinatorId) async {
    final response = await get(
      ApiEndpoints.getPanelsByCoordinator(coordinatorId),
    );
    final List<dynamic> panelsJson =
        response['panels'] ?? response['data'] ?? [];
    return panelsJson.map((json) => PanelModel.fromJson(json)).toList();
  }

  Future<PanelModel> createPanel(Map<String, dynamic> panelData) async {
    final response = await post(ApiEndpoints.panels, panelData);
    return PanelModel.fromJson(response);
  }

  Future<PanelModel> updatePanel(
    String id,
    Map<String, dynamic> panelData,
  ) async {
    final response = await put(ApiEndpoints.getPanelById(id), panelData);
    return PanelModel.fromJson(response);
  }

  Future<void> deletePanel(String id) async {
    await delete(ApiEndpoints.getPanelById(id));
  }

  Future<PanelModel> addProjectToPanel(String panelId, String projectId) async {
    final response = await put(ApiEndpoints.addProjectToPanel(panelId), {
      'project_id': projectId,
    });
    return PanelModel.fromJson(response);
  }

  Future<void> removeProjectFromPanel(String panelId, String projectId) async {
    await delete(ApiEndpoints.removeProjectFromPanel(panelId, projectId));
  }

  // Review API calls
  Future<List<ReviewModel>> getReviews() async {
    final response = await get(ApiEndpoints.reviews);
    final List<dynamic> reviewsJson =
        response['reviews'] ?? response['data'] ?? [];
    return reviewsJson.map((json) => ReviewModel.fromJson(json)).toList();
  }

  Future<ReviewModel> getReviewById(String id) async {
    final response = await get(ApiEndpoints.getReviewById(id));
    return ReviewModel.fromJson(response);
  }

  Future<List<ReviewModel>> getReviewsByProject(String projectId) async {
    final response = await get(ApiEndpoints.getReviewsByProject(projectId));
    final List<dynamic> reviewsJson =
        response['reviews'] ?? response['data'] ?? [];
    return reviewsJson.map((json) => ReviewModel.fromJson(json)).toList();
  }

  Future<ReviewModel> getProjectReviewByNumber(
    String projectId,
    int reviewNumber,
  ) async {
    final response = await get(
      ApiEndpoints.getProjectReviewByNumber(projectId, reviewNumber),
    );
    return ReviewModel.fromJson(response);
  }

  Future<ReviewModel> createReview(Map<String, dynamic> reviewData) async {
    final response = await post(ApiEndpoints.reviews, reviewData);
    return ReviewModel.fromJson(response);
  }

  Future<ReviewModel> updateReview(
    String id,
    Map<String, dynamic> reviewData,
  ) async {
    final response = await put(ApiEndpoints.getReviewById(id), reviewData);
    return ReviewModel.fromJson(response);
  }

  Future<void> deleteReview(String id) async {
    await delete(ApiEndpoints.getReviewById(id));
  }

  Future<ReviewModel> updateReviewMarks(
    String id,
    Map<String, double> marks,
  ) async {
    final response = await put(ApiEndpoints.updateReviewMarks(id), {
      'marks': marks,
    });
    return ReviewModel.fromJson(response);
  }

  Future<ReviewModel> updateReviewComments(
    String id,
    Map<String, String> comments,
  ) async {
    final response = await put(ApiEndpoints.updateReviewComments(id), {
      'comments': comments,
    });
    return ReviewModel.fromJson(response);
  }

  Future<double> getReviewTotalScore(String id) async {
    final response = await get(ApiEndpoints.getReviewTotalScore(id));
    return (response['total_score'] ?? 0.0).toDouble();
  }

  // Student API calls
  Future<List<StudentModel>> getStudents() async {
    final users = await getUsers();
    return users
        .where((user) => user.role.toLowerCase() == 'student')
        .map((user) => StudentModel.fromJson(user.toJson()))
        .toList();
  }

  // Admin API calls
  Future<Map<String, dynamic>> getAdminReports() async {
    return await get(ApiEndpoints.adminReports);
  }

  Future<Map<String, dynamic>> getAdminDashboard() async {
    return await get(ApiEndpoints.adminDashboard);
  }

  // Reviewer API calls
  Future<List<PanelModel>> getReviewerPanels() async {
    final response = await get(ApiEndpoints.reviewerPanels);
    final List<dynamic> panelsJson =
        response['panels'] ?? response['data'] ?? [];
    return panelsJson.map((json) => PanelModel.fromJson(json)).toList();
  }

  Future<List<ReviewModel>> getTeamReviews() async {
    final response = await get(ApiEndpoints.teamReviews);
    final List<dynamic> reviewsJson =
        response['reviews'] ?? response['data'] ?? [];
    return reviewsJson.map((json) => ReviewModel.fromJson(json)).toList();
  }

  // Add missing methods
  Future<List<Map<String, dynamic>>> getReports() async {
    // Placeholder implementation
    return [
      {
        'title': 'Evaluation Summary',
        'type': 'summary',
        'data': 'Sample report data',
      },
    ];
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
