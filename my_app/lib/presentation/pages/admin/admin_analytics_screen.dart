import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';

class AdminAnalyticsScreen extends ConsumerStatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  ConsumerState<AdminAnalyticsScreen> createState() =>
      _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends ConsumerState<AdminAnalyticsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String _selectedTimeRange = 'Last 30 Days';
  String _selectedDepartment = 'All Departments';

  // Analytics Data
  final Map<String, dynamic> _analyticsData = {
    'overview': {
      'totalEvaluations': 1247,
      'completedEvaluations': 1125,
      'pendingEvaluations': 122,
      'averageScore': 78.5,
      'totalUsers': 245,
      'activeUsers': 198,
      'systemUptime': 99.8,
    },
    'evaluations': {
      'monthly': [
        {'month': 'Jan', 'evaluations': 95, 'avgScore': 76.2},
        {'month': 'Feb', 'evaluations': 108, 'avgScore': 77.1},
        {'month': 'Mar', 'evaluations': 142, 'avgScore': 79.3},
        {'month': 'Apr', 'evaluations': 156, 'avgScore': 78.8},
        {'month': 'May', 'evaluations': 134, 'avgScore': 80.1},
        {'month': 'Jun', 'evaluations': 167, 'avgScore': 78.5},
      ],
      'byDepartment': [
        {
          'department': 'Computer Science',
          'count': 456,
          'avgScore': 82.3,
          'completion': 95.2,
        },
        {
          'department': 'Information Technology',
          'count': 324,
          'avgScore': 78.9,
          'completion': 92.1,
        },
        {
          'department': 'Electronics Engineering',
          'count': 287,
          'avgScore': 76.4,
          'completion': 88.5,
        },
        {
          'department': 'Mechanical Engineering',
          'count': 180,
          'avgScore': 74.8,
          'completion': 85.0,
        },
      ],
      'scoreDistribution': [
        {'range': '90-100', 'count': 187, 'percentage': 15.0},
        {'range': '80-89', 'count': 312, 'percentage': 25.0},
        {'range': '70-79', 'count': 436, 'percentage': 35.0},
        {'range': '60-69', 'count': 249, 'percentage': 20.0},
        {'range': '0-59', 'count': 63, 'percentage': 5.0},
      ],
    },
    'users': {
      'roleDistribution': [
        {'role': 'Students', 'count': 145, 'percentage': 59.2},
        {'role': 'Faculty', 'count': 68, 'percentage': 27.8},
        {'role': 'Coordinators', 'count': 24, 'percentage': 9.8},
        {'role': 'Admins', 'count': 8, 'percentage': 3.3},
      ],
      'activityTrend': [
        {'date': '2024-01-01', 'activeUsers': 145},
        {'date': '2024-01-02', 'activeUsers': 167},
        {'date': '2024-01-03', 'activeUsers': 189},
        {'date': '2024-01-04', 'activeUsers': 198},
        {'date': '2024-01-05', 'activeUsers': 203},
        {'date': '2024-01-06', 'activeUsers': 195},
        {'date': '2024-01-07', 'activeUsers': 178},
      ],
    },
    'system': {
      'performance': [
        {'metric': 'CPU Usage', 'value': 45.2, 'status': 'good'},
        {'metric': 'Memory Usage', 'value': 67.8, 'status': 'warning'},
        {'metric': 'Disk Usage', 'value': 23.1, 'status': 'good'},
        {'metric': 'Network I/O', 'value': 12.5, 'status': 'good'},
      ],
      'errors': [
        {'type': 'Authentication', 'count': 12, 'trend': -2},
        {'type': 'Database', 'count': 3, 'trend': 0},
        {'type': 'Network', 'count': 7, 'trend': 1},
        {'type': 'Validation', 'count': 18, 'trend': -5},
      ],
    },
  };

  final List<String> _timeRanges = [
    'Last 7 Days',
    'Last 30 Days',
    'Last 3 Months',
    'Last 6 Months',
    'Last Year',
    'Custom Range',
  ];

  final List<String> _departments = [
    'All Departments',
    'Computer Science',
    'Information Technology',
    'Electronics Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAnalyticsData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAnalyticsData() async {
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
        title: const Text('Analytics Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Export Report'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'schedule',
                child: Row(
                  children: [
                    Icon(Icons.schedule),
                    SizedBox(width: 8),
                    Text('Schedule Report'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'export') _exportReport();
              if (value == 'schedule') _scheduleReport();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Filter Row
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: AppColors.primary.withOpacity(0.1),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown(
                        'Time Range',
                        _selectedTimeRange,
                        _timeRanges,
                        (value) => setState(() => _selectedTimeRange = value!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildFilterDropdown(
                        'Department',
                        _selectedDepartment,
                        _departments,
                        (value) => setState(() => _selectedDepartment = value!),
                      ),
                    ),
                  ],
                ),
              ),
              // Tab Bar
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                isScrollable: false,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Evaluations'),
                  Tab(text: 'Users'),
                  Tab(text: 'System'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildEvaluationsTab(),
                _buildUsersTab(),
                _buildSystemTab(),
              ],
            ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: Container(),
            items: options.map((option) {
              return DropdownMenuItem(value: option, child: Text(option));
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab() {
    final overview = _analyticsData['overview'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Overview',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Key Metrics Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildMetricCard(
                'Total Evaluations',
                overview['totalEvaluations'].toString(),
                Icons.assessment,
                AppColors.primary,
              ),
              _buildMetricCard(
                'Completed',
                overview['completedEvaluations'].toString(),
                Icons.check_circle,
                AppColors.success,
              ),
              _buildMetricCard(
                'Average Score',
                '${overview['averageScore']}%',
                Icons.trending_up,
                AppColors.warning,
              ),
              _buildMetricCard(
                'Active Users',
                '${overview['activeUsers']}/${overview['totalUsers']}',
                Icons.people,
                AppColors.info,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Progress Indicators
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Health',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildProgressIndicator(
                    'Evaluation Completion Rate',
                    overview['completedEvaluations'] /
                        overview['totalEvaluations'],
                    '${(overview['completedEvaluations'] / overview['totalEvaluations'] * 100).toStringAsFixed(1)}%',
                    AppColors.success,
                  ),
                  const SizedBox(height: 12),
                  _buildProgressIndicator(
                    'User Engagement',
                    overview['activeUsers'] / overview['totalUsers'],
                    '${(overview['activeUsers'] / overview['totalUsers'] * 100).toStringAsFixed(1)}%',
                    AppColors.info,
                  ),
                  const SizedBox(height: 12),
                  _buildProgressIndicator(
                    'System Uptime',
                    overview['systemUptime'] / 100,
                    '${overview['systemUptime']}%',
                    AppColors.primary,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Recent Activity Chart Placeholder
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Activity Trend',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => _showDetailedChart('activity'),
                        child: const Text('View Details'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.insert_chart,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Activity Trend Chart\n(Chart library integration needed)',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationsTab() {
    final evaluations = _analyticsData['evaluations'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Evaluation Analytics',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Monthly Trend
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Evaluation Trend',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bar_chart, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'Monthly Evaluation Bar Chart\n(Chart library integration needed)',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Department Performance
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Department Performance',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...evaluations['byDepartment']
                      .map((dept) => _buildDepartmentPerformanceCard(dept))
                      .toList(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Score Distribution
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Score Distribution',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => _showDetailedChart('scores'),
                        child: const Text('View Chart'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...evaluations['scoreDistribution']
                      .map((score) => _buildScoreDistributionItem(score))
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    final users = _analyticsData['users'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Analytics',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Role Distribution
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'User Role Distribution',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => _showDetailedChart('roles'),
                        child: const Text('View Pie Chart'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...users['roleDistribution']
                      .map((role) => _buildRoleDistributionItem(role))
                      .toList(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // User Activity Trend
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Active Users',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.timeline, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'User Activity Line Chart\n(Chart library integration needed)',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // User Engagement Stats
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'New Users (7d)',
                  '23',
                  Icons.person_add,
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Retention Rate',
                  '87.3%',
                  Icons.trending_up,
                  AppColors.info,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemTab() {
    final system = _analyticsData['system'];

    return SingleChildScrollView(
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

          // Performance Metrics
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Performance',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...system['performance']
                      .map((metric) => _buildPerformanceMetric(metric))
                      .toList(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Error Statistics
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Error Statistics (Last 24h)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...system['errors']
                      .map((error) => _buildErrorStatistic(error))
                      .toList(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // System Resources Chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resource Usage Over Time',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.memory, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'System Resource Chart\n(Chart library integration needed)',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(
    String label,
    double progress,
    String percentage,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(
              percentage,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildDepartmentPerformanceCard(Map<String, dynamic> dept) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dept['department'],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '${dept['avgScore']}%',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: Text('Evaluations: ${dept['count']}')),
              Text('Completion: ${dept['completion']}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreDistributionItem(Map<String, dynamic> score) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              score['range'],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: score['percentage'] / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${score['count']} (${score['percentage']}%)',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleDistributionItem(Map<String, dynamic> role) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _getRoleColor(role['role']),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              role['role'],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '${role['count']} (${role['percentage']}%)',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetric(Map<String, dynamic> metric) {
    Color statusColor;
    switch (metric['status']) {
      case 'good':
        statusColor = AppColors.success;
        break;
      case 'warning':
        statusColor = AppColors.warning;
        break;
      case 'error':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              metric['metric'],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '${metric['value']}%',
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorStatistic(Map<String, dynamic> error) {
    IconData trendIcon;
    Color trendColor;
    if (error['trend'] > 0) {
      trendIcon = Icons.trending_up;
      trendColor = AppColors.error;
    } else if (error['trend'] < 0) {
      trendIcon = Icons.trending_down;
      trendColor = AppColors.success;
    } else {
      trendIcon = Icons.trending_flat;
      trendColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${error['type']} Errors',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '${error['count']}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Icon(trendIcon, size: 16, color: trendColor),
          Text(
            error['trend'] > 0 ? '+${error['trend']}' : '${error['trend']}',
            style: TextStyle(color: trendColor, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Students':
        return AppColors.info;
      case 'Faculty':
        return AppColors.success;
      case 'Coordinators':
        return AppColors.warning;
      case 'Admins':
        return AppColors.primary;
      default:
        return Colors.grey;
    }
  }

  void _refreshData() {
    _loadAnalyticsData();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Analytics data refreshed')));
  }

  void _showDetailedChart(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${type.toUpperCase()} Chart'),
        content: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.pie_chart, size: 48, color: Colors.grey),
                const SizedBox(height: 8),
                Text(
                  'Interactive ${type.toUpperCase()} Chart\n(Chart library needed)',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export report feature coming soon')),
    );
  }

  void _scheduleReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Schedule report feature coming soon')),
    );
  }
}
