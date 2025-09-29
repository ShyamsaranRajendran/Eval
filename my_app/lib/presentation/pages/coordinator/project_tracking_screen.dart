// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../core/constants/colors.dart';
// import '../../../models/project_model.dart';
// import '../../../data/models/student_panel_models.dart';
// import '../../../data/models/user_models.dart';

// // Add project status enum
// enum ProjectStatus { proposal, inProgress, underReview, completed }

// class ProjectTrackingScreen extends ConsumerStatefulWidget {
//   const ProjectTrackingScreen({super.key});

//   @override
//   ConsumerState<ProjectTrackingScreen> createState() =>
//       _ProjectTrackingScreenState();
// }

// class _ProjectTrackingScreenState extends ConsumerState<ProjectTrackingScreen> {
//   final _searchController = TextEditingController();

//   List<ProjectModel> _projects = [];
//   List<ProjectModel> _filteredProjects = [];
//   ProjectStatus? _selectedStatusFilter;
//   String? _selectedDepartmentFilter;
//   bool _isLoading = true;
//   String _searchQuery = '';

//   final List<String> _departments = [
//     'Computer Science',
//     'Information Technology',
//     'Electronics Engineering',
//     'Software Engineering',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadProjects();
//     _searchController.addListener(_onSearchChanged);
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadProjects() async {
//     setState(() => _isLoading = true);

//     try {
//       await Future.delayed(const Duration(seconds: 1));

//       // Mock data
//       _projects = [
//         ProjectModel(),
//         ProjectModel(),
//         ProjectModel(),
//         ProjectModel(),
//         ProjectModel(),
//       ];

//       _filteredProjects = _projects;
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error loading projects: $e')));
//       }
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _onSearchChanged() {
//     setState(() {
//       _searchQuery = _searchController.text;
//       _filterProjects();
//     });
//   }

//   void _filterProjects() {
//     _filteredProjects = _projects.where((project) {
//       final matchesSearch =
//           _searchQuery.isEmpty ||
//           project.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//           project.description.toLowerCase().contains(
//             _searchQuery.toLowerCase(),
//           ) ||
//           project.department.toLowerCase().contains(_searchQuery.toLowerCase());

//       final matchesStatus =
//           _selectedStatusFilter == null ||
//           project.status == _selectedStatusFilter;
//       final matchesDepartment =
//           _selectedDepartmentFilter == null ||
//           project.department == _selectedDepartmentFilter;

//       return matchesSearch && matchesStatus && matchesDepartment;
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Project Tracking'),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list),
//             onPressed: _showFilterDialog,
//           ),
//           IconButton(icon: const Icon(Icons.refresh), onPressed: _loadProjects),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search Section
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: Colors.grey[100],
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText:
//                     'Search projects by title, description, or department',
//                 prefixIcon: const Icon(Icons.search),
//                 suffixIcon: _searchQuery.isNotEmpty
//                     ? IconButton(
//                         icon: const Icon(Icons.clear),
//                         onPressed: () => _searchController.clear(),
//                       )
//                     : null,
//                 border: const OutlineInputBorder(),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//           ),

//           // Filter chips
//           if (_selectedStatusFilter != null ||
//               _selectedDepartmentFilter != null)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Row(
//                 children: [
//                   const Text('Active filters: '),
//                   if (_selectedStatusFilter != null) ...[
//                     Chip(
//                       label: Text(
//                         _getStatusDisplayName(_selectedStatusFilter!),
//                       ),
//                       onDeleted: () {
//                         setState(() {
//                           _selectedStatusFilter = null;
//                           _filterProjects();
//                         });
//                       },
//                     ),
//                     const SizedBox(width: 8),
//                   ],
//                   if (_selectedDepartmentFilter != null) ...[
//                     Chip(
//                       label: Text(_selectedDepartmentFilter!),
//                       onDeleted: () {
//                         setState(() {
//                           _selectedDepartmentFilter = null;
//                           _filterProjects();
//                         });
//                       },
//                     ),
//                   ],
//                 ],
//               ),
//             ),

//           // Stats Row
//           Container(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: _buildStatCard(
//                     'Total',
//                     _projects.length.toString(),
//                     Icons.folder,
//                     AppColors.primary,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: _buildStatCard(
//                     'In Progress',
//                     _projects
//                         .where((p) => p.status == ProjectStatus.inProgress)
//                         .length
//                         .toString(),
//                     Icons.hourglass_empty,
//                     AppColors.warning,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: _buildStatCard(
//                     'Completed',
//                     _projects
//                         .where((p) => p.status == ProjectStatus.completed)
//                         .length
//                         .toString(),
//                     Icons.check_circle,
//                     AppColors.success,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: _buildStatCard(
//                     'Overdue',
//                     _projects
//                         .where(
//                           (p) =>
//                               p.deadline.isBefore(DateTime.now()) &&
//                               p.status != ProjectStatus.completed,
//                         )
//                         .length
//                         .toString(),
//                     Icons.warning,
//                     AppColors.error,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Projects List
//           Expanded(
//             child: _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : _filteredProjects.isEmpty
//                 ? _buildEmptyState()
//                 : RefreshIndicator(
//                     onRefresh: _loadProjects,
//                     child: ListView.builder(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: _filteredProjects.length,
//                       itemBuilder: (context, index) {
//                         final project = _filteredProjects[index];
//                         return _buildProjectCard(project);
//                       },
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard(
//     String title,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 24),
//             const SizedBox(height: 4),
//             Text(
//               value,
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//             Text(
//               title,
//               style: Theme.of(
//                 context,
//               ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProjectCard(ProjectModel project) {
//     final isOverdue =
//         project.deadline.isBefore(DateTime.now()) &&
//         project.status != ProjectStatus.completed;
//     final daysUntilDeadline = project.deadline
//         .difference(DateTime.now())
//         .inDays;

//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     project.title,
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: _getStatusColor(project.status).withOpacity(0.1),
//                     border: Border.all(color: _getStatusColor(project.status)),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     _getStatusDisplayName(project.status),
//                     style: TextStyle(
//                       color: _getStatusColor(project.status),
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 8),

//             // Description
//             Text(
//               project.description,
//               style: Theme.of(
//                 context,
//               ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),

//             const SizedBox(height: 12),

//             // Progress Bar
//             Row(
//               children: [
//                 const Icon(
//                   Icons.trending_up,
//                   size: 16,
//                   color: AppColors.textSecondary,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: LinearProgressIndicator(
//                     value: project.progress / 100,
//                     backgroundColor: Colors.grey[300],
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       project.progress >= 80
//                           ? AppColors.success
//                           : project.progress >= 50
//                           ? AppColors.warning
//                           : AppColors.error,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   '${project.progress.toInt()}%',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             // Project Info
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildInfoRow(Icons.school, project.department),
//                       const SizedBox(height: 4),
//                       _buildInfoRow(
//                         Icons.assignment,
//                         'Phase: ${project.currentPhase}',
//                       ),
//                     ],
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     _buildInfoRow(
//                       isOverdue ? Icons.error : Icons.schedule,
//                       isOverdue
//                           ? 'Overdue'
//                           : daysUntilDeadline >= 0
//                           ? '$daysUntilDeadline days left'
//                           : 'Completed',
//                       isOverdue ? AppColors.error : null,
//                     ),
//                     const SizedBox(height: 4),
//                     _buildInfoRow(
//                       Icons.calendar_today,
//                       'Due: ${_formatDate(project.deadline)}',
//                     ),
//                   ],
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             // Action Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton.icon(
//                   onPressed: () => _viewProjectDetails(project),
//                   icon: const Icon(Icons.visibility, size: 16),
//                   label: const Text('View Details'),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton.icon(
//                   onPressed: () => _trackProgress(project),
//                   icon: const Icon(Icons.timeline, size: 16),
//                   label: const Text('Track Progress'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String text, [Color? color]) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 14, color: color ?? AppColors.textSecondary),
//         const SizedBox(width: 4),
//         Text(
//           text,
//           style: Theme.of(context).textTheme.bodySmall?.copyWith(
//             color: color ?? AppColors.textSecondary,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           Text(
//             _searchQuery.isNotEmpty ||
//                     _selectedStatusFilter != null ||
//                     _selectedDepartmentFilter != null
//                 ? 'No projects found'
//                 : 'No projects assigned yet',
//             style: Theme.of(
//               context,
//             ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             _searchQuery.isNotEmpty ||
//                     _selectedStatusFilter != null ||
//                     _selectedDepartmentFilter != null
//                 ? 'Try adjusting your search or filters'
//                 : 'Projects will appear here once assigned',
//             style: Theme.of(
//               context,
//             ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 24),
//           if (_searchQuery.isNotEmpty ||
//               _selectedStatusFilter != null ||
//               _selectedDepartmentFilter != null)
//             ElevatedButton.icon(
//               onPressed: () {
//                 _searchController.clear();
//                 setState(() {
//                   _selectedStatusFilter = null;
//                   _selectedDepartmentFilter = null;
//                   _filterProjects();
//                 });
//               },
//               icon: const Icon(Icons.clear),
//               label: const Text('Clear Filters'),
//             ),
//         ],
//       ),
//     );
//   }

//   void _showFilterDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Filter Projects'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Status:',
//               style: TextStyle(fontWeight: FontWeight.w500),
//             ),
//             DropdownButton<ProjectStatus?>(
//               value: _selectedStatusFilter,
//               isExpanded: true,
//               hint: const Text('All Statuses'),
//               onChanged: (status) {
//                 setState(() => _selectedStatusFilter = status);
//               },
//               items: [
//                 const DropdownMenuItem<ProjectStatus?>(
//                   value: null,
//                   child: Text('All Statuses'),
//                 ),
//                 ...ProjectStatus.values.map(
//                   (status) => DropdownMenuItem(
//                     value: status,
//                     child: Text(_getStatusDisplayName(status)),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Department:',
//               style: TextStyle(fontWeight: FontWeight.w500),
//             ),
//             DropdownButton<String?>(
//               value: _selectedDepartmentFilter,
//               isExpanded: true,
//               hint: const Text('All Departments'),
//               onChanged: (department) {
//                 setState(() => _selectedDepartmentFilter = department);
//               },
//               items: [
//                 const DropdownMenuItem<String?>(
//                   value: null,
//                   child: Text('All Departments'),
//                 ),
//                 ..._departments.map(
//                   (dept) => DropdownMenuItem(value: dept, child: Text(dept)),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _filterProjects();
//             },
//             child: const Text('Apply Filters'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _viewProjectDetails(ProjectModel project) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProjectDetailsScreen(project: project),
//       ),
//     );
//   }

//   void _trackProgress(ProjectModel project) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProjectProgressScreen(project: project),
//       ),
//     );
//   }

//   String _getStatusDisplayName(ProjectStatus status) {
//     switch (status) {
//       case ProjectStatus.proposal:
//         return 'Proposal';
//       case ProjectStatus.inProgress:
//         return 'In Progress';
//       case ProjectStatus.underReview:
//         return 'Under Review';
//       case ProjectStatus.completed:
//         return 'Completed';
//     }
//   }

//   Color _getStatusColor(ProjectStatus status) {
//     switch (status) {
//       case ProjectStatus.proposal:
//         return AppColors.info;
//       case ProjectStatus.inProgress:
//         return AppColors.warning;
//       case ProjectStatus.underReview:
//         return AppColors.primary;
//       case ProjectStatus.completed:
//         return AppColors.success;
//     }
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }

// // Project Details Screen
// class ProjectDetailsScreen extends StatelessWidget {
//   final ProjectModel project;

//   const ProjectDetailsScreen({super.key, required this.project});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Project Details'),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       project.title,
//                       style: Theme.of(context).textTheme.headlineSmall
//                           ?.copyWith(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       project.description,
//                       style: Theme.of(context).textTheme.bodyLarge,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Project Information
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Project Information',
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     _buildDetailRow('Department', project.department),
//                     _buildDetailRow('Current Phase', project.currentPhase),
//                     _buildDetailRow(
//                       'Status',
//                       _getStatusDisplayName(project.status),
//                     ),
//                     _buildDetailRow('Progress', '${project.progress.toInt()}%'),
//                     _buildDetailRow(
//                       'Submission Date',
//                       _formatDate(project.submissionDate),
//                     ),
//                     _buildDetailRow('Deadline', _formatDate(project.deadline)),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Progress Timeline
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Progress Timeline',
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     // TODO: Add timeline visualization
//                     const Text(
//                       'Timeline visualization will be implemented here',
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ),
//           const Text(': '),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }

//   String _getStatusDisplayName(ProjectStatus status) {
//     switch (status) {
//       case ProjectStatus.proposal:
//         return 'Proposal';
//       case ProjectStatus.inProgress:
//         return 'In Progress';
//       case ProjectStatus.underReview:
//         return 'Under Review';
//       case ProjectStatus.completed:
//         return 'Completed';
//     }
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }

// // Project Progress Screen
// class ProjectProgressScreen extends StatelessWidget {
//   final ProjectModel project;

//   const ProjectProgressScreen({super.key, required this.project});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Project Progress'),
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       project.title,
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     LinearProgressIndicator(
//                       value: project.progress / 100,
//                       backgroundColor: Colors.grey[300],
//                       valueColor: const AlwaysStoppedAnimation<Color>(
//                         AppColors.primary,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text('${project.progress.toInt()}% Complete'),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Milestone tracking would go here
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Milestones',
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     // TODO: Add milestone tracking
//                     const Text('Milestone tracking will be implemented here'),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
