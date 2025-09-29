// Application-wide constants
class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.myapp.com';
  static const String apiVersion = 'v1';
  static const String apiPrefix = '/api';

  // App Info
  static const String appName = 'Project Review System';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // File Constraints
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = [
    '.jpg',
    '.jpeg',
    '.png',
    '.webp',
  ];
  static const List<String> allowedDocTypes = ['.pdf', '.doc', '.docx'];

  // Review System
  static const int maxScorePerCriteria = 100;
  static const int minPanelSize = 3;
  static const int maxPanelSize = 15;
  static const Duration evaluationTimeout = Duration(hours: 48);

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 800);

  // Refresh Intervals
  static const Duration autoRefreshInterval = Duration(minutes: 5);
  static const Duration tokenRefreshThreshold = Duration(minutes: 10);
}

// API Endpoints
class ApiEndpoints {
  static const String base = AppConstants.apiPrefix;

  // Authentication
  static const String login = '$base/auth/login';
  static const String register = '$base/auth/register';
  static const String logout = '$base/auth/logout';
  static const String refreshToken = '$base/auth/refresh-token';
  static const String profile = '$base/users/me';

  // Users
  static const String users = '$base/users';
  static const String faculty = '$base/users/faculty';
  static String userById(String id) => '$users/$id';

  // Review Phases
  static const String reviewPhases = '$base/review-phases';
  static const String activePhase = '$base/review-phases/active';
  static String reviewPhaseById(String id) => '$reviewPhases/$id';

  // Evaluation Criteria
  static String criteria = '$base/criteria';
  static String criteriaByPhase(String phaseId) => '$base/criteria/$phaseId';
  static String criteriaById(String id) => '$criteria/$id';

  // Panels
  static String panels = '$base/panels';
  static String panelsByPhase(String phaseId) => '$base/panels/$phaseId';
  static String panelById(String id) => '$panels/$id';
  static String panelStudents(String id) => '$panels/$id/students';
  static String panelEvaluators(String id) => '$panels/$id/evaluators';

  // Students
  static const String students = '$base/students';
  static const String bulkUploadStudents = '$base/students/bulk-upload';
  static String studentById(String id) => '$students/$id';
  static String studentScores(String studentId, String phaseId) =>
      '$students/$studentId/scores/$phaseId';

  // Evaluations
  static const String evaluations = '$base/evaluations';
  static const String submitEvaluation = '$base/evaluations/submit';
  static const String finalizeEvaluations = '$base/evaluations/finalize';
  static String evaluationById(String id) => '$evaluations/$id';
  static String evaluationsByPanel(String panelId) =>
      '$evaluations/panel/$panelId';
  static String evaluationsByStudent(String studentId, String phaseId) =>
      '$evaluations/student/$studentId/$phaseId';
  static String evaluationProgress(String panelId) =>
      '$evaluations/progress/$panelId';

  // Assignments
  static const String assignments = '$base/assignments';
  static const String assignStudents = '$base/assignments/students';
  static const String assignEvaluators = '$base/assignments/evaluators';
  static String myAssignments(String phaseId) =>
      '$assignments/my-assignments/$phaseId';

  // Reports
  static const String reports = '$base/reports';
  static const String generatePdf = '$base/reports/generate-pdf';
  static const String dashboardStats = '$base/reports/dashboard-stats';
  static String panelSummary(String panelId) =>
      '$reports/panel-summary/$panelId';
  static String studentTranscript(String studentId) =>
      '$reports/student-transcript/$studentId';
  static String facultyWorkload(String phaseId) =>
      '$reports/faculty-workload/$phaseId';
}
