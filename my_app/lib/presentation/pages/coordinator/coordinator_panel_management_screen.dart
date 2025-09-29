import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';

class CoordinatorPanelManagementScreen extends ConsumerStatefulWidget {
  const CoordinatorPanelManagementScreen({super.key});

  @override
  ConsumerState<CoordinatorPanelManagementScreen> createState() =>
      _CoordinatorPanelManagementScreenState();
}

class _CoordinatorPanelManagementScreenState
    extends ConsumerState<CoordinatorPanelManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'All Panels';
  bool _isLoading = false;

  // Mock data - Replace with actual API calls
  final List<Map<String, dynamic>> _panels = [
    {
      'id': 'PANEL_AI_2024',
      'name': 'AI & Machine Learning Projects',
      'description':
          'Panel for artificial intelligence and machine learning final year projects',
      'coordinator': 'Dr. Sarah Johnson',
      'department': 'Computer Science',
      'semester': 'Fall 2024',
      'status': 'active',
      'facultyMembers': [
        {
          'id': 'FAC_001',
          'name': 'Dr. Michael Chen',
          'specialization': 'Deep Learning',
          'isChairperson': true,
        },
        {
          'id': 'FAC_002',
          'name': 'Prof. Lisa Wang',
          'specialization': 'Natural Language Processing',
          'isChairperson': false,
        },
        {
          'id': 'FAC_003',
          'name': 'Dr. Ahmed Hassan',
          'specialization': 'Computer Vision',
          'isChairperson': false,
        },
        {
          'id': 'FAC_004',
          'name': 'Dr. Emily Rodriguez',
          'specialization': 'Machine Learning',
          'isChairperson': false,
        },
      ],
      'students': [
        {
          'id': 'STD_001',
          'name': 'John Smith',
          'project': 'Deep Learning for Image Recognition',
          'status': 'in_progress',
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
      ],
      'createdDate': '2024-08-15',
      'evaluationStart': '2024-01-15',
      'evaluationEnd': '2024-01-25',
      'completedEvaluations': 8,
      'totalEvaluations': 12,
      'averageScore': 82.5,
    },
    {
      'id': 'PANEL_WEB_2024',
      'name': 'Web Development & Mobile Apps',
      'description':
          'Panel for web development and mobile application projects',
      'coordinator': 'Prof. David Miller',
      'department': 'Information Technology',
      'semester': 'Fall 2024',
      'status': 'active',
      'facultyMembers': [
        {
          'id': 'FAC_005',
          'name': 'Prof. David Miller',
          'specialization': 'Web Development',
          'isChairperson': true,
        },
        {
          'id': 'FAC_006',
          'name': 'Dr. Jennifer Lee',
          'specialization': 'Mobile Development',
          'isChairperson': false,
        },
        {
          'id': 'FAC_007',
          'name': 'Mr. Carlos Martinez',
          'specialization': 'UI/UX Design',
          'isChairperson': false,
        },
      ],
      'students': [
        {
          'id': 'STD_004',
          'name': 'Mike Wilson',
          'project': 'E-commerce Platform with React',
          'status': 'in_progress',
        },
        {
          'id': 'STD_005',
          'name': 'Sophie Brown',
          'project': 'Social Media Analytics Dashboard',
          'status': 'completed',
        },
        {
          'id': 'STD_006',
          'name': 'Ryan Taylor',
          'project': 'Mobile Banking Application',
          'status': 'in_progress',
        },
        {
          'id': 'STD_007',
          'name': 'Olivia White',
          'project': 'Real-time Chat Application',
          'status': 'completed',
        },
      ],
      'createdDate': '2024-08-20',
      'evaluationStart': '2024-01-20',
      'evaluationEnd': '2024-01-30',
      'completedEvaluations': 15,
      'totalEvaluations': 20,
      'averageScore': 78.3,
    },
    {
      'id': 'PANEL_IOT_2024',
      'name': 'IoT & Embedded Systems',
      'description':
          'Panel for Internet of Things and embedded systems projects',
      'coordinator': 'Dr. Robert Johnson',
      'department': 'Electronics Engineering',
      'semester': 'Fall 2024',
      'status': 'draft',
      'facultyMembers': [
        {
          'id': 'FAC_008',
          'name': 'Dr. Robert Johnson',
          'specialization': 'Embedded Systems',
          'isChairperson': true,
        },
        {
          'id': 'FAC_009',
          'name': 'Prof. Maria Garcia',
          'specialization': 'IoT Architecture',
          'isChairperson': false,
        },
      ],
      'students': [
        {
          'id': 'STD_008',
          'name': 'James Anderson',
          'project': 'Smart Home Security System',
          'status': 'pending',
        },
        {
          'id': 'STD_009',
          'name': 'Isabella Clark',
          'project': 'Industrial IoT Monitoring',
          'status': 'pending',
        },
      ],
      'createdDate': '2024-09-01',
      'evaluationStart': '2024-02-01',
      'evaluationEnd': '2024-02-10',
      'completedEvaluations': 0,
      'totalEvaluations': 8,
      'averageScore': 0.0,
    },
  ];

  List<Map<String, dynamic>> _filteredPanels = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredPanels = List.from(_panels);
    _loadPanels();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPanels() async {
    setState(() => _isLoading = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    _filterPanels();
  }

  void _filterPanels() {
    setState(() {
      _filteredPanels = _panels.where((panel) {
        // Search filter
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch =
            searchQuery.isEmpty ||
            panel['name'].toString().toLowerCase().contains(searchQuery) ||
            panel['department'].toString().toLowerCase().contains(
              searchQuery,
            ) ||
            panel['coordinator'].toString().toLowerCase().contains(searchQuery);

        // Status filter
        bool matchesFilter = true;
        switch (_selectedFilter) {
          case 'Active':
            matchesFilter = panel['status'] == 'active';
            break;
          case 'Draft':
            matchesFilter = panel['status'] == 'draft';
            break;
          case 'Completed':
            matchesFilter = panel['status'] == 'completed';
            break;
          case 'All Panels':
          default:
            matchesFilter = true;
        }

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Panel Management'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _showPanelAnalytics,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          onTap: (index) {
            switch (index) {
              case 0:
                _selectedFilter = 'All Panels';
                break;
              case 1:
                _selectedFilter = 'Active';
                break;
              case 2:
                _selectedFilter = 'Draft';
                break;
            }
            _filterPanels();
          },
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('All'),
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
                      '${_panels.length}',
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
                  const Text('Active'),
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
                      '${_panels.where((p) => p['status'] == 'active').length}',
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
                  const Text('Draft'),
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
                      '${_panels.where((p) => p['status'] == 'draft').length}',
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
              label: 'Search panels by name, department, or coordinator...',
              prefixIcon: Icons.search,
              onChanged: (_) => _filterPanels(),
            ),
          ),

          // Overview Stats
          _buildOverviewStats(),

          // Panels List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadPanels,
                    child: _filteredPanels.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredPanels.length,
                            itemBuilder: (context, index) {
                              final panel = _filteredPanels[index];
                              return _buildPanelCard(panel);
                            },
                          ),
                  ),
          ),
        ],
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

  Widget _buildOverviewStats() {
    final activePanels = _panels.where((p) => p['status'] == 'active').length;
    final draftPanels = _panels.where((p) => p['status'] == 'draft').length;
    final totalFaculty = _panels.fold<int>(
      0,
      (sum, panel) => sum + (panel['facultyMembers'] as List).length,
    );
    final totalStudents = _panels.fold<int>(
      0,
      (sum, panel) => sum + (panel['students'] as List).length,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Active Panels',
              '$activePanels',
              AppColors.success,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              'Draft Panels',
              '$draftPanels',
              AppColors.warning,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              'Total Faculty',
              '$totalFaculty',
              AppColors.info,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              'Total Students',
              '$totalStudents',
              AppColors.primary,
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
              Icons.dashboard_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No panels found',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first evaluation panel to get started.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(text: 'Create Panel', onPressed: _createNewPanel),
          ],
        ),
      ),
    );
  }

  Widget _buildPanelCard(Map<String, dynamic> panel) {
    final statusColor = _getStatusColor(panel['status']);
    final progress = panel['completedEvaluations'] / panel['totalEvaluations'];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showPanelDetails(panel),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          panel['name'],
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          panel['description'],
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Coordinator: ${panel['coordinator']}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      _buildStatusBadge(panel['status']),
                      const SizedBox(height: 8),
                      Text(
                        panel['id'],
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

              // Progress Section (only for active panels)
              if (panel['status'] == 'active') ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Evaluation Progress',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${panel['completedEvaluations']}/${panel['totalEvaluations']} completed',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.textSecondary.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    ),
                    const SizedBox(height: 8),
                    if (panel['averageScore'] > 0)
                      Text(
                        'Average Score: ${panel['averageScore'].toStringAsFixed(1)}/100',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Stats Row
              Row(
                children: [
                  _buildInfoChip(
                    Icons.people,
                    '${(panel['facultyMembers'] as List).length} Faculty',
                    AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    Icons.school,
                    '${(panel['students'] as List).length} Students',
                    AppColors.info,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    Icons.business,
                    panel['department'],
                    AppColors.success,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Evaluation Timeline
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Evaluation: ${panel['evaluationStart']} - ${panel['evaluationEnd']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    panel['semester'],
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (panel['status'] == 'draft') ...[
                    TextButton.icon(
                      onPressed: () => _activatePanel(panel),
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: const Text('Activate'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  TextButton.icon(
                    onPressed: () => _editPanel(panel),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _showPanelDetails(panel),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('Details'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
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

  Widget _buildStatusBadge(String status) {
    final statusColor = _getStatusColor(status);
    String statusText;

    switch (status) {
      case 'active':
        statusText = 'ACTIVE';
        break;
      case 'draft':
        statusText = 'DRAFT';
        break;
      case 'completed':
        statusText = 'COMPLETED';
        break;
      default:
        statusText = 'UNKNOWN';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return AppColors.success;
      case 'draft':
        return AppColors.warning;
      case 'completed':
        return AppColors.info;
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
              'Filter Panels',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Filter by Status',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ['All Panels', 'Active', 'Draft', 'Completed'].map((
                filter,
              ) {
                final isSelected = _selectedFilter == filter;
                return FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  checkmarkColor: AppColors.primary,
                  onSelected: (selected) {
                    setState(() => _selectedFilter = filter);
                    Navigator.pop(context);
                    _filterPanels();
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Apply Filters',
              onPressed: () {
                Navigator.pop(context);
                _filterPanels();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPanelDetails(Map<String, dynamic> panel) {
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
                      panel['name'],
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

              // Panel Details
              _buildDetailRow('Panel ID', panel['id']),
              _buildDetailRow('Description', panel['description']),
              _buildDetailRow('Coordinator', panel['coordinator']),
              _buildDetailRow('Department', panel['department']),
              _buildDetailRow('Semester', panel['semester']),
              _buildDetailRow(
                'Status',
                panel['status'].toString().toUpperCase(),
              ),
              _buildDetailRow('Created Date', panel['createdDate']),

              const SizedBox(height: 20),

              // Faculty Members
              Text(
                'Faculty Members (${(panel['facultyMembers'] as List).length})',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              ...(panel['facultyMembers'] as List)
                  .map((faculty) => _buildFacultyItem(faculty))
                  .toList(),

              const SizedBox(height: 20),

              // Students
              Text(
                'Students (${(panel['students'] as List).length})',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: (panel['students'] as List).length,
                  itemBuilder: (context, index) {
                    final student = (panel['students'] as List)[index];
                    return _buildStudentItem(student);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacultyItem(Map<String, dynamic> faculty) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: faculty['isChairperson']
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.textSecondary.withOpacity(0.1),
          child: Icon(
            faculty['isChairperson'] ? Icons.star : Icons.person,
            color: faculty['isChairperson']
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                faculty['name'],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            if (faculty['isChairperson'])
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'CHAIRPERSON',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Text(faculty['specialization']),
      ),
    );
  }

  Widget _buildStudentItem(Map<String, dynamic> student) {
    Color statusColor;
    switch (student['status']) {
      case 'completed':
        statusColor = AppColors.success;
        break;
      case 'in_progress':
        statusColor = AppColors.info;
        break;
      case 'pending':
      default:
        statusColor = AppColors.warning;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(
            student['status'] == 'completed'
                ? Icons.check_circle
                : student['status'] == 'in_progress'
                ? Icons.pending
                : Icons.hourglass_empty,
            color: statusColor,
          ),
        ),
        title: Text(
          student['name'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(student['project']),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            student['status'].toString().toUpperCase(),
            style: TextStyle(
              color: statusColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _createNewPanel() {
    // TODO: Navigate to create panel screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create new panel feature coming soon')),
    );
  }

  void _editPanel(Map<String, dynamic> panel) {
    // TODO: Navigate to edit panel screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit panel ${panel['name']} feature coming soon'),
      ),
    );
  }

  void _activatePanel(Map<String, dynamic> panel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activate Panel'),
        content: Text(
          'Are you sure you want to activate the panel "${panel['name']}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                panel['status'] = 'active';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Panel "${panel['name']}" activated successfully',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Activate'),
          ),
        ],
      ),
    );
  }

  void _showPanelAnalytics() {
    // TODO: Navigate to panel analytics screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Panel analytics feature coming soon')),
    );
  }
}
