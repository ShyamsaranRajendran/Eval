import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';

class StudentEvaluationScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> student;
  final String panelId;

  const StudentEvaluationScreen({
    super.key,
    required this.student,
    required this.panelId,
  });

  @override
  ConsumerState<StudentEvaluationScreen> createState() =>
      _StudentEvaluationScreenState();
}

class _StudentEvaluationScreenState
    extends ConsumerState<StudentEvaluationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isSubmitted = false;

  // Evaluation criteria with scores
  final Map<String, Map<String, dynamic>> _evaluationCriteria = {
    'technical_skills': {
      'name': 'Technical Skills',
      'icon': Icons.code,
      'color': AppColors.primary,
      'weight': 0.3,
      'score': 0.0,
      'maxScore': 25.0,
      'subcriteria': [
        {'name': 'Code Quality', 'score': 0.0, 'maxScore': 5.0},
        {'name': 'Technical Implementation', 'score': 0.0, 'maxScore': 5.0},
        {'name': 'Innovation & Creativity', 'score': 0.0, 'maxScore': 5.0},
        {'name': 'Problem Solving', 'score': 0.0, 'maxScore': 5.0},
        {'name': 'Best Practices', 'score': 0.0, 'maxScore': 5.0},
      ],
    },
    'presentation_skills': {
      'name': 'Presentation Skills',
      'icon': Icons.slideshow,
      'color': AppColors.info,
      'weight': 0.25,
      'score': 0.0,
      'maxScore': 20.0,
      'subcriteria': [
        {'name': 'Clarity & Communication', 'score': 0.0, 'maxScore': 5.0},
        {'name': 'Visual Aids & Demos', 'score': 0.0, 'maxScore': 5.0},
        {'name': 'Time Management', 'score': 0.0, 'maxScore': 5.0},
        {'name': 'Audience Engagement', 'score': 0.0, 'maxScore': 5.0},
      ],
    },
    'project_documentation': {
      'name': 'Project Documentation',
      'icon': Icons.description,
      'color': AppColors.warning,
      'weight': 0.2,
      'score': 0.0,
      'maxScore': 15.0,
      'subcriteria': [
        {'name': 'Report Quality', 'score': 0.0, 'maxScore': 5.0},
        {'name': 'Technical Documentation', 'score': 0.0, 'maxScore': 5.0},
        {'name': 'Literature Review', 'score': 0.0, 'maxScore': 5.0},
      ],
    },
    'qa_session': {
      'name': 'Q&A Session',
      'icon': Icons.question_answer,
      'color': AppColors.success,
      'weight': 0.25,
      'score': 0.0,
      'maxScore': 20.0,
      'subcriteria': [
        {'name': 'Understanding of Project', 'score': 0.0, 'maxScore': 5.0},
        {'name': 'Response to Questions', 'score': 0.0, 'maxScore': 5.0},
        {'name': 'Knowledge Depth', 'score': 0.0, 'maxScore': 5.0},
        {'name': 'Confidence & Composure', 'score': 0.0, 'maxScore': 5.0},
      ],
    },
  };

  // Text controllers for comments
  final Map<String, TextEditingController> _commentControllers = {};
  final TextEditingController _overallCommentController =
      TextEditingController();
  final TextEditingController _recommendationsController =
      TextEditingController();

  double _totalScore = 0.0;
  String _overallGrade = 'F';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Initialize comment controllers
    for (String criteria in _evaluationCriteria.keys) {
      _commentControllers[criteria] = TextEditingController();
    }

    _updateTotalScore();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _overallCommentController.dispose();
    _recommendationsController.dispose();
    for (var controller in _commentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateTotalScore() {
    double total = 0.0;

    for (var criteria in _evaluationCriteria.values) {
      double criteriaScore = 0.0;
      for (var subcriteria in criteria['subcriteria']) {
        criteriaScore += subcriteria['score'];
      }
      criteria['score'] = criteriaScore;
      total += criteriaScore;
    }

    setState(() {
      _totalScore = total;
      _overallGrade = _calculateGrade(total);
    });
  }

  String _calculateGrade(double score) {
    final percentage = (score / 80) * 100; // Total max score is 80
    if (percentage >= 90) return 'A+';
    if (percentage >= 85) return 'A';
    if (percentage >= 80) return 'A-';
    if (percentage >= 75) return 'B+';
    if (percentage >= 70) return 'B';
    if (percentage >= 65) return 'B-';
    if (percentage >= 60) return 'C+';
    if (percentage >= 55) return 'C';
    if (percentage >= 50) return 'C-';
    if (percentage >= 45) return 'D';
    return 'F';
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
      case 'A-':
        return AppColors.success;
      case 'B+':
      case 'B':
      case 'B-':
        return AppColors.info;
      case 'C+':
      case 'C':
      case 'C-':
        return AppColors.warning;
      case 'D':
      case 'F':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Evaluating: ${widget.student['name']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.student['projectTitle'],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (!_isSubmitted)
            IconButton(
              icon: const Icon(Icons.save_outlined),
              onPressed: _saveDraft,
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.score), text: 'Scoring'),
            Tab(icon: Icon(Icons.comment), text: 'Comments'),
            Tab(icon: Icon(Icons.preview), text: 'Review'),
          ],
        ),
      ),
      body: _isSubmitted ? _buildSubmissionSuccess() : _buildEvaluationForm(),
      bottomNavigationBar: _isSubmitted ? null : _buildBottomBar(),
    );
  }

  Widget _buildEvaluationForm() {
    return Form(
      key: _formKey,
      child: TabBarView(
        controller: _tabController,
        children: [_buildScoringTab(), _buildCommentsTab(), _buildReviewTab()],
      ),
    );
  }

  Widget _buildScoringTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student Info Card
          _buildStudentInfoCard(),
          const SizedBox(height: 20),

          // Score Summary Card
          _buildScoreSummaryCard(),
          const SizedBox(height: 20),

          // Evaluation Criteria
          ...(_evaluationCriteria.entries.map((entry) {
            return _buildCriteriaCard(entry.key, entry.value);
          }).toList()),
        ],
      ),
    );
  }

  Widget _buildStudentInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    widget.student['name'].substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.student['name'],
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.student['projectTitle'],
                        style: Theme.of(context).textTheme.bodyMedium,
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
                            'Panel: ${widget.panelId}',
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSummaryCard() {
    final percentage = (_totalScore / 80) * 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Score Summary',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildScoreItem(
                  'Total Score',
                  '${_totalScore.toStringAsFixed(1)}/80',
                ),
                _buildScoreItem(
                  'Percentage',
                  '${percentage.toStringAsFixed(1)}%',
                ),
                _buildScoreItem('Grade', _overallGrade),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppColors.textSecondary.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                _getGradeColor(_overallGrade),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: _overallGrade.isNotEmpty
                ? _getGradeColor(_overallGrade)
                : AppColors.textSecondary,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildCriteriaCard(String key, Map<String, dynamic> criteria) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(criteria['icon'], color: criteria['color'], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    criteria['name'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: criteria['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${criteria['score'].toStringAsFixed(1)}/${criteria['maxScore']}',
                    style: TextStyle(
                      color: criteria['color'],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Subcriteria
            ...((criteria['subcriteria'] as List).map((subcriteria) {
              return _buildSubcriteriaRow(subcriteria);
            }).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcriteriaRow(Map<String, dynamic> subcriteria) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  subcriteria['name'],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '${subcriteria['score'].toStringAsFixed(1)}/${subcriteria['maxScore']}',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: subcriteria['score'],
            max: subcriteria['maxScore'],
            divisions: (subcriteria['maxScore'] * 2).toInt(), // 0.5 increments
            activeColor: AppColors.primary,
            label: subcriteria['score'].toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                subcriteria['score'] = value;
                _updateTotalScore();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Feedback',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Comments for each criteria
          ...(_evaluationCriteria.entries.map((entry) {
            return _buildCommentSection(entry.key, entry.value);
          }).toList()),

          const SizedBox(height: 20),

          // Overall Comments
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.comment, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Overall Comments',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _overallCommentController,
                    label:
                        'Provide overall feedback on the student\'s performance...',
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Recommendations
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: AppColors.warning),
                      const SizedBox(width: 8),
                      Text(
                        'Recommendations',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _recommendationsController,
                    label: 'Suggestions for improvement and future learning...',
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSection(String key, Map<String, dynamic> criteria) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(criteria['icon'], color: criteria['color'], size: 20),
                const SizedBox(width: 8),
                Text(
                  criteria['name'],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _commentControllers[key]!,
              label: 'Comments for ${criteria['name']}...',
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Evaluation Review',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Final Score Card
          Card(
            color: _getGradeColor(_overallGrade).withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Final Evaluation',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${_totalScore.toStringAsFixed(1)}',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _getGradeColor(_overallGrade),
                                ),
                          ),
                          Text(
                            'Total Score',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            _overallGrade,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _getGradeColor(_overallGrade),
                                ),
                          ),
                          Text(
                            'Grade',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${((_totalScore / 80) * 100).toStringAsFixed(1)}%',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _getGradeColor(_overallGrade),
                                ),
                          ),
                          Text(
                            'Percentage',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Score Breakdown
          Text(
            'Score Breakdown',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...(_evaluationCriteria.entries.map((entry) {
            final criteria = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(criteria['icon'], color: criteria['color']),
                title: Text(criteria['name']),
                trailing: Text(
                  '${criteria['score'].toStringAsFixed(1)}/${criteria['maxScore']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList()),

          const SizedBox(height: 20),

          // Comments Preview
          if (_overallCommentController.text.isNotEmpty) ...[
            Text(
              'Overall Comments',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_overallCommentController.text),
              ),
            ),
            const SizedBox(height: 16),
          ],

          if (_recommendationsController.text.isNotEmpty) ...[
            Text(
              'Recommendations',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_recommendationsController.text),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: 'Save Draft',
              onPressed: _saveDraft,
              backgroundColor: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: CustomButton(
              text: 'Submit Evaluation',
              onPressed: _submitEvaluation,
              isLoading: _isLoading,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 60,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Evaluation Submitted Successfully!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Your evaluation for ${widget.student['name']} has been submitted and recorded.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Back to Assignments',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _saveDraft() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Implement save draft API call
      await Future.delayed(const Duration(seconds: 1));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Draft saved successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving draft: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _submitEvaluation() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required fields'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Check if evaluation is complete (at least some scores given)
    if (_totalScore == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide scores for the evaluation'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Evaluation'),
        content: Text(
          'Are you sure you want to submit the evaluation for ${widget.student['name']}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Implement submit evaluation API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _isSubmitted = true;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting evaluation: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
