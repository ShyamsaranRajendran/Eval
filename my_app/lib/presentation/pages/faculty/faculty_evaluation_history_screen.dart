import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';

class FacultyEvaluationHistoryScreen extends ConsumerStatefulWidget {
  const FacultyEvaluationHistoryScreen({super.key});

  @override
  ConsumerState<FacultyEvaluationHistoryScreen> createState() =>
      _FacultyEvaluationHistoryScreenState();
}

class _FacultyEvaluationHistoryScreenState
    extends ConsumerState<FacultyEvaluationHistoryScreen> {
  final _searchController = TextEditingController();

  List<EvaluationHistory> _evaluations = [];
  List<EvaluationHistory> _filteredEvaluations = [];
  String? _selectedPhaseFilter;
  String? _selectedStatusFilter;
  bool _isLoading = true;
  String _searchQuery = '';

  final List<String> _phases = [
    'Proposal Defense',
    'Mid-term Evaluation',
    'Final Defense',
    'Thesis Defense',
  ];

  final List<String> _statuses = ['Completed', 'Draft', 'Submitted'];

  @override
  void initState() {
    super.initState();
    _loadEvaluationHistory();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEvaluationHistory() async {
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 1));

      // Mock evaluation history data
      _evaluations = [
        EvaluationHistory(
          id: '1',
          studentName: 'Alice Johnson',
          studentRegNo: 'CS2021001',
          projectTitle: 'AI-Based Student Performance Prediction',
          reviewPhase: 'Final Defense',
          panelName: 'CS Final Defense Panel A',
          evaluatedOn: DateTime.now().subtract(const Duration(days: 5)),
          totalScore: 85.5,
          maxScore: 100.0,
          status: 'Completed',
          comments:
              'Excellent presentation and implementation. Strong understanding of ML concepts.',
          criteriaScores: {
            'Technical Implementation': 18.0,
            'Innovation': 16.5,
            'Presentation': 17.0,
            'Documentation': 16.0,
            'Q&A Session': 18.0,
          },
        ),
        EvaluationHistory(
          id: '2',
          studentName: 'Bob Wilson',
          studentRegNo: 'CS2021002',
          projectTitle: 'Blockchain Document Verification',
          reviewPhase: 'Mid-term Evaluation',
          panelName: 'CS Mid-term Panel B',
          evaluatedOn: DateTime.now().subtract(const Duration(days: 15)),
          totalScore: 78.0,
          maxScore: 100.0,
          status: 'Completed',
          comments:
              'Good progress on blockchain implementation. Needs improvement in UI/UX design.',
          criteriaScores: {
            'Progress': 16.0,
            'Technical Quality': 17.5,
            'Timeline Adherence': 15.0,
            'Research Quality': 16.5,
            'Presentation': 13.0,
          },
        ),
        EvaluationHistory(
          id: '3',
          studentName: 'Charlie Brown',
          studentRegNo: 'IT2021003',
          projectTitle: 'Mobile Health Monitoring App',
          reviewPhase: 'Proposal Defense',
          panelName: 'IT Proposal Panel C',
          evaluatedOn: DateTime.now().subtract(const Duration(days: 30)),
          totalScore: 72.5,
          maxScore: 100.0,
          status: 'Completed',
          comments:
              'Well-defined problem statement. Implementation plan needs more detail.',
          criteriaScores: {
            'Problem Definition': 18.0,
            'Literature Review': 15.5,
            'Methodology': 14.0,
            'Feasibility': 16.0,
            'Presentation': 9.0,
          },
        ),
        EvaluationHistory(
          id: '4',
          studentName: 'Diana Prince',
          studentRegNo: 'CS2021004',
          projectTitle: 'IoT-Based Smart Campus System',
          reviewPhase: 'Final Defense',
          panelName: 'CS Final Defense Panel D',
          evaluatedOn: DateTime.now().subtract(const Duration(days: 2)),
          totalScore: 92.0,
          maxScore: 100.0,
          status: 'Completed',
          comments:
              'Outstanding work with practical implementation. Excellent defense performance.',
          criteriaScores: {
            'Technical Implementation': 19.0,
            'Innovation': 18.5,
            'Presentation': 19.0,
            'Documentation': 17.5,
            'Q&A Session': 18.0,
          },
        ),
      ];

      _filteredEvaluations = _evaluations;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading evaluation history: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterEvaluations();
    });
  }

  void _filterEvaluations() {
    _filteredEvaluations = _evaluations.where((evaluation) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          evaluation.studentName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          evaluation.studentRegNo.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          evaluation.projectTitle.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          evaluation.panelName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      final matchesPhase =
          _selectedPhaseFilter == null ||
          evaluation.reviewPhase == _selectedPhaseFilter;

      final matchesStatus =
          _selectedStatusFilter == null ||
          evaluation.status == _selectedStatusFilter;

      return matchesSearch && matchesPhase && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluation History'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportHistory,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEvaluationHistory,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by student, project, or panel',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // Filter chips
          if (_selectedPhaseFilter != null || _selectedStatusFilter != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text('Filters: '),
                    if (_selectedPhaseFilter != null) ...[
                      Chip(
                        label: Text(_selectedPhaseFilter!),
                        onDeleted: () {
                          setState(() {
                            _selectedPhaseFilter = null;
                            _filterEvaluations();
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (_selectedStatusFilter != null) ...[
                      Chip(
                        label: Text(_selectedStatusFilter!),
                        onDeleted: () {
                          setState(() {
                            _selectedStatusFilter = null;
                            _filterEvaluations();
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),

          // Stats Row
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    _evaluations.length.toString(),
                    Icons.assessment,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Avg Score',
                    '${(_evaluations.isEmpty ? 0 : _evaluations.map((e) => e.totalScore).reduce((a, b) => a + b) / _evaluations.length).toStringAsFixed(1)}',
                    Icons.star,
                    AppColors.warning,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'This Month',
                    _evaluations
                        .where(
                          (e) =>
                              e.evaluatedOn.month == DateTime.now().month &&
                              e.evaluatedOn.year == DateTime.now().year,
                        )
                        .length
                        .toString(),
                    Icons.calendar_today,
                    AppColors.info,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'High Scores',
                    _evaluations
                        .where((e) => e.totalScore >= 85)
                        .length
                        .toString(),
                    Icons.emoji_events,
                    AppColors.success,
                  ),
                ),
              ],
            ),
          ),

          // Evaluations List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredEvaluations.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _loadEvaluationHistory,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredEvaluations.length,
                      itemBuilder: (context, index) {
                        final evaluation = _filteredEvaluations[index];
                        return _buildEvaluationCard(evaluation);
                      },
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
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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

  Widget _buildEvaluationCard(EvaluationHistory evaluation) {
    final scorePercentage = evaluation.totalScore / evaluation.maxScore;
    final scoreColor = scorePercentage >= 0.85
        ? AppColors.success
        : scorePercentage >= 0.70
        ? AppColors.warning
        : scorePercentage >= 0.60
        ? Colors.orange
        : AppColors.error;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Score
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        evaluation.studentName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        evaluation.studentRegNo,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.1),
                    border: Border.all(color: scoreColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 16, color: scoreColor),
                      const SizedBox(width: 4),
                      Text(
                        '${evaluation.totalScore.toStringAsFixed(1)}/${evaluation.maxScore.toInt()}',
                        style: TextStyle(
                          color: scoreColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Project Title
            Text(
              evaluation.projectTitle,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 8),

            // Phase and Panel
            Row(
              children: [
                Chip(
                  label: Text(evaluation.reviewPhase),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    evaluation.panelName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Evaluation Date
            _buildInfoRow(
              Icons.calendar_today,
              'Evaluated on ${_formatDate(evaluation.evaluatedOn)}',
            ),

            const SizedBox(height: 8),

            // Score Breakdown
            if (evaluation.criteriaScores.isNotEmpty) ...[
              Text(
                'Score Breakdown:',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              ...evaluation.criteriaScores.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.key,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Text(
                        entry.value.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Comments
            if (evaluation.comments.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comments:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      evaluation.comments,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _viewDetails(evaluation),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View Details'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _exportEvaluation(evaluation),
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Export'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty ||
                    _selectedPhaseFilter != null ||
                    _selectedStatusFilter != null
                ? 'No evaluations found'
                : 'No evaluation history',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty ||
                    _selectedPhaseFilter != null ||
                    _selectedStatusFilter != null
                ? 'Try adjusting your search or filters'
                : 'Your evaluation history will appear here',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (_searchQuery.isNotEmpty ||
              _selectedPhaseFilter != null ||
              _selectedStatusFilter != null)
            ElevatedButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _selectedPhaseFilter = null;
                  _selectedStatusFilter = null;
                  _filterEvaluations();
                });
              },
              icon: const Icon(Icons.clear),
              label: const Text('Clear Filters'),
            ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter History'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review Phase:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            DropdownButton<String?>(
              value: _selectedPhaseFilter,
              isExpanded: true,
              hint: const Text('All Phases'),
              onChanged: (phase) {
                setState(() => _selectedPhaseFilter = phase);
              },
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('All Phases'),
                ),
                ..._phases.map(
                  (phase) => DropdownMenuItem(value: phase, child: Text(phase)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Status:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            DropdownButton<String?>(
              value: _selectedStatusFilter,
              isExpanded: true,
              hint: const Text('All Statuses'),
              onChanged: (status) {
                setState(() => _selectedStatusFilter = status);
              },
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('All Statuses'),
                ),
                ..._statuses.map(
                  (status) =>
                      DropdownMenuItem(value: status, child: Text(status)),
                ),
              ],
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
              _filterEvaluations();
            },
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }

  void _viewDetails(EvaluationHistory evaluation) {
    Navigator.pushNamed(context, '/evaluation-detail', arguments: evaluation);
  }

  void _exportEvaluation(EvaluationHistory evaluation) {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting evaluation for ${evaluation.studentName}'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _exportHistory() {
    // TODO: Implement bulk export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting evaluation history'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Data class for evaluation history
class EvaluationHistory {
  final String id;
  final String studentName;
  final String studentRegNo;
  final String projectTitle;
  final String reviewPhase;
  final String panelName;
  final DateTime evaluatedOn;
  final double totalScore;
  final double maxScore;
  final String status;
  final String comments;
  final Map<String, double> criteriaScores;

  EvaluationHistory({
    required this.id,
    required this.studentName,
    required this.studentRegNo,
    required this.projectTitle,
    required this.reviewPhase,
    required this.panelName,
    required this.evaluatedOn,
    required this.totalScore,
    required this.maxScore,
    required this.status,
    required this.comments,
    required this.criteriaScores,
  });
}
