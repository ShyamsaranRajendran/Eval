import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../widgets/custom_button.dart';

class CoordinatorSchedulingScreen extends ConsumerStatefulWidget {
  const CoordinatorSchedulingScreen({super.key});

  @override
  ConsumerState<CoordinatorSchedulingScreen> createState() =>
      _CoordinatorSchedulingScreenState();
}

class _CoordinatorSchedulingScreenState
    extends ConsumerState<CoordinatorSchedulingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  DateTime _selectedDate = DateTime.now();
  String _selectedView = 'Week';
  bool _isLoading = false;

  // Mock scheduling data
  final List<Map<String, dynamic>> _schedules = [
    {
      'id': 'EVAL_001',
      'type': 'evaluation',
      'title': 'Final Year Project Evaluation - AI Panel',
      'panel': 'AI & Machine Learning Projects',
      'student': 'John Smith',
      'project': 'Deep Learning for Image Recognition',
      'faculty': ['Dr. Michael Chen', 'Prof. Lisa Wang', 'Dr. Ahmed Hassan'],
      'chairperson': 'Dr. Michael Chen',
      'date': '2024-01-25',
      'time': '09:00 AM',
      'duration': '60 minutes',
      'venue': 'Conference Room A',
      'status': 'scheduled',
      'priority': 'high',
      'notes': 'Final evaluation for computer science project',
      'reminders': ['24 hours', '2 hours'],
    },
    {
      'id': 'EVAL_002',
      'type': 'evaluation',
      'title': 'Mid-term Progress Review - Web Dev Panel',
      'panel': 'Web Development & Mobile Apps',
      'student': 'Emma Davis',
      'project': 'E-commerce Platform with React',
      'faculty': ['Prof. David Miller', 'Dr. Emily Rodriguez'],
      'chairperson': 'Prof. David Miller',
      'date': '2024-01-25',
      'time': '11:00 AM',
      'duration': '45 minutes',
      'venue': 'Conference Room B',
      'status': 'scheduled',
      'priority': 'medium',
      'notes': 'Mid-term progress evaluation',
      'reminders': ['24 hours'],
    },
    {
      'id': 'MEET_001',
      'type': 'panel_meeting',
      'title': 'AI Panel Coordination Meeting',
      'panel': 'AI & Machine Learning Projects',
      'faculty': [
        'Dr. Michael Chen',
        'Prof. Lisa Wang',
        'Dr. Ahmed Hassan',
        'Dr. Emily Rodriguez',
      ],
      'chairperson': 'Dr. Michael Chen',
      'date': '2024-01-24',
      'time': '02:00 PM',
      'duration': '90 minutes',
      'venue': 'Main Conference Hall',
      'status': 'scheduled',
      'priority': 'medium',
      'notes': 'Discuss evaluation criteria and student progress',
      'agenda': [
        'Review evaluation rubric',
        'Discuss student progress',
        'Plan final evaluations',
      ],
    },
    {
      'id': 'EVAL_003',
      'type': 'evaluation',
      'title': 'Project Defense - IoT Systems',
      'panel': 'IoT & Embedded Systems',
      'student': 'Alex Johnson',
      'project': 'Smart Home Security System',
      'faculty': ['Dr. Robert Johnson', 'Prof. Maria Garcia'],
      'chairperson': 'Dr. Robert Johnson',
      'date': '2024-01-26',
      'time': '10:30 AM',
      'duration': '75 minutes',
      'venue': 'Lab 3',
      'status': 'confirmed',
      'priority': 'high',
      'notes': 'Final defense with demonstration',
      'equipment': ['Projector', 'IoT Demo Kit', 'Laptop'],
    },
    {
      'id': 'WORK_001',
      'type': 'workshop',
      'title': 'Evaluation Standards Workshop',
      'faculty': ['All Faculty'],
      'facilitator': 'Dr. Sarah Johnson',
      'date': '2024-01-23',
      'time': '01:00 PM',
      'duration': '120 minutes',
      'venue': 'Auditorium',
      'status': 'scheduled',
      'priority': 'low',
      'notes': 'Training on new evaluation standards',
      'attendees': 45,
    },
  ];

  final Map<String, List<String>> _timeSlots = {
    'morning': [
      '09:00 AM',
      '09:30 AM',
      '10:00 AM',
      '10:30 AM',
      '11:00 AM',
      '11:30 AM',
    ],
    'afternoon': [
      '12:00 PM',
      '12:30 PM',
      '01:00 PM',
      '01:30 PM',
      '02:00 PM',
      '02:30 PM',
      '03:00 PM',
      '03:30 PM',
    ],
    'evening': ['04:00 PM', '04:30 PM', '05:00 PM', '05:30 PM'],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSchedules();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSchedules() async {
    setState(() => _isLoading = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  List<Map<String, dynamic>> _getSchedulesForDate(DateTime date) {
    final dateString =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return _schedules
        .where((schedule) => schedule['date'] == dateString)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Evaluation Scheduling'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.view_module),
            onSelected: (value) {
              setState(() => _selectedView = value);
            },
            itemBuilder: (context) => ['Day', 'Week', 'Month']
                .map(
                  (view) =>
                      PopupMenuItem(value: view, child: Text('$view View')),
                )
                .toList(),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
          IconButton(
            icon: const Icon(Icons.notification_add),
            onPressed: _manageNotifications,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Schedule'),
            Tab(text: 'Calendar'),
            Tab(text: 'Conflicts'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Date and View Selector
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _formatSelectedDate(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '$_selectedView View',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildScheduleTab(),
                _buildCalendarTab(),
                _buildConflictsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scheduleNewEvaluation,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.event_available),
        label: const Text('Schedule'),
      ),
    );
  }

  Widget _buildScheduleTab() {
    final daySchedules = _getSchedulesForDate(_selectedDate);

    return RefreshIndicator(
      onRefresh: _loadSchedules,
      child: Column(
        children: [
          // Time Slots Overview
          _buildTimeSlotOverview(),

          // Scheduled Events
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : daySchedules.isEmpty
                ? _buildEmptySchedule()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: daySchedules.length,
                    itemBuilder: (context, index) {
                      final schedule = daySchedules[index];
                      return _buildScheduleCard(schedule);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Calendar Widget Placeholder
          Card(
            child: Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calendar View',
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
                              Icons.calendar_month,
                              size: 48,
                              color: AppColors.textSecondary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Calendar widget will be implemented\nwith table_calendar package',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.textSecondary),
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

          const SizedBox(height: 16),

          // Month Statistics
          _buildMonthStatistics(),
        ],
      ),
    );
  }

  Widget _buildConflictsTab() {
    // Mock conflict detection
    final conflicts = _detectScheduleConflicts();

    return RefreshIndicator(
      onRefresh: _loadSchedules,
      child: conflicts.isEmpty
          ? _buildNoConflicts()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: conflicts.length,
              itemBuilder: (context, index) {
                final conflict = conflicts[index];
                return _buildConflictCard(conflict);
              },
            ),
    );
  }

  Widget _buildTimeSlotOverview() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Time Slots',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTimeSlotGroup('Morning', _timeSlots['morning']!),
              ),
              Expanded(
                child: _buildTimeSlotGroup(
                  'Afternoon',
                  _timeSlots['afternoon']!,
                ),
              ),
              Expanded(
                child: _buildTimeSlotGroup('Evening', _timeSlots['evening']!),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotGroup(String title, List<String> slots) {
    final occupiedSlots = _getSchedulesForDate(
      _selectedDate,
    ).map((s) => s['time']).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: slots.map((slot) {
            final isOccupied = occupiedSlots.contains(slot);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isOccupied
                    ? AppColors.error.withOpacity(0.1)
                    : AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                slot,
                style: TextStyle(
                  fontSize: 10,
                  color: isOccupied ? AppColors.error : AppColors.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEmptySchedule() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No events scheduled',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Schedule your first evaluation for ${_formatSelectedDate()}.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Schedule Evaluation',
              onPressed: _scheduleNewEvaluation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> schedule) {
    final typeColor = _getScheduleTypeColor(schedule['type']);
    final priorityColor = _getPriorityColor(schedule['priority']);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showScheduleDetails(schedule),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: typeColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                schedule['title'],
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: priorityColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                schedule['priority'].toString().toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: priorityColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (schedule['panel'] != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            schedule['panel'],
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Time and Venue Info
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${schedule['time']} (${schedule['duration']})',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    schedule['venue'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              if (schedule['student'] != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Student: ${schedule['student']}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                if (schedule['project'] != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.assignment,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Project: ${schedule['project']}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ],
              ],

              const SizedBox(height: 12),

              // Faculty Members
              if (schedule['faculty'] != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Faculty: ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        (schedule['faculty'] as List).join(', '),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              // Status and Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusBadge(schedule['status']),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => _editSchedule(schedule),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _showScheduleDetails(schedule),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color statusColor;
    switch (status) {
      case 'scheduled':
        statusColor = AppColors.info;
        break;
      case 'confirmed':
        statusColor = AppColors.success;
        break;
      case 'cancelled':
        statusColor = AppColors.error;
        break;
      case 'completed':
        statusColor = AppColors.textSecondary;
        break;
      default:
        statusColor = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: statusColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMonthStatistics() {
    final totalScheduled = _schedules.length;
    final completedEvals = _schedules
        .where((s) => s['status'] == 'completed')
        .length;
    final upcomingEvals = _schedules
        .where((s) => s['status'] == 'scheduled' || s['status'] == 'confirmed')
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This Month Statistics',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Events',
                    '$totalScheduled',
                    AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Completed',
                    '$completedEvals',
                    AppColors.success,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Upcoming',
                    '$upcomingEvals',
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

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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

  Widget _buildNoConflicts() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: AppColors.success.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'No scheduling conflicts',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All your scheduled events are properly organized without any conflicts.',
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

  Widget _buildConflictCard(Map<String, dynamic> conflict) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.error.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: AppColors.error),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    conflict['title'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              conflict['description'],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _resolveConflict(conflict),
                  child: const Text('Resolve'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getScheduleTypeColor(String type) {
    switch (type) {
      case 'evaluation':
        return AppColors.primary;
      case 'panel_meeting':
        return AppColors.info;
      case 'workshop':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      case 'low':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  List<Map<String, dynamic>> _detectScheduleConflicts() {
    // Mock conflict detection logic
    return [
      {
        'title': 'Faculty Double Booking',
        'description':
            'Dr. Michael Chen is scheduled for two evaluations at the same time on Jan 25, 2024 at 09:00 AM.',
        'type': 'faculty_conflict',
        'schedules': ['EVAL_001', 'EVAL_002'],
      },
      // Add more mock conflicts if needed
    ];
  }

  String _formatSelectedDate() {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[_selectedDate.month - 1]} ${_selectedDate.day}, ${_selectedDate.year}';
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _scheduleNewEvaluation() {
    // TODO: Implement schedule creation dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Schedule creation feature coming soon')),
    );
  }

  void _editSchedule(Map<String, dynamic> schedule) {
    // TODO: Implement schedule editing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit schedule ${schedule['title']} feature coming soon'),
      ),
    );
  }

  void _showScheduleDetails(Map<String, dynamic> schedule) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
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
                      schedule['title'],
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

              // Detailed schedule information would go here
              Text('Schedule details coming soon...'),
            ],
          ),
        ),
      ),
    );
  }

  void _manageNotifications() {
    // TODO: Implement notification management
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification management feature coming soon'),
      ),
    );
  }

  void _resolveConflict(Map<String, dynamic> conflict) {
    // TODO: Implement conflict resolution
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Resolve conflict ${conflict['title']} feature coming soon',
        ),
      ),
    );
  }
}
