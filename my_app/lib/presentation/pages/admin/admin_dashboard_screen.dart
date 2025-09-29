import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../widgets/custom_button.dart';
import '../coordinator/coordinator_panel_management_screen.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String _selectedTimeRange = 'This Month';

  // Mock admin dashboard data
  final Map<String, dynamic> _dashboardData = {
    'systemOverview': {
      'totalUsers': 1250,
      'activeUsers': 892,
      'totalFaculty': 145,
      'totalStudents': 3200,
      'totalPanelCoordinators': 25,
      'totalAdmins': 8,
      'activePanels': 45,
      'completedEvaluations': 2847,
      'pendingEvaluations': 178,
      'systemUptime': 99.7,
    },
    'performanceMetrics': {
      'avgEvaluationTime': 4.2, // days
      'onTimeSubmissions': 94.5, // percentage
      'facultyUtilization': 87.3, // percentage
      'systemLoad': 23.8, // percentage
      'storageUsed': 67.2, // percentage
      'responseTime': 0.85, // seconds
    },
    'recentActivity': [
      {
        'type': 'user_registration',
        'message': '15 new student registrations',
        'timestamp': '2 hours ago',
        'icon': Icons.person_add,
        'color': AppColors.success,
      },
      {
        'type': 'system_backup',
        'message': 'Automated system backup completed',
        'timestamp': '4 hours ago',
        'icon': Icons.backup,
        'color': AppColors.info,
      },
      {
        'type': 'security_alert',
        'message': 'Unusual login activity detected',
        'timestamp': '6 hours ago',
        'icon': Icons.security,
        'color': AppColors.warning,
      },
      {
        'type': 'system_update',
        'message': 'Evaluation criteria updated',
        'timestamp': '1 day ago',
        'icon': Icons.update,
        'color': AppColors.primary,
      },
      {
        'type': 'error_resolved',
        'message': 'Database connection issue resolved',
        'timestamp': '2 days ago',
        'icon': Icons.check_circle,
        'color': AppColors.success,
      },
    ],
    'systemHealth': {
      'database': {'status': 'healthy', 'responseTime': 45, 'connections': 23},
      'apiServer': {'status': 'healthy', 'responseTime': 120, 'load': 34.2},
      'storage': {'status': 'warning', 'usage': 67.2, 'available': 2.1}, // TB
      'backup': {
        'status': 'healthy',
        'lastBackup': '4 hours ago',
        'size': 8.7,
      }, // GB
    },
    'departmentStats': [
      {
        'name': 'Computer Science',
        'faculty': 45,
        'students': 890,
        'panels': 12,
        'evaluations': 567,
      },
      {
        'name': 'Information Technology',
        'faculty': 32,
        'students': 645,
        'panels': 9,
        'evaluations': 423,
      },
      {
        'name': 'Electronics Engineering',
        'faculty': 28,
        'students': 567,
        'panels': 8,
        'evaluations': 345,
      },
      {
        'name': 'Mechanical Engineering',
        'faculty': 25,
        'students': 478,
        'panels': 7,
        'evaluations': 289,
      },
      {
        'name': 'Civil Engineering',
        'faculty': 15,
        'students': 320,
        'panels': 5,
        'evaluations': 198,
      },
    ],
    'alerts': [
      {
        'severity': 'high',
        'title': 'Storage Space Warning',
        'message': 'System storage is 67% full. Consider cleanup or expansion.',
        'timestamp': '1 hour ago',
      },
      {
        'severity': 'medium',
        'title': 'Pending User Approvals',
        'message': '23 faculty accounts awaiting admin approval.',
        'timestamp': '3 hours ago',
      },
      {
        'severity': 'low',
        'title': 'Scheduled Maintenance',
        'message': 'System maintenance scheduled for next Sunday 2 AM.',
        'timestamp': '6 hours ago',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadDashboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('System Administrator Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.date_range),
            onSelected: (value) {
              setState(() => _selectedTimeRange = value);
              _loadDashboardData();
            },
            itemBuilder: (context) =>
                [
                      'Today',
                      'This Week',
                      'This Month',
                      'This Quarter',
                      'This Year',
                    ]
                    .map(
                      (range) =>
                          PopupMenuItem(value: range, child: Text(range)),
                    )
                    .toList(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showSystemAlerts,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Users'),
            Tab(text: 'System'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Time Range Indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Icon(Icons.schedule, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Data Period: $_selectedTimeRange',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (_isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildUsersTab(),
                _buildSystemTab(),
                _buildAnalyticsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showQuickActions,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.admin_panel_settings),
        label: const Text('Quick Actions'),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // System Overview Cards
            Text(
              'System Overview',
              style: Theme.of(
                this.context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildOverviewCard(
                  'Total Users',
                  '${_dashboardData['systemOverview']['totalUsers']}',
                  Icons.people,
                  AppColors.primary,
                  '${_dashboardData['systemOverview']['activeUsers']} active',
                ),
                _buildOverviewCard(
                  'Faculty Members',
                  '${_dashboardData['systemOverview']['totalFaculty']}',
                  Icons.school,
                  AppColors.info,
                  'Teaching staff',
                ),
                _buildOverviewCard(
                  'Students',
                  '${_dashboardData['systemOverview']['totalStudents']}',
                  Icons.group,
                  AppColors.success,
                  'Enrolled students',
                ),
                _buildOverviewCard(
                  'Active Panels',
                  '${_dashboardData['systemOverview']['activePanels']}',
                  Icons.dashboard,
                  AppColors.warning,
                  'Evaluation panels',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Quick Actions Grid
            Text(
              'Quick Actions',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildQuickActionCard(
                  'User Management',
                  Icons.people_alt,
                  AppColors.primary,
                  () => Navigator.pushNamed(context, '/admin/user-management'),
                ),
                _buildQuickActionCard(
                  'Panel Management',
                  Icons.dashboard,
                  AppColors.secondary,
                  () => _navigateToPanelManagement(),
                ),
                _buildQuickActionCard(
                  'System Settings',
                  Icons.settings,
                  AppColors.info,
                  () => Navigator.pushNamed(context, '/admin/system-config'),
                ),
                _buildQuickActionCard(
                  'Analytics',
                  Icons.analytics,
                  AppColors.success,
                  () => Navigator.pushNamed(context, '/admin/analytics'),
                ),
                _buildQuickActionCard(
                  'Backup & Recovery',
                  Icons.backup,
                  AppColors.warning,
                  () => Navigator.pushNamed(context, '/admin/backup'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recent Activity
            Text(
              'Recent System Activity',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Card(
              child: Column(
                children: (_dashboardData['recentActivity'] as List)
                    .take(5)
                    .map((activity) => _buildActivityItem(activity))
                    .toList(),
              ),
            ),

            const SizedBox(height: 24),

            // System Health Quick View
            Text(
              'System Health',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildHealthCard(
                    'Database',
                    _dashboardData['systemHealth']['database'],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildHealthCard(
                    'API Server',
                    _dashboardData['systemHealth']['apiServer'],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Statistics
            Text(
              'User Statistics',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildUserStatCard(
                    'Faculty',
                    '${_dashboardData['systemOverview']['totalFaculty']}',
                    AppColors.primary,
                    Icons.school,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildUserStatCard(
                    'Students',
                    '${_dashboardData['systemOverview']['totalStudents']}',
                    AppColors.success,
                    Icons.group,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildUserStatCard(
                    'Panel Coordinators',
                    '${_dashboardData['systemOverview']['totalPanelCoordinators']}',
                    AppColors.info,
                    Icons.supervisor_account,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildUserStatCard(
                    'Admins',
                    '${_dashboardData['systemOverview']['totalAdmins']}',
                    AppColors.warning,
                    Icons.admin_panel_settings,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Department Breakdown
            Text(
              'Department Distribution',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ...(_dashboardData['departmentStats'] as List).map((dept) {
              return _buildDepartmentCard(dept);
            }).toList(),

            const SizedBox(height: 24),

            // User Management Actions
            CustomButton(
              text: 'Manage Users',
              onPressed: () =>
                  Navigator.pushNamed(context, '/admin/user-management'),
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemTab() {
    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // System Health Status
            Text(
              'System Health Status',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ...(_dashboardData['systemHealth'] as Map<String, dynamic>).entries
                .map((entry) {
                  return _buildSystemHealthCard(entry.key, entry.value);
                })
                .toList(),

            const SizedBox(height: 24),

            // Performance Metrics
            Text(
              'Performance Metrics',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildPerformanceMetric(
                      'System Uptime',
                      '${_dashboardData['systemOverview']['systemUptime']}%',
                      _dashboardData['systemOverview']['systemUptime'] / 100,
                      AppColors.success,
                    ),
                    const SizedBox(height: 16),
                    _buildPerformanceMetric(
                      'Faculty Utilization',
                      '${_dashboardData['performanceMetrics']['facultyUtilization']}%',
                      _dashboardData['performanceMetrics']['facultyUtilization'] /
                          100,
                      AppColors.info,
                    ),
                    const SizedBox(height: 16),
                    _buildPerformanceMetric(
                      'On-Time Submissions',
                      '${_dashboardData['performanceMetrics']['onTimeSubmissions']}%',
                      _dashboardData['performanceMetrics']['onTimeSubmissions'] /
                          100,
                      AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // System Actions
            CustomButton(
              text: 'System Configuration',
              onPressed: () =>
                  Navigator.pushNamed(context, '/admin/system-config'),
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Analytics',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Analytics Chart Placeholder
            Card(
              child: Container(
                height: 300,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'System Usage Trends',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.analytics,
                                size: 48,
                                color: AppColors.textSecondary.withOpacity(0.5),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Advanced analytics charts will be\nimplemented with charts_flutter package',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Analytics Actions
            CustomButton(
              text: 'View Detailed Analytics',
              onPressed: () => Navigator.pushNamed(context, '/admin/analytics'),
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.trending_up, color: color, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: activity['color'].withOpacity(0.1),
        child: Icon(activity['icon'], color: activity['color'], size: 20),
      ),
      title: Text(activity['message']),
      subtitle: Text(activity['timestamp']),
      trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: () {
        // Handle activity tap
      },
    );
  }

  Widget _buildHealthCard(String title, Map<String, dynamic> health) {
    final isHealthy = health['status'] == 'healthy';
    final color = isHealthy ? AppColors.success : AppColors.warning;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isHealthy ? Icons.check_circle : Icons.warning,
                  color: color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              health['status'].toString().toUpperCase(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
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
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentCard(Map<String, dynamic> dept) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(Icons.business, color: AppColors.primary),
        ),
        title: Text(
          dept['name'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${dept['faculty']} Faculty • ${dept['students']} Students',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${dept['panels']} Panels',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              '${dept['evaluations']} Evaluations',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemHealthCard(String title, Map<String, dynamic> health) {
    final isHealthy = health['status'] == 'healthy';
    final color = isHealthy
        ? AppColors.success
        : health['status'] == 'warning'
        ? AppColors.warning
        : AppColors.error;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isHealthy
                      ? Icons.check_circle
                      : health['status'] == 'warning'
                      ? Icons.warning
                      : Icons.error,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  title.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    health['status'].toString().toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Add specific health details based on component
            if (health.containsKey('responseTime'))
              Text('Response Time: ${health['responseTime']}ms'),
            if (health.containsKey('usage')) Text('Usage: ${health['usage']}%'),
            if (health.containsKey('lastBackup'))
              Text('Last Backup: ${health['lastBackup']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetric(
    String label,
    String value,
    double progress,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              value,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.textSecondary.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  void _showSystemAlerts() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'System Alerts',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: (_dashboardData['alerts'] as List).length,
                  itemBuilder: (context, index) {
                    final alert = (_dashboardData['alerts'] as List)[index];
                    return _buildAlertCard(alert);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    Color severityColor;
    IconData severityIcon;

    switch (alert['severity']) {
      case 'high':
        severityColor = AppColors.error;
        severityIcon = Icons.error;
        break;
      case 'medium':
        severityColor = AppColors.warning;
        severityIcon = Icons.warning;
        break;
      case 'low':
        severityColor = AppColors.info;
        severityIcon = Icons.info;
        break;
      default:
        severityColor = AppColors.textSecondary;
        severityIcon = Icons.info;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(severityIcon, color: severityColor),
        title: Text(
          alert['title'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alert['message']),
            const SizedBox(height: 4),
            Text(
              alert['timestamp'],
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: severityColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            alert['severity'].toString().toUpperCase(),
            style: TextStyle(
              color: severityColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin Management Center',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'v2.0 - Updated',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Panel Management Section
                      _buildQuickActionSection(
                        'Panel Management',
                        Icons.dashboard,
                        AppColors.primary,
                        [
                          _buildQuickActionTile(
                            'Create New Panel',
                            'Set up evaluation panels for student projects',
                            Icons.add_circle,
                            AppColors.success,
                            () => _showCreatePanelDialog(),
                          ),
                          _buildQuickActionTile(
                            'View All Panels',
                            'Manage existing evaluation panels',
                            Icons.view_list,
                            AppColors.info,
                            () => _navigateToPanelManagement(),
                          ),
                          _buildQuickActionTile(
                            'Assign Faculty to Panels',
                            'Assign faculty members to evaluation panels',
                            Icons.person_add,
                            AppColors.warning,
                            () => _showFacultyAssignment(),
                          ),
                          _buildQuickActionTile(
                            'Panel Analytics',
                            'View detailed panel performance metrics',
                            Icons.analytics,
                            AppColors.secondary,
                            () => _showPanelAnalytics(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Student Management Section
                      _buildQuickActionSection(
                        'Student Management',
                        Icons.school,
                        AppColors.secondary,
                        [
                          _buildQuickActionTile(
                            'Assign Student Groups',
                            'Assign student groups to evaluation panels',
                            Icons.group_add,
                            AppColors.primary,
                            () => _showStudentGroupAssignment(),
                          ),
                          _buildQuickActionTile(
                            'Manage Projects',
                            'Link projects with student groups',
                            Icons.assignment,
                            AppColors.info,
                            () => _showProjectManagement(),
                          ),
                          _buildQuickActionTile(
                            'View Student Progress',
                            'Monitor student evaluation progress',
                            Icons.analytics,
                            AppColors.success,
                            () => _showStudentProgress(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Review Management Section
                      _buildQuickActionSection(
                        'Review Management',
                        Icons.rate_review,
                        AppColors.error,
                        [
                          _buildQuickActionTile(
                            'Create Review Phases',
                            'Set up evaluation phases and criteria',
                            Icons.create,
                            AppColors.warning,
                            () => _showCreateReviewPhase(),
                          ),
                          _buildQuickActionTile(
                            'Assign Reviews',
                            'Assign reviews to faculty members',
                            Icons.assignment_ind,
                            AppColors.error,
                            () => _showReviewAssignment(),
                          ),
                          _buildQuickActionTile(
                            'Monitor Reviews',
                            'Track review progress and completions',
                            Icons.track_changes,
                            AppColors.info,
                            () => _showReviewMonitor(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // System Management Section
                      _buildQuickActionSection(
                        'System Management',
                        Icons.settings,
                        AppColors.textSecondary,
                        [
                          _buildQuickActionTile(
                            'User Management',
                            'Add, edit, or remove user accounts',
                            Icons.people_alt,
                            AppColors.primary,
                            () => Navigator.pushNamed(
                              context,
                              '/admin/user-management',
                            ),
                          ),
                          _buildQuickActionTile(
                            'System Reports',
                            'Generate comprehensive system reports',
                            Icons.analytics,
                            AppColors.success,
                            () =>
                                Navigator.pushNamed(context, '/admin/reports'),
                          ),
                          _buildQuickActionTile(
                            'Backup & Recovery',
                            'Manage system backups and data recovery',
                            Icons.backup,
                            AppColors.warning,
                            () => Navigator.pushNamed(context, '/admin/backup'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionSection(
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildQuickActionTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textSecondary,
        ),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
      ),
    );
  }

  // Panel Management Methods
  void _showCreatePanelDialog() {
    showDialog(context: context, builder: (context) => _CreatePanelDialog());
  }

  void _showPanelManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _PanelManagementScreen()),
    );
  }

  void _navigateToPanelManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CoordinatorPanelManagementScreen(),
      ),
    );
  }

  void _showPanelAnalytics() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Panel Analytics feature coming soon')),
    );
  }

  void _showFacultyAssignment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _FacultyAssignmentScreen()),
    );
  }

  // Student Management Methods
  void _showStudentGroupAssignment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _GeneralStudentAssignmentScreen(),
      ),
    );
  }

  void _showProjectManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _ProjectManagementScreen()),
    );
  }

  void _showStudentProgress() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _StudentProgressScreen()),
    );
  }

  // Review Management Methods
  void _showCreateReviewPhase() {
    showDialog(
      context: context,
      builder: (context) => _CreateReviewPhaseDialog(),
    );
  }

  void _showReviewAssignment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _ReviewAssignmentScreen()),
    );
  }

  void _showReviewMonitor() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _ReviewMonitorScreen()),
    );
  }
}

// Create Panel Dialog
class _CreatePanelDialog extends StatefulWidget {
  @override
  _CreatePanelDialogState createState() => _CreatePanelDialogState();
}

class _CreatePanelDialogState extends State<_CreatePanelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();
  String _selectedDepartment = 'Computer Science';
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.dashboard, color: AppColors.primary),
          const SizedBox(width: 8),
          const Text('Create New Panel'),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Panel Name',
                  prefixIcon: Icon(Icons.label),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter panel name' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                decoration: const InputDecoration(
                  labelText: 'Department',
                  prefixIcon: Icon(Icons.business),
                ),
                items:
                    ['Computer Science', 'Electronics', 'Mechanical', 'Civil']
                        .map(
                          (dept) =>
                              DropdownMenuItem(value: dept, child: Text(dept)),
                        )
                        .toList(),
                onChanged: (value) =>
                    setState(() => _selectedDepartment = value!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location/Room',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _capacityController,
                decoration: const InputDecoration(
                  labelText: 'Capacity (Max Students)',
                  prefixIcon: Icon(Icons.people),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter capacity';
                  if (int.tryParse(value!) == null)
                    return 'Please enter valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              ListTile(
                leading: Icon(Icons.calendar_today, color: AppColors.primary),
                title: const Text('Evaluation Date'),
                subtitle: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createPanel,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Create Panel'),
        ),
      ],
    );
  }

  void _createPanel() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement panel creation logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Panel "${_nameController.text}" created successfully!',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    super.dispose();
  }
}

// Panel Management Screen
class _PanelManagementScreen extends StatefulWidget {
  @override
  _PanelManagementScreenState createState() => _PanelManagementScreenState();
}

class _PanelManagementScreenState extends State<_PanelManagementScreen> {
  List<Map<String, dynamic>> _panels = [
    {
      'id': '1',
      'name': 'Software Engineering Panel A',
      'department': 'Computer Science',
      'location': 'Room 101',
      'capacity': 15,
      'assignedStudents': 12,
      'faculty': ['Dr. Smith', 'Prof. Johnson'],
      'date': '2025-10-15',
      'status': 'Active',
    },
    {
      'id': '2',
      'name': 'Data Science Panel B',
      'department': 'Computer Science',
      'location': 'Room 205',
      'capacity': 10,
      'assignedStudents': 8,
      'faculty': ['Dr. Williams', 'Prof. Brown'],
      'date': '2025-10-18',
      'status': 'Setup',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Management'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreatePanelDialog(),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _panels.length,
        itemBuilder: (context, index) {
          final panel = _panels[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text('${panel['assignedStudents']}'),
              ),
              title: Text(
                panel['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${panel['department']} • ${panel['location']}'),
              trailing: Chip(
                label: Text(panel['status']),
                backgroundColor: panel['status'] == 'Active'
                    ? AppColors.success.withOpacity(0.2)
                    : AppColors.warning.withOpacity(0.2),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoTile(
                              'Capacity',
                              '${panel['assignedStudents']}/${panel['capacity']}',
                            ),
                          ),
                          Expanded(
                            child: _buildInfoTile('Date', panel['date']),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoTile(
                        'Faculty',
                        (panel['faculty'] as List).join(', '),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _editPanel(panel),
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text('Edit'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.info,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => _assignStudents(panel),
                            icon: const Icon(Icons.group_add, size: 16),
                            label: const Text('Assign Students'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => _assignFaculty(panel),
                            icon: const Icon(Icons.person_add, size: 16),
                            label: const Text('Assign Faculty'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.warning,
                            ),
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
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  void _showCreatePanelDialog() {
    showDialog(context: context, builder: (context) => _CreatePanelDialog());
  }

  void _editPanel(Map<String, dynamic> panel) {
    showDialog(
      context: context,
      builder: (context) => _EditPanelDialog(panel: panel),
    );
  }

  void _assignStudents(Map<String, dynamic> panel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _StudentAssignmentScreen(panelId: panel['id']),
      ),
    );
  }

  void _assignFaculty(Map<String, dynamic> panel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FacultyAssignmentScreen(panelId: panel['id']),
      ),
    );
  }
}

// Edit Panel Dialog
class _EditPanelDialog extends StatefulWidget {
  final Map<String, dynamic> panel;
  const _EditPanelDialog({required this.panel});

  @override
  _EditPanelDialogState createState() => _EditPanelDialogState();
}

class _EditPanelDialogState extends State<_EditPanelDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _capacityController;
  late String _selectedDepartment;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.panel['name'] ?? '');
    _descriptionController = TextEditingController();
    _locationController = TextEditingController(
      text: widget.panel['location'] ?? '',
    );
    _capacityController = TextEditingController(
      text: widget.panel['capacity']?.toString() ?? '',
    );
    _selectedDepartment = widget.panel['department'] ?? 'Computer Science';
    _selectedDate =
        DateTime.tryParse(widget.panel['date'] ?? '') ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.edit, color: AppColors.primary),
          const SizedBox(width: 8),
          const Text('Edit Panel'),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Panel Name',
                  prefixIcon: Icon(Icons.label),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter panel name' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                decoration: const InputDecoration(
                  labelText: 'Department',
                  prefixIcon: Icon(Icons.business),
                ),
                items:
                    ['Computer Science', 'Electronics', 'Mechanical', 'Civil']
                        .map(
                          (dept) =>
                              DropdownMenuItem(value: dept, child: Text(dept)),
                        )
                        .toList(),
                onChanged: (value) =>
                    setState(() => _selectedDepartment = value!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location/Room',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _capacityController,
                decoration: const InputDecoration(
                  labelText: 'Capacity (Max Students)',
                  prefixIcon: Icon(Icons.people),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter capacity';
                  if (int.tryParse(value!) == null)
                    return 'Please enter valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              ListTile(
                leading: Icon(Icons.calendar_today, color: AppColors.primary),
                title: const Text('Evaluation Date'),
                subtitle: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _savePanel,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Save Changes'),
        ),
      ],
    );
  }

  void _savePanel() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement panel update logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Panel "${_nameController.text}" updated successfully!',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    super.dispose();
  }
}

// Student Assignment Screen
class _StudentAssignmentScreen extends StatefulWidget {
  final String panelId;
  const _StudentAssignmentScreen({required this.panelId});

  @override
  _StudentAssignmentScreenState createState() =>
      _StudentAssignmentScreenState();
}

class _StudentAssignmentScreenState extends State<_StudentAssignmentScreen> {
  List<Map<String, dynamic>> _availableStudents = [
    {
      'id': '1',
      'name': 'John Doe',
      'rollNumber': 'CS001',
      'project': 'AI Chatbot',
      'assigned': false,
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'rollNumber': 'CS002',
      'project': 'Web App',
      'assigned': false,
    },
    {
      'id': '3',
      'name': 'Bob Johnson',
      'rollNumber': 'CS003',
      'project': 'Mobile App',
      'assigned': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Students to Panel'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveAssignments,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _availableStudents.length,
        itemBuilder: (context, index) {
          final student = _availableStudents[index];
          return Card(
            child: CheckboxListTile(
              secondary: CircleAvatar(
                backgroundColor: student['assigned']
                    ? AppColors.success
                    : AppColors.textSecondary,
                child: Text(student['rollNumber'].substring(2)),
              ),
              title: Text(student['name']),
              subtitle: Text(
                '${student['rollNumber']} • Project: ${student['project']}',
              ),
              value: student['assigned'],
              onChanged: (value) {
                setState(() {
                  student['assigned'] = value ?? false;
                });
              },
            ),
          );
        },
      ),
    );
  }

  void _saveAssignments() {
    final assignedCount = _availableStudents.where((s) => s['assigned']).length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$assignedCount students assigned to panel'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context);
  }
}

// Faculty Assignment Screen
class _FacultyAssignmentScreen extends StatefulWidget {
  final String? panelId;
  const _FacultyAssignmentScreen({this.panelId});

  @override
  _FacultyAssignmentScreenState createState() =>
      _FacultyAssignmentScreenState();
}

class _FacultyAssignmentScreenState extends State<_FacultyAssignmentScreen> {
  List<Map<String, dynamic>> _facultyMembers = [
    {
      'id': '1',
      'name': 'Dr. Smith',
      'department': 'Computer Science',
      'expertise': 'AI/ML',
      'assigned': true,
    },
    {
      'id': '2',
      'name': 'Prof. Johnson',
      'department': 'Computer Science',
      'expertise': 'Web Dev',
      'assigned': false,
    },
    {
      'id': '3',
      'name': 'Dr. Williams',
      'department': 'Computer Science',
      'expertise': 'Data Science',
      'assigned': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Faculty to Panel'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveAssignments,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _facultyMembers.length,
        itemBuilder: (context, index) {
          final faculty = _facultyMembers[index];
          return Card(
            child: CheckboxListTile(
              secondary: CircleAvatar(
                backgroundColor: faculty['assigned']
                    ? AppColors.success
                    : AppColors.textSecondary,
                child: Text(faculty['name'].split(' ')[1][0]),
              ),
              title: Text(faculty['name']),
              subtitle: Text(
                '${faculty['department']} • ${faculty['expertise']}',
              ),
              value: faculty['assigned'],
              onChanged: (value) {
                setState(() {
                  faculty['assigned'] = value ?? false;
                });
              },
            ),
          );
        },
      ),
    );
  }

  void _saveAssignments() {
    final assignedCount = _facultyMembers.where((f) => f['assigned']).length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$assignedCount faculty members assigned to panel'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context);
  }
}

// General Student Assignment Screen (without specific panel requirement)
class _GeneralStudentAssignmentScreen extends StatefulWidget {
  @override
  _GeneralStudentAssignmentScreenState createState() =>
      _GeneralStudentAssignmentScreenState();
}

class _GeneralStudentAssignmentScreenState
    extends State<_GeneralStudentAssignmentScreen> {
  String _selectedPanel = 'All Panels';
  final List<String> _panels = [
    'All Panels',
    'Panel A',
    'Panel B',
    'Panel C',
    'Panel D',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Assignment Management'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add),
            onPressed: _showCreateTeamDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedPanel,
                    decoration: const InputDecoration(
                      labelText: 'Filter by Panel',
                      prefixIcon: Icon(Icons.group),
                    ),
                    items: _panels
                        .map(
                          (panel) => DropdownMenuItem(
                            value: panel,
                            child: Text(panel),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedPanel = value!),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _showAssignStudentsDialog,
                  icon: const Icon(Icons.assignment_ind),
                  label: const Text('Assign Students'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          // Student Teams List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 8, // Mock data
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text('T${index + 1}'),
                    ),
                    title: Text('Team ${String.fromCharCode(65 + index)}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Panel: ${index < 3
                              ? 'Panel A'
                              : index < 6
                              ? 'Panel B'
                              : 'Panel C'}',
                        ),
                        const SizedBox(height: 4),
                        Text('Members: ${3 + (index % 2)} students'),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.people, color: AppColors.primary),
                                const SizedBox(width: 8),
                                const Text(
                                  'Team Members:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...List.generate(
                              3 + (index % 2),
                              (memberIndex) => ListTile(
                                dense: true,
                                leading: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.blue[100],
                                  child: Text('S${memberIndex + 1}'),
                                ),
                                title: Text(
                                  'Student ${memberIndex + 1}${String.fromCharCode(65 + index)}',
                                ),
                                subtitle: Text(
                                  'Roll: 202${index}0${memberIndex + 1}',
                                ),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (action) => _handleStudentAction(
                                    action,
                                    index,
                                    memberIndex,
                                  ),
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'remove',
                                      child: Text('Remove'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _editTeam(index),
                                  icon: const Icon(Icons.edit),
                                  label: const Text('Edit Team'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _addStudentToTeam(index),
                                  icon: const Icon(Icons.person_add),
                                  label: const Text('Add Student'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.success,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _deleteTeam(index),
                                  icon: const Icon(Icons.delete),
                                  label: const Text('Delete'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.error,
                                  ),
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
          ),
        ],
      ),
    );
  }

  void _showCreateTeamDialog() {
    showDialog(context: context, builder: (context) => _CreateTeamDialog());
  }

  void _showAssignStudentsDialog() {
    showDialog(context: context, builder: (context) => _AssignStudentsDialog());
  }

  void _editTeam(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing Team ${String.fromCharCode(65 + index)}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _addStudentToTeam(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Adding student to Team ${String.fromCharCode(65 + index)}',
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _deleteTeam(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Team'),
        content: Text(
          'Are you sure you want to delete Team ${String.fromCharCode(65 + index)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Team ${String.fromCharCode(65 + index)} deleted',
                  ),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleStudentAction(String action, int teamIndex, int studentIndex) {
    final teamName = 'Team ${String.fromCharCode(65 + teamIndex)}';
    final studentName =
        'Student ${studentIndex + 1}${String.fromCharCode(65 + teamIndex)}';

    if (action == 'edit') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Editing $studentName from $teamName'),
          backgroundColor: Colors.blue,
        ),
      );
    } else if (action == 'remove') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed $studentName from $teamName'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

class _ProjectManagementScreen extends StatefulWidget {
  @override
  _ProjectManagementScreenState createState() =>
      _ProjectManagementScreenState();
}

class _ProjectManagementScreenState extends State<_ProjectManagementScreen> {
  List<Map<String, dynamic>> _projects = [
    {
      'id': '1',
      'title': 'AI-Powered Chatbot',
      'description': 'Intelligent chatbot using NLP and machine learning',
      'students': ['John Doe', 'Jane Smith'],
      'supervisor': 'Dr. Smith',
      'panel': 'Software Engineering Panel A',
      'status': 'In Progress',
      'submissionDate': '2025-11-01',
    },
    {
      'id': '2',
      'title': 'E-Commerce Web Application',
      'description': 'Full-stack web application with payment integration',
      'students': ['Bob Johnson', 'Alice Brown'],
      'supervisor': 'Prof. Johnson',
      'panel': 'Not Assigned',
      'status': 'Planning',
      'submissionDate': '2025-11-15',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Management'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddProjectDialog(),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _projects.length,
        itemBuilder: (context, index) {
          final project = _projects[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: _getStatusColor(project['status']),
                child: Text('${index + 1}'),
              ),
              title: Text(
                project['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${project['students'].join(', ')} • ${project['supervisor']}',
              ),
              trailing: Chip(
                label: Text(project['status']),
                backgroundColor: _getStatusColor(
                  project['status'],
                ).withOpacity(0.2),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(project['description']),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _buildProjectInfoTile(
                              'Panel',
                              project['panel'],
                            ),
                          ),
                          Expanded(
                            child: _buildProjectInfoTile(
                              'Due Date',
                              project['submissionDate'],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _editProject(project),
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text('Edit'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.info,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => _assignToPanel(project),
                            icon: const Icon(Icons.dashboard, size: 16),
                            label: const Text('Assign Panel'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.warning,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => _viewProgress(project),
                            icon: const Icon(Icons.analytics, size: 16),
                            label: const Text('Progress'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                            ),
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
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Progress':
        return AppColors.info;
      case 'Planning':
        return AppColors.warning;
      case 'Completed':
        return AppColors.success;
      case 'Under Review':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildProjectInfoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  void _showAddProjectDialog() {
    showDialog(context: context, builder: (context) => _AddProjectDialog());
  }

  void _editProject(Map<String, dynamic> project) {
    showDialog(
      context: context,
      builder: (context) => _EditProjectDialog(project: project),
    );
  }

  void _assignToPanel(Map<String, dynamic> project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign to Panel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Software Engineering Panel A'),
              subtitle: const Text('Room 101 • 12/15 students'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${project['title']} assigned to Software Engineering Panel A',
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Data Science Panel B'),
              subtitle: const Text('Room 205 • 8/10 students'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${project['title']} assigned to Data Science Panel B',
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _viewProgress(Map<String, dynamic> project) {
    // TODO: Navigate to project progress screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View progress for: ${project['title']}')),
    );
  }
}

class _StudentProgressScreen extends StatefulWidget {
  @override
  _StudentProgressScreenState createState() => _StudentProgressScreenState();
}

class _StudentProgressScreenState extends State<_StudentProgressScreen> {
  String _selectedFilter = 'All Students';
  final List<String> _filters = [
    'All Students',
    'Active Students',
    'Inactive Students',
    'High Performers',
    'Needs Attention',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Progress Monitor'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _showAnalytics,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedFilter,
                    decoration: const InputDecoration(
                      labelText: 'Filter Students',
                      prefixIcon: Icon(Icons.filter_list),
                    ),
                    items: _filters
                        .map(
                          (filter) => DropdownMenuItem(
                            value: filter,
                            child: Text(filter),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedFilter = value!),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _exportProgress,
                  icon: const Icon(Icons.download),
                  label: const Text('Export'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          // Progress Statistics Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Students',
                    '324',
                    Icons.people,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Active',
                    '298',
                    Icons.trending_up,
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'At Risk',
                    '26',
                    Icons.warning,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Completed',
                    '156',
                    Icons.check_circle,
                    AppColors.success,
                  ),
                ),
              ],
            ),
          ),

          // Student Progress List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 15, // Mock data
              itemBuilder: (context, index) {
                final progressPercentage = 60 + (index * 3) % 40;
                final isAtRisk = progressPercentage < 70;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: isAtRisk
                          ? Colors.orange
                          : AppColors.success,
                      child: Text('S${index + 1}'),
                    ),
                    title: Text('Student ${index + 1} - John Doe${index + 1}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Roll: 202301${index.toString().padLeft(2, '0')} • Team Alpha ${(index % 4) + 1}',
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: progressPercentage / 100,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isAtRisk ? Colors.orange : AppColors.success,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$progressPercentage%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isAtRisk
                                    ? Colors.orange
                                    : AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(isAtRisk ? 'At Risk' : 'On Track'),
                      backgroundColor: isAtRisk
                          ? Colors.orange[100]
                          : Colors.green[100],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.assignment,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Project Milestones:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildMilestone('Planning', true),
                                _buildMilestone(
                                  'Development',
                                  progressPercentage > 70,
                                ),
                                _buildMilestone(
                                  'Testing',
                                  progressPercentage > 85,
                                ),
                                _buildMilestone(
                                  'Documentation',
                                  progressPercentage > 90,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Icon(
                                  Icons.assessment,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Recent Activity:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ListTile(
                              dense: true,
                              leading: Icon(Icons.code, color: Colors.blue),
                              title: const Text('Code commit'),
                              subtitle: Text('${2 + (index % 3)} hours ago'),
                            ),
                            ListTile(
                              dense: true,
                              leading: Icon(Icons.message, color: Colors.green),
                              title: const Text('Team discussion'),
                              subtitle: Text('${5 + (index % 4)} hours ago'),
                            ),

                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _viewStudentDetails(index),
                                  icon: const Icon(Icons.visibility),
                                  label: const Text('View Details'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _contactStudent(index),
                                  icon: const Icon(Icons.message),
                                  label: const Text('Contact'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                ),
                                if (isAtRisk)
                                  ElevatedButton.icon(
                                    onPressed: () => _flagForAttention(index),
                                    icon: const Icon(Icons.flag),
                                    label: const Text('Flag'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                    ),
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
          ),
        ],
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestone(String title, bool completed) {
    return Column(
      children: [
        Icon(
          completed ? Icons.check_circle : Icons.radio_button_unchecked,
          color: completed ? AppColors.success : Colors.grey,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: completed ? AppColors.success : Colors.grey,
          ),
        ),
      ],
    );
  }

  void _showAnalytics() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening detailed analytics...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _exportProgress() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting progress report...'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _viewStudentDetails(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing details for Student ${index + 1}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _contactStudent(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contacting Student ${index + 1}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _flagForAttention(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Student ${index + 1} flagged for attention'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

class _CreateReviewPhaseDialog extends StatefulWidget {
  @override
  _CreateReviewPhaseDialogState createState() =>
      _CreateReviewPhaseDialogState();
}

class _CreateReviewPhaseDialogState extends State<_CreateReviewPhaseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _criteriaController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  String _reviewType = 'Midterm Review';
  int _maxScore = 100;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.rate_review, color: AppColors.primary),
          const SizedBox(width: 8),
          const Text('Create Review Phase'),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Review Phase Name',
                  prefixIcon: Icon(Icons.label),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter phase name' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _reviewType,
                decoration: const InputDecoration(
                  labelText: 'Review Type',
                  prefixIcon: Icon(Icons.category),
                ),
                items:
                    [
                          'Midterm Review',
                          'Final Review',
                          'Progress Review',
                          'Viva Voce',
                        ]
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                onChanged: (value) => setState(() => _reviewType = value!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _criteriaController,
                decoration: const InputDecoration(
                  labelText: 'Evaluation Criteria',
                  prefixIcon: Icon(Icons.checklist),
                  hintText:
                      'e.g., Technical Implementation (40%), Documentation (30%)...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: _maxScore.toString(),
                decoration: const InputDecoration(
                  labelText: 'Maximum Score',
                  prefixIcon: Icon(Icons.score),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _maxScore = int.tryParse(value) ?? 100,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                      ),
                      title: const Text('Start Date'),
                      subtitle: Text(
                        '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (date != null) setState(() => _startDate = date);
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                        color: AppColors.error,
                      ),
                      title: const Text('End Date'),
                      subtitle: Text(
                        '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                      ),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: _startDate,
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (date != null) setState(() => _endDate = date);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createReviewPhase,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Create Phase'),
        ),
      ],
    );
  }

  void _createReviewPhase() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement review phase creation logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Review phase "${_nameController.text}" created successfully!',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _criteriaController.dispose();
    super.dispose();
  }
}

class _ReviewAssignmentScreen extends StatefulWidget {
  @override
  _ReviewAssignmentScreenState createState() => _ReviewAssignmentScreenState();
}

class _ReviewAssignmentScreenState extends State<_ReviewAssignmentScreen> {
  String _selectedPanel = 'All Panels';
  String _selectedReviewPhase = 'All Phases';
  final List<String> _panels = ['All Panels', 'Panel A', 'Panel B', 'Panel C'];
  final List<String> _reviewPhases = [
    'All Phases',
    'Midterm Review',
    'Final Review',
    'Progress Review',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Assignment'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.assignment_add),
            onPressed: _showAssignReviewDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedPanel,
                    decoration: const InputDecoration(
                      labelText: 'Filter by Panel',
                      prefixIcon: Icon(Icons.group),
                    ),
                    items: _panels
                        .map(
                          (panel) => DropdownMenuItem(
                            value: panel,
                            child: Text(panel),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedPanel = value!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedReviewPhase,
                    decoration: const InputDecoration(
                      labelText: 'Filter by Phase',
                      prefixIcon: Icon(Icons.timeline),
                    ),
                    items: _reviewPhases
                        .map(
                          (phase) => DropdownMenuItem(
                            value: phase,
                            child: Text(phase),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedReviewPhase = value!),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5, // Mock data
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text('R${index + 1}'),
                    ),
                    title: Text('Review Assignment ${index + 1}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phase: Midterm Review • Panel: Panel ${String.fromCharCode(65 + index)}',
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 16,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Due: ${DateTime.now().add(Duration(days: 7)).day}/${DateTime.now().add(Duration(days: 7)).month}/${DateTime.now().add(Duration(days: 7)).year}',
                            ),
                          ],
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.people, color: AppColors.primary),
                                const SizedBox(width: 8),
                                const Text(
                                  'Faculty Members:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                Chip(
                                  avatar: const Icon(Icons.person, size: 16),
                                  label: const Text('Dr. John Smith'),
                                  backgroundColor: Colors.blue[50],
                                ),
                                Chip(
                                  avatar: const Icon(Icons.person, size: 16),
                                  label: const Text('Prof. Sarah Johnson'),
                                  backgroundColor: Colors.green[50],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Icon(
                                  Icons.assignment,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Projects to Review:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...List.generate(
                              3,
                              (projIndex) => ListTile(
                                dense: true,
                                leading: Icon(
                                  Icons.folder,
                                  color: Colors.orange,
                                ),
                                title: Text('Project ${projIndex + 1}'),
                                subtitle: Text('Team Alpha ${projIndex + 1}'),
                                trailing: Chip(
                                  label: const Text('Pending'),
                                  backgroundColor: Colors.orange[100],
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _editAssignment(index),
                                  icon: const Icon(Icons.edit),
                                  label: const Text('Edit'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _viewProgress(index),
                                  icon: const Icon(Icons.visibility),
                                  label: const Text('View Progress'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _deleteAssignment(index),
                                  icon: const Icon(Icons.delete),
                                  label: const Text('Delete'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.error,
                                  ),
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
          ),
        ],
      ),
    );
  }

  void _showAssignReviewDialog() {
    showDialog(context: context, builder: (context) => _AssignReviewDialog());
  }

  void _editAssignment(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing review assignment ${index + 1}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _viewProgress(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ReviewProgressScreen(assignmentId: index),
      ),
    );
  }

  void _deleteAssignment(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Assignment'),
        content: Text(
          'Are you sure you want to delete review assignment ${index + 1}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Review assignment ${index + 1} deleted'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _ReviewMonitorScreen extends StatefulWidget {
  @override
  _ReviewMonitorScreenState createState() => _ReviewMonitorScreenState();
}

class _ReviewMonitorScreenState extends State<_ReviewMonitorScreen> {
  String _selectedFilter = 'All Reviews';
  final List<String> _filters = [
    'All Reviews',
    'Pending',
    'In Progress',
    'Completed',
    'Overdue',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Monitor'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _showAnalytics,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter and Stats Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedFilter,
                        decoration: const InputDecoration(
                          labelText: 'Filter Reviews',
                          prefixIcon: Icon(Icons.filter_list),
                        ),
                        items: _filters
                            .map(
                              (filter) => DropdownMenuItem(
                                value: filter,
                                child: Text(filter),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedFilter = value!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _exportReport,
                      icon: const Icon(Icons.download),
                      label: const Text('Export'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Quick Stats
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total',
                        '48',
                        Icons.assignment,
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'Pending',
                        '12',
                        Icons.schedule,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'In Progress',
                        '18',
                        Icons.play_circle,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'Completed',
                        '15',
                        Icons.check_circle,
                        AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'Overdue',
                        '3',
                        Icons.warning,
                        AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Review List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 10, // Mock data
              itemBuilder: (context, index) {
                final reviewStatuses = [
                  'Pending',
                  'In Progress',
                  'Completed',
                  'Overdue',
                ];
                final status = reviewStatuses[index % reviewStatuses.length];
                final isOverdue = status == 'Overdue';
                final isCompleted = status == 'Completed';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(status),
                      child: Icon(
                        _getStatusIcon(status),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Review ${index + 1} - ${_getReviewType(index)}',
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Panel: Panel ${String.fromCharCode(65 + (index % 4))} • Faculty: Dr. ${_getFacultyName(index)}',
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              isOverdue ? Icons.warning : Icons.schedule,
                              size: 16,
                              color: isOverdue ? AppColors.error : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Due: ${_getDueDate(index)}',
                              style: TextStyle(
                                color: isOverdue
                                    ? AppColors.error
                                    : Colors.grey[600],
                                fontWeight: isOverdue
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(status),
                      backgroundColor: _getStatusColor(status).withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: _getStatusColor(status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Progress Bar
                            Row(
                              children: [
                                Icon(Icons.timeline, color: AppColors.primary),
                                const SizedBox(width: 8),
                                const Text(
                                  'Progress:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: _getProgressValue(status),
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getStatusColor(status),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(_getProgressValue(status) * 100).toInt()}% Complete',
                            ),
                            const SizedBox(height: 16),

                            // Projects under review
                            Row(
                              children: [
                                Icon(Icons.folder, color: AppColors.primary),
                                const SizedBox(width: 8),
                                const Text(
                                  'Projects:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...List.generate(
                              2 + (index % 2),
                              (projIndex) => ListTile(
                                dense: true,
                                leading: Icon(
                                  Icons.assignment,
                                  color: Colors.blue,
                                ),
                                title: Text('Project ${projIndex + 1}'),
                                subtitle: Text(
                                  'Team ${String.fromCharCode(65 + projIndex)}',
                                ),
                                trailing: Icon(
                                  isCompleted
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: isCompleted
                                      ? AppColors.success
                                      : Colors.grey,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _viewReviewDetails(index),
                                  icon: const Icon(Icons.visibility),
                                  label: const Text('View Details'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _contactFaculty(index),
                                  icon: const Icon(Icons.message),
                                  label: const Text('Contact'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                ),
                                if (isOverdue)
                                  ElevatedButton.icon(
                                    onPressed: () => _sendReminder(index),
                                    icon: const Icon(
                                      Icons.notification_important,
                                    ),
                                    label: const Text('Remind'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                    ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              count,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Completed':
        return AppColors.success;
      case 'Overdue':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pending':
        return Icons.schedule;
      case 'In Progress':
        return Icons.play_circle;
      case 'Completed':
        return Icons.check_circle;
      case 'Overdue':
        return Icons.warning;
      default:
        return Icons.assignment;
    }
  }

  double _getProgressValue(String status) {
    switch (status) {
      case 'Pending':
        return 0.0;
      case 'In Progress':
        return 0.6;
      case 'Completed':
        return 1.0;
      case 'Overdue':
        return 0.3;
      default:
        return 0.0;
    }
  }

  String _getReviewType(int index) {
    final types = [
      'Midterm Review',
      'Final Review',
      'Progress Review',
      'Viva Voce',
    ];
    return types[index % types.length];
  }

  String _getFacultyName(int index) {
    final names = ['Smith', 'Johnson', 'Brown', 'Davis', 'Wilson'];
    return names[index % names.length];
  }

  String _getDueDate(int index) {
    final now = DateTime.now();
    final dueDate = now.add(Duration(days: 7 - (index % 14)));
    return '${dueDate.day}/${dueDate.month}/${dueDate.year}';
  }

  void _refreshData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refreshing review data...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showAnalytics() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening review analytics...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting review report...'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _viewReviewDetails(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing details for Review ${index + 1}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _contactFaculty(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contacting faculty for Review ${index + 1}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _sendReminder(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder sent for Review ${index + 1}'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

class _AssignReviewDialog extends StatefulWidget {
  @override
  _AssignReviewDialogState createState() => _AssignReviewDialogState();
}

class _AssignReviewDialogState extends State<_AssignReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  String _selectedPanel = '';
  String _selectedReviewPhase = '';
  List<String> _selectedFaculty = [];
  List<String> _selectedProjects = [];

  final List<String> _panels = ['Panel A', 'Panel B', 'Panel C'];
  final List<String> _reviewPhases = [
    'Midterm Review',
    'Final Review',
    'Progress Review',
  ];
  final List<String> _faculty = [
    'Dr. John Smith',
    'Prof. Sarah Johnson',
    'Dr. Mike Wilson',
    'Prof. Emily Brown',
  ];
  final List<String> _projects = [
    'E-Commerce Platform',
    'Mobile Health App',
    'AI Chatbot',
    'IoT Smart Home',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.assignment_add, color: AppColors.primary),
          const SizedBox(width: 8),
          const Text('Assign Review'),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedPanel.isEmpty ? null : _selectedPanel,
                decoration: const InputDecoration(
                  labelText: 'Select Panel',
                  prefixIcon: Icon(Icons.group),
                ),
                items: _panels
                    .map(
                      (panel) =>
                          DropdownMenuItem(value: panel, child: Text(panel)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedPanel = value!),
                validator: (value) =>
                    value == null ? 'Please select a panel' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedReviewPhase.isEmpty
                    ? null
                    : _selectedReviewPhase,
                decoration: const InputDecoration(
                  labelText: 'Select Review Phase',
                  prefixIcon: Icon(Icons.timeline),
                ),
                items: _reviewPhases
                    .map(
                      (phase) =>
                          DropdownMenuItem(value: phase, child: Text(phase)),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedReviewPhase = value!),
                validator: (value) =>
                    value == null ? 'Please select a review phase' : null,
              ),
              const SizedBox(height: 16),

              ExpansionTile(
                title: Text(
                  'Select Faculty Members (${_selectedFaculty.length} selected)',
                ),
                leading: Icon(Icons.people, color: AppColors.primary),
                children: _faculty
                    .map(
                      (faculty) => CheckboxListTile(
                        title: Text(faculty),
                        value: _selectedFaculty.contains(faculty),
                        onChanged: (checked) {
                          setState(() {
                            if (checked!) {
                              _selectedFaculty.add(faculty);
                            } else {
                              _selectedFaculty.remove(faculty);
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),

              ExpansionTile(
                title: Text(
                  'Select Projects (${_selectedProjects.length} selected)',
                ),
                leading: Icon(Icons.folder, color: AppColors.primary),
                children: _projects
                    .map(
                      (project) => CheckboxListTile(
                        title: Text(project),
                        value: _selectedProjects.contains(project),
                        onChanged: (checked) {
                          setState(() {
                            if (checked!) {
                              _selectedProjects.add(project);
                            } else {
                              _selectedProjects.remove(project);
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _assignReview,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Assign Review'),
        ),
      ],
    );
  }

  void _assignReview() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedFaculty.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one faculty member'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      if (_selectedProjects.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one project'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // TODO: Implement review assignment logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Review assigned: $_selectedReviewPhase for $_selectedPanel',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }
}

class _ReviewProgressScreen extends StatelessWidget {
  final int assignmentId;

  const _ReviewProgressScreen({required this.assignmentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Progress - Assignment ${assignmentId + 1}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: AppColors.primary),
                        const SizedBox(width: 8),
                        const Text(
                          'Assignment Overview',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Panel:', 'Panel A'),
                    _buildInfoRow('Review Phase:', 'Midterm Review'),
                    _buildInfoRow(
                      'Due Date:',
                      '${DateTime.now().add(const Duration(days: 7)).day}/${DateTime.now().add(const Duration(days: 7)).month}/${DateTime.now().add(const Duration(days: 7)).year}',
                    ),
                    _buildInfoRow('Total Projects:', '3'),
                    _buildInfoRow('Completed Reviews:', '1'),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: 0.33,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Progress: 33% (1/3 projects reviewed)',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.people, color: AppColors.primary),
                        const SizedBox(width: 8),
                        const Text(
                          'Faculty Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.success,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      title: const Text('Dr. John Smith'),
                      subtitle: const Text('1/3 reviews completed'),
                      trailing: Chip(
                        label: const Text('Active'),
                        backgroundColor: Colors.green[100],
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      title: const Text('Prof. Sarah Johnson'),
                      subtitle: const Text('0/3 reviews completed'),
                      trailing: Chip(
                        label: const Text('Pending'),
                        backgroundColor: Colors.orange[100],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.assignment, color: AppColors.primary),
                        const SizedBox(width: 8),
                        const Text(
                          'Project Review Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(
                      3,
                      (index) => ListTile(
                        leading: Icon(
                          Icons.folder,
                          color: index == 0 ? AppColors.success : Colors.orange,
                        ),
                        title: Text('Project ${index + 1}'),
                        subtitle: Text('Team Alpha ${index + 1}'),
                        trailing: Chip(
                          label: Text(index == 0 ? 'Completed' : 'Pending'),
                          backgroundColor: index == 0
                              ? Colors.green[100]
                              : Colors.orange[100],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}

// Create Team Dialog
class _CreateTeamDialog extends StatefulWidget {
  @override
  _CreateTeamDialogState createState() => _CreateTeamDialogState();
}

class _CreateTeamDialogState extends State<_CreateTeamDialog> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  String _selectedPanel = '';
  final List<String> _panels = ['Panel A', 'Panel B', 'Panel C', 'Panel D'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.group_add, color: AppColors.primary),
          const SizedBox(width: 8),
          const Text('Create New Team'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _teamNameController,
              decoration: const InputDecoration(
                labelText: 'Team Name',
                prefixIcon: Icon(Icons.label),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter team name' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPanel.isEmpty ? null : _selectedPanel,
              decoration: const InputDecoration(
                labelText: 'Assign to Panel',
                prefixIcon: Icon(Icons.group),
              ),
              items: _panels
                  .map(
                    (panel) =>
                        DropdownMenuItem(value: panel, child: Text(panel)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedPanel = value!),
              validator: (value) =>
                  value == null ? 'Please select a panel' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createTeam,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Create Team'),
        ),
      ],
    );
  }

  void _createTeam() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Team "${_teamNameController.text}" created for $_selectedPanel',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    super.dispose();
  }
}

// Assign Students Dialog
class _AssignStudentsDialog extends StatefulWidget {
  @override
  _AssignStudentsDialogState createState() => _AssignStudentsDialogState();
}

class _AssignStudentsDialogState extends State<_AssignStudentsDialog> {
  String _selectedPanel = '';
  String _selectedTeam = '';
  List<String> _selectedStudents = [];

  final List<String> _panels = ['Panel A', 'Panel B', 'Panel C', 'Panel D'];
  final List<String> _teams = [
    'Team Alpha',
    'Team Beta',
    'Team Gamma',
    'Team Delta',
  ];
  final List<String> _students = [
    'John Smith',
    'Sarah Johnson',
    'Mike Wilson',
    'Emily Brown',
    'David Lee',
    'Anna Davis',
    'Chris Taylor',
    'Lisa Anderson',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.assignment_ind, color: AppColors.primary),
          const SizedBox(width: 8),
          const Text('Assign Students'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedPanel.isEmpty ? null : _selectedPanel,
              decoration: const InputDecoration(
                labelText: 'Select Panel',
                prefixIcon: Icon(Icons.group),
              ),
              items: _panels
                  .map(
                    (panel) =>
                        DropdownMenuItem(value: panel, child: Text(panel)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedPanel = value!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedTeam.isEmpty ? null : _selectedTeam,
              decoration: const InputDecoration(
                labelText: 'Select Team',
                prefixIcon: Icon(Icons.people),
              ),
              items: _teams
                  .map(
                    (team) => DropdownMenuItem(value: team, child: Text(team)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedTeam = value!),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Students:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._students
                .map(
                  (student) => CheckboxListTile(
                    title: Text(student),
                    value: _selectedStudents.contains(student),
                    onChanged: (checked) {
                      setState(() {
                        if (checked!) {
                          _selectedStudents.add(student);
                        } else {
                          _selectedStudents.remove(student);
                        }
                      });
                    },
                  ),
                )
                .toList(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _assignStudents,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Assign Students'),
        ),
      ],
    );
  }

  void _assignStudents() {
    if (_selectedPanel.isEmpty ||
        _selectedTeam.isEmpty ||
        _selectedStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select panel, team, and at least one student'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_selectedStudents.length} students assigned to $_selectedTeam in $_selectedPanel',
        ),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context);
  }
}

// Add Project Dialog
class _AddProjectDialog extends StatefulWidget {
  @override
  _AddProjectDialogState createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<_AddProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _techStackController = TextEditingController();
  String _selectedDifficulty = 'Medium';
  String _selectedCategory = 'Web Development';
  String _selectedPanel = '';
  DateTime _deadline = DateTime.now().add(const Duration(days: 90));

  final List<String> _difficulties = ['Easy', 'Medium', 'Hard', 'Expert'];
  final List<String> _categories = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'IoT',
    'Blockchain',
    'Game Development',
    'AI/ML',
  ];
  final List<String> _panels = ['Panel A', 'Panel B', 'Panel C', 'Panel D'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.add_box, color: AppColors.primary),
          const SizedBox(width: 8),
          const Text('Add New Project'),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Project Title',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter project title'
                    : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Project Description',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter project description'
                    : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: _categories
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedCategory = value!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedDifficulty,
                      decoration: const InputDecoration(
                        labelText: 'Difficulty',
                        prefixIcon: Icon(Icons.speed),
                      ),
                      items: _difficulties
                          .map(
                            (difficulty) => DropdownMenuItem(
                              value: difficulty,
                              child: Text(difficulty),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedDifficulty = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _requirementsController,
                decoration: const InputDecoration(
                  labelText: 'Requirements',
                  prefixIcon: Icon(Icons.checklist),
                  hintText: 'List the project requirements...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _techStackController,
                decoration: const InputDecoration(
                  labelText: 'Technology Stack',
                  prefixIcon: Icon(Icons.code),
                  hintText: 'e.g., React, Node.js, MongoDB...',
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedPanel.isEmpty ? null : _selectedPanel,
                decoration: const InputDecoration(
                  labelText: 'Assign to Panel',
                  prefixIcon: Icon(Icons.group),
                ),
                items: _panels
                    .map(
                      (panel) =>
                          DropdownMenuItem(value: panel, child: Text(panel)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedPanel = value!),
                validator: (value) =>
                    value == null ? 'Please select a panel' : null,
              ),
              const SizedBox(height: 16),

              ListTile(
                leading: Icon(Icons.calendar_today, color: AppColors.primary),
                title: const Text('Project Deadline'),
                subtitle: Text(
                  '${_deadline.day}/${_deadline.month}/${_deadline.year}',
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _deadline,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) setState(() => _deadline = date);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addProject,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Add Project'),
        ),
      ],
    );
  }

  void _addProject() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Project "${_titleController.text}" added successfully!',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    _techStackController.dispose();
    super.dispose();
  }
}

// Edit Project Dialog
class _EditProjectDialog extends StatefulWidget {
  final Map<String, dynamic> project;

  const _EditProjectDialog({required this.project});

  @override
  _EditProjectDialogState createState() => _EditProjectDialogState();
}

class _EditProjectDialogState extends State<_EditProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _requirementsController;
  late final TextEditingController _techStackController;
  late String _selectedDifficulty;
  late String _selectedCategory;
  late String _selectedPanel;
  late String _selectedStatus;
  late DateTime _deadline;

  final List<String> _difficulties = ['Easy', 'Medium', 'Hard', 'Expert'];
  final List<String> _categories = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'IoT',
    'Blockchain',
    'Game Development',
    'AI/ML',
  ];
  final List<String> _panels = ['Panel A', 'Panel B', 'Panel C', 'Panel D'];
  final List<String> _statuses = [
    'Planning',
    'In Progress',
    'Review',
    'Completed',
    'On Hold',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project['title']);
    _descriptionController = TextEditingController(
      text: widget.project['description'] ?? '',
    );
    _requirementsController = TextEditingController(
      text: widget.project['requirements'] ?? '',
    );
    _techStackController = TextEditingController(
      text: widget.project['techStack'] ?? '',
    );
    _selectedDifficulty = widget.project['difficulty'] ?? 'Medium';
    _selectedCategory = widget.project['category'] ?? 'Web Development';
    _selectedPanel = widget.project['panel'] ?? 'Panel A';
    _selectedStatus = widget.project['status'] ?? 'Planning';
    _deadline = DateTime.now().add(const Duration(days: 90));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.edit, color: AppColors.primary),
          const SizedBox(width: 8),
          const Text('Edit Project'),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Project Title',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter project title'
                    : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Project Description',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: _categories
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedCategory = value!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedDifficulty,
                      decoration: const InputDecoration(
                        labelText: 'Difficulty',
                        prefixIcon: Icon(Icons.speed),
                      ),
                      items: _difficulties
                          .map(
                            (difficulty) => DropdownMenuItem(
                              value: difficulty,
                              child: Text(difficulty),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedDifficulty = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedPanel,
                      decoration: const InputDecoration(
                        labelText: 'Panel',
                        prefixIcon: Icon(Icons.group),
                      ),
                      items: _panels
                          .map(
                            (panel) => DropdownMenuItem(
                              value: panel,
                              child: Text(panel),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedPanel = value!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        prefixIcon: Icon(Icons.flag),
                      ),
                      items: _statuses
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedStatus = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _requirementsController,
                decoration: const InputDecoration(
                  labelText: 'Requirements',
                  prefixIcon: Icon(Icons.checklist),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _techStackController,
                decoration: const InputDecoration(
                  labelText: 'Technology Stack',
                  prefixIcon: Icon(Icons.code),
                ),
              ),
              const SizedBox(height: 16),

              ListTile(
                leading: Icon(Icons.calendar_today, color: AppColors.primary),
                title: const Text('Project Deadline'),
                subtitle: Text(
                  '${_deadline.day}/${_deadline.month}/${_deadline.year}',
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _deadline,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) setState(() => _deadline = date);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveChanges,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Save Changes'),
        ),
      ],
    );
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Project "${_titleController.text}" updated successfully!',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    _techStackController.dispose();
    super.dispose();
  }
}
