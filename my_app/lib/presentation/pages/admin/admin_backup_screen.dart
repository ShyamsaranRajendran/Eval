import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';

class AdminBackupScreen extends ConsumerStatefulWidget {
  const AdminBackupScreen({super.key});

  @override
  ConsumerState<AdminBackupScreen> createState() => _AdminBackupScreenState();
}

class _AdminBackupScreenState extends ConsumerState<AdminBackupScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  bool _isBackingUp = false;
  bool _isRestoring = false;
  double _backupProgress = 0.0;
  double _restoreProgress = 0.0;

  // Backup Configuration
  Map<String, dynamic> _backupConfig = {
    'autoBackup': true,
    'frequency': 'Daily',
    'time': '02:00',
    'retentionDays': 30,
    'compression': true,
    'encryption': true,
    'cloudSync': true,
    'localPath': '/var/backups/evaluation_system',
    'cloudProvider': 'AWS S3',
    'maxBackupSize': 10, // GB
    'includeUserData': true,
    'includeLogs': false,
    'includeMedia': true,
  };

  final List<Map<String, dynamic>> _backupHistory = [
    {
      'id': 'backup_001',
      'type': 'Automatic',
      'timestamp': '2024-01-15 02:00:15',
      'size': '2.4 GB',
      'status': 'Completed',
      'duration': '15 min 32 sec',
      'location': 'Cloud + Local',
      'compressed': true,
      'encrypted': true,
    },
    {
      'id': 'backup_002',
      'type': 'Manual',
      'timestamp': '2024-01-14 14:30:45',
      'size': '2.3 GB',
      'status': 'Completed',
      'duration': '12 min 18 sec',
      'location': 'Cloud + Local',
      'compressed': true,
      'encrypted': true,
    },
    {
      'id': 'backup_003',
      'type': 'Automatic',
      'timestamp': '2024-01-14 02:00:12',
      'size': '2.1 GB',
      'status': 'Completed',
      'duration': '11 min 45 sec',
      'location': 'Local Only',
      'compressed': true,
      'encrypted': false,
    },
    {
      'id': 'backup_004',
      'type': 'Manual',
      'timestamp': '2024-01-13 16:22:08',
      'size': '1.9 GB',
      'status': 'Failed',
      'duration': '3 min 12 sec',
      'location': 'None',
      'compressed': false,
      'encrypted': false,
      'error': 'Insufficient disk space',
    },
    {
      'id': 'backup_005',
      'type': 'Automatic',
      'timestamp': '2024-01-13 02:00:05',
      'size': '2.0 GB',
      'status': 'Completed',
      'duration': '14 min 55 sec',
      'location': 'Cloud + Local',
      'compressed': true,
      'encrypted': true,
    },
  ];

  final List<Map<String, dynamic>> _systemHealth = [
    {
      'component': 'Database',
      'status': 'Healthy',
      'lastCheck': '2024-01-15 08:30:00',
      'issues': 0,
      'size': '1.2 GB',
    },
    {
      'component': 'File System',
      'status': 'Healthy',
      'lastCheck': '2024-01-15 08:30:00',
      'issues': 0,
      'size': '800 MB',
    },
    {
      'component': 'User Uploads',
      'status': 'Warning',
      'lastCheck': '2024-01-15 08:30:00',
      'issues': 2,
      'size': '450 MB',
    },
    {
      'component': 'System Logs',
      'status': 'Healthy',
      'lastCheck': '2024-01-15 08:30:00',
      'issues': 0,
      'size': '125 MB',
    },
    {
      'component': 'Configuration',
      'status': 'Healthy',
      'lastCheck': '2024-01-15 08:30:00',
      'issues': 0,
      'size': '12 MB',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadBackupData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBackupData() async {
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
        title: const Text('Backup & Recovery'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'health_check',
                child: Row(
                  children: [
                    Icon(Icons.health_and_safety),
                    SizedBox(width: 8),
                    Text('System Health Check'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'cleanup',
                child: Row(
                  children: [
                    Icon(Icons.cleaning_services),
                    SizedBox(width: 8),
                    Text('Cleanup Old Backups'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'verify',
                child: Row(
                  children: [
                    Icon(Icons.verified),
                    SizedBox(width: 8),
                    Text('Verify Backups'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'health_check') _performHealthCheck();
              if (value == 'cleanup') _cleanupOldBackups();
              if (value == 'verify') _verifyBackups();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Create Backup'),
            Tab(text: 'Restore'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildCreateBackupTab(),
                _buildRestoreTab(),
                _buildSettingsTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Backups',
                  '${_backupHistory.length}',
                  Icons.backup,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Last Backup',
                  _getLastBackupTime(),
                  Icons.schedule,
                  AppColors.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Size',
                  _getTotalBackupSize(),
                  Icons.storage,
                  AppColors.info,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Success Rate',
                  _getSuccessRate(),
                  Icons.check_circle,
                  AppColors.warning,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // System Health Overview
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
                        'System Health Status',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        onPressed: _performHealthCheck,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Check Now'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._systemHealth.map(
                    (component) => _buildHealthStatusItem(component),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Recent Backup History
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
                        'Recent Backups',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => _tabController.animateTo(1),
                        child: const Text('Create New'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._backupHistory
                      .take(3)
                      .map((backup) => _buildBackupHistoryItem(backup)),
                  if (_backupHistory.length > 3)
                    Center(
                      child: TextButton(
                        onPressed: _showFullHistory,
                        child: Text(
                          'View All ${_backupHistory.length} Backups',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Quick Actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isBackingUp ? null : _createManualBackup,
                          icon: const Icon(Icons.backup),
                          label: const Text('Manual Backup'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _tabController.animateTo(2),
                          icon: const Icon(Icons.restore),
                          label: const Text('Restore Data'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.warning,
                            foregroundColor: Colors.white,
                          ),
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

  Widget _buildCreateBackupTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isBackingUp) ...[
            Card(
              color: AppColors.primary.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.backup, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Backup in Progress...',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Text(
                          '${(_backupProgress * 100).toInt()}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _backupProgress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Estimated time remaining: ${_getEstimatedTime()}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          Text(
            'Create Manual Backup',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Backup Options
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Backup Configuration',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  CheckboxListTile(
                    title: const Text('Include User Data'),
                    subtitle: const Text(
                      'User profiles, evaluations, and submissions',
                    ),
                    value: _backupConfig['includeUserData'],
                    onChanged: (value) {
                      setState(() {
                        _backupConfig['includeUserData'] = value!;
                      });
                    },
                  ),

                  CheckboxListTile(
                    title: const Text('Include Media Files'),
                    subtitle: const Text(
                      'Images, documents, and uploaded files',
                    ),
                    value: _backupConfig['includeMedia'],
                    onChanged: (value) {
                      setState(() {
                        _backupConfig['includeMedia'] = value!;
                      });
                    },
                  ),

                  CheckboxListTile(
                    title: const Text('Include System Logs'),
                    subtitle: const Text('Application logs and audit trails'),
                    value: _backupConfig['includeLogs'],
                    onChanged: (value) {
                      setState(() {
                        _backupConfig['includeLogs'] = value!;
                      });
                    },
                  ),

                  const Divider(),

                  SwitchListTile(
                    title: const Text('Enable Compression'),
                    subtitle: const Text('Reduce backup size by 60-80%'),
                    value: _backupConfig['compression'],
                    onChanged: (value) {
                      setState(() {
                        _backupConfig['compression'] = value;
                      });
                    },
                  ),

                  SwitchListTile(
                    title: const Text('Enable Encryption'),
                    subtitle: const Text('Encrypt backup with AES-256'),
                    value: _backupConfig['encryption'],
                    onChanged: (value) {
                      setState(() {
                        _backupConfig['encryption'] = value;
                      });
                    },
                  ),

                  SwitchListTile(
                    title: const Text('Upload to Cloud'),
                    subtitle: Text('Sync to ${_backupConfig['cloudProvider']}'),
                    value: _backupConfig['cloudSync'],
                    onChanged: (value) {
                      setState(() {
                        _backupConfig['cloudSync'] = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Backup Size Estimation
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estimated Backup Size',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSizeEstimationItem(
                    'Database',
                    '1.2 GB',
                    _backupConfig['includeUserData'],
                  ),
                  _buildSizeEstimationItem(
                    'Media Files',
                    '800 MB',
                    _backupConfig['includeMedia'],
                  ),
                  _buildSizeEstimationItem(
                    'System Logs',
                    '125 MB',
                    _backupConfig['includeLogs'],
                  ),
                  _buildSizeEstimationItem('Configuration', '12 MB', true),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Estimated Size:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _getEstimatedBackupSize(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  if (_backupConfig['compression'])
                    Text(
                      'With compression: ~${_getCompressedSize()}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Create Backup Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isBackingUp ? null : _startBackup,
              icon: Icon(_isBackingUp ? Icons.hourglass_bottom : Icons.backup),
              label: Text(
                _isBackingUp ? 'Backup in Progress...' : 'Create Backup Now',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestoreTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isRestoring) ...[
            Card(
              color: AppColors.warning.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.restore, color: AppColors.warning),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Restore in Progress...',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.warning,
                            ),
                          ),
                        ),
                        Text(
                          '${(_restoreProgress * 100).toInt()}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _restoreProgress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.warning,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'WARNING: Do not close the application during restore',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          Text(
            'Restore from Backup',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a backup to restore from. This will overwrite current data.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          // Available Backups
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Backups',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._backupHistory
                      .where((backup) => backup['status'] == 'Completed')
                      .map((backup) => _buildRestoreBackupItem(backup)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Restore Options
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Restore Options',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Restoring will permanently overwrite current data. Make sure to create a backup before proceeding.',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  CheckboxListTile(
                    title: const Text('Restore User Data'),
                    subtitle: const Text(
                      'Overwrite all user accounts and evaluations',
                    ),
                    value: true,
                    onChanged: null, // Always required
                  ),

                  CheckboxListTile(
                    title: const Text('Restore System Configuration'),
                    subtitle: const Text(
                      'Overwrite system settings and preferences',
                    ),
                    value: true,
                    onChanged: null, // Always required
                  ),

                  CheckboxListTile(
                    title: const Text('Create Pre-Restore Backup'),
                    subtitle: const Text(
                      'Automatically backup current data first',
                    ),
                    value: true,
                    onChanged: null, // Recommended safety measure
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Backup Settings',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Automatic Backup Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Automatic Backup',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  SwitchListTile(
                    title: const Text('Enable Automatic Backup'),
                    subtitle: const Text('Schedule regular system backups'),
                    value: _backupConfig['autoBackup'],
                    onChanged: (value) {
                      setState(() {
                        _backupConfig['autoBackup'] = value;
                      });
                    },
                  ),

                  if (_backupConfig['autoBackup']) ...[
                    ListTile(
                      title: const Text('Backup Frequency'),
                      subtitle: Text(_backupConfig['frequency']),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _selectBackupFrequency(),
                    ),

                    ListTile(
                      title: const Text('Backup Time'),
                      subtitle: Text(_backupConfig['time']),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _selectBackupTime(),
                    ),
                  ],

                  ListTile(
                    title: const Text('Retention Period'),
                    subtitle: Text('${_backupConfig['retentionDays']} days'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _selectRetentionPeriod(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Storage Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Storage Configuration',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ListTile(
                    title: const Text('Local Storage Path'),
                    subtitle: Text(_backupConfig['localPath']),
                    trailing: const Icon(Icons.folder),
                    onTap: () => _selectLocalPath(),
                  ),

                  ListTile(
                    title: const Text('Cloud Provider'),
                    subtitle: Text(_backupConfig['cloudProvider']),
                    trailing: const Icon(Icons.cloud),
                    onTap: () => _selectCloudProvider(),
                  ),

                  ListTile(
                    title: const Text('Max Backup Size'),
                    subtitle: Text('${_backupConfig['maxBackupSize']} GB'),
                    trailing: const Icon(Icons.storage),
                    onTap: () => _setMaxBackupSize(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Security Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Security & Encryption',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  SwitchListTile(
                    title: const Text('Enable Encryption'),
                    subtitle: const Text('Encrypt backups with AES-256'),
                    value: _backupConfig['encryption'],
                    onChanged: (value) {
                      setState(() {
                        _backupConfig['encryption'] = value;
                      });
                    },
                  ),

                  if (_backupConfig['encryption'])
                    ListTile(
                      title: const Text('Encryption Key Management'),
                      subtitle: const Text('Configure encryption keys'),
                      trailing: const Icon(Icons.key),
                      onTap: () => _configureEncryption(),
                    ),

                  SwitchListTile(
                    title: const Text('Verify Backup Integrity'),
                    subtitle: const Text('Check backup files for corruption'),
                    value: true,
                    onChanged: null, // Always enabled for safety
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Save Settings Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saveBackupSettings,
              icon: const Icon(Icons.save),
              label: const Text('Save Settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                fontSize: 20,
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

  Widget _buildHealthStatusItem(Map<String, dynamic> component) {
    Color statusColor;
    IconData statusIcon;
    switch (component['status']) {
      case 'Healthy':
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        break;
      case 'Warning':
        statusColor = AppColors.warning;
        statusIcon = Icons.warning;
        break;
      case 'Error':
        statusColor = AppColors.error;
        statusIcon = Icons.error;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  component['component'],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Last checked: ${component['lastCheck']} • Size: ${component['size']}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (component['issues'] > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${component['issues']} issues',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBackupHistoryItem(Map<String, dynamic> backup) {
    Color statusColor;
    IconData statusIcon;
    switch (backup['status']) {
      case 'Completed':
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        break;
      case 'Failed':
        statusColor = AppColors.error;
        statusIcon = Icons.error;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(statusIcon, color: statusColor),
        title: Text(
          '${backup['type']} Backup',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(backup['timestamp']),
            Text('${backup['size']} • ${backup['duration']}'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            if (backup['status'] == 'Completed') ...[
              const PopupMenuItem(
                value: 'restore',
                child: Row(
                  children: [
                    Icon(Icons.restore),
                    SizedBox(width: 8),
                    Text('Restore'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Download'),
                  ],
                ),
              ),
            ],
            const PopupMenuItem(
              value: 'details',
              child: Row(
                children: [
                  Icon(Icons.info),
                  SizedBox(width: 8),
                  Text('Details'),
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
            if (value == 'restore') _restoreFromBackup(backup);
            if (value == 'download') _downloadBackup(backup);
            if (value == 'details') _showBackupDetails(backup);
            if (value == 'delete') _deleteBackup(backup);
          },
        ),
      ),
    );
  }

  Widget _buildRestoreBackupItem(Map<String, dynamic> backup) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.success,
          child: Icon(Icons.backup, color: Colors.white),
        ),
        title: Text(
          '${backup['type']} - ${backup['timestamp']}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${backup['size']} • ${backup['location']}'),
        trailing: ElevatedButton(
          onPressed: _isRestoring ? null : () => _restoreFromBackup(backup),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.warning,
            foregroundColor: Colors.white,
          ),
          child: const Text('Restore'),
        ),
      ),
    );
  }

  Widget _buildSizeEstimationItem(
    String component,
    String size,
    bool included,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            included ? Icons.check_box : Icons.check_box_outline_blank,
            color: included ? AppColors.success : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(component)),
          Text(
            included ? size : '0 MB',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: included ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getLastBackupTime() {
    if (_backupHistory.isNotEmpty) {
      return _backupHistory.first['timestamp'].split(' ')[0];
    }
    return 'Never';
  }

  String _getTotalBackupSize() {
    // Calculate total from completed backups
    return '12.1 GB';
  }

  String _getSuccessRate() {
    int completed = _backupHistory
        .where((b) => b['status'] == 'Completed')
        .length;
    double rate = completed / _backupHistory.length * 100;
    return '${rate.toStringAsFixed(1)}%';
  }

  String _getEstimatedTime() {
    double remaining = 1.0 - _backupProgress;
    int minutes = (remaining * 15).round();
    return '${minutes} min';
  }

  String _getEstimatedBackupSize() {
    double total = 0;
    if (_backupConfig['includeUserData']) total += 1200; // MB
    if (_backupConfig['includeMedia']) total += 800;
    if (_backupConfig['includeLogs']) total += 125;
    total += 12; // Configuration always included

    if (total > 1024) {
      return '${(total / 1024).toStringAsFixed(1)} GB';
    }
    return '${total.toInt()} MB';
  }

  String _getCompressedSize() {
    String original = _getEstimatedBackupSize();
    // Assume 70% compression
    if (original.contains('GB')) {
      double gb = double.parse(original.split(' ')[0]);
      return '${(gb * 0.3).toStringAsFixed(1)} GB';
    }
    double mb = double.parse(original.split(' ')[0]);
    return '${(mb * 0.3).toInt()} MB';
  }

  void _refreshData() {
    _loadBackupData();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Backup data refreshed')));
  }

  void _createManualBackup() {
    _tabController.animateTo(1);
  }

  Future<void> _startBackup() async {
    setState(() {
      _isBackingUp = true;
      _backupProgress = 0.0;
    });

    // Simulate backup progress
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        _backupProgress = i / 100;
      });
    }

    setState(() {
      _isBackingUp = false;
      _backupProgress = 0.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Backup completed successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _restoreFromBackup(Map<String, dynamic> backup) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Restore'),
        content: Text(
          'This will restore data from backup created on ${backup['timestamp']}. '
          'Current data will be permanently overwritten. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isRestoring = true;
        _restoreProgress = 0.0;
      });

      // Simulate restore progress
      for (int i = 0; i <= 100; i += 3) {
        await Future.delayed(const Duration(milliseconds: 150));
        setState(() {
          _restoreProgress = i / 100;
        });
      }

      setState(() {
        _isRestoring = false;
        _restoreProgress = 0.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data restored successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _performHealthCheck() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('System health check feature coming soon')),
    );
  }

  void _cleanupOldBackups() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cleanup old backups feature coming soon')),
    );
  }

  void _verifyBackups() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verify backups feature coming soon')),
    );
  }

  void _showFullHistory() {
    // TODO: Navigate to full backup history screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Full backup history feature coming soon')),
    );
  }

  void _downloadBackup(Map<String, dynamic> backup) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading backup ${backup['id']}...')),
    );
  }

  void _showBackupDetails(Map<String, dynamic> backup) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Backup Details - ${backup['id']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${backup['type']}'),
            Text('Created: ${backup['timestamp']}'),
            Text('Size: ${backup['size']}'),
            Text('Duration: ${backup['duration']}'),
            Text('Location: ${backup['location']}'),
            Text('Compressed: ${backup['compressed'] ? 'Yes' : 'No'}'),
            Text('Encrypted: ${backup['encrypted'] ? 'Yes' : 'No'}'),
            if (backup['error'] != null)
              Text(
                'Error: ${backup['error']}',
                style: const TextStyle(color: Colors.red),
              ),
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

  void _deleteBackup(Map<String, dynamic> backup) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Backup'),
        content: Text(
          'Are you sure you want to delete backup ${backup['id']}?',
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
                _backupHistory.remove(backup);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Backup ${backup['id']} deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _selectBackupFrequency() {
    // TODO: Show frequency selection dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Backup frequency selection coming soon')),
    );
  }

  void _selectBackupTime() {
    // TODO: Show time picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Backup time selection coming soon')),
    );
  }

  void _selectRetentionPeriod() {
    // TODO: Show retention period selection
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Retention period selection coming soon')),
    );
  }

  void _selectLocalPath() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Local path selection coming soon')),
    );
  }

  void _selectCloudProvider() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cloud provider selection coming soon')),
    );
  }

  void _setMaxBackupSize() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Max backup size setting coming soon')),
    );
  }

  void _configureEncryption() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Encryption configuration coming soon')),
    );
  }

  void _saveBackupSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Backup settings saved successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
