import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../services/api_service.dart';
import '../../models/project_model.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/card_widget.dart';

class ProjectManagementScreen extends StatefulWidget {
  const ProjectManagementScreen({super.key});

  @override
  State<ProjectManagementScreen> createState() =>
      _ProjectManagementScreenState();
}

class _ProjectManagementScreenState extends State<ProjectManagementScreen> {
  final ApiService _apiService = ApiService();
  final _searchController = TextEditingController();

  List<ProjectModel> _projects = [];
  List<ProjectModel> _filteredProjects = [];
  bool _isLoading = false;
  String _selectedFilter =
      'all'; // all, assigned, in_progress, submitted, reviewed, completed

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProjects() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final projects = await _apiService.getProjects();
      setState(() {
        _projects = projects;
        _filteredProjects = projects;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading projects: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterProjects() {
    String query = _searchController.text.toLowerCase();

    setState(() {
      _filteredProjects = _projects.where((project) {
        bool matchesSearch =
            project.title.toLowerCase().contains(query) ||
            project.supervisorName.toLowerCase().contains(query) ||
            project.teamMembers.toLowerCase().contains(query);

        bool matchesFilter =
            _selectedFilter == 'all' || project.status == _selectedFilter;

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _showCreateProjectDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreateProjectDialog(),
    ).then((_) => _loadProjects());
  }

  void _showProjectDetails(ProjectModel project) {
    Navigator.of(context)
        .pushNamed('/project-detail', arguments: project)
        .then((_) => _loadProjects());
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'assigned':
        return AppColors.info;
      case 'in_progress':
        return AppColors.warning;
      case 'submitted':
        return AppColors.primary;
      case 'reviewed':
        return AppColors.secondary;
      case 'completed':
        return AppColors.success;
      default:
        return AppColors.grey;
    }
  }

  String _getStatusDisplay(String status) {
    switch (status) {
      case 'in_progress':
        return 'In Progress';
      default:
        return status.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Management'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadProjects),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.background,
            child: Column(
              children: [
                SearchTextField(
                  controller: _searchController,
                  hint: 'Search projects, supervisors, or students...',
                  onChanged: (_) => _filterProjects(),
                  onClear: _filterProjects,
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('all', 'All'),
                      _buildFilterChip('assigned', 'Assigned'),
                      _buildFilterChip('in_progress', 'In Progress'),
                      _buildFilterChip('submitted', 'Submitted'),
                      _buildFilterChip('reviewed', 'Reviewed'),
                      _buildFilterChip('completed', 'Completed'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Stats Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: InfoCard(
                    title: 'Total Projects',
                    value: _projects.length.toString(),
                    icon: Icons.folder,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InfoCard(
                    title: 'Completed',
                    value: _projects
                        .where((p) => p.isCompleted)
                        .length
                        .toString(),
                    icon: Icons.check_circle,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InfoCard(
                    title: 'In Progress',
                    value: _projects
                        .where((p) => p.isInProgress)
                        .length
                        .toString(),
                    icon: Icons.hourglass_bottom,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
          ),

          // Projects List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProjects.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _projects.isEmpty
                              ? 'No projects found'
                              : 'No projects match your search',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredProjects.length,
                    itemBuilder: (context, index) {
                      final project = _filteredProjects[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(
                            project.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('Supervisor: ${project.supervisorName}'),
                              const SizedBox(height: 2),
                              Text('Students: ${project.studentCount}'),
                              if (project.students.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  project.teamMembers,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(project.status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getStatusDisplay(project.status),
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: () => _showProjectDetails(project),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateProjectDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
          _filterProjects();
        },
        selectedColor: AppColors.primary.withOpacity(0.2),
        checkmarkColor: AppColors.primary,
      ),
    );
  }
}

class CreateProjectDialog extends StatefulWidget {
  const CreateProjectDialog({super.key});

  @override
  State<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<CreateProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ApiService _apiService = ApiService();

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createProject() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _apiService.createProject({
          'title': _titleController.text.trim(),
          'description': _descriptionController.text.trim(),
        });

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Project created successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error creating project: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Project'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: _titleController,
              label: 'Project Title',
              hint: 'Enter project title',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter project title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Enter project description (optional)',
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text(AppStrings.cancel),
        ),
        CustomButton(
          text: 'Create',
          onPressed: _isLoading ? null : _createProject,
          isLoading: _isLoading,
        ),
      ],
    );
  }
}
