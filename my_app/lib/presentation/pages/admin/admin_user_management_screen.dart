import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';

class AdminUserManagementScreen extends ConsumerStatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  ConsumerState<AdminUserManagementScreen> createState() =>
      _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState
    extends ConsumerState<AdminUserManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _selectedRoleFilter = 'All Users';
  String _selectedDepartmentFilter = 'All Departments';
  String _selectedStatusFilter = 'All Status';
  bool _isLoading = false;
  List<String> _selectedUsers = [];

  // Mock user data
  final List<Map<String, dynamic>> _users = [
    {
      'id': 'USER_001',
      'name': 'Dr. Michael Chen',
      'email': 'michael.chen@university.edu',
      'role': 'Faculty',
      'department': 'Computer Science',
      'phone': '+1-555-0101',
      'status': 'Active',
      'lastLogin': '2024-01-25 09:30 AM',
      'joinDate': '2022-08-15',
      'avatar': 'MC',
      'permissions': ['Evaluate Students', 'View Reports', 'Manage Profile'],
      'panelsAssigned': 3,
      'evaluationsCompleted': 45,
      'averageRating': 4.8,
    },
    {
      'id': 'USER_002',
      'name': 'Prof. Lisa Wang',
      'email': 'lisa.wang@university.edu',
      'role': 'Faculty',
      'department': 'Computer Science',
      'phone': '+1-555-0102',
      'status': 'Active',
      'lastLogin': '2024-01-24 02:15 PM',
      'joinDate': '2021-09-01',
      'avatar': 'LW',
      'permissions': ['Evaluate Students', 'View Reports', 'Manage Profile'],
      'panelsAssigned': 2,
      'evaluationsCompleted': 38,
      'averageRating': 4.9,
    },
    {
      'id': 'USER_003',
      'name': 'Dr. Sarah Johnson',
      'email': 'sarah.johnson@university.edu',
      'role': 'Coordinator',
      'department': 'Computer Science',
      'phone': '+1-555-0103',
      'status': 'Active',
      'lastLogin': '2024-01-25 11:45 AM',
      'joinDate': '2020-01-10',
      'avatar': 'SJ',
      'permissions': [
        'Manage Panels',
        'Assign Faculty',
        'Generate Reports',
        'System Configuration',
      ],
      'panelsManaged': 8,
      'facultyManaged': 25,
      'averageRating': 4.7,
    },
    {
      'id': 'USER_004',
      'name': 'John Smith',
      'email': 'john.smith@student.university.edu',
      'role': 'Student',
      'department': 'Computer Science',
      'phone': '+1-555-0104',
      'status': 'Active',
      'lastLogin': '2024-01-24 07:20 PM',
      'joinDate': '2021-09-01',
      'avatar': 'JS',
      'permissions': ['View Evaluations', 'Update Profile'],
      'projectsSubmitted': 1,
      'evaluationsReceived': 3,
      'averageScore': 85.5,
    },
    {
      'id': 'USER_005',
      'name': 'Dr. Robert Wilson',
      'email': 'robert.wilson@university.edu',
      'role': 'Admin',
      'department': 'Administration',
      'phone': '+1-555-0105',
      'status': 'Active',
      'lastLogin': '2024-01-25 08:00 AM',
      'joinDate': '2019-03-15',
      'avatar': 'RW',
      'permissions': [
        'Full System Access',
        'User Management',
        'System Configuration',
        'Analytics',
      ],
      'usersManaged': 1250,
      'systemUptime': 99.8,
    },
    {
      'id': 'USER_006',
      'name': 'Emma Davis',
      'email': 'emma.davis@student.university.edu',
      'role': 'Student',
      'department': 'Information Technology',
      'phone': '+1-555-0106',
      'status': 'Pending Approval',
      'lastLogin': 'Never',
      'joinDate': '2024-01-20',
      'avatar': 'ED',
      'permissions': ['Pending'],
      'projectsSubmitted': 0,
      'evaluationsReceived': 0,
      'averageScore': 0,
    },
    {
      'id': 'USER_007',
      'name': 'Prof. Ahmed Hassan',
      'email': 'ahmed.hassan@university.edu',
      'role': 'Faculty',
      'department': 'Electronics Engineering',
      'phone': '+1-555-0107',
      'status': 'Inactive',
      'lastLogin': '2023-12-15 03:30 PM',
      'joinDate': '2018-06-10',
      'avatar': 'AH',
      'permissions': ['Limited Access'],
      'panelsAssigned': 0,
      'evaluationsCompleted': 127,
      'averageRating': 4.6,
    },
  ];

  List<Map<String, dynamic>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _filteredUsers = List.from(_users);
    _loadUsers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    _filterUsers();
  }

  void _filterUsers() {
    setState(() {
      _filteredUsers = _users.where((user) {
        // Search filter
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch =
            searchQuery.isEmpty ||
            user['name'].toString().toLowerCase().contains(searchQuery) ||
            user['email'].toString().toLowerCase().contains(searchQuery) ||
            user['department'].toString().toLowerCase().contains(searchQuery);

        // Role filter
        final matchesRole =
            _selectedRoleFilter == 'All Users' ||
            user['role'] == _selectedRoleFilter;

        // Department filter
        final matchesDepartment =
            _selectedDepartmentFilter == 'All Departments' ||
            user['department'] == _selectedDepartmentFilter;

        // Status filter
        final matchesStatus =
            _selectedStatusFilter == 'All Status' ||
            user['status'] == _selectedStatusFilter;

        return matchesSearch &&
            matchesRole &&
            matchesDepartment &&
            matchesStatus;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_selectedUsers.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _showBulkDeleteDialog,
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _showBulkEditDialog,
            ),
          ],
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(icon: const Icon(Icons.download), onPressed: _exportUsers),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(Icons.upload),
                    SizedBox(width: 8),
                    Text('Import Users'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'backup',
                child: Row(
                  children: [
                    Icon(Icons.backup),
                    SizedBox(width: 8),
                    Text('Backup Users'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'import') _importUsers();
              if (value == 'backup') _backupUsers();
            },
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
                _selectedRoleFilter = 'All Users';
                break;
              case 1:
                _selectedRoleFilter = 'Faculty';
                break;
              case 2:
                _selectedRoleFilter = 'Student';
                break;
              case 3:
                _selectedRoleFilter = 'Admin';
                break;
            }
            _filterUsers();
          },
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('All Users'),
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
                      '${_users.length}',
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
                  const Text('Faculty'),
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
                      '${_users.where((u) => u['role'] == 'Faculty').length}',
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
                  const Text('Students'),
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
                      '${_users.where((u) => u['role'] == 'Student').length}',
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
                  const Text('Admins'),
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
                      '${_users.where((u) => u['role'] == 'Admin').length}',
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
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _searchController,
                    label: 'Search users by name, email, or department...',
                    prefixIcon: Icons.search,
                    onChanged: (_) => _filterUsers(),
                  ),
                ),
                if (_selectedUsers.isNotEmpty) ...[
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_selectedUsers.length} selected',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Statistics Overview
          _buildStatisticsOverview(),

          // Users List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadUsers,
                    child: _filteredUsers.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = _filteredUsers[index];
                              return _buildUserCard(user);
                            },
                          ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewUser,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add),
        label: const Text('Add User'),
      ),
    );
  }

  Widget _buildStatisticsOverview() {
    final activeUsers = _users.where((u) => u['status'] == 'Active').length;
    final pendingUsers = _users
        .where((u) => u['status'] == 'Pending Approval')
        .length;
    final inactiveUsers = _users.where((u) => u['status'] == 'Inactive').length;
    final facultyCount = _users.where((u) => u['role'] == 'Faculty').length;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem('Active', '$activeUsers', AppColors.success),
          ),
          Expanded(
            child: _buildStatItem(
              'Pending',
              '$pendingUsers',
              AppColors.warning,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              'Inactive',
              '$inactiveUsers',
              AppColors.error,
            ),
          ),
          Expanded(
            child: _buildStatItem('Faculty', '$facultyCount', AppColors.info),
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
              Icons.people_outline,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No users found',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first user to get started with user management.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(text: 'Add User', onPressed: _createNewUser),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final isSelected = _selectedUsers.contains(user['id']);
    final roleColor = _getRoleColor(user['role']);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showUserDetails(user),
        onLongPress: () => _toggleUserSelection(user['id']),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      backgroundColor: roleColor.withOpacity(0.1),
                      radius: 24,
                      child: Text(
                        user['avatar'],
                        style: TextStyle(
                          color: roleColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['name'],
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user['email'],
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          Text(
                            user['department'],
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),

                    // Status and Role Badges
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildStatusBadge(user['status']),
                        const SizedBox(height: 4),
                        _buildRoleBadge(user['role']),
                        const SizedBox(height: 4),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 20,
                          ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // User Statistics
                if (user['role'] == 'Faculty') ...[
                  Row(
                    children: [
                      _buildUserStat(
                        'Panels',
                        '${user['panelsAssigned']}',
                        Icons.dashboard,
                      ),
                      const SizedBox(width: 16),
                      _buildUserStat(
                        'Evaluations',
                        '${user['evaluationsCompleted']}',
                        Icons.assignment_turned_in,
                      ),
                      const SizedBox(width: 16),
                      _buildUserStat(
                        'Rating',
                        '${user['averageRating']}/5',
                        Icons.star,
                      ),
                    ],
                  ),
                ] else if (user['role'] == 'Student') ...[
                  Row(
                    children: [
                      _buildUserStat(
                        'Projects',
                        '${user['projectsSubmitted']}',
                        Icons.assignment,
                      ),
                      const SizedBox(width: 16),
                      _buildUserStat(
                        'Evaluations',
                        '${user['evaluationsReceived']}',
                        Icons.grading,
                      ),
                      const SizedBox(width: 16),
                      _buildUserStat(
                        'Score',
                        '${user['averageScore']}%',
                        Icons.score,
                      ),
                    ],
                  ),
                ] else if (user['role'] == 'Coordinator') ...[
                  Row(
                    children: [
                      _buildUserStat(
                        'Panels',
                        '${user['panelsManaged']}',
                        Icons.dashboard,
                      ),
                      const SizedBox(width: 16),
                      _buildUserStat(
                        'Faculty',
                        '${user['facultyManaged']}',
                        Icons.people,
                      ),
                      const SizedBox(width: 16),
                      _buildUserStat(
                        'Rating',
                        '${user['averageRating']}/5',
                        Icons.star,
                      ),
                    ],
                  ),
                ] else if (user['role'] == 'Admin') ...[
                  Row(
                    children: [
                      _buildUserStat(
                        'Users',
                        '${user['usersManaged']}',
                        Icons.people,
                      ),
                      const SizedBox(width: 16),
                      _buildUserStat(
                        'Uptime',
                        '${user['systemUptime']}%',
                        Icons.trending_up,
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 16),

                // Contact and Activity Info
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                user['phone'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Joined: ${user['joinDate']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Last Login',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          user['lastLogin'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
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
                    if (user['status'] == 'Pending Approval') ...[
                      TextButton.icon(
                        onPressed: () => _approveUser(user),
                        icon: const Icon(Icons.check, size: 16),
                        label: const Text('Approve'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () => _rejectUser(user),
                        icon: const Icon(Icons.close, size: 16),
                        label: const Text('Reject'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.error,
                        ),
                      ),
                    ] else ...[
                      TextButton.icon(
                        onPressed: () => _editUser(user),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () => _showUserDetails(user),
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('Details'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.info,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    final color = _getRoleColor(role);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUserStat(String label, String value, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return AppColors.success;
      case 'Pending Approval':
        return AppColors.warning;
      case 'Inactive':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin':
        return AppColors.error;
      case 'Coordinator':
        return AppColors.warning;
      case 'Faculty':
        return AppColors.primary;
      case 'Student':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  void _toggleUserSelection(String userId) {
    setState(() {
      if (_selectedUsers.contains(userId)) {
        _selectedUsers.remove(userId);
      } else {
        _selectedUsers.add(userId);
      }
    });
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
              'Filter Users',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Role Filter
            Text(
              'Filter by Role',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children:
                  [
                    'All Users',
                    'Admin',
                    'Coordinator',
                    'Faculty',
                    'Student',
                  ].map((role) {
                    final isSelected = _selectedRoleFilter == role;
                    return FilterChip(
                      label: Text(role),
                      selected: isSelected,
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      checkmarkColor: AppColors.primary,
                      onSelected: (selected) {
                        setState(() => _selectedRoleFilter = role);
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 20),

            // Status Filter
            Text(
              'Filter by Status',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ['All Status', 'Active', 'Pending Approval', 'Inactive']
                  .map((status) {
                    final isSelected = _selectedStatusFilter == status;
                    return FilterChip(
                      label: Text(status),
                      selected: isSelected,
                      selectedColor: AppColors.success.withOpacity(0.2),
                      checkmarkColor: AppColors.success,
                      onSelected: (selected) {
                        setState(() => _selectedStatusFilter = status);
                      },
                    );
                  })
                  .toList(),
            ),

            const SizedBox(height: 20),

            // Department Filter
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
                    'Administration',
                  ].map((dept) {
                    final isSelected = _selectedDepartmentFilter == dept;
                    return FilterChip(
                      label: Text(dept),
                      selected: isSelected,
                      selectedColor: AppColors.info.withOpacity(0.2),
                      checkmarkColor: AppColors.info,
                      onSelected: (selected) {
                        setState(() => _selectedDepartmentFilter = dept);
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 20),
            CustomButton(
              text: 'Apply Filters',
              onPressed: () {
                Navigator.pop(context);
                _filterUsers();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUserDetails(Map<String, dynamic> user) {
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
                      user['name'],
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

              // Detailed user information would go here
              Text('User details coming soon...'),
            ],
          ),
        ),
      ),
    );
  }

  void _createNewUser() {
    // TODO: Navigate to create user screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create user feature coming soon')),
    );
  }

  void _editUser(Map<String, dynamic> user) {
    // TODO: Navigate to edit user screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit user ${user['name']} feature coming soon')),
    );
  }

  void _approveUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve User'),
        content: Text('Are you sure you want to approve ${user['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                user['status'] = 'Active';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${user['name']} approved successfully'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _rejectUser(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject User'),
        content: Text('Are you sure you want to reject ${user['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _users.removeWhere((u) => u['id'] == user['id']);
              });
              _filterUsers();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${user['name']} rejected')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _showBulkDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Selected Users'),
        content: Text(
          'Are you sure you want to delete ${_selectedUsers.length} selected users?',
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
                _users.removeWhere((u) => _selectedUsers.contains(u['id']));
                _selectedUsers.clear();
              });
              _filterUsers();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Selected users deleted successfully'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showBulkEditDialog() {
    // TODO: Implement bulk edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bulk edit feature coming soon')),
    );
  }

  void _exportUsers() {
    // TODO: Implement user export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export users feature coming soon')),
    );
  }

  void _importUsers() {
    // TODO: Implement user import functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import users feature coming soon')),
    );
  }

  void _backupUsers() {
    // TODO: Implement user backup functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Backup users feature coming soon')),
    );
  }
}
