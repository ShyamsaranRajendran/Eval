import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/colors.dart';

class SystemReportsScreen extends ConsumerStatefulWidget {
  const SystemReportsScreen({super.key});

  @override
  ConsumerState<SystemReportsScreen> createState() =>
      _SystemReportsScreenState();
}

class _SystemReportsScreenState extends ConsumerState<SystemReportsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  Map<String, dynamic> _reportData = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadReportData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadReportData() async {
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 1));

      // Mock data for demonstration
      _reportData = {
        'userStats': {
          'totalUsers': 45,
          'activeUsers': 42,
          'inactiveUsers': 3,
          'adminCount': 2,
          'coordinatorCount': 8,
          'facultyCount': 35,
          'newUsersThisMonth': 5,
          'loginActivity': [12, 15, 18, 22, 19, 25, 28], // Last 7 days
        },
        'projectStats': {
          'totalProjects': 23,
          'activeProjects': 18,
          'completedProjects': 5,
          'pendingReviews': 12,
          'averageScore': 7.8,
          'projectsByDepartment': {
            'Computer Science': 12,
            'Information Technology': 8,
            'Electronics': 3,
          },
          'completionRate': [65, 72, 78, 81, 85], // Last 5 months
        },
        'evaluationStats': {
          'totalEvaluations': 156,
          'pendingEvaluations': 23,
          'completedEvaluations': 133,
          'averageEvaluationTime': 2.5, // hours
          'evaluationsByPhase': {
            'Proposal': 45,
            'Mid-term': 38,
            'Final': 50,
            'Defense': 23,
          },
          'evaluatorWorkload': [8, 12, 15, 10, 6], // Evaluations per faculty
        },
        'systemHealth': {
          'uptime': 99.8,
          'averageResponseTime': 245, // milliseconds
          'errorRate': 0.02,
          'activeConnections': 18,
          'storageUsed': 67.3, // percentage
          'backupStatus': 'healthy',
        },
      };
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Reports & Analytics'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.folder), text: 'Projects'),
            Tab(icon: Icon(Icons.assessment), text: 'Evaluations'),
            Tab(icon: Icon(Icons.monitor_heart), text: 'System'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadReportData,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReports,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildUserReports(),
                _buildProjectReports(),
                _buildEvaluationReports(),
                _buildSystemHealthReports(),
              ],
            ),
    );
  }

  Widget _buildUserReports() {
    final userStats = _reportData['userStats'] ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Overview Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                'Total Users',
                '${userStats['totalUsers'] ?? 0}',
                Icons.people,
                AppColors.primary,
              ),
              _buildStatCard(
                'Active Users',
                '${userStats['activeUsers'] ?? 0}',
                Icons.check_circle,
                AppColors.success,
              ),
              _buildStatCard(
                'Coordinators',
                '${userStats['coordinatorCount'] ?? 0}',
                Icons.supervisor_account,
                AppColors.warning,
              ),
              _buildStatCard(
                'Faculty Members',
                '${userStats['facultyCount'] ?? 0}',
                Icons.school,
                AppColors.info,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // User Role Distribution
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Role Distribution',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: (userStats['adminCount'] ?? 0).toDouble(),
                            title: 'Admin\n${userStats['adminCount'] ?? 0}',
                            color: AppColors.error,
                            radius: 80,
                          ),
                          PieChartSectionData(
                            value: (userStats['coordinatorCount'] ?? 0)
                                .toDouble(),
                            title:
                                'Coord.\n${userStats['coordinatorCount'] ?? 0}',
                            color: AppColors.warning,
                            radius: 80,
                          ),
                          PieChartSectionData(
                            value: (userStats['facultyCount'] ?? 0).toDouble(),
                            title: 'Faculty\n${userStats['facultyCount'] ?? 0}',
                            color: AppColors.info,
                            radius: 80,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Login Activity Chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login Activity (Last 7 Days)',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) => Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const days = [
                                  'Mon',
                                  'Tue',
                                  'Wed',
                                  'Thu',
                                  'Fri',
                                  'Sat',
                                  'Sun',
                                ];
                                if (value.toInt() >= 0 &&
                                    value.toInt() < days.length) {
                                  return Text(
                                    days[value.toInt()],
                                    style: const TextStyle(fontSize: 12),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(),
                          topTitles: const AxisTitles(),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots:
                                (userStats['loginActivity'] as List<dynamic>?)
                                    ?.asMap()
                                    .entries
                                    .map(
                                      (e) => FlSpot(
                                        e.key.toDouble(),
                                        e.value.toDouble(),
                                      ),
                                    )
                                    .toList() ??
                                [],
                            isCurved: true,
                            color: AppColors.primary,
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
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

  Widget _buildProjectReports() {
    final projectStats = _reportData['projectStats'] ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Overview Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                'Total Projects',
                '${projectStats['totalProjects'] ?? 0}',
                Icons.folder,
                AppColors.primary,
              ),
              _buildStatCard(
                'Active Projects',
                '${projectStats['activeProjects'] ?? 0}',
                Icons.folder_open,
                AppColors.success,
              ),
              _buildStatCard(
                'Completed',
                '${projectStats['completedProjects'] ?? 0}',
                Icons.check_circle,
                AppColors.info,
              ),
              _buildStatCard(
                'Avg. Score',
                '${projectStats['averageScore'] ?? 0}',
                Icons.star,
                AppColors.warning,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Projects by Department
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Projects by Department',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...((projectStats['projectsByDepartment']
                              as Map<String, dynamic>?) ??
                          {})
                      .entries
                      .map(
                        (entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(child: Text(entry.key)),
                              Container(
                                width: 100,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor:
                                      entry.value / 15, // Assuming max 15
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${entry.value}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Project Completion Trend
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Completion Rate Trend (%)',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 100,
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final months = [
                                  'Jan',
                                  'Feb',
                                  'Mar',
                                  'Apr',
                                  'May',
                                ];
                                if (value.toInt() >= 0 &&
                                    value.toInt() < months.length) {
                                  return Text(months[value.toInt()]);
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) =>
                                  Text('${value.toInt()}%'),
                            ),
                          ),
                          rightTitles: const AxisTitles(),
                          topTitles: const AxisTitles(),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups:
                            (projectStats['completionRate'] as List<dynamic>?)
                                ?.asMap()
                                .entries
                                .map(
                                  (e) => BarChartGroupData(
                                    x: e.key,
                                    barRods: [
                                      BarChartRodData(
                                        toY: e.value.toDouble(),
                                        color: AppColors.success,
                                        width: 20,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(4),
                                            ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList() ??
                            [],
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

  Widget _buildEvaluationReports() {
    final evalStats = _reportData['evaluationStats'] ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Evaluation Overview Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                'Total Evaluations',
                '${evalStats['totalEvaluations'] ?? 0}',
                Icons.assessment,
                AppColors.primary,
              ),
              _buildStatCard(
                'Pending',
                '${evalStats['pendingEvaluations'] ?? 0}',
                Icons.pending,
                AppColors.warning,
              ),
              _buildStatCard(
                'Completed',
                '${evalStats['completedEvaluations'] ?? 0}',
                Icons.done_all,
                AppColors.success,
              ),
              _buildStatCard(
                'Avg. Time',
                '${evalStats['averageEvaluationTime'] ?? 0}h',
                Icons.timer,
                AppColors.info,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Evaluations by Phase
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Evaluations by Phase',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections:
                            ((evalStats['evaluationsByPhase']
                                        as Map<String, dynamic>?) ??
                                    {})
                                .entries
                                .map(
                                  (entry) => PieChartSectionData(
                                    value: entry.value.toDouble(),
                                    title: '${entry.key}\n${entry.value}',
                                    color: _getPhaseColor(entry.key),
                                    radius: 80,
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Evaluator Workload Distribution
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Evaluator Workload Distribution',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) =>
                                  Text('F${value.toInt() + 1}'),
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) =>
                                  Text('${value.toInt()}'),
                            ),
                          ),
                          rightTitles: const AxisTitles(),
                          topTitles: const AxisTitles(),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups:
                            (evalStats['evaluatorWorkload'] as List<dynamic>?)
                                ?.asMap()
                                .entries
                                .map(
                                  (e) => BarChartGroupData(
                                    x: e.key,
                                    barRods: [
                                      BarChartRodData(
                                        toY: e.value.toDouble(),
                                        color: AppColors.info,
                                        width: 20,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(4),
                                            ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList() ??
                            [],
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

  Widget _buildSystemHealthReports() {
    final systemHealth = _reportData['systemHealth'] ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // System Health Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                'Uptime',
                '${systemHealth['uptime'] ?? 0}%',
                Icons.trending_up,
                AppColors.success,
              ),
              _buildStatCard(
                'Response Time',
                '${systemHealth['averageResponseTime'] ?? 0}ms',
                Icons.speed,
                AppColors.info,
              ),
              _buildStatCard(
                'Error Rate',
                '${systemHealth['errorRate'] ?? 0}%',
                Icons.error_outline,
                AppColors.warning,
              ),
              _buildStatCard(
                'Active Users',
                '${systemHealth['activeConnections'] ?? 0}',
                Icons.people,
                AppColors.primary,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Storage Usage
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Storage Usage',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: (systemHealth['storageUsed'] ?? 0) / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      (systemHealth['storageUsed'] ?? 0) > 80
                          ? AppColors.error
                          : (systemHealth['storageUsed'] ?? 0) > 60
                          ? AppColors.warning
                          : AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${systemHealth['storageUsed'] ?? 0}% of total storage used',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // System Status
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Status',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatusRow('Database', 'Online', AppColors.success),
                  _buildStatusRow('API Server', 'Online', AppColors.success),
                  _buildStatusRow('File Storage', 'Online', AppColors.success),
                  _buildStatusRow('Email Service', 'Online', AppColors.success),
                  _buildStatusRow(
                    'Backup System',
                    systemHealth['backupStatus'] == 'healthy'
                        ? 'Healthy'
                        : 'Warning',
                    systemHealth['backupStatus'] == 'healthy'
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quick Actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Maintenance',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _runBackup,
                          icon: const Icon(Icons.backup),
                          label: const Text('Run Backup'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _clearCache,
                          icon: const Icon(Icons.clear_all),
                          label: const Text('Clear Cache'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _buildStatusRow(String service, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(service),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPhaseColor(String phase) {
    switch (phase) {
      case 'Proposal':
        return AppColors.primary;
      case 'Mid-term':
        return AppColors.warning;
      case 'Final':
        return AppColors.success;
      case 'Defense':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  void _exportReports() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Reports'),
        content: const Text('Select the format for exporting reports:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performExport('PDF');
            },
            child: const Text('Export as PDF'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performExport('Excel');
            },
            child: const Text('Export as Excel'),
          ),
        ],
      ),
    );
  }

  void _performExport(String format) {
    // TODO: Implement actual export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reports exported as $format'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _runBackup() {
    // TODO: Implement backup functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('System backup initiated'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _clearCache() {
    // TODO: Implement cache clearing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('System cache cleared'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
