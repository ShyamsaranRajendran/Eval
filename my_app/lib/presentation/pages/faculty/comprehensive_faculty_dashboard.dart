import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app_routes.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/student_panel_models.dart';
import '../../../data/models/evaluation_models.dart';
import '../../../data/models/review_phase_models.dart';
import '../../providers/auth_provider.dart';

class ComprehensiveFacultyDashboard extends ConsumerStatefulWidget {
  const ComprehensiveFacultyDashboard({super.key});

  @override
  ConsumerState<ComprehensiveFacultyDashboard> createState() =>
      _ComprehensiveFacultyDashboardState();
}

class _ComprehensiveFacultyDashboardState
    extends ConsumerState<ComprehensiveFacultyDashboard> {
  int _selectedIndex = 0;
  List<PanelModel> _assignedPanels = [];
  List<EvaluationModel> _pendingEvaluations = [];
  List<EvaluationModel> _completedEvaluations = [];
  List<ReviewPhaseModel> _activePhases = [];
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
    _assignedPanels = [
      PanelModel(
        id: '1',
        name: 'Panel A - Mobile Apps',
        location: 'Lab 101',
        reviewPhaseId: '1',
        coordinatorId: '1',
        capacity: 15,
        currentCount: 12,
      ),
      PanelModel(
        id: '2',
        name: 'Panel C - Web Development',
        location: 'Lab 201',
        reviewPhaseId: '1',
        coordinatorId: '2',
        capacity: 18,
        currentCount: 15,
      ),
    ];

    _activePhases = [
      ReviewPhaseModel(
        id: '1',
        name: 'Mid-Term Evaluation',
        order: 1,
        academicYear: '2024-25',
        isActive: true,
        startDate: DateTime.now().subtract(const Duration(days: 7)),
        endDate: DateTime.now().add(const Duration(days: 14)),
        createdAt: DateTime.now(),
      ),
    ];

    _pendingEvaluations = [
      EvaluationModel(
        id: '1',
        reviewPhaseId: '1',
        panelId: '1',
        evaluatorId: 'faculty1',
        studentId: 'student1',
        criteriaId: 'criteria1',
        marksAwarded: 0,
        comments: '',
        submittedAt: DateTime.now().add(const Duration(days: 7)),
        isFinalized: false,
      ),
      EvaluationModel(
        id: '2',
        reviewPhaseId: '1',
        panelId: '1',
        evaluatorId: 'faculty1',
        studentId: 'student2',
        criteriaId: 'criteria1',
        marksAwarded: 0,
        comments: '',
        submittedAt: DateTime.now().add(const Duration(days: 7)),
        isFinalized: false,
      ),
    ];

    _completedEvaluations = [
      EvaluationModel(
        id: '3',
        reviewPhaseId: '1',
        panelId: '1',
        evaluatorId: 'faculty1',
        studentId: 'student3',
        criteriaId: 'criteria1',
        marksAwarded: 85,
        comments: 'Good implementation with room for improvement',
        submittedAt: DateTime.now().subtract(const Duration(days: 2)),
        isFinalized: true,
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
        title: const Text('Faculty Dashboard'),
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                if (_pendingEvaluations.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '${_pendingEvaluations.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              _showNotifications();
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
                case 'help':
                  _showHelpDialog();
                  break;
                case 'logout':
                  _logout();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'profile', child: Text('Profile')),
              const PopupMenuItem(value: 'help', child: Text('Help')),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  user?.name.substring(0, 1).toUpperCase() ?? 'F',
                  style: TextStyle(
                    color: AppColors.success,
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
      floatingActionButton:
          _selectedIndex == 1 && _pendingEvaluations.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () =>
                  _navigateToEvaluationScreen(_pendingEvaluations.first),
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.rate_review),
              label: const Text('Start Evaluation'),
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
          Text('Loading faculty dashboard...'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardView();
      case 1:
        return _buildEvaluationsView();
      case 2:
        return _buildPanelsView();
      case 3:
        return _buildScheduleView();
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
                    Row(
                      children: [
                        Icon(Icons.school, color: AppColors.success, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Faculty Dashboard',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.success,
                                    ),
                              ),
                              Text(
                                'Evaluate student projects and track progress',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Active Phase Banner
            if (_activePhases.isNotEmpty)
              Card(
                color: AppColors.primary.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Active: ${_activePhases.first.name}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                            ),
                            Text(
                              'Ends: ${_formatDate(_activePhases.first.endDate)}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
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
                    'Assigned Panels',
                    _assignedPanels.length.toString(),
                    Icons.dashboard,
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Pending',
                    _pendingEvaluations.length.toString(),
                    Icons.pending_actions,
                    AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Completed',
                    _completedEvaluations.length.toString(),
                    Icons.check_circle,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Total Evaluations',
                    (_pendingEvaluations.length + _completedEvaluations.length)
                        .toString(),
                    Icons.assignment,
                    AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

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

            // Recent Evaluations
            if (_pendingEvaluations.isNotEmpty) ...[
              Text(
                'Pending Evaluations',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ..._pendingEvaluations
                  .take(3)
                  .map((evaluation) => _buildEvaluationCard(evaluation, true)),
            ],

            if (_completedEvaluations.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Recent Completed',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ..._completedEvaluations
                  .take(2)
                  .map((evaluation) => _buildEvaluationCard(evaluation, false)),
            ],
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
            Icon(icon, color: color, size: 28),
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
      _QuickAction(
        'Start Evaluation',
        Icons.rate_review,
        AppColors.success,
        () {
          if (_pendingEvaluations.isNotEmpty) {
            _navigateToEvaluationScreen(_pendingEvaluations.first);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No pending evaluations')),
            );
          }
        },
      ),
      _QuickAction('View Schedule', Icons.schedule, AppColors.primary, () {
        setState(() => _selectedIndex = 3);
      }),
      _QuickAction('My Panels', Icons.dashboard, AppColors.secondary, () {
        setState(() => _selectedIndex = 2);
      }),
      _QuickAction('Guidelines', Icons.help_outline, AppColors.warning, () {
        _showGuidelinesDialog();
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

  Widget _buildEvaluationCard(EvaluationModel evaluation, bool isPending) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPending
              ? AppColors.warning.withOpacity(0.1)
              : AppColors.success.withOpacity(0.1),
          child: Icon(
            isPending ? Icons.pending_actions : Icons.check_circle,
            color: isPending ? AppColors.warning : AppColors.success,
          ),
        ),
        title: Text('Student ID: ${evaluation.studentId}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Panel: ${evaluation.panelId}'),
            if (!isPending) Text('Score: ${evaluation.marksAwarded}/100'),
          ],
        ),
        trailing: isPending
            ? ElevatedButton(
                onPressed: () => _navigateToEvaluationScreen(evaluation),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Evaluate'),
              )
            : Icon(Icons.done, color: AppColors.success),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildEvaluationsView() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              tabs: [
                Tab(text: 'Pending', icon: Icon(Icons.pending_actions)),
                Tab(text: 'Completed', icon: Icon(Icons.check_circle)),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildEvaluationsList(_pendingEvaluations, true),
                _buildEvaluationsList(_completedEvaluations, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationsList(
    List<EvaluationModel> evaluations,
    bool isPending,
  ) {
    if (evaluations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPending ? Icons.pending_actions : Icons.check_circle,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              isPending ? 'No Pending Evaluations' : 'No Completed Evaluations',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isPending
                  ? 'All evaluations are up to date!'
                  : 'Complete some evaluations to see them here',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: evaluations.length,
        itemBuilder: (context, index) {
          final evaluation = evaluations[index];
          return _buildEvaluationCard(evaluation, isPending);
        },
      ),
    );
  }

  Widget _buildPanelsView() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _assignedPanels.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'My Assigned Panels',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            );
          }

          final panel = _assignedPanels[index - 1];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.success.withOpacity(0.1),
                child: Icon(Icons.dashboard, color: AppColors.success),
              ),
              title: Text(panel.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Location: ${panel.location}'),
                  Text('Students: ${panel.currentCount}/${panel.capacity}'),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              isThreeLine: true,
              onTap: () {
                _showPanelDetails(panel);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Evaluation Schedule',
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
      selectedItemColor: AppColors.success,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Evaluations',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.view_module), label: 'Panels'),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
      ],
    );
  }

  void _navigateToEvaluationScreen(EvaluationModel evaluation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EvaluationScreen(evaluation: evaluation),
      ),
    );
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.pending_actions, color: AppColors.warning),
              title: Text('${_pendingEvaluations.length} Pending Evaluations'),
              subtitle: const Text('Please complete your assigned evaluations'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPanelDetails(PanelModel panel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(panel.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location: ${panel.location}'),
            Text('Capacity: ${panel.currentCount}/${panel.capacity}'),
            Text('Review Phase: ${panel.reviewPhaseId}'),
          ],
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

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Faculty Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Evaluation Guidelines:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('1. Review project requirements carefully'),
              Text('2. Evaluate based on given criteria'),
              Text('3. Provide constructive feedback'),
              Text('4. Submit evaluations on time'),
              SizedBox(height: 16),
              Text('Need more help? Contact the coordinator.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showGuidelinesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Evaluation Guidelines'),
        content: const SingleChildScrollView(
          child: Text(
            'Please follow these guidelines when evaluating student projects:\n\n'
            '• Review the project requirements and objectives\n'
            '• Assess technical implementation and code quality\n'
            '• Evaluate presentation and documentation\n'
            '• Consider innovation and problem-solving approach\n'
            '• Provide specific and constructive feedback\n'
            '• Be fair and consistent in your scoring\n'
            '• Complete evaluations within the deadline',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Understood'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _QuickAction {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _QuickAction(this.title, this.icon, this.color, this.onTap);
}

// Evaluation Screen for detailed evaluation
class EvaluationScreen extends StatefulWidget {
  final EvaluationModel evaluation;

  const EvaluationScreen({super.key, required this.evaluation});

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentsController = TextEditingController();
  final _marksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _commentsController.text = widget.evaluation.comments;
    _marksController.text = widget.evaluation.marksAwarded.toString();
  }

  @override
  void dispose() {
    _commentsController.dispose();
    _marksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Evaluation'),
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveEvaluation,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                      Text(
                        'Evaluation Details',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Student ID:',
                        widget.evaluation.studentId,
                      ),
                      _buildDetailRow('Panel ID:', widget.evaluation.panelId),
                      _buildDetailRow(
                        'Criteria ID:',
                        widget.evaluation.criteriaId,
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
                      Text(
                        'Scoring',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _marksController,
                        decoration: const InputDecoration(
                          labelText: 'Marks (out of 100)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.grade),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter marks';
                          }
                          final marks = int.tryParse(value);
                          if (marks == null || marks < 0 || marks > 100) {
                            return 'Please enter a valid score (0-100)';
                          }
                          return null;
                        },
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
                      Text(
                        'Feedback & Comments',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _commentsController,
                        decoration: const InputDecoration(
                          labelText: 'Comments',
                          hintText:
                              'Provide detailed feedback about the project...',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please provide feedback comments';
                          }
                          if (value.trim().length < 10) {
                            return 'Comments should be more detailed';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveEvaluation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Save Draft'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitEvaluation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Submit Final'),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _saveEvaluation() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Save evaluation to API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evaluation saved as draft'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  void _submitEvaluation() {
    if (_formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Submit Evaluation'),
          content: const Text(
            'Are you sure you want to submit this evaluation? '
            'Once submitted, you cannot make changes.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Submit evaluation to API
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Evaluation submitted successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context); // Return to dashboard
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      );
    }
  }
}
