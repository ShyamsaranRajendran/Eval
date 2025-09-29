class ApiEndpoints {
  // Base URL for your API
  static const String baseUrl = 'http://10.177.222.201:3000';

  // Authentication endpoints
  static const String login = '$baseUrl/users/login';
  static const String logout = '$baseUrl/users/logout';
  static const String refreshToken = '$baseUrl/users/refresh';

  // User endpoints
  static const String users = '$baseUrl/users';
  static const String userProfile = '$baseUrl/users/profile';
  static String getUserById(String id) => '$users/$id';
  static String getUsersByRole(String role) => '$users/role/$role';

  // Project endpoints
  static const String projects = '$baseUrl/projects';
  static const String projectNames = '$baseUrl/projects/names';
  static String getProjectById(String id) => '$projects/$id';
  static String getProjectsByBatch(String batchId) =>
      '$projects/batch/$batchId';
  static String getProjectsBySupervisor(String supervisorId) =>
      '$projects/supervisor/$supervisorId';
  static String updateProjectStudents(String id) => '$projects/$id/students';
  static String updateProjectReviewers(String id) => '$projects/$id/reviewers';

  // Batch endpoints
  static const String batches = '$baseUrl/batches';
  static String getBatchById(String id) => '$batches/$id';
  static String getBatchesByDepartment(String department) =>
      '$batches/department/$department';
  static String getBatchesByYear(int year) => '$batches/year/$year';

  // Panel endpoints
  static const String panels = '$baseUrl/panels';
  static String getPanelById(String id) => '$panels/$id';
  static String getPanelsByCoordinator(String coordinatorId) =>
      '$panels/coordinator/$coordinatorId';
  static String addProjectToPanel(String panelId) =>
      '$panels/$panelId/projects';
  static String removeProjectFromPanel(String panelId, String projectId) =>
      '$panels/$panelId/projects/$projectId';

  // Review endpoints
  static const String reviews = '$baseUrl/reviews';
  static String getReviewById(String id) => '$reviews/$id';
  static String getReviewsByProject(String projectId) =>
      '$reviews/project/$projectId';
  static String getProjectReviewByNumber(String projectId, int reviewNumber) =>
      '$reviews/project/$projectId/review/$reviewNumber';
  static String updateReviewMarks(String id) => '$reviews/$id/marks';
  static String updateReviewComments(String id) => '$reviews/$id/comments';
  static String getReviewTotalScore(String id) => '$reviews/$id/total-score';

  // Admin endpoints
  static const String adminReports = '$baseUrl/admin/reports';
  static const String adminDashboard = '$baseUrl/admin/dashboard';

  // Reviewer endpoints
  static const String reviewerPanels = '$baseUrl/reviewer/panels';
  static const String teamReviews = '$baseUrl/reviewer/team-reviews';
}
