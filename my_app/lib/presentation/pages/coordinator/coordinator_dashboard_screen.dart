import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../presentation/providers/auth_provider.dart';

class CoordinatorDashboardScreen extends ConsumerStatefulWidget {
  const CoordinatorDashboardScreen({super.key});

  @override
  ConsumerState<CoordinatorDashboardScreen> createState() =>
      _CoordinatorDashboardScreenState();
}

class _CoordinatorDashboardScreenState
    extends ConsumerState<CoordinatorDashboardScreen> {
  bool _isLoading = true;
  String _selectedTimeRange = 'This Semester';

  // Mock data - Replace with actual API calls
  final Map<String, dynamic> _dashboardData = {
    'totalPanels': 12,
    'activePanels': 8,
    'completedPanels': 4,
    'totalFaculty': 35,
    'totalStudents': 156,
    'pendingAssignments': 15,
    'evaluationProgress': 0.75,
    'averageScore': 78.5,
    'recentActivities': [
      {
        'type': 'panel_created',
        'title': 'New panel created',
        'subtitle': 'AI & Machine Learning Projects Panel',
        'time': '2 hours ago',
        'icon': Icons.group_add,
        'color': AppColors.success,
      },
      {
        'type': 'assignment_completed',
        'title': 'Assignment completed',
        'subtitle': 'Dr. Smith completed evaluation batch',
        'time': '4 hours ago',
        'icon': Icons.check_circle,
        'color': AppColors.info,
      },
      {
        'type': 'evaluation_submitted',
        'title': 'Evaluation submitted',
        'subtitle': '15 evaluations submitted today',
        'time': '6 hours ago',
        'icon': Icons.assignment_turned_in,
        'color': AppColors.primary,
      },
    ],
    'upcomingDeadlines': [
      {
        'title': 'Final Evaluation Deadline',
        'description': 'AI & ML Projects Panel',
        'date': '2024-01-20',
        'priority': 'high',
        'progress': 0.6,
      },
      {
        'title': 'Report Submission',
        'description': 'Web Development Panel',
        'date': '2024-01-25',
        'priority': 'medium',
        'progress': 0.8,
      },
    ],
    'performanceMetrics': [
      {'name': 'On-time Completion', 'value': 85, 'target': 90, 'unit': '%'},
      {
        'name': 'Average Evaluation Score',
        'value': 78.5,
        'target': 75,
        'unit': '/100',
      },
      {'name': 'Faculty Participation', 'value': 92, 'target': 95, 'unit': '%'},
      {'name': 'Student Satisfaction', 'value': 88, 'target': 85, 'unit': '%'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Panel Coordinator Dashboard',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user?.name ?? 'Panel Coordinator',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, color: Colors.white),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to profile screen
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                setState(() => _isLoading = true);
                _loadDashboardData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTimeRangeSelector(),
                    const SizedBox(height: 20),
                    _buildOverviewCards(),
                    const SizedBox(height: 20),
                    _buildQuickActions(),
                    const SizedBox(height: 20),
                    _buildPerformanceMetrics(),
                    const SizedBox(height: 20),
                    _buildUpcomingDeadlines(),
                    const SizedBox(height: 20),
                    _buildRecentActivity(),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewPanel,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Panel'),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: ['This Week', 'This Month', 'This Semester', 'This Year'].map(
          (timeRange) {
            final isSelected = _selectedTimeRange == timeRange;
            return GestureDetector(
              onTap: () => setState(() => _selectedTimeRange = timeRange),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  timeRange,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          'Total Panels',
          '${_dashboardData['totalPanels']}',
          Icons.dashboard,
          AppColors.primary,
          subtitle: '${_dashboardData['activePanels']} active',
        ),
        _buildStatCard(
          'Total Faculty',
          '${_dashboardData['totalFaculty']}',
          Icons.people,
          AppColors.info,
          subtitle: 'Assigned to panels',
        ),
        _buildStatCard(
          'Total Students',
          '${_dashboardData['totalStudents']}',
          Icons.school,
          AppColors.success,
          subtitle: 'In evaluation',
        ),
        _buildStatCard(
          'Pending Tasks',
          '${_dashboardData['pendingAssignments']}',
          Icons.pending_actions,
          AppColors.warning,
          subtitle: 'Require attention',
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
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
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (subtitle != null)
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

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildQuickActionButton(
              'Manage Panels',
              Icons.dashboard,
              AppColors.primary,
              () {
                Navigator.pushNamed(context, '/coordinator/panel-management');
              },
            ),
            _buildQuickActionButton(
              'Assign Faculty',
              Icons.person_add,
              AppColors.info,
              () {
                Navigator.pushNamed(context, '/coordinator/assignments');
              },
            ),
            _buildQuickActionButton(
              'View Reports',
              Icons.analytics,
              AppColors.success,
              () {
                Navigator.pushNamed(context, '/coordinator/reports');
              },
            ),
            _buildQuickActionButton(
              'Schedule Events',
              Icons.calendar_today,
              AppColors.warning,
              () {
                Navigator.pushNamed(context, '/coordinator/scheduling');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Metrics',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: (_dashboardData['performanceMetrics'] as List).map((
                metric,
              ) {
                return _buildMetricRow(metric);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(Map<String, dynamic> metric) {
    final percentage =
        metric['value'] /
        (metric['name'].contains('Score') ? 100 : metric['target']);
    final isOnTarget = metric['value'] >= metric['target'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                metric['name'],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Text(
                    '${metric['value']}${metric['unit']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isOnTarget ? AppColors.success : AppColors.warning,
                    ),
                  ),
                  Text(
                    ' / ${metric['target']}${metric['unit']}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percentage > 1 ? 1 : percentage,
            backgroundColor: AppColors.textSecondary.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
              isOnTarget ? AppColors.success : AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingDeadlines() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Deadlines',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to full deadlines view
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...(_dashboardData['upcomingDeadlines'] as List).map((deadline) {
          return _buildDeadlineCard(deadline);
        }).toList(),
      ],
    );
  }

  Widget _buildDeadlineCard(Map<String, dynamic> deadline) {
    Color priorityColor;
    switch (deadline['priority']) {
      case 'high':
        priorityColor = AppColors.error;
        break;
      case 'medium':
        priorityColor = AppColors.warning;
        break;
      case 'low':
      default:
        priorityColor = AppColors.success;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    deadline['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    deadline['priority'].toUpperCase(),
                    style: TextStyle(
                      color: priorityColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(deadline['description']),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  deadline['date'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(deadline['progress'] * 100).toInt()}% complete',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: deadline['progress'],
              backgroundColor: AppColors.textSecondary.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(priorityColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to full activity log
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (_dashboardData['recentActivities'] as List).length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final activity =
                  (_dashboardData['recentActivities'] as List)[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: activity['color'].withOpacity(0.1),
                  child: Icon(
                    activity['icon'],
                    color: activity['color'],
                    size: 20,
                  ),
                ),
                title: Text(
                  activity['title'],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(activity['subtitle']),
                trailing: Text(
                  activity['time'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap: () {
                  // TODO: Navigate to activity details
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _createNewPanel() {
    // TODO: Navigate to create panel screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create new panel feature coming soon')),
    );
  }
}
