import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';

class CoordinatorAssignmentsScreen extends ConsumerStatefulWidget {
  const CoordinatorAssignmentsScreen({super.key});

  @override
  ConsumerState<CoordinatorAssignmentsScreen> createState() =>
      _CoordinatorAssignmentsScreenState();
}

class _CoordinatorAssignmentsScreenState
    extends ConsumerState<CoordinatorAssignmentsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'All Assignments';
  String _selectedDepartment = 'All Departments';
  bool _isLoading = false;

  // Mock data - Replace with actual API calls
  final List<Map<String, dynamic>> _assignments = [
    {
      'id': 'ASG_001',
      'facultyId': 'FAC_001',
      'facultyName': 'Dr. Michael Chen',
      'department': 'Computer Science',
      'specialization': 'Deep Learning',
      'email': 'michael.chen@university.edu',
      'phone': '+1-555-0101',
      'totalAssignments': 8,
      'completedAssignments': 6,
      'pendingAssignments': 2,
      'panels': [
        {
          'id': 'PANEL_AI_2024',
          'name': 'AI & Machine Learning Projects',
          'role': 'Chairperson',
          'status': 'active',
        },
        {
          'id': 'PANEL_DS_2024',
          'name': 'Data Science Projects',
          'role': 'Member',
          'status': 'active',
        },
      ],
      'students': [
        {
          'id': 'STD_001',
          'name': 'John Smith',
          'project': 'Deep Learning for Image Recognition',
          'status': 'completed',
        },
        {
          'id': 'STD_002',
          'name': 'Emma Davis',
          'project': 'NLP Chatbot Development',
          'status': 'completed',
        },
        {
          'id': 'STD_003',
          'name': 'Alex Johnson',
          'project': 'Computer Vision for Autonomous Vehicles',
          'status': 'in_progress',
        },
        {
          'id': 'STD_004',
          'name': 'Sarah Wilson',
          'project': 'Machine Learning for Healthcare',
          'status': 'in_progress',
        },
      ],
      'workload': 85, // Percentage
      'availability': 'Available',
      'lastAssigned': '2024-01-15',
      'averageScore': 87.5,
      'totalEvaluations': 42,
      'onTimeSubmissions': 95,
    },
    {
      'id': 'ASG_002',
      'facultyId': 'FAC_002',
      'facultyName': 'Prof. Lisa Wang',
      'department': 'Computer Science',
      'specialization': 'Natural Language Processing',
      'email': 'lisa.wang@university.edu',
      'phone': '+1-555-0102',
      'totalAssignments': 6,
      'completedAssignments': 5,
      'pendingAssignments': 1,
      'panels': [
        {
          'id': 'PANEL_AI_2024',
          'name': 'AI & Machine Learning Projects',
          'role': 'Member',
          'status': 'active',
        },
      ],
      'students': [
        {
          'id': 'STD_005',
          'name': 'Mike Wilson',
          'project': 'Sentiment Analysis Tool',
          'status': 'completed',
        },
        {
          'id': 'STD_006',
          'name': 'Sophie Brown',
          'project': 'Text Summarization System',
          'status': 'in_progress',
        },
      ],
      'workload': 60,
      'availability': 'Available',
      'lastAssigned': '2024-01-10',
      'averageScore': 89.2,
      'totalEvaluations': 28,
      'onTimeSubmissions': 100,
    },
    {
      'id': 'ASG_003',
      'facultyId': 'FAC_003',
      'facultyName': 'Dr. Ahmed Hassan',
      'department': 'Computer Science',
      'specialization': 'Computer Vision',
      'email': 'ahmed.hassan@university.edu',
      'phone': '+1-555-0103',
      'totalAssignments': 10,
      'completedAssignments': 7,
      'pendingAssignments': 3,
      'panels': [
        {
          'id': 'PANEL_AI_2024',
          'name': 'AI & Machine Learning Projects',
          'role': 'Member',
          'status': 'active',
        },
        {
          'id': 'PANEL_CV_2024',
          'name': 'Computer Vision Projects',
          'role': 'Chairperson',
          'status': 'active',
        },
      ],
      'students': [
        {
          'id': 'STD_007',
          'name': 'Ryan Taylor',
          'project': 'Object Detection System',
          'status': 'completed',
        },
        {
          'id': 'STD_008',
          'name': 'Olivia White',
          'project': 'Face Recognition App',
          'status': 'in_progress',
        },
        {
          'id': 'STD_009',
          'name': 'James Anderson',
          'project': 'Medical Image Analysis',
          'status': 'pending',
        },
      ],
      'workload': 95,
      'availability': 'Overloaded',
      'lastAssigned': '2024-01-20',
      'averageScore': 85.8,
      'totalEvaluations': 55,
      'onTimeSubmissions': 92,
    },
    {
      'id': 'ASG_004',
      'facultyId': 'FAC_004',
      'facultyName': 'Dr. Emily Rodriguez',
      'department': 'Information Technology',
      'specialization': 'Web Development',
      'email': 'emily.rodriguez@university.edu',
      'phone': '+1-555-0104',
      'totalAssignments': 4,
      'completedAssignments': 4,
      'pendingAssignments': 0,
      'panels': [
        {
          'id': 'PANEL_WEB_2024',
          'name': 'Web Development & Mobile Apps',
          'role': 'Member',
          'status': 'active',
        },
      ],
      'students': [
        {
          'id': 'STD_010',
          'name': 'Isabella Clark',
          'project': 'E-commerce Platform',
          'status': 'completed',
        },
        {
          'id': 'STD_011',
          'name': 'Noah Martinez',
          'project': 'Social Media Dashboard',
          'status': 'completed',
        },
      ],
      'workload': 40,
      'availability': 'Available',
      'lastAssigned': '2024-01-05',
      'averageScore': 91.3,
      'totalEvaluations': 18,
      'onTimeSubmissions': 100,
    },
    {
      'id': 'ASG_005',
      'facultyId': 'FAC_005',
      'facultyName': 'Prof. David Miller',
      'department': 'Information Technology',
      'specialization': 'Mobile Development',
      'email': 'david.miller@university.edu',
      'phone': '+1-555-0105',
      'totalAssignments': 7,
      'completedAssignments': 5,
      'pendingAssignments': 2,
      'panels': [
        {
          'id': 'PANEL_WEB_2024',
          'name': 'Web Development & Mobile Apps',
          'role': 'Chairperson',
          'status': 'active',
        },
      ],
      'students': [
        {
          'id': 'STD_012',
          'name': 'Liam Garcia',
          'project': 'Cross-Platform Mobile App',
          'status': 'in_progress',
        },
        {
          'id': 'STD_013',
          'name': 'Ava Rodriguez',
          'project': 'AR Shopping Application',
          'status': 'pending',
        },
      ],
      'workload': 70,
      'availability': 'Busy',
      'lastAssigned': '2024-01-18',
      'averageScore': 88.7,
      'totalEvaluations': 32,
      'onTimeSubmissions': 97,
    },
  ];

  List<Map<String, dynamic>> _filteredAssignments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _filteredAssignments = List.from(_assignments);
    _loadAssignments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAssignments() async {
    setState(() => _isLoading = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    _filterAssignments();
  }

  void _filterAssignments() {
    setState(() {
      _filteredAssignments = _assignments.where((assignment) {
        // Search filter
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch =
            searchQuery.isEmpty ||
            assignment['facultyName'].toString().toLowerCase().contains(
              searchQuery,
            ) ||
            assignment['department'].toString().toLowerCase().contains(
              searchQuery,
            ) ||
            assignment['specialization'].toString().toLowerCase().contains(
              searchQuery,
            );

        // Department filter
        final matchesDepartment =
            _selectedDepartment == 'All Departments' ||
            assignment['department'] == _selectedDepartment;

        // Availability filter
        bool matchesFilter = true;
        switch (_selectedFilter) {
          case 'Available':
            matchesFilter = assignment['availability'] == 'Available';
            break;
          case 'Busy':
            matchesFilter = assignment['availability'] == 'Busy';
            break;
          case 'Overloaded':
            matchesFilter = assignment['availability'] == 'Overloaded';
            break;
          case 'All Assignments':
          default:
            matchesFilter = true;
        }

        return matchesSearch && matchesDepartment && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Faculty Assignments'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _showWorkloadAnalytics,
          ),
          IconButton(
            icon: const Icon(Icons.balance),
            onPressed: _showWorkloadBalancer,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          isScrollable: true,
          onTap: (index) {
            switch (index) {
              case 0:
                _selectedFilter = 'All Assignments';
                break;
              case 1:
                _selectedFilter = 'Available';
                break;
              case 2:
                _selectedFilter = 'Busy';
                break;
              case 3:
                _selectedFilter = 'Overloaded';
                break;
            }
            _filterAssignments();
          },
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('All Faculty'),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_assignments.length}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Available'),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_assignments.where((a) => a['availability'] == 'Available').length}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Busy'),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_assignments.where((a) => a['availability'] == 'Busy').length}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Overloaded'),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_assignments.where((a) => a['availability'] == 'Overloaded').length}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: CustomTextField(
              controller: _searchController,
              label: 'Search faculty by name, department, or specialization...',
              prefixIcon: Icons.search,
              onChanged: (_) => _filterAssignments(),
            ),
          ),

          // Overview Stats
          _buildOverviewStats(),

          // Assignments List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadAssignments,
                    child: _filteredAssignments.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredAssignments.length,
                            itemBuilder: (context, index) {
                              final assignment = _filteredAssignments[index];
                              return _buildAssignmentCard(assignment);
                            },
                          ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAssignmentDialog,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.assignment_add),
        label: const Text('New Assignment'),
      ),
    );
  }

  Widget _buildOverviewStats() {
    final totalFaculty = _assignments.length;
    final availableFaculty = _assignments
        .where((a) => a['availability'] == 'Available')
        .length;
    final busyFaculty = _assignments
        .where((a) => a['availability'] == 'Busy')
        .length;
    final overloadedFaculty = _assignments
        .where((a) => a['availability'] == 'Overloaded')
        .length;
    final averageWorkload =
        _assignments.fold<double>(0, (sum, a) => sum + a['workload']) /
        totalFaculty;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Available',
              '$availableFaculty',
              AppColors.success,
            ),
          ),
          Expanded(
            child: _buildStatItem('Busy', '$busyFaculty', AppColors.warning),
          ),
          Expanded(
            child: _buildStatItem(
              'Overloaded',
              '$overloadedFaculty',
              AppColors.error,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              'Avg Workload',
              '${averageWorkload.toStringAsFixed(0)}%',
              AppColors.info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No assignments found',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Create new faculty assignments to get started.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Create Assignment',
              onPressed: _showAssignmentDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> assignment) {
    final workloadColor = _getWorkloadColor(assignment['workload']);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showAssignmentDetails(assignment),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      assignment['facultyName']
                          .toString()
                          .split(' ')
                          .map((n) => n[0])
                          .join('')
                          .toUpperCase(),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assignment['facultyName'],
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          assignment['specialization'],
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        Text(
                          assignment['department'],
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      _buildAvailabilityBadge(assignment['availability']),
                      const SizedBox(height: 4),
                      Text(
                        assignment['id'],
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Workload Progress
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Workload',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${assignment['workload']}% capacity',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: workloadColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: assignment['workload'] / 100,
                    backgroundColor: AppColors.textSecondary.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(workloadColor),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Assignment Stats
              Row(
                children: [
                  Expanded(
                    child: _buildAssignmentStat(
                      'Total',
                      '${assignment['totalAssignments']}',
                      AppColors.primary,
                      Icons.assignment,
                    ),
                  ),
                  Expanded(
                    child: _buildAssignmentStat(
                      'Completed',
                      '${assignment['completedAssignments']}',
                      AppColors.success,
                      Icons.check_circle,
                    ),
                  ),
                  Expanded(
                    child: _buildAssignmentStat(
                      'Pending',
                      '${assignment['pendingAssignments']}',
                      AppColors.warning,
                      Icons.pending,
                    ),
                  ),
                  Expanded(
                    child: _buildAssignmentStat(
                      'Avg Score',
                      '${assignment['averageScore'].toStringAsFixed(1)}',
                      AppColors.info,
                      Icons.star,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Panels and Contact Info
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Active Panels (${(assignment['panels'] as List).length})',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: (assignment['panels'] as List).map((panel) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: panel['role'] == 'Chairperson'
                                    ? AppColors.primary.withOpacity(0.1)
                                    : AppColors.info.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    panel['role'] == 'Chairperson'
                                        ? Icons.star
                                        : Icons.group,
                                    size: 10,
                                    color: panel['role'] == 'Chairperson'
                                        ? AppColors.primary
                                        : AppColors.info,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    panel['role'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: panel['role'] == 'Chairperson'
                                          ? AppColors.primary
                                          : AppColors.info,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Last Assigned',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        assignment['lastAssigned'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${assignment['onTimeSubmissions']}% on-time',
                        style: TextStyle(
                          fontSize: 10,
                          color: assignment['onTimeSubmissions'] >= 95
                              ? AppColors.success
                              : assignment['onTimeSubmissions'] >= 80
                              ? AppColors.warning
                              : AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _assignToPanel(assignment),
                    icon: const Icon(Icons.add_circle, size: 16),
                    label: const Text('Assign'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _viewWorkload(assignment),
                    icon: const Icon(Icons.analytics, size: 16),
                    label: const Text('Workload'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.info,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _showAssignmentDetails(assignment),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('Details'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvailabilityBadge(String availability) {
    final color = _getAvailabilityColor(availability);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        availability.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAssignmentStat(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getWorkloadColor(int workload) {
    if (workload >= 90) return AppColors.error;
    if (workload >= 70) return AppColors.warning;
    return AppColors.success;
  }

  Color _getAvailabilityColor(String availability) {
    switch (availability) {
      case 'Available':
        return AppColors.success;
      case 'Busy':
        return AppColors.warning;
      case 'Overloaded':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
              'Filter Faculty Assignments',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Text(
              'Filter by Availability',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ['All Assignments', 'Available', 'Busy', 'Overloaded']
                  .map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      checkmarkColor: AppColors.primary,
                      onSelected: (selected) {
                        setState(() => _selectedFilter = filter);
                      },
                    );
                  })
                  .toList(),
            ),

            const SizedBox(height: 20),

            Text(
              'Filter by Department',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children:
                  [
                    'All Departments',
                    'Computer Science',
                    'Information Technology',
                    'Electronics Engineering',
                  ].map((dept) {
                    final isSelected = _selectedDepartment == dept;
                    return FilterChip(
                      label: Text(dept),
                      selected: isSelected,
                      selectedColor: AppColors.info.withOpacity(0.2),
                      checkmarkColor: AppColors.info,
                      onSelected: (selected) {
                        setState(() => _selectedDepartment = dept);
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 20),
            CustomButton(
              text: 'Apply Filters',
              onPressed: () {
                Navigator.pop(context);
                _filterAssignments();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAssignmentDetails(Map<String, dynamic> assignment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      assignment['facultyName'],
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Detailed assignment information would go here
              Text('Assignment details coming soon...'),
            ],
          ),
        ),
      ),
    );
  }

  void _showAssignmentDialog() {
    // TODO: Implement assignment creation dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Assignment creation feature coming soon')),
    );
  }

  void _assignToPanel(Map<String, dynamic> assignment) {
    // TODO: Implement panel assignment
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Assign ${assignment['facultyName']} to panel feature coming soon',
        ),
      ),
    );
  }

  void _viewWorkload(Map<String, dynamic> assignment) {
    // TODO: Show detailed workload view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Workload details for ${assignment['facultyName']} coming soon',
        ),
      ),
    );
  }

  void _showWorkloadAnalytics() {
    // TODO: Navigate to workload analytics screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workload analytics feature coming soon')),
    );
  }

  void _showWorkloadBalancer() {
    // TODO: Navigate to workload balancer tool
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workload balancer feature coming soon')),
    );
  }
}
