import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app_routes.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/student_panel_models.dart';
import '../../providers/auth_provider.dart';

class ComprehensiveCoordinatorDashboard extends ConsumerStatefulWidget {
  const ComprehensiveCoordinatorDashboard({super.key});

  @override
  ConsumerState<ComprehensiveCoordinatorDashboard> createState() =>
      _ComprehensiveCoordinatorDashboardState();
}

class _ComprehensiveCoordinatorDashboardState
    extends ConsumerState<ComprehensiveCoordinatorDashboard> {
  int _selectedIndex = 0;
  List<PanelModel> _managedPanels = [];
  List<StudentModel> _assignedStudents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // TODO: Load actual data from API
    await Future.delayed(const Duration(seconds: 1));

    // Mock data for demonstration
    _managedPanels = [
      PanelModel(
        id: '1',
        name: 'Panel A - Software Engineering',
        location: 'Room 101',
        reviewPhaseId: '1',
        coordinatorId: '1',
        capacity: 15,
        currentCount: 12,
      ),
      PanelModel(
        id: '2',
        name: 'Panel B - Data Science',
        location: 'Room 102',
        reviewPhaseId: '1',
        coordinatorId: '1',
        capacity: 20,
        currentCount: 18,
      ),
    ];

    _assignedStudents = [
      StudentModel(
        id: '1',
        registerNo: 'CS2021001',
        name: 'John Doe',
        email: 'john@example.com',
        phone: '1234567890',
        projectTitle: 'AI-Based Project Management System',
        supervisor: 'Dr. Smith',
      ),
      StudentModel(
        id: '2',
        registerNo: 'CS2021002',
        name: 'Jane Smith',
        email: 'jane@example.com',
        phone: '0987654321',
        projectTitle: 'Blockchain Voting System',
        supervisor: 'Dr. Johnson',
      ),
    ];

    setState(() => _isLoading = false);
  }

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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Coordinator Dashboard'),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Add new panel/assignment
              _showAddDialog();
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile page coming soon')),
                  );
                  break;
                case 'logout':
                  _logout();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'profile', child: Text('Profile')),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  user?.name.substring(0, 1).toUpperCase() ?? 'C',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading ? _buildLoadingView() : _buildBody(),
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _showAddDialog,
              backgroundColor: AppColors.secondary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading dashboard data...'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardView();
      case 1:
        return _buildPanelsView();
      case 2:
        return _buildStudentsView();
      case 3:
        return _buildEvaluationsView();
      default:
        return _buildDashboardView();
    }
  }

  Widget _buildDashboardView() {
    return RefreshIndicator(
      onRefresh: _loadData,
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
                      'Panel Coordinator Overview',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage panels, assign students, and monitor evaluations',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Managed Panels',
                    _managedPanels.length.toString(),
                    Icons.dashboard,
                    AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Assigned Students',
                    _assignedStudents.length.toString(),
                    Icons.people,
                    AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            _buildQuickActionGrid(),
            const SizedBox(height: 24),

            // Recent Panels
            Text(
              'Recent Panels',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            ..._managedPanels.map((panel) => _buildPanelCard(panel)),
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

  Widget _buildQuickActionGrid() {
    final actions = [
      _QuickAction('Create Panel', Icons.add_box, AppColors.primary, () {
        _showCreatePanelDialog();
      }),
      _QuickAction(
        'Assign Students',
        Icons.person_add,
        AppColors.secondary,
        () {
          _showAssignStudentDialog();
        },
      ),
      _QuickAction('View Schedule', Icons.schedule, AppColors.warning, () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schedule view coming soon')),
        );
      }),
      _QuickAction('Reports', Icons.analytics, AppColors.error, () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Reports coming soon')));
      }),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.0,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return Card(
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: action.onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(action.icon, color: action.color, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      action.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPanelCard(PanelModel panel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.secondary.withOpacity(0.1),
          child: Icon(Icons.dashboard, color: AppColors.secondary),
        ),
        title: Text(panel.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location: ${panel.location}'),
            Text('Capacity: ${panel.currentCount}/${panel.capacity}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'view':
                // TODO: Navigate to panel detail
                break;
              case 'edit':
                // TODO: Edit panel
                break;
              case 'assign':
                _showAssignStudentDialog();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'view', child: Text('View Details')),
            const PopupMenuItem(value: 'edit', child: Text('Edit Panel')),
            const PopupMenuItem(
              value: 'assign',
              child: Text('Assign Students'),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildPanelsView() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _managedPanels.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Managed Panels',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            );
          }

          final panel = _managedPanels[index - 1];
          return _buildPanelCard(panel);
        },
      ),
    );
  }

  Widget _buildStudentsView() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _assignedStudents.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Assigned Students',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            );
          }

          final student = _assignedStudents[index - 1];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.success.withOpacity(0.1),
                child: Text(
                  student.name.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(student.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reg No: ${student.registerNo}'),
                  Text(
                    'Project: ${student.projectTitle}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('Supervisor: ${student.supervisor}'),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              isThreeLine: true,
              onTap: () {
                // TODO: Navigate to student detail
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Student details for ${student.name} coming soon',
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEvaluationsView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Evaluations',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Coming Soon', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      selectedItemColor: AppColors.secondary,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Overview'),
        BottomNavigationBarItem(icon: Icon(Icons.view_module), label: 'Panels'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Students'),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Evaluations',
        ),
      ],
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quick Add'),
        content: const Text('What would you like to add?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showCreatePanelDialog();
            },
            child: const Text('New Panel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showAssignStudentDialog();
            },
            child: const Text('Assign Student'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCreatePanelDialog() {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final capacityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Panel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Panel Name'),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: capacityController,
              decoration: const InputDecoration(labelText: 'Capacity'),
              keyboardType: TextInputType.number,
            ),
          ],
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
                const SnackBar(content: Text('Panel creation coming soon')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showAssignStudentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign Student'),
        content: const Text('Student assignment functionality coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _QuickAction(this.title, this.icon, this.color, this.onTap);
}
