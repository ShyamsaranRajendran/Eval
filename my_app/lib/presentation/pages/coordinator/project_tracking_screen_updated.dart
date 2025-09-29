// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../core/constants/colors.dart';
// import '../../../models/project_model.dart';
// import '../../../data/models/student_panel_models.dart';

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
//   String? _selectedStatusFilter;
//   bool _isLoading = true;
//   String _searchQuery = '';

//   final List<String> _statusOptions = [
//     'assigned',
//     'in_progress',
//     'submitted',
//     'reviewed',
//     'completed',
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

//       // Mock data using the correct ProjectModel structure
//       _projects = [
//         ProjectModel(
//           id: '1',
//           title: 'AI-Based Student Performance Prediction System',
//           description:
//               'A machine learning system to predict student academic performance',
//           batchId: 'batch1',
//           supervisorId: 'sup1',
//           supervisorName: 'Dr. John Smith',
//           students: [
//             StudentModel(
//               id: 'student1',
//               registerNo: 'CS2021001',
//               name: 'Alice Johnson',
//               projectTitle: 'AI-Based Student Performance Prediction System',
//               supervisor: 'Dr. John Smith',
//               email: 'alice@example.com',
//               phone: '+1234567890',
//               cgpa: 8.7,
//             ),
//           ],
//           panelId: 'panel1',
//           status: 'in_progress',
//           submissionDate: DateTime.now().subtract(const Duration(days: 30)),
//           createdAt: DateTime.now().subtract(const Duration(days: 60)),
//         ),
//         ProjectModel(
//           id: '2',
//           title: 'Mobile Health Monitoring Application',
//           description: 'Cross-platform mobile app for health tracking',
//           batchId: 'batch1',
//           supervisorId: 'sup2',
//           supervisorName: 'Dr. Jane Doe',
//             StudentModel(
//               id: 'student2',
//               registerNo: 'IT2021002',
//               name: 'Bob Wilson',
//               projectTitle: 'Mobile Health Monitoring Application',
//               supervisor: 'Dr. Jane Doe',
//               email: 'bob@example.com',
//               phone: '+1234567891',
//               cgpa: 8.2,
//             ),
//             ),
//           ],
//           panelId: 'panel2',
//           status: 'completed',
//           submissionDate: DateTime.now().subtract(const Duration(days: 10)),
//           createdAt: DateTime.now().subtract(const Duration(days: 90)),
//         ),
//         ProjectModel(
//           id: '3',
//           title: 'IoT-Based Smart Campus System',
//           description: 'Internet of Things solution for campus management',
//           batchId: 'batch2',
//           supervisorId: 'sup1',
//             StudentModel(
//               id: 'student3',
//               registerNo: 'EE2021003',
//               name: 'Charlie Brown',
//               projectTitle: 'IoT-Based Smart Campus System',
//               supervisor: 'Dr. John Smith',
//               email: 'charlie@example.com',
//               phone: '+1234567892',
//               cgpa: 7.9,
//             ),
//               phone: '+1234567892',
//             ),
//           ],
//           panelId: 'panel1',
//           status: 'assigned',
//           createdAt: DateTime.now().subtract(const Duration(days: 20)),
//         ),
//         ProjectModel(
//           id: '4',
//           title: 'Blockchain-Based Document Verification',
//           description:
//               'Secure document verification using blockchain technology',
//           batchId: 'batch2',
//             StudentModel(
//               id: 'student4',
//               registerNo: 'CS2021004',
//               name: 'Diana Prince',
//               projectTitle: 'Blockchain-Based Document Verification',
//               supervisor: 'Dr. Mike Johnson',
//               email: 'diana@example.com',
//               phone: '+1234567893',
//               cgpa: 9.1,
//             ),
//               email: 'diana@example.com',
//               phone: '+1234567893',
//             ),
//           ],
//           panelId: 'panel3',
//           status: 'submitted',
//           submissionDate: DateTime.now().subtract(const Duration(days: 5)),
//           createdAt: DateTime.now().subtract(const Duration(days: 45)),
//         ),
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
//           (project.description?.toLowerCase().contains(
//                 _searchQuery.toLowerCase(),
//               ) ??
//               false) ||
//           project.supervisorName.toLowerCase().contains(
//             _searchQuery.toLowerCase(),
//           );

