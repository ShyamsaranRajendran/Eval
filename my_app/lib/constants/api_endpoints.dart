class ApiEndpoints {
  // Base URL for your API
  static const String baseUrl = 'https://localhost:3000/';

  // Authentication endpoints
  static const String login = '$baseUrl/users/login';
  static const String logout = '$baseUrl/users/logout';
  static const String refreshToken = '$baseUrl/users/refresh';

  // User endpoints
  static const String users = '$baseUrl/users';
  static const String userProfile = '$baseUrl/users/profile';

  // Admin endpoints
  static const String batches = '$baseUrl/admin/batches';
  static const String panels = '$baseUrl/admin/panels';
  static const String reports = '$baseUrl/admin/reports';

  // Reviewer endpoints
  static const String reviewerPanels = '$baseUrl/reviewer/panels';
  static const String teamReviews = '$baseUrl/reviewer/team-reviews';
}
