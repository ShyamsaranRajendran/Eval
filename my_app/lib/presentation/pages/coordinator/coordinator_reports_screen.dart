import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../widgets/custom_button.dart';

class CoordinatorReportsScreen extends ConsumerStatefulWidget {
  const CoordinatorReportsScreen({super.key});

  @override
  ConsumerState<CoordinatorReportsScreen> createState() =>
      _CoordinatorReportsScreenState();
}

class _CoordinatorReportsScreenState
    extends ConsumerState<CoordinatorReportsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  String _selectedTimeRange = 'This Month';
  bool _isLoading = false;

  // Mock analytics data
  final Map<String, dynamic> _analyticsData = {
    'totalPanels': 15,
    'activePanels': 8,
    'completedEvaluations': 142,
    'pendingEvaluations': 28,
    'totalFaculty': 45,
    'totalStudents': 320,
    'averageScore': 84.2,
    'onTimeSubmissions': 92.5,
    'panelUtilization': 78.3,
    'facultyWorkload': 67.8,
    'monthlyTrends': [
      {'month': 'Jan', 'evaluations': 45, 'score': 82.1},
      {'month': 'Feb', 'evaluations': 52, 'score': 84.3},
      {'month': 'Mar', 'evaluations': 48, 'score': 83.7},
      {'month': 'Apr', 'evaluations': 56, 'score': 85.2},
      {'month': 'May', 'evaluations': 42, 'score': 84.8},
      {'month': 'Jun', 'evaluations': 38, 'score': 86.1},
    ],
    'departmentStats': [
      {
        'department': 'Computer Science',
        'panels': 6,
        'faculty': 18,
        'students': 145,
        'avgScore': 85.4,
      },
      {
        'department': 'Information Technology',
        'panels': 4,
        'faculty': 12,
        'students': 98,
        'avgScore': 83.2,
      },
      {
        'department': 'Electronics Engineering',
        'panels': 3,
        'faculty': 10,
        'students': 67,
        'avgScore': 84.1,
      },
      {
        'department': 'Mechanical Engineering',
        'panels': 2,
        'faculty': 5,
        'students': 10,
        'avgScore': 82.8,
      },
    ],
    'topPerformers': [
      {
        'name': 'Dr. Michael Chen',
        'department': 'Computer Science',
        'evaluations': 28,
        'avgScore': 89.5,
        'onTime': 100,
      },
      {
        'name': 'Prof. Lisa Wang',
        'department': 'Computer Science',
        'evaluations': 24,
        'avgScore': 87.8,
        'onTime': 96,
      },
      {
        'name': 'Dr. Emily Rodriguez',
        'department': 'Information Technology',
        'evaluations': 22,
        'avgScore': 86.9,
        'onTime': 100,
      },
      {
        'name': 'Prof. David Miller',
        'department': 'Information Technology',
        'evaluations': 26,
        'avgScore': 85.4,
        'onTime': 92,
      },
      {
        'name': 'Dr. Ahmed Hassan',
        'department': 'Computer Science',
        'evaluations': 30,
        'avgScore': 84.7,
        'onTime': 87,
      },
    ],
    'recentActivity': [
      {
        'type': 'evaluation_completed',
        'faculty': 'Dr. Michael Chen',
        'student': 'John Smith',
        'score': 92,
        'time': '2 hours ago',
      },
      {
        'type': 'panel_created',
        'name': 'IoT Projects Panel',
        'coordinator': 'Dr. Robert Johnson',
        'time': '4 hours ago',
      },
      {
        'type': 'assignment_updated',
        'faculty': 'Prof. Lisa Wang',
        'panel': 'AI Projects',
        'time': '6 hours ago',
      },
      {
        'type': 'evaluation_overdue',
        'faculty': 'Dr. Ahmed Hassan',
        'student': 'Sarah Wilson',
        'time': '1 day ago',
      },
      {
        'type': 'report_generated',
        'name': 'Monthly Performance Report',
        'time': '2 days ago',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAnalytics();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAnalytics() async {
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
        title: const Text('Reports & Analytics'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.date_range),
            onSelected: (value) {
              setState(() => _selectedTimeRange = value);
              _loadAnalytics();
            },
            itemBuilder: (context) =>
                [
                      'This Week',
                      'This Month',
                      'This Quarter',
                      'This Year',
                      'Custom Range',
                    ]
                    .map(
                      (range) =>
                          PopupMenuItem(value: range, child: Text(range)),
                    )
                    .toList(),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _showExportOptions,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showReportSettings,
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
            Tab(text: 'Performance'),
            Tab(text: 'Departments'),
            Tab(text: 'Activity'),
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
                  'Reporting Period: $_selectedTimeRange',
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
                _buildPerformanceTab(),
                _buildDepartmentsTab(),
                _buildActivityTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generateCustomReport,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.analytics),
        label: const Text('Custom Report'),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return RefreshIndicator(
      onRefresh: _loadAnalytics,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Key Metrics Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildMetricCard(
                  'Total Panels',
                  '${_analyticsData['totalPanels']}',
                  '${_analyticsData['activePanels']} active',
                  Icons.dashboard,
                  AppColors.primary,
                ),
                _buildMetricCard(
                  'Evaluations',
                  '${_analyticsData['completedEvaluations']}',
                  '${_analyticsData['pendingEvaluations']} pending',
                  Icons.assignment_turned_in,
                  AppColors.success,
                ),
                _buildMetricCard(
                  'Faculty Members',
                  '${_analyticsData['totalFaculty']}',
                  '${(_analyticsData['facultyWorkload'] as double).toStringAsFixed(1)}% avg workload',
                  Icons.people,
                  AppColors.info,
                ),
                _buildMetricCard(
                  'Students',
                  '${_analyticsData['totalStudents']}',
                  '${(_analyticsData['averageScore'] as double).toStringAsFixed(1)} avg score',
                  Icons.school,
                  AppColors.warning,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Performance Indicators
            Text(
              'Performance Indicators',
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
                    _buildProgressIndicator(
                      'On-Time Submissions',
                      _analyticsData['onTimeSubmissions'] as double,
                      AppColors.success,
                    ),
                    const SizedBox(height: 16),
                    _buildProgressIndicator(
                      'Panel Utilization',
                      _analyticsData['panelUtilization'] as double,
                      AppColors.info,
                    ),
                    const SizedBox(height: 16),
                    _buildProgressIndicator(
                      'Faculty Workload',
                      _analyticsData['facultyWorkload'] as double,
                      AppColors.warning,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    'Generate Monthly Report',
                    Icons.description,
                    AppColors.primary,
                    () => _generateReport('monthly'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionCard(
                    'Export Analytics',
                    Icons.file_download,
                    AppColors.info,
                    _showExportOptions,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return RefreshIndicator(
      onRefresh: _loadAnalytics,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Performance Chart Placeholder
            Card(
              child: Container(
                height: 250,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Evaluation Trends',
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
                                Icons.insert_chart,
                                size: 48,
                                color: AppColors.textSecondary.withOpacity(0.5),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Chart will be implemented with\ncharts_flutter package',
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

            // Top Performers
            Text(
              'Top Performing Faculty',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ...(_analyticsData['topPerformers'] as List).asMap().entries.map((
              entry,
            ) {
              final index = entry.key;
              final performer = entry.value;
              return _buildPerformerCard(performer, index + 1);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentsTab() {
    return RefreshIndicator(
      onRefresh: _loadAnalytics,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Department Statistics',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ...(_analyticsData['departmentStats'] as List).map((dept) {
              return _buildDepartmentCard(dept);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTab() {
    return RefreshIndicator(
      onRefresh: _loadAnalytics,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ...(_analyticsData['recentActivity'] as List).map((activity) {
              return _buildActivityCard(activity);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
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

  Widget _buildProgressIndicator(String label, double value, Color color) {
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
              '${value.toStringAsFixed(1)}%',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value / 100,
          backgroundColor: AppColors.textSecondary.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildActionCard(
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
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformerCard(Map<String, dynamic> performer, int rank) {
    Color rankColor;
    IconData rankIcon;

    switch (rank) {
      case 1:
        rankColor = const Color(0xFFFFD700); // Gold
        rankIcon = Icons.emoji_events;
        break;
      case 2:
        rankColor = const Color(0xFFC0C0C0); // Silver
        rankIcon = Icons.emoji_events;
        break;
      case 3:
        rankColor = const Color(0xFFCD7F32); // Bronze
        rankIcon = Icons.emoji_events;
        break;
      default:
        rankColor = AppColors.textSecondary;
        rankIcon = Icons.star;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: rankColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: rank <= 3
                    ? Icon(rankIcon, color: rankColor, size: 20)
                    : Text(
                        '$rank',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: rankColor,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    performer['name'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    performer['department'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: AppColors.warning, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${performer['avgScore'].toStringAsFixed(1)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  '${performer['evaluations']} evaluations',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${performer['onTime']}% on-time',
                  style: TextStyle(
                    fontSize: 12,
                    color: performer['onTime'] >= 95
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentCard(Map<String, dynamic> dept) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dept['department'],
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDeptStat(
                    'Panels',
                    '${dept['panels']}',
                    AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _buildDeptStat(
                    'Faculty',
                    '${dept['faculty']}',
                    AppColors.info,
                  ),
                ),
                Expanded(
                  child: _buildDeptStat(
                    'Students',
                    '${dept['students']}',
                    AppColors.success,
                  ),
                ),
                Expanded(
                  child: _buildDeptStat(
                    'Avg Score',
                    '${dept['avgScore'].toStringAsFixed(1)}',
                    AppColors.warning,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeptStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    IconData icon;
    Color iconColor;
    String description;

    switch (activity['type']) {
      case 'evaluation_completed':
        icon = Icons.check_circle;
        iconColor = AppColors.success;
        description =
            '${activity['faculty']} completed evaluation for ${activity['student']} (Score: ${activity['score']})';
        break;
      case 'panel_created':
        icon = Icons.add_circle;
        iconColor = AppColors.primary;
        description =
            'New panel "${activity['name']}" created by ${activity['coordinator']}';
        break;
      case 'assignment_updated':
        icon = Icons.update;
        iconColor = AppColors.info;
        description =
            '${activity['faculty']} assignment updated for ${activity['panel']}';
        break;
      case 'evaluation_overdue':
        icon = Icons.warning;
        iconColor = AppColors.error;
        description =
            'Overdue evaluation: ${activity['faculty']} for ${activity['student']}';
        break;
      case 'report_generated':
        icon = Icons.description;
        iconColor = AppColors.success;
        description = 'Report "${activity['name']}" generated successfully';
        break;
      default:
        icon = Icons.info;
        iconColor = AppColors.textSecondary;
        description = 'Unknown activity';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(description, style: Theme.of(context).textTheme.bodyMedium),
        subtitle: Text(
          activity['time'],
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ),
    );
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export Options',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('Export as PDF'),
              subtitle: const Text('Comprehensive report with charts'),
              onTap: () => _exportReport('pdf'),
            ),

            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: const Text('Export as Excel'),
              subtitle: const Text('Data tables and raw numbers'),
              onTap: () => _exportReport('excel'),
            ),

            ListTile(
              leading: const Icon(Icons.code, color: Colors.blue),
              title: const Text('Export as CSV'),
              subtitle: const Text('Raw data for external analysis'),
              onTap: () => _exportReport('csv'),
            ),

            const SizedBox(height: 12),
            CustomButton(
              text: 'Cancel',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportSettings() {
    // TODO: Implement report settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report settings feature coming soon')),
    );
  }

  void _generateCustomReport() {
    // TODO: Implement custom report generation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom report generation feature coming soon'),
      ),
    );
  }

  void _generateReport(String type) {
    // TODO: Implement report generation
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Generating $type report...')));
  }

  void _exportReport(String format) {
    Navigator.pop(context);
    // TODO: Implement export functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Exporting report as $format...')));
  }
}