//       final matchesStatus =
//           _selectedStatusFilter == null ||
//           project.status == _selectedStatusFilter;

//       return matchesSearch && matchesStatus;
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
//                     'Search projects by title, description, or supervisor',
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

//           // Filter chip
//           if (_selectedStatusFilter != null)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Row(
//                 children: [
//                   const Text('Active filter: '),
//                   Chip(
//                     label: Text(_getStatusDisplayName(_selectedStatusFilter!)),
//                     onDeleted: () {
//                       setState(() {
//                         _selectedStatusFilter = null;
//                         _filterProjects();
//                       });
//                     },
//                   ),
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
//                         .where((p) => p.status == 'in_progress')
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
//                         .where((p) => p.status == 'completed')
//                         .length
//                         .toString(),
//                     Icons.check_circle,
//                     AppColors.success,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: _buildStatCard(
//                     'Submitted',
//                     _projects
//                         .where((p) => p.status == 'submitted')
//                         .length
//                         .toString(),
//                     Icons.upload,
//                     AppColors.info,
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
//     final daysElapsed = DateTime.now().difference(project.createdAt).inDays;
//     final hasSubmissionDate = project.submissionDate != null;
//     final daysSinceSubmission = hasSubmissionDate
//         ? DateTime.now().difference(project.submissionDate!).inDays
//         : 0;

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
//             if (project.description != null)
//               Text(
//                 project.description!,
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   color: AppColors.textSecondary,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),

//             const SizedBox(height: 12),

