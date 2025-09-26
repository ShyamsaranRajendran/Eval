import 'package:flutter/material.dart';
import 'screens/login/login_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/admin/batches_screen.dart';
import 'screens/admin/users_screen.dart';
import 'screens/admin/panels_screen.dart';
import 'screens/admin/reports_screen.dart';
import 'screens/reviewer/reviewer_dashboard.dart';
import 'screens/reviewer/panel_detail_screen.dart';
import 'screens/reviewer/team_review_screen.dart';

class AppRoutes {
  // Route names
  static const String login = '/login';
  static const String adminDashboard = '/admin-dashboard';
  static const String reviewerDashboard = '/reviewer-dashboard';
  static const String batches = '/batches';
  static const String users = '/users';
  static const String panels = '/panels';
  static const String reports = '/reports';
  static const String panelDetail = '/panel-detail';
  static const String teamReview = '/team-review';

  // Initial route
  static const String initialRoute = login;

  // Route generator
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
          settings: settings,
        );

      case adminDashboard:
        return MaterialPageRoute(
          builder: (context) => const AdminDashboard(),
          settings: settings,
        );

      case reviewerDashboard:
        return MaterialPageRoute(
          builder: (context) => const ReviewerDashboard(),
          settings: settings,
        );

      case batches:
        return MaterialPageRoute(
          builder: (context) => const BatchesScreen(),
          settings: settings,
        );

      case users:
        return MaterialPageRoute(
          builder: (context) => const UsersScreen(),
          settings: settings,
        );

      case panels:
        return MaterialPageRoute(
          builder: (context) => const PanelsScreen(),
          settings: settings,
        );

      case reports:
        return MaterialPageRoute(
          builder: (context) => const ReportsScreen(),
          settings: settings,
        );

      case panelDetail:
        return MaterialPageRoute(
          builder: (context) => const PanelDetailScreen(),
          settings: settings,
        );

      case teamReview:
        return MaterialPageRoute(
          builder: (context) => const TeamReviewScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const UnknownRoute(),
          settings: settings,
        );
    }
  }

  // Get all routes as a map (alternative approach)
  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    adminDashboard: (context) => const AdminDashboard(),
    reviewerDashboard: (context) => const ReviewerDashboard(),
    batches: (context) => const BatchesScreen(),
    users: (context) => const UsersScreen(),
    panels: (context) => const PanelsScreen(),
    reports: (context) => const ReportsScreen(),
    panelDetail: (context) => const PanelDetailScreen(),
    teamReview: (context) => const TeamReviewScreen(),
  };

  // Helper methods for navigation
  static void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(login);
  }

  static void navigateToAdminDashboard(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(adminDashboard);
  }

  static void navigateToReviewerDashboard(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(reviewerDashboard);
  }

  static void navigateToBatches(BuildContext context) {
    Navigator.of(context).pushNamed(batches);
  }

  static void navigateToUsers(BuildContext context) {
    Navigator.of(context).pushNamed(users);
  }

  static void navigateToPanels(BuildContext context) {
    Navigator.of(context).pushNamed(panels);
  }

  static void navigateToReports(BuildContext context) {
    Navigator.of(context).pushNamed(reports);
  }

  static void navigateToPanelDetail(
    BuildContext context, {
    Map<String, dynamic>? arguments,
  }) {
    Navigator.of(context).pushNamed(panelDetail, arguments: arguments);
  }

  static void navigateToTeamReview(BuildContext context) {
    Navigator.of(context).pushNamed(teamReview);
  }

  // Navigation with result handling
  static Future<T?> navigateToWithResult<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(context).pushNamed<T>(routeName, arguments: arguments);
  }

  // Replace current route
  static void replaceWith(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }

  // Clear stack and navigate
  static void clearAndNavigateTo(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // Pop until a specific route
  static void popUntil(BuildContext context, String routeName) {
    Navigator.of(context).popUntil(ModalRoute.withName(routeName));
  }

  // Check if can pop
  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  // Pop with result
  static void popWithResult<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }
}

// Unknown route widget
class UnknownRoute extends StatelessWidget {
  const UnknownRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              '404 - Page Not Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
