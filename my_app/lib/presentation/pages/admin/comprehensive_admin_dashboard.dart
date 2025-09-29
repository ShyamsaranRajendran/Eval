import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app_routes.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/user_models.dart';
import '../../providers/auth_provider.dart';
import '../evaluation_criteria/evaluation_criteria_screen.dart';

class ComprehensiveAdminDashboard extends ConsumerStatefulWidget {
  const ComprehensiveAdminDashboard({super.key});

  @override
  ConsumerState<ComprehensiveAdminDashboard> createState() =>
      _ComprehensiveAdminDashboardState();
}

class _ComprehensiveAdminDashboardState
    extends ConsumerState<ComprehensiveAdminDashboard> {
  int _selectedIndex = 0;

  List<DashboardItem> get _dashboardItems => [
    DashboardItem(
      title: 'Users',
      subtitle: 'Manage faculty and panel coordinators',
      icon: Icons.people,
      color: AppColors.primary,
      onTap: () => _navigateToUserManagement(),
    ),
    DashboardItem(
      title: 'Review Phases',
      subtitle: 'Configure evaluation phases',
      icon: Icons.assignment,
      color: AppColors.secondary,
      onTap: () => _navigateToReviewPhases(),
    ),
    DashboardItem(
      title: 'Evaluation Criteria',
      subtitle: 'Set scoring criteria',
      icon: Icons.checklist,
      color: AppColors.success,
      onTap: () => _navigateToEvaluationCriteria(),
    ),
    DashboardItem(
      title: 'Panels',
      subtitle: 'Create & assign evaluation panels',
      icon: Icons.dashboard,
      color: AppColors.warning,
      onTap: () => _navigateToPanelManagement(),
    ),
    DashboardItem(
      title: 'Students',
      subtitle: 'Assign students to panels',
      icon: Icons.school,
      color: AppColors.info,
      onTap: () => _navigateToStudentManagement(),
    ),
    DashboardItem(
      title: 'Reports',
      subtitle: 'View evaluation reports',
      icon: Icons.analytics,
      color: AppColors.error,
      onTap: () => _navigateToReports(),
    ),
  ];

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(authProvider.notifier).logout();
                AppRoutes.clearAndNavigateTo(context, AppRoutes.login);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // Navigation Methods
  void _navigateToUserManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserManagementScreen()),
    );
  }

  void _navigateToReviewPhases() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReviewPhasesScreen()),
    );
  }

  void _navigateToEvaluationCriteria() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EvaluationCriteriaScreen()),
    );
  }

  void _navigateToPanelManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PanelManagementScreen()),
    );
  }

  void _navigateToStudentManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StudentManagementScreen()),
    );
  }

  void _navigateToReports() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReportsScreen()),
    );
  }

  void _showNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
    );
  }

  void _showProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  void _showSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  // Utility Methods
  Future<void> _refreshDashboardData() async {
    await Future.delayed(const Duration(seconds: 1));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Dashboard data refreshed')));
  }

  // User Management Methods
  void _showAddUserDialog() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Add User dialog opened')));
  }

  void _showBulkImportDialog() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Bulk Import dialog opened')));
  }

  void _handleUserAction(String action, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action action for User ${index + 1}')),
    );
  }

  // Review Phase Methods
  void _showCreateReviewPhaseDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create Review Phase dialog opened')),
    );
  }

  void _showPhaseTemplatesDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Phase Templates dialog opened')),
    );
  }

  // Reports Methods
  void _generateReport() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Generating report...')));
  }

  void _exportAllData() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Exporting all data...')));
  }

  String _getReportType(int index) {
    final types = [
      'Evaluation',
      'Performance',
      'Student Progress',
      'Faculty',
      'Panel Summary',
      'Analytics',
    ];
    return types[index % types.length];
  }

  String _getReportSize(int index) {
    final sizes = ['2.3 MB', '1.8 MB', '3.1 MB', '945 KB', '1.2 MB', '876 KB'];
    return sizes[index % sizes.length];
  }

  void _viewReport(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing ${_getReportType(index)} Report')),
    );
  }

  void _downloadReport(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${_getReportType(index)} Report')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotifications(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  _showProfile();
                  break;
                case 'settings':
                  _showSettings();
                  break;
                case 'logout':
                  _logout();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'profile', child: Text('Profile')),
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  user?.name.substring(0, 1).toUpperCase() ?? 'A',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(user),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildDrawer(UserModel? user) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    user?.name.substring(0, 1).toUpperCase() ?? 'A',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user?.name ?? 'Administrator',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user?.email ?? 'admin@example.com',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  selected: _selectedIndex == 0,
                  onTap: () {
                    setState(() => _selectedIndex = 0);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('User Management'),
                  selected: _selectedIndex == 1,
                  onTap: () {
                    setState(() => _selectedIndex = 1);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.assignment),
                  title: const Text('Review Phases'),
                  selected: _selectedIndex == 2,
                  onTap: () {
                    setState(() => _selectedIndex = 2);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.analytics),
                  title: const Text('Reports'),
                  selected: _selectedIndex == 3,
                  onTap: () {
                    setState(() => _selectedIndex = 3);
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    _showSettings();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    _logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardView();
      case 1:
        return _buildUserManagementView();
      case 2:
        return _buildReviewPhasesView();
      case 3:
        return _buildReportsView();
      default:
        return _buildDashboardView();
    }
  }

  Widget _buildDashboardView() {
    return RefreshIndicator(
      onRefresh: () async {
        await _refreshDashboardData();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'System Administrator Dashboard',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create panels, assign students, and manage the evaluation system',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Users',
                    '45',
                    Icons.people,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Active Panels',
                    '12',
                    Icons.dashboard,
                    AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Students',
                    '320',
                    Icons.school,
                    AppColors.warning,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Evaluations',
                    '156',
                    Icons.assignment,
                    AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _dashboardItems.length,
              itemBuilder: (context, index) {
                final item = _dashboardItems[index];
                return _buildActionCard(item);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(DashboardItem item) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(item.icon, color: item.color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserManagementView() {
    return RefreshIndicator(
      onRefresh: () async => await _refreshDashboardData(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Statistics Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Users',
                    '1,247',
                    Icons.people,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Faculty',
                    '145',
                    Icons.school,
                    AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Coordinators',
                    '25',
                    Icons.admin_panel_settings,
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Admins',
                    '8',
                    Icons.verified_user,
                    AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddUserDialog(),
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add User'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showBulkImportDialog(),
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Bulk Import'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Users
            const Text(
              'Recent Users',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              5,
              (index) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text('U${index + 1}'),
                  ),
                  title: Text('User ${index + 1}'),
                  subtitle: Text('user${index + 1}@example.com'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (action) => _handleUserAction(action, index),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                      const PopupMenuItem(
                        value: 'disable',
                        child: Text('Disable'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewPhasesView() {
    return RefreshIndicator(
      onRefresh: () async => await _refreshDashboardData(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Review Phase Statistics
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Phases',
                    '12',
                    Icons.timeline,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Active',
                    '5',
                    Icons.play_circle,
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Pending',
                    '3',
                    Icons.schedule,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Completed',
                    '4',
                    Icons.check_circle,
                    AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showCreateReviewPhaseDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Phase'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showPhaseTemplatesDialog(),
                    icon: const Icon(Icons.library_books),
                    label: const Text('Templates'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Active Review Phases
            const Text(
              'Active Review Phases',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              5,
              (index) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.secondary,
                    child: Text('R${index + 1}'),
                  ),
                  title: Text('Review Phase ${index + 1}'),
                  subtitle: Text(
                    '${15 + index * 3} projects • Due: ${DateTime.now().add(Duration(days: 7 + index * 2)).day}/${DateTime.now().add(Duration(days: 7 + index * 2)).month}',
                  ),
                  trailing: Chip(
                    label: Text(
                      index < 2
                          ? 'Active'
                          : index < 4
                          ? 'Pending'
                          : 'Completed',
                    ),
                    backgroundColor: index < 2
                        ? Colors.green[100]
                        : index < 4
                        ? Colors.orange[100]
                        : Colors.blue[100],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsView() {
    return RefreshIndicator(
      onRefresh: () async => await _refreshDashboardData(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Analytics Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Reports',
                    '156',
                    Icons.description,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'This Month',
                    '24',
                    Icons.calendar_today,
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Pending',
                    '8',
                    Icons.pending,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Downloads',
                    '1.2K',
                    Icons.download,
                    AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _generateReport(),
                    icon: const Icon(Icons.analytics),
                    label: const Text('Generate Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _exportAllData(),
                    icon: const Icon(Icons.file_download),
                    label: const Text('Export Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recent Reports
            const Text(
              'Recent Reports',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              6,
              (index) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.info,
                    child: Icon(Icons.description, color: Colors.white),
                  ),
                  title: Text('${_getReportType(index)} Report'),
                  subtitle: Text(
                    'Generated: ${DateTime.now().subtract(Duration(days: index * 2)).day}/${DateTime.now().subtract(Duration(days: index * 2)).month} • ${_getReportSize(index)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () => _viewReport(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () => _downloadReport(index),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Phases'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Reports'),
      ],
    );
  }
}

class DashboardItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  DashboardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

// Screen Classes
class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showAddUserDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text('U${index + 1}'),
              ),
              title: Text('User ${index + 1}'),
              subtitle: Text(
                'user${index + 1}@example.com • ${_getUserRole(index)}',
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (action) =>
                    _handleUserAction(context, action, index),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  const PopupMenuItem(value: 'disable', child: Text('Disable')),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddUserDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getUserRole(int index) {
    final roles = ['Faculty', 'Coordinator', 'Admin', 'Student'];
    return roles[index % roles.length];
  }

  void _showAddUserDialog(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Add User functionality')));
  }

  void _handleUserAction(BuildContext context, String action, int index) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$action User ${index + 1}')));
  }
}

class ReviewPhasesScreen extends StatelessWidget {
  const ReviewPhasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Phases'),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreatePhaseDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 12,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.secondary,
                child: Text('R${index + 1}'),
              ),
              title: Text('Review Phase ${index + 1}'),
              subtitle: Text(
                '${15 + index * 3} projects assigned • Due: ${_getDueDate(index)}',
              ),
              trailing: Chip(
                label: Text(_getPhaseStatus(index)),
                backgroundColor: _getStatusColor(index),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Criteria: ${_getCriteria(index)}'),
                      const SizedBox(height: 8),
                      Text('Faculty Assigned: ${3 + (index % 3)}'),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => _editPhase(context, index),
                            child: const Text('Edit'),
                          ),
                          ElevatedButton(
                            onPressed: () => _duplicatePhase(context, index),
                            child: const Text('Duplicate'),
                          ),
                          ElevatedButton(
                            onPressed: () => _deletePhase(context, index),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePhaseDialog(context),
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getDueDate(int index) {
    final date = DateTime.now().add(Duration(days: 7 + index * 2));
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getPhaseStatus(int index) {
    final statuses = ['Active', 'Pending', 'Completed', 'Draft'];
    return statuses[index % statuses.length];
  }

  Color _getStatusColor(int index) {
    final colors = [
      Colors.green[100]!,
      Colors.orange[100]!,
      Colors.blue[100]!,
      Colors.grey[100]!,
    ];
    return colors[index % colors.length];
  }

  String _getCriteria(int index) {
    final criteria = [
      'Code Quality',
      'Documentation',
      'Innovation',
      'Implementation',
    ];
    return criteria[index % criteria.length];
  }

  void _showCreatePhaseDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create Review Phase functionality')),
    );
  }

  void _editPhase(BuildContext context, int index) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Edit Phase ${index + 1}')));
  }

  void _duplicatePhase(BuildContext context, int index) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Duplicate Phase ${index + 1}')));
  }

  void _deletePhase(BuildContext context, int index) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Delete Phase ${index + 1}')));
  }
}

class EvaluationCriteriaScreen extends StatelessWidget {
  const EvaluationCriteriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluation Criteria'),
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCriteriaDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.success,
                child: Text('C${index + 1}'),
              ),
              title: Text(_getCriteriaName(index)),
              subtitle: Text(
                'Weight: ${_getWeight(index)}% • Max Score: ${_getMaxScore(index)}',
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description: ${_getDescription(index)}'),
                      const SizedBox(height: 8),
                      Text('Rubric: ${_getRubric(index)}'),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => _editCriteria(context, index),
                            child: const Text('Edit'),
                          ),
                          ElevatedButton(
                            onPressed: () => _deleteCriteria(context, index),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCriteriaDialog(context),
        backgroundColor: AppColors.success,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getCriteriaName(int index) {
    final names = [
      'Code Quality',
      'Documentation',
      'Innovation',
      'User Interface',
      'Performance',
      'Testing',
      'Security',
      'Scalability',
    ];
    return names[index % names.length];
  }

  int _getWeight(int index) {
    final weights = [25, 15, 20, 10, 15, 10, 3, 2];
    return weights[index % weights.length];
  }

  int _getMaxScore(int index) {
    return _getWeight(index) * 4; // Assuming 4-point scale
  }

  String _getDescription(int index) {
    return 'Detailed description for ${_getCriteriaName(index)} evaluation criteria.';
  }

  String _getRubric(int index) {
    return 'Excellent (4), Good (3), Fair (2), Poor (1)';
  }

  void _showAddCriteriaDialog(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Add Criteria functionality')));
  }

  void _editCriteria(BuildContext context, int index) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Edit ${_getCriteriaName(index)}')));
  }

  void _deleteCriteria(BuildContext context, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Delete ${_getCriteriaName(index)}')),
    );
  }
}

class PanelManagementScreen extends StatelessWidget {
  const PanelManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Management'),
        backgroundColor: AppColors.warning,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreatePanelDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.warning,
                child: Text('P${index + 1}'),
              ),
              title: Text('Panel ${String.fromCharCode(65 + index)}'),
              subtitle: Text(
                '${_getAssignedStudents(index)} students • ${_getFacultyCount(index)} faculty',
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Location: Room ${101 + index * 5}'),
                      const SizedBox(height: 8),
                      Text('Schedule: ${_getSchedule(index)}'),
                      const SizedBox(height: 8),
                      Text('Faculty: ${_getFacultyList(index)}'),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => _editPanel(context, index),
                            child: const Text('Edit'),
                          ),
                          ElevatedButton(
                            onPressed: () => _assignStudents(context, index),
                            child: const Text('Assign Students'),
                          ),
                          ElevatedButton(
                            onPressed: () => _deletePanel(context, index),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePanelDialog(context),
        backgroundColor: AppColors.warning,
        child: const Icon(Icons.add),
      ),
    );
  }

  int _getAssignedStudents(int index) {
    return 12 + (index * 3);
  }

  int _getFacultyCount(int index) {
    return 3 + (index % 2);
  }

  String _getSchedule(int index) {
    final times = [
      '9:00 AM - 12:00 PM',
      '1:00 PM - 4:00 PM',
      '2:00 PM - 5:00 PM',
    ];
    return times[index % times.length];
  }

  String _getFacultyList(int index) {
    final faculty = [
      'Dr. Smith, Prof. Johnson',
      'Dr. Williams, Prof. Brown, Dr. Davis',
      'Prof. Miller, Dr. Wilson',
      'Dr. Moore, Prof. Taylor, Dr. Anderson',
    ];
    return faculty[index % faculty.length];
  }

  void _showCreatePanelDialog(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Create Panel functionality')));
  }

  void _editPanel(BuildContext context, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit Panel ${String.fromCharCode(65 + index)}')),
    );
  }

  void _assignStudents(BuildContext context, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Assign Students to Panel ${String.fromCharCode(65 + index)}',
        ),
      ),
    );
  }

  void _deletePanel(BuildContext context, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Delete Panel ${String.fromCharCode(65 + index)}'),
      ),
    );
  }
}

class StudentManagementScreen extends StatelessWidget {
  const StudentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management'),
        backgroundColor: AppColors.info,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showAddStudentDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 25,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.info,
                child: Text('S${index + 1}'),
              ),
              title: Text('Student ${index + 1}'),
              subtitle: Text(
                'Roll: 202301${(index + 1).toString().padLeft(2, '0')} • Panel: ${_getAssignedPanel(index)}',
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (action) =>
                    _handleStudentAction(context, action, index),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(
                    value: 'reassign',
                    child: Text('Reassign Panel'),
                  ),
                  const PopupMenuItem(value: 'remove', child: Text('Remove')),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddStudentDialog(context),
        backgroundColor: AppColors.info,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getAssignedPanel(int index) {
    if (index % 6 == 0) return 'Not Assigned';
    final panels = ['Panel A', 'Panel B', 'Panel C', 'Panel D', 'Panel E'];
    return panels[index % panels.length];
  }

  void _showAddStudentDialog(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Add Student functionality')));
  }

  void _handleStudentAction(BuildContext context, String action, int index) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$action Student ${index + 1}')));
  }
}

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshReports(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _generateReport(context),
                    icon: const Icon(Icons.analytics),
                    label: const Text('Generate Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _exportData(context),
                    icon: const Icon(Icons.file_download),
                    label: const Text('Export Data'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Report Categories
            const Text(
              'Available Reports',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              6,
              (index) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.error,
                    child: Icon(_getReportIcon(index), color: Colors.white),
                  ),
                  title: Text('${_getReportType(index)} Report'),
                  subtitle: Text('Last generated: ${_getLastGenerated(index)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () => _viewReport(context, index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () => _downloadReport(context, index),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getReportIcon(int index) {
    final icons = [
      Icons.people,
      Icons.assessment,
      Icons.trending_up,
      Icons.school,
      Icons.dashboard,
      Icons.analytics,
    ];
    return icons[index % icons.length];
  }

  String _getReportType(int index) {
    final types = [
      'User Activity',
      'Evaluation Summary',
      'Performance Trends',
      'Student Progress',
      'Panel Efficiency',
      'System Analytics',
    ];
    return types[index % types.length];
  }

  String _getLastGenerated(int index) {
    final date = DateTime.now().subtract(Duration(days: index + 1));
    return '${date.day}/${date.month}/${date.year}';
  }

  void _refreshReports(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Refreshing reports...')));
  }

  void _generateReport(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Generating new report...')));
  }

  void _exportData(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Exporting data...')));
  }

  void _viewReport(BuildContext context, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing ${_getReportType(index)} Report')),
    );
  }

  void _downloadReport(BuildContext context, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${_getReportType(index)} Report')),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: () => _markAllAsRead(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 15,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getNotificationColor(index),
                child: Icon(_getNotificationIcon(index), color: Colors.white),
              ),
              title: Text(_getNotificationTitle(index)),
              subtitle: Text(_getNotificationSubtitle(index)),
              trailing: Text(_getNotificationTime(index)),
              onTap: () => _handleNotificationTap(context, index),
            ),
          );
        },
      ),
    );
  }

  Color _getNotificationColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.success,
      AppColors.warning,
      AppColors.error,
      AppColors.info,
    ];
    return colors[index % colors.length];
  }

  IconData _getNotificationIcon(int index) {
    final icons = [
      Icons.assignment,
      Icons.person,
      Icons.schedule,
      Icons.warning,
      Icons.info,
    ];
    return icons[index % icons.length];
  }

  String _getNotificationTitle(int index) {
    final titles = [
      'New evaluation submitted',
      'Faculty member added',
      'Review phase deadline approaching',
      'System maintenance scheduled',
      'New student registration',
    ];
    return titles[index % titles.length];
  }

  String _getNotificationSubtitle(int index) {
    final subtitles = [
      'Panel A has submitted evaluation for Project ${index + 1}',
      'Dr. Smith has been added to the system',
      'Phase ${index + 1} deadline is in 2 days',
      'System will be down for maintenance tonight',
      'Student ${index + 1} has registered for evaluation',
    ];
    return subtitles[index % subtitles.length];
  }

  String _getNotificationTime(int index) {
    final hours = [1, 2, 3, 5, 8, 12, 24];
    final time = hours[index % hours.length];
    return time == 1 ? '1 hour ago' : '$time hours ago';
  }

  void _markAllAsRead(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _handleNotificationTap(BuildContext context, int index) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Opened notification ${index + 1}')));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editProfile(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary,
                      child: const Text(
                        'A',
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Administrator',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'admin@example.com',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Profile Details
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Full Name'),
                    subtitle: const Text('System Administrator'),
                    trailing: const Icon(Icons.edit),
                    onTap: () => _editField(context, 'Full Name'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: const Text('admin@example.com'),
                    trailing: const Icon(Icons.edit),
                    onTap: () => _editField(context, 'Email'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Phone'),
                    subtitle: const Text('+1 234 567 8900'),
                    trailing: const Icon(Icons.edit),
                    onTap: () => _editField(context, 'Phone'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Change Password'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _changePassword(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editProfile(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Edit Profile functionality')));
  }

  void _editField(BuildContext context, String field) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Edit $field functionality')));
  }

  void _changePassword(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change Password functionality')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // System Settings
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(
                    'System Settings',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.color_lens),
                  title: const Text('Theme'),
                  subtitle: const Text('Light Mode'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _changeSetting(context, 'Theme'),
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  subtitle: const Text('English'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _changeSetting(context, 'Language'),
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) =>
                        _toggleSetting(context, 'Notifications', value),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Security Settings
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.security),
                  title: Text(
                    'Security',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.fingerprint),
                  title: const Text('Two-Factor Authentication'),
                  trailing: Switch(
                    value: false,
                    onChanged: (value) => _toggleSetting(context, '2FA', value),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Login History'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _viewLoginHistory(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // System Administration
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.admin_panel_settings),
                  title: Text(
                    'Administration',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.backup),
                  title: const Text('Backup & Restore'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _manageBackup(context),
                ),
                ListTile(
                  leading: const Icon(Icons.update),
                  title: const Text('System Updates'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _checkUpdates(context),
                ),
                ListTile(
                  leading: const Icon(Icons.bug_report),
                  title: const Text('System Logs'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _viewSystemLogs(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _changeSetting(BuildContext context, String setting) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Change $setting functionality')));
  }

  void _toggleSetting(BuildContext context, String setting, bool value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$setting ${value ? "enabled" : "disabled"}')),
    );
  }

  void _viewLoginHistory(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('View Login History functionality')),
    );
  }

  void _manageBackup(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Backup Management functionality')),
    );
  }

  void _checkUpdates(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Check for Updates functionality')),
    );
  }

  void _viewSystemLogs(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('View System Logs functionality')),
    );
  }
}
