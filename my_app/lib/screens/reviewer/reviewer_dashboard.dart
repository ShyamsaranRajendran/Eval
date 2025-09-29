import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../services/api_service.dart';
import '../../widgets/card_widget.dart';
import '../../models/panel_model.dart';

class ReviewerDashboard extends StatefulWidget {
  const ReviewerDashboard({super.key});

  @override
  State<ReviewerDashboard> createState() => _ReviewerDashboardState();
}

class _ReviewerDashboardState extends State<ReviewerDashboard> {
  final _authController = AuthController();
  final _apiService = ApiService();
  List<PanelModel> _assignedPanels = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAssignedPanels();
  }

  Future<void> _loadAssignedPanels() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final panels = await _apiService.getReviewerPanels();
      setState(() {
        _assignedPanels = panels;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading panels: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.reviewerDashboard),
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
                  'Welcome, ${user?.fullName ?? user?.username ?? 'Reviewer'}!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    title: 'My Panels',
                    subtitle: '${_assignedPanels.length} assigned',
                    icon: Icons.dashboard,
                    color: AppColors.primary,
                    onTap: () {
                      // Show assigned panels (scroll down to see them)
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomCard(
                    title: AppStrings.teamReview,
                    subtitle: 'Review team work',
                    icon: Icons.group,
                    color: AppColors.secondary,
                    onTap: () {
                      Navigator.of(context).pushNamed('/team-review');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Assigned Panels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Assigned Panels',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (_isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Panels List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _assignedPanels.isEmpty
                  ? const Center(
                      child: Text(
                        AppStrings.noData,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _assignedPanels.length,
                      itemBuilder: (context, index) {
                        final panel = _assignedPanels[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            title: Text(panel.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Venue: ${panel.venue}'),
                                const SizedBox(height: 4),
                                Text(
                                  'Date: ${panel.reviewDate.toString().split(' ')[0]}',
                                  style: TextStyle(
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.dashboard,
                                color: AppColors.primary,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(panel.status),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                panel.status,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(
                                context,
                              ).pushNamed('/panel-detail', arguments: panel);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return AppColors.success;
      case 'in_progress':
      case 'in progress':
        return AppColors.warning;
      case 'pending':
      default:
        return AppColors.info;
    }
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
