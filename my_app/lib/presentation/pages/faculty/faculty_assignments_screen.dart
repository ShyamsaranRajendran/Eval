import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';

class FacultyAssignmentsScreen extends ConsumerStatefulWidget {
  const FacultyAssignmentsScreen({super.key});

  @override
  ConsumerState<FacultyAssignmentsScreen> createState() =>
      _FacultyAssignmentsScreenState();
}

class _FacultyAssignmentsScreenState
    extends ConsumerState<FacultyAssignmentsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'All';
  String _selectedSort = 'Date';
  bool _isLoading = false;

  // Mock data - Replace with actual API calls
  final List<Map<String, dynamic>> _assignments = [
    {
      'id': 'ASSIGN_001',
      'panelId': 'PANEL_001',
      'panelName': 'AI & Machine Learning Projects',
      'studentCount': 8,
      'evaluatedCount': 5,
      'pendingCount': 3,
      'deadline': '2024-01-20',
      'status': 'active',
      'priority': 'high',
      'coordinator': 'Dr. Sarah Wilson',
      'students': [
        {
          'id': 'STD_001',
          'name': 'John Smith',
          'projectTitle': 'Deep Learning for Image Recognition',
          'evaluationDate': '2024-01-15',
          'status': 'pending',
          'score': null,
        },
        {
          'id': 'STD_002',
          'name': 'Emma Davis',
          'projectTitle': 'NLP Chatbot Development',
          'evaluationDate': '2024-01-14',
          'status': 'completed',
          'score': 92,
        },
      ],
    },
    {
      'id': 'ASSIGN_002',
      'panelId': 'PANEL_002',
      'panelName': 'Web Development Capstone',
      'studentCount': 12,
      'evaluatedCount': 10,
      'pendingCount': 2,
      'deadline': '2024-01-25',
      'status': 'active',
      'priority': 'medium',
      'coordinator': 'Prof. Michael Johnson',
      'students': [
        {
          'id': 'STD_003',
          'name': 'Mike Wilson',
          'projectTitle': 'E-commerce Platform with React',
          'evaluationDate': '2024-01-16',
          'status': 'pending',
          'score': null,
        },
      ],
    },
  ];

  List<Map<String, dynamic>> _filteredAssignments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
  }

  void _filterAssignments() {
    setState(() {
      _filteredAssignments = _assignments.where((assignment) {
        // Search filter
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch =
            searchQuery.isEmpty ||
            assignment['panelName'].toString().toLowerCase().contains(
              searchQuery,
            ) ||
            assignment['coordinator'].toString().toLowerCase().contains(
              searchQuery,
            );

        // Status filter
        bool matchesFilter = true;
        switch (_selectedFilter) {
          case 'Pending':
            matchesFilter = assignment['pendingCount'] > 0;
            break;
          case 'Completed':
            matchesFilter = assignment['status'] == 'completed';
            break;
          case 'High Priority':
            matchesFilter = assignment['priority'] == 'high';
            break;
          case 'All':
          default:
            matchesFilter = true;
        }

        return matchesSearch && matchesFilter;
      }).toList();

      // Sort assignments
      switch (_selectedSort) {
        case 'Date':
          _filteredAssignments.sort(
            (a, b) => a['deadline'].compareTo(b['deadline']),
          );
          break;
        case 'Priority':
          final priorityOrder = {'high': 3, 'medium': 2, 'low': 1};
          _filteredAssignments.sort(
            (a, b) => (priorityOrder[b['priority']] ?? 0).compareTo(
              priorityOrder[a['priority']] ?? 0,
            ),
          );
          break;
        case 'Students':
          _filteredAssignments.sort(
            (a, b) => b['studentCount'].compareTo(a['studentCount']),
          );
          break;
        case 'Progress':
          _filteredAssignments.sort((a, b) {
            final progressA = a['evaluatedCount'] / a['studentCount'];
            final progressB = b['evaluatedCount'] / b['studentCount'];
            return progressB.compareTo(progressA);
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Assignments'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
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
                _selectedFilter = 'All';
                break;
              case 1:
                _selectedFilter = 'Pending';
                break;
              case 2:
                _selectedFilter = 'Completed';
                break;
            }
            _filterAssignments();
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
                  const Text('Pending'),
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
                      '${_assignments.where((a) => a['pendingCount'] > 0).length}',
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
                  const Text('Completed'),
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
                      '${_assignments.where((a) => a['status'] == 'completed').length}',
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
          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _searchController,
                    label: 'Search assignments...',
                    prefixIcon: Icons.search,
                    onChanged: (_) => _filterAssignments(),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.textSecondary.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.sort),
                    onSelected: (value) {
                      setState(() => _selectedSort = value);
                      _filterAssignments();
                    },
                    itemBuilder: (context) =>
                        ['Date', 'Priority', 'Students', 'Progress']
                            .map(
                              (sort) => PopupMenuItem(
                                value: sort,
                                child: Row(
                                  children: [
                                    if (_selectedSort == sort)
                                      const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                    if (_selectedSort == sort)
                                      const SizedBox(width: 8),
                                    Text(sort),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),

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
        onPressed: _showEvaluationCalendar,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.calendar_today),
        label: const Text('Schedule'),
      ),
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
              'Try adjusting your filters or check back later for new assignments.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> assignment) {
    final progress = assignment['evaluatedCount'] / assignment['studentCount'];

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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assignment['panelName'],
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Coordinator: ${assignment['coordinator']}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  _buildPriorityBadge(assignment['priority']),
                ],
              ),

              const SizedBox(height: 16),

              // Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${assignment['evaluatedCount']}/${assignment['studentCount']} completed',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.textSecondary.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress == 1.0 ? AppColors.success : AppColors.info,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Stats Row
              Row(
                children: [
                  _buildStatChip(
                    Icons.people,
                    '${assignment['studentCount']} Students',
                    AppColors.info,
                  ),
                  const SizedBox(width: 8),
                  if (assignment['pendingCount'] > 0)
                    _buildStatChip(
                      Icons.pending,
                      '${assignment['pendingCount']} Pending',
                      AppColors.warning,
                    ),
                  if (assignment['pendingCount'] > 0) const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatChip(
                      Icons.calendar_today,
                      'Due ${assignment['deadline']}',
                      _isDeadlineNear(assignment['deadline'])
                          ? AppColors.error
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (assignment['pendingCount'] > 0) ...[
                    TextButton.icon(
                      onPressed: () => _startEvaluation(assignment),
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: const Text('Start'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  TextButton.icon(
                    onPressed: () => _showAssignmentDetails(assignment),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('Details'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.info,
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

  Widget _buildPriorityBadge(String priority) {
    Color color;
    switch (priority) {
      case 'high':
        color = AppColors.error;
        break;
      case 'medium':
        color = AppColors.warning;
        break;
      case 'low':
      default:
        color = AppColors.success;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text, Color color) {
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
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  bool _isDeadlineNear(String deadline) {
    final deadlineDate = DateTime.parse(deadline);
    final now = DateTime.now();
    final difference = deadlineDate.difference(now).inDays;
    return difference <= 3;
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
              'Filter & Sort',
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
              children: ['All', 'Pending', 'Completed', 'High Priority'].map((
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
                    _filterAssignments();
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
                      assignment['panelName'],
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

              // Assignment Info
              _buildInfoRow('Panel ID', assignment['panelId']),
              _buildInfoRow('Coordinator', assignment['coordinator']),
              _buildInfoRow('Deadline', assignment['deadline']),
              _buildInfoRow(
                'Priority',
                assignment['priority'].toString().toUpperCase(),
              ),

              const SizedBox(height: 20),

              // Students List
              Text(
                'Students (${assignment['students'].length})',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: assignment['students'].length,
                  itemBuilder: (context, index) {
                    final student = assignment['students'][index];
                    return _buildStudentTile(student);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
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

  Widget _buildStudentTile(Map<String, dynamic> student) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: student['status'] == 'completed'
              ? AppColors.success.withOpacity(0.1)
              : AppColors.warning.withOpacity(0.1),
          child: Icon(
            student['status'] == 'completed' ? Icons.check : Icons.pending,
            color: student['status'] == 'completed'
                ? AppColors.success
                : AppColors.warning,
          ),
        ),
        title: Text(
          student['name'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(student['projectTitle']),
            const SizedBox(height: 4),
            Text(
              'Evaluation: ${student['evaluationDate']}',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        trailing: student['score'] != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${student['score']}',
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : TextButton(
                onPressed: () => _evaluateStudent(student),
                child: const Text('Evaluate'),
              ),
      ),
    );
  }

  void _startEvaluation(Map<String, dynamic> assignment) {
    // TODO: Navigate to evaluation screen
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Starting evaluation...')));
  }

  void _evaluateStudent(Map<String, dynamic> student) {
    // TODO: Navigate to student evaluation screen
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Evaluating ${student['name']}...')));
  }

  void _showEvaluationCalendar() {
    // TODO: Show evaluation calendar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Evaluation calendar coming soon')),
    );
  }
}
