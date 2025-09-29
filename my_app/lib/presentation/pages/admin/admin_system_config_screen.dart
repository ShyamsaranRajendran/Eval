import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../widgets/custom_text_field.dart';

class AdminSystemConfigScreen extends ConsumerStatefulWidget {
  const AdminSystemConfigScreen({super.key});

  @override
  ConsumerState<AdminSystemConfigScreen> createState() =>
      _AdminSystemConfigScreenState();
}

class _AdminSystemConfigScreenState
    extends ConsumerState<AdminSystemConfigScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  // Configuration Controllers
  final TextEditingController _universityNameController =
      TextEditingController();
  final TextEditingController _semesterController = TextEditingController();
  final TextEditingController _academicYearController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // System Settings
  Map<String, dynamic> _systemSettings = {
    'general': {
      'universityName': 'University of Excellence',
      'currentSemester': 'Fall 2024',
      'academicYear': '2024-2025',
      'contactEmail': 'admin@university.edu',
      'contactPhone': '+1-555-0100',
      'address': '123 University Avenue, Education City, EC 12345',
      'timezone': 'America/New_York',
      'language': 'English',
      'dateFormat': 'MM/dd/yyyy',
    },
    'evaluation': {
      'maxScore': 100,
      'passingScore': 60,
      'evaluationDuration': 90, // minutes
      'allowLateSubmissions': true,
      'lateSubmissionPenalty': 10, // percentage
      'autoReminders': true,
      'reminderIntervals': [24, 2], // hours before deadline
    },
    'security': {
      'sessionTimeout': 120, // minutes
      'passwordMinLength': 8,
      'requireSpecialChars': true,
      'requireNumbers': true,
      'enableTwoFactor': false,
      'lockoutAttempts': 5,
      'lockoutDuration': 30, // minutes
    },
    'notifications': {
      'emailNotifications': true,
      'pushNotifications': true,
      'systemAlerts': true,
      'evaluationReminders': true,
      'reportGeneration': true,
      'maintenanceAlerts': true,
    },
    'backup': {
      'autoBackup': true,
      'backupFrequency': 'Daily',
      'retentionDays': 30,
      'cloudBackup': true,
      'localBackup': true,
      'compressionEnabled': true,
    },
  };

  final List<Map<String, dynamic>> _departments = [
    {
      'id': 'CS',
      'name': 'Computer Science',
      'code': 'CS',
      'head': 'Dr. Michael Chen',
      'faculty': 45,
      'active': true,
    },
    {
      'id': 'IT',
      'name': 'Information Technology',
      'code': 'IT',
      'head': 'Prof. Lisa Wang',
      'faculty': 32,
      'active': true,
    },
    {
      'id': 'EE',
      'name': 'Electronics Engineering',
      'code': 'EE',
      'head': 'Dr. Ahmed Hassan',
      'faculty': 28,
      'active': true,
    },
    {
      'id': 'ME',
      'name': 'Mechanical Engineering',
      'code': 'ME',
      'head': 'Prof. David Miller',
      'faculty': 25,
      'active': false,
    },
    {
      'id': 'CE',
      'name': 'Civil Engineering',
      'code': 'CE',
      'head': 'Dr. Sarah Johnson',
      'faculty': 15,
      'active': true,
    },
  ];

  final List<Map<String, dynamic>> _evaluationCriteria = [
    {
      'id': 'TECH',
      'name': 'Technical Implementation',
      'weight': 40,
      'maxScore': 40,
      'description': 'Code quality, functionality, and technical complexity',
    },
    {
      'id': 'PRES',
      'name': 'Presentation Quality',
      'weight': 25,
      'maxScore': 25,
      'description': 'Clarity of presentation and communication skills',
    },
    {
      'id': 'INNO',
      'name': 'Innovation & Creativity',
      'weight': 20,
      'maxScore': 20,
      'description': 'Originality and creative problem-solving approach',
    },
    {
      'id': 'DOCS',
      'name': 'Documentation',
      'weight': 15,
      'maxScore': 15,
      'description': 'Quality and completeness of project documentation',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadSystemConfiguration();
    _initializeControllers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _universityNameController.dispose();
    _semesterController.dispose();
    _academicYearController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    _universityNameController.text =
        _systemSettings['general']['universityName'];
    _semesterController.text = _systemSettings['general']['currentSemester'];
    _academicYearController.text = _systemSettings['general']['academicYear'];
    _emailController.text = _systemSettings['general']['contactEmail'];
    _phoneController.text = _systemSettings['general']['contactPhone'];
    _addressController.text = _systemSettings['general']['address'];
  }

  Future<void> _loadSystemConfiguration() async {
    setState(() => _isLoading = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasUnsavedChanges) {
          return await _showUnsavedChangesDialog() ?? false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('System Configuration'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          actions: [
            if (_hasUnsavedChanges)
              TextButton(
                onPressed: _saveConfiguration,
                child: const Text(
                  'SAVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetToDefaults,
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'export',
                  child: Row(
                    children: [
                      Icon(Icons.download),
                      SizedBox(width: 8),
                      Text('Export Config'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'import',
                  child: Row(
                    children: [
                      Icon(Icons.upload),
                      SizedBox(width: 8),
                      Text('Import Config'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'export') _exportConfiguration();
                if (value == 'import') _importConfiguration();
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            isScrollable: true,
            tabs: const [
              Tab(text: 'General'),
              Tab(text: 'Departments'),
              Tab(text: 'Evaluation'),
              Tab(text: 'Security'),
              Tab(text: 'Advanced'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildGeneralTab(),
                  _buildDepartmentsTab(),
                  _buildEvaluationTab(),
                  _buildSecurityTab(),
                  _buildAdvancedTab(),
                ],
              ),
        floatingActionButton: _hasUnsavedChanges
            ? FloatingActionButton.extended(
                onPressed: _saveConfiguration,
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.save),
                label: const Text('Save Changes'),
              )
            : null,
      ),
    );
  }

  Widget _buildGeneralTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'University Information',
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
                  CustomTextField(
                    controller: _universityNameController,
                    label: 'University Name',
                    prefixIcon: Icons.school,
                    onChanged: (_) => _markAsChanged(),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _semesterController,
                    label: 'Current Semester',
                    prefixIcon: Icons.calendar_today,
                    onChanged: (_) => _markAsChanged(),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _academicYearController,
                    label: 'Academic Year',
                    prefixIcon: Icons.date_range,
                    onChanged: (_) => _markAsChanged(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Contact Information',
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
                  CustomTextField(
                    controller: _emailController,
                    label: 'Contact Email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => _markAsChanged(),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _phoneController,
                    label: 'Contact Phone',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    onChanged: (_) => _markAsChanged(),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _addressController,
                    label: 'University Address',
                    prefixIcon: Icons.location_on,
                    maxLines: 3,
                    onChanged: (_) => _markAsChanged(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'System Preferences',
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
                  _buildDropdownSetting(
                    'Timezone',
                    _systemSettings['general']['timezone'],
                    [
                      'America/New_York',
                      'America/Chicago',
                      'America/Denver',
                      'America/Los_Angeles',
                    ],
                    Icons.access_time,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownSetting(
                    'Language',
                    _systemSettings['general']['language'],
                    ['English', 'Spanish', 'French', 'German'],
                    Icons.language,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownSetting(
                    'Date Format',
                    _systemSettings['general']['dateFormat'],
                    ['MM/dd/yyyy', 'dd/MM/yyyy', 'yyyy-MM-dd'],
                    Icons.date_range,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Academic Departments',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _addDepartment,
                icon: const Icon(Icons.add),
                label: const Text('Add Department'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ..._departments.map((dept) => _buildDepartmentCard(dept)).toList(),
        ],
      ),
    );
  }

  Widget _buildEvaluationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Evaluation Settings',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scoring Configuration',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSliderSetting(
                    'Maximum Score',
                    _systemSettings['evaluation']['maxScore'].toDouble(),
                    50,
                    200,
                    (value) {
                      _systemSettings['evaluation']['maxScore'] = value.toInt();
                      _markAsChanged();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSliderSetting(
                    'Passing Score',
                    _systemSettings['evaluation']['passingScore'].toDouble(),
                    30,
                    100,
                    (value) {
                      _systemSettings['evaluation']['passingScore'] = value
                          .toInt();
                      _markAsChanged();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSliderSetting(
                    'Evaluation Duration (minutes)',
                    _systemSettings['evaluation']['evaluationDuration']
                        .toDouble(),
                    30,
                    180,
                    (value) {
                      _systemSettings['evaluation']['evaluationDuration'] =
                          value.toInt();
                      _markAsChanged();
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Evaluation Criteria',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Criteria Management',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: _addEvaluationCriteria,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Criteria'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                ..._evaluationCriteria
                    .map((criteria) => _buildCriteriaCard(criteria))
                    .toList(),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Submission Settings',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSwitchSetting(
                    'Allow Late Submissions',
                    _systemSettings['evaluation']['allowLateSubmissions'],
                    (value) {
                      _systemSettings['evaluation']['allowLateSubmissions'] =
                          value;
                      _markAsChanged();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSliderSetting(
                    'Late Submission Penalty (%)',
                    _systemSettings['evaluation']['lateSubmissionPenalty']
                        .toDouble(),
                    0,
                    50,
                    (value) {
                      _systemSettings['evaluation']['lateSubmissionPenalty'] =
                          value.toInt();
                      _markAsChanged();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSwitchSetting(
                    'Auto Reminders',
                    _systemSettings['evaluation']['autoReminders'],
                    (value) {
                      _systemSettings['evaluation']['autoReminders'] = value;
                      _markAsChanged();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Settings',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Authentication',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSliderSetting(
                    'Session Timeout (minutes)',
                    _systemSettings['security']['sessionTimeout'].toDouble(),
                    15,
                    480,
                    (value) {
                      _systemSettings['security']['sessionTimeout'] = value
                          .toInt();
                      _markAsChanged();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSliderSetting(
                    'Password Minimum Length',
                    _systemSettings['security']['passwordMinLength'].toDouble(),
                    6,
                    20,
                    (value) {
                      _systemSettings['security']['passwordMinLength'] = value
                          .toInt();
                      _markAsChanged();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSwitchSetting(
                    'Require Special Characters',
                    _systemSettings['security']['requireSpecialChars'],
                    (value) {
                      _systemSettings['security']['requireSpecialChars'] =
                          value;
                      _markAsChanged();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSwitchSetting(
                    'Require Numbers',
                    _systemSettings['security']['requireNumbers'],
                    (value) {
                      _systemSettings['security']['requireNumbers'] = value;
                      _markAsChanged();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSwitchSetting(
                    'Enable Two-Factor Authentication',
                    _systemSettings['security']['enableTwoFactor'],
                    (value) {
                      _systemSettings['security']['enableTwoFactor'] = value;
                      _markAsChanged();
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Lockout',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSliderSetting(
                    'Failed Login Attempts',
                    _systemSettings['security']['lockoutAttempts'].toDouble(),
                    3,
                    10,
                    (value) {
                      _systemSettings['security']['lockoutAttempts'] = value
                          .toInt();
                      _markAsChanged();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSliderSetting(
                    'Lockout Duration (minutes)',
                    _systemSettings['security']['lockoutDuration'].toDouble(),
                    5,
                    120,
                    (value) {
                      _systemSettings['security']['lockoutDuration'] = value
                          .toInt();
                      _markAsChanged();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notification Settings',
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
                  _buildSwitchSetting(
                    'Email Notifications',
                    _systemSettings['notifications']['emailNotifications'],
                    (value) {
                      _systemSettings['notifications']['emailNotifications'] =
                          value;
                      _markAsChanged();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSwitchSetting(
                    'Push Notifications',
                    _systemSettings['notifications']['pushNotifications'],
                    (value) {
                      _systemSettings['notifications']['pushNotifications'] =
                          value;
                      _markAsChanged();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSwitchSetting(
                    'System Alerts',
                    _systemSettings['notifications']['systemAlerts'],
                    (value) {
                      _systemSettings['notifications']['systemAlerts'] = value;
                      _markAsChanged();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSwitchSetting(
                    'Evaluation Reminders',
                    _systemSettings['notifications']['evaluationReminders'],
                    (value) {
                      _systemSettings['notifications']['evaluationReminders'] =
                          value;
                      _markAsChanged();
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Backup Configuration',
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
                  _buildSwitchSetting(
                    'Automatic Backup',
                    _systemSettings['backup']['autoBackup'],
                    (value) {
                      _systemSettings['backup']['autoBackup'] = value;
                      _markAsChanged();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownSetting(
                    'Backup Frequency',
                    _systemSettings['backup']['backupFrequency'],
                    ['Hourly', 'Daily', 'Weekly', 'Monthly'],
                    Icons.schedule,
                  ),
                  const SizedBox(height: 16),
                  _buildSliderSetting(
                    'Retention Days',
                    _systemSettings['backup']['retentionDays'].toDouble(),
                    7,
                    365,
                    (value) {
                      _systemSettings['backup']['retentionDays'] = value
                          .toInt();
                      _markAsChanged();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSwitchSetting(
                    'Cloud Backup',
                    _systemSettings['backup']['cloudBackup'],
                    (value) {
                      _systemSettings['backup']['cloudBackup'] = value;
                      _markAsChanged();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildSwitchSetting(
                    'Compression',
                    _systemSettings['backup']['compressionEnabled'],
                    (value) {
                      _systemSettings['backup']['compressionEnabled'] = value;
                      _markAsChanged();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentCard(Map<String, dynamic> dept) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: dept['active']
              ? AppColors.success.withOpacity(0.1)
              : AppColors.error.withOpacity(0.1),
          child: Icon(
            Icons.business,
            color: dept['active'] ? AppColors.success : AppColors.error,
          ),
        ),
        title: Text(
          dept['name'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Code: ${dept['code']} • Head: ${dept['head']}'),
            Text('Faculty: ${dept['faculty']}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: dept['active'],
              onChanged: (value) {
                setState(() {
                  dept['active'] = value;
                });
                _markAsChanged();
              },
              activeColor: AppColors.success,
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') _editDepartment(dept);
                if (value == 'delete') _deleteDepartment(dept);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCriteriaCard(Map<String, dynamic> criteria) {
    return ListTile(
      title: Text(
        criteria['name'],
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(criteria['description']),
          const SizedBox(height: 4),
          Text(
            'Weight: ${criteria['weight']}% • Max Score: ${criteria['maxScore']}',
          ),
        ],
      ),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [Icon(Icons.edit), SizedBox(width: 8), Text('Edit')],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.red),
                SizedBox(width: 8),
                Text('Delete'),
              ],
            ),
          ),
        ],
        onSelected: (value) {
          if (value == 'edit') _editCriteria(criteria);
          if (value == 'delete') _deleteCriteria(criteria);
        },
      ),
    );
  }

  Widget _buildDropdownSetting(
    String label,
    String value,
    List<String> options,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              DropdownButton<String>(
                value: value,
                isExpanded: true,
                items: options.map((option) {
                  return DropdownMenuItem(value: option, child: Text(option));
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      if (label == 'Timezone')
                        _systemSettings['general']['timezone'] = newValue;
                      if (label == 'Language')
                        _systemSettings['general']['language'] = newValue;
                      if (label == 'Date Format')
                        _systemSettings['general']['dateFormat'] = newValue;
                      if (label == 'Backup Frequency')
                        _systemSettings['backup']['backupFrequency'] = newValue;
                    });
                    _markAsChanged();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliderSetting(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(
              '${value.toInt()}',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSwitchSetting(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.success,
        ),
      ],
    );
  }

  void _markAsChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  Future<void> _saveConfiguration() async {
    setState(() => _isLoading = true);

    // Update general settings from controllers
    _systemSettings['general']['universityName'] =
        _universityNameController.text;
    _systemSettings['general']['currentSemester'] = _semesterController.text;
    _systemSettings['general']['academicYear'] = _academicYearController.text;
    _systemSettings['general']['contactEmail'] = _emailController.text;
    _systemSettings['general']['contactPhone'] = _phoneController.text;
    _systemSettings['general']['address'] = _addressController.text;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _hasUnsavedChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuration saved successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<bool?> _showUnsavedChangesDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
          'You have unsaved changes. Do you want to save them before leaving?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _saveConfiguration();
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text(
          'This will reset all settings to their default values. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _loadSystemConfiguration();
              _initializeControllers();
              setState(() => _hasUnsavedChanges = false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to defaults')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _addDepartment() {
    // TODO: Implement add department dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add department feature coming soon')),
    );
  }

  void _editDepartment(Map<String, dynamic> dept) {
    // TODO: Implement edit department dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit department ${dept['name']} feature coming soon'),
      ),
    );
  }

  void _deleteDepartment(Map<String, dynamic> dept) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Department'),
        content: Text(
          'Are you sure you want to delete the ${dept['name']} department?',
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
                _departments.remove(dept);
              });
              _markAsChanged();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${dept['name']} department deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addEvaluationCriteria() {
    // TODO: Implement add criteria dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add evaluation criteria feature coming soon'),
      ),
    );
  }

  void _editCriteria(Map<String, dynamic> criteria) {
    // TODO: Implement edit criteria dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit criteria ${criteria['name']} feature coming soon'),
      ),
    );
  }

  void _deleteCriteria(Map<String, dynamic> criteria) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Criteria'),
        content: Text(
          'Are you sure you want to delete the ${criteria['name']} criteria?',
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
                _evaluationCriteria.remove(criteria);
              });
              _markAsChanged();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${criteria['name']} criteria deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _exportConfiguration() {
    // TODO: Implement configuration export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export configuration feature coming soon')),
    );
  }

  void _importConfiguration() {
    // TODO: Implement configuration import
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import configuration feature coming soon')),
    );
  }
}