//             // Project Info
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildInfoRow(
//                         Icons.person,
//                         'Supervisor: ${project.supervisorName}',
//                       ),
//                       const SizedBox(height: 4),
//                       _buildInfoRow(
//                         Icons.people,
//                         '${project.students.length} student(s)',
//                       ),
//                       if (project.students.isNotEmpty) ...[
//                         const SizedBox(height: 4),
//                         _buildInfoRow(
//                           Icons.person,
//                           'Reg: ${project.students.first.registerNo}',
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     _buildInfoRow(
//                       Icons.schedule,
//                       '$daysElapsed days since created',
//                     ),
//                     if (hasSubmissionDate) ...[
//                       const SizedBox(height: 4),
//                       _buildInfoRow(
//                         Icons.upload,
//                         'Submitted $daysSinceSubmission days ago',
//                         AppColors.success,
//                       ),
//                     ],
//                   ],
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             // Students list
//             if (project.students.isNotEmpty) ...[
//               const Divider(),
//               const SizedBox(height: 8),
//               Text(
//                 'Students:',
//                 style: Theme.of(
//                   context,
//                 ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
//               ),
//               const SizedBox(height: 4),
//               ...project.students.map(
//                 (student) => Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 2),
//                   child: Row(
//                     children: [
//                       const Icon(
//                         Icons.person_outline,
//                         size: 16,
//                         color: AppColors.textSecondary,
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           '${student.name} (${student.id})',
//                           style: Theme.of(context).textTheme.bodySmall,
//                         ),
//                       ),
//                       Text(
//                         'CGPA: ${student.cgpa}',
//                         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],

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
//                   onPressed: () => _updateProjectStatus(project),
//                   icon: const Icon(Icons.edit, size: 16),
//                   label: const Text('Update Status'),
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
//         Expanded(
//           child: Text(
//             text,
//             style: Theme.of(context).textTheme.bodySmall?.copyWith(
//               color: color ?? AppColors.textSecondary,
//             ),
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
//             _searchQuery.isNotEmpty || _selectedStatusFilter != null
//                 ? 'No projects found'
//                 : 'No projects assigned yet',
//             style: Theme.of(
//               context,
//             ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             _searchQuery.isNotEmpty || _selectedStatusFilter != null
//                 ? 'Try adjusting your search or filters'
//                 : 'Projects will appear here once assigned',
//             style: Theme.of(
//               context,
//             ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 24),
//           if (_searchQuery.isNotEmpty || _selectedStatusFilter != null)
//             ElevatedButton.icon(
//               onPressed: () {
//                 _searchController.clear();
//                 setState(() {
//                   _selectedStatusFilter = null;
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
//             DropdownButton<String?>(
//               value: _selectedStatusFilter,
//               isExpanded: true,
//               hint: const Text('All Statuses'),
//               onChanged: (status) {
//                 setState(() => _selectedStatusFilter = status);
//               },
//               items: [
//                 const DropdownMenuItem<String?>(
//                   value: null,
//                   child: Text('All Statuses'),
//                 ),
//                 ..._statusOptions.map(
//                   (status) => DropdownMenuItem(
//                     value: status,
//                     child: Text(_getStatusDisplayName(status)),
//                   ),
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
//             child: const Text('Apply Filter'),
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

//   void _updateProjectStatus(ProjectModel project) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Update Project Status'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Current Status: ${_getStatusDisplayName(project.status)}'),
//             const SizedBox(height: 16),
//             DropdownButtonFormField<String>(
//               value: project.status,
//               decoration: const InputDecoration(
//                 labelText: 'New Status',
//                 border: OutlineInputBorder(),
//               ),
//               items: _statusOptions
//                   .map(
//                     (status) => DropdownMenuItem(
//                       value: status,
//                       child: Text(_getStatusDisplayName(status)),
//                     ),
//                   )
//                   .toList(),
//               onChanged: (newStatus) {
//                 if (newStatus != null && newStatus != project.status) {
//                   // TODO: Update project status via API
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         'Project status updated to ${_getStatusDisplayName(newStatus)}',
//                       ),
//                       backgroundColor: AppColors.success,
//                     ),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getStatusDisplayName(String status) {
//     switch (status) {
//       case 'assigned':
//         return 'Assigned';
//       case 'in_progress':
//         return 'In Progress';
//       case 'submitted':
//         return 'Submitted';
//       case 'reviewed':
//         return 'Under Review';
//       case 'completed':
//         return 'Completed';
//       default:
//         return status.toUpperCase();
//     }
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'assigned':
//         return AppColors.info;
//       case 'in_progress':
//         return AppColors.warning;
//       case 'submitted':
//         return AppColors.primary;
//       case 'reviewed':
//         return Colors.purple;
//       case 'completed':
//         return AppColors.success;
//       default:
//         return AppColors.textSecondary;
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
//             // Project Title and Description
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
//                     if (project.description != null)
//                       Text(
//                         project.description!,
//                         style: Theme.of(context).textTheme.bodyLarge,
//                       ),
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
//                     _buildDetailRow(
//                       'Status',
//                       _getStatusDisplayName(project.status),
//                     ),
//                     _buildDetailRow('Supervisor', project.supervisorName),
//                     _buildDetailRow('Batch', project.batchId),
//                     _buildDetailRow(
//                       'Panel ID',
//                       project.panelId ?? 'Not assigned',
//                     ),
//                     _buildDetailRow('Created', _formatDate(project.createdAt)),
//                     if (project.submissionDate != null)
//                       _buildDetailRow(
//                         'Submitted',
//                         _formatDate(project.submissionDate!),
//                       ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Student Information
//             if (project.students.isNotEmpty)
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Students',
//                         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       ...project.students.map(
//                         (student) => Card(
//                           margin: const EdgeInsets.symmetric(vertical: 4),
//                           child: ListTile(
//                             leading: CircleAvatar(
//                               backgroundColor: AppColors.primary.withOpacity(
//                                 0.1,
//                               ),
//                               child: Text(
//                                 student.name.substring(0, 1).toUpperCase(),
//                                 style: TextStyle(
//                                   color: AppColors.primary,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             title: Text(student.name),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('ID: ${student.studentId}'),
//                                 Text('Department: ${student.department}'),
//                                 Text('CGPA: ${student.cgpa}'),
//                               ],
//                             ),
//                             trailing: Text(
//                               student.batch,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             isThreeLine: true,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
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

//   String _getStatusDisplayName(String status) {
//     switch (status) {
//       case 'assigned':
//         return 'Assigned';
//       case 'in_progress':
//         return 'In Progress';
//       case 'submitted':
//         return 'Submitted';
//       case 'reviewed':
//         return 'Under Review';
//       case 'completed':
//         return 'Completed';
//       default:
//         return status.toUpperCase();
//     }
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }
