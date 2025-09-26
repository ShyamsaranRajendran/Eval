import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../widgets/card_widget.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.adminDashboard),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  // TODO: Navigate to profile
                  break;
                case 'logout':
                  _handleLogout();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(AppStrings.profile),
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(AppStrings.logout),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            ListenableBuilder(
              listenable: _authController,
              builder: (context, child) {
                final user = _authController.currentUser;
                return Text(
                  'Welcome, ${user?.fullName ?? user?.username ?? 'Admin'}!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Dashboard cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  CustomCard(
                    title: AppStrings.batches,
                    subtitle: AppStrings.manageBatches,
                    icon: Icons.batch_prediction,
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.of(context).pushNamed('/batches');
                    },
                  ),
                  CustomCard(
                    title: AppStrings.users,
                    subtitle: AppStrings.manageUsers,
                    icon: Icons.people,
                    color: AppColors.secondary,
                    onTap: () {
                      Navigator.of(context).pushNamed('/users');
                    },
                  ),
                  CustomCard(
                    title: AppStrings.panels,
                    subtitle: AppStrings.managePanels,
                    icon: Icons.dashboard,
                    color: AppColors.success,
                    onTap: () {
                      Navigator.of(context).pushNamed('/panels');
                    },
                  ),
                  CustomCard(
                    title: AppStrings.reports,
                    subtitle: AppStrings.viewReports,
                    icon: Icons.analytics,
                    color: AppColors.warning,
                    onTap: () {
                      Navigator.of(context).pushNamed('/reports');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.confirm),
        content: const Text(AppStrings.areYouSure),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _authController.logout();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );
  }
}
