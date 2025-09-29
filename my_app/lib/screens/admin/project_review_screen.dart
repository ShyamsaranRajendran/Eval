import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/colors.dart';
import '../../services/api_service.dart';
import '../../models/project_model.dart';
import '../../models/review_model.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/card_widget.dart';

class ProjectReviewScreen extends StatefulWidget {
  final ProjectModel project;

  const ProjectReviewScreen({super.key, required this.project});

  @override
  State<ProjectReviewScreen> createState() => _ProjectReviewScreenState();
}

class _ProjectReviewScreenState extends State<ProjectReviewScreen> {
  final ApiService _apiService = ApiService();
  final Map<String, TextEditingController> _marksControllers = {};
  final Map<String, TextEditingController> _commentsControllers = {};

  List<ReviewModel> _existingReviews = [];
  ReviewModel? _currentReview;
  bool _isLoading = false;
  bool _isSaving = false;
  int _currentReviewNumber = 1;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadExistingReviews();
  }

  @override
  void dispose() {
    for (var controller in _marksControllers.values) {
      controller.dispose();
    }
    for (var controller in _commentsControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeControllers() {
    for (var criteria in ReviewCriteria.defaultCriteria) {
      _marksControllers[criteria.id] = TextEditingController();
      _commentsControllers[criteria.id] = TextEditingController();
    }
  }

  Future<void> _loadExistingReviews() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final reviews = await _apiService.getReviewsByProject(widget.project.id);
      setState(() {
        _existingReviews = reviews;
        _currentReviewNumber = reviews.length + 1;
      });

      // Load the latest review if exists
      if (reviews.isNotEmpty) {
        _loadReviewData(reviews.last);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading reviews: $e'),
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

  void _loadReviewData(ReviewModel review) {
    setState(() {
      _currentReview = review;
    });

    // Populate controllers with existing data
    for (var criteria in ReviewCriteria.defaultCriteria) {
      if (review.marks.containsKey(criteria.id)) {
        _marksControllers[criteria.id]?.text = review.marks[criteria.id]!
            .toString();
      }
      if (review.comments.containsKey(criteria.id)) {
        _commentsControllers[criteria.id]?.text = review.comments[criteria.id]!;
      }
    }
  }

  Future<void> _saveReview() async {
    // Validate marks
    Map<String, double> marks = {};
    Map<String, String> comments = {};

    for (var criteria in ReviewCriteria.defaultCriteria) {
      final marksText = _marksControllers[criteria.id]?.text ?? '';
      final commentsText = _commentsControllers[criteria.id]?.text ?? '';

      if (marksText.isNotEmpty) {
        final marksValue = double.tryParse(marksText);
        if (marksValue == null ||
            marksValue < 0 ||
            marksValue > criteria.maxMarks) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Invalid marks for ${criteria.name}. Must be between 0 and ${criteria.maxMarks}',
              ),
              backgroundColor: AppColors.error,
            ),
          );
          return;
        }
        marks[criteria.id] = marksValue;
      }

      if (commentsText.isNotEmpty) {
        comments[criteria.id] = commentsText;
      }
    }

    if (marks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least one mark'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final totalScore = marks.values.fold(0.0, (sum, mark) => sum + mark);
      final maxScore = ReviewCriteria.defaultCriteria
          .where((c) => marks.containsKey(c.id))
          .fold(0.0, (sum, criteria) => sum + criteria.maxMarks);

      final reviewData = {
        'project_id': widget.project.id,
        'review_number': _currentReview?.reviewNumber ?? _currentReviewNumber,
        'marks': marks,
        'comments': comments,
        'total_score': totalScore,
        'max_score': maxScore,
        'status': 'completed',
        'review_date': DateTime.now().toIso8601String(),
      };

      if (_currentReview != null) {
        // Update existing review
        await _apiService.updateReview(_currentReview!.id, reviewData);
      } else {
        // Create new review
        await _apiService.createReview(reviewData);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review saved successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving review: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  double _calculateTotalScore() {
    double total = 0.0;
    for (var criteria in ReviewCriteria.defaultCriteria) {
      final marksText = _marksControllers[criteria.id]?.text ?? '';
      if (marksText.isNotEmpty) {
        total += double.tryParse(marksText) ?? 0.0;
      }
    }
    return total;
  }

  double _calculateMaxScore() {
    double max = 0.0;
    for (var criteria in ReviewCriteria.defaultCriteria) {
      final marksText = _marksControllers[criteria.id]?.text ?? '';
      if (marksText.isNotEmpty) {
        max += criteria.maxMarks;
      }
    }
    return max;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review: ${widget.project.title}'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        actions: [
          if (_existingReviews.isNotEmpty)
            PopupMenuButton<int>(
              icon: const Icon(Icons.history),
              tooltip: 'View Previous Reviews',
              onSelected: (reviewNumber) {
                final review = _existingReviews.firstWhere(
                  (r) => r.reviewNumber == reviewNumber,
                  orElse: () => _existingReviews.first,
                );
                _loadReviewData(review);
              },
              itemBuilder: (context) => _existingReviews
                  .map(
                    (review) => PopupMenuItem<int>(
                      value: review.reviewNumber,
                      child: Text(
                        '${review.reviewTypeDisplay} (${review.percentage.toStringAsFixed(1)}%)',
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project Info Card
                  CustomCard(
                    title: widget.project.title,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Supervisor: ${widget.project.supervisorName}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Team Members:',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        ...widget.project.students.map(
                          (student) => Padding(
                            padding: const EdgeInsets.only(left: 16, bottom: 2),
                            child: Text(
                              '• ${student.name} (${student.registerNo})',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Current Review Info
                  Row(
                    children: [
                      Expanded(
                        child: InfoCard(
                          title: 'Review Number',
                          value:
                              (_currentReview?.reviewNumber ??
                                      _currentReviewNumber)
                                  .toString(),
                          icon: Icons.rate_review,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InfoCard(
                          title: 'Total Score',
                          value:
                              '${_calculateTotalScore().toStringAsFixed(1)}/${_calculateMaxScore().toStringAsFixed(1)}',
                          icon: Icons.score,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Review Criteria
                  Text(
                    'Evaluation Criteria',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ...ReviewCriteria.defaultCriteria.map(
                    (criteria) => _buildCriteriaCard(criteria),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedCustomButton(
                  text: 'Cancel',
                  onPressed: _isSaving
                      ? null
                      : () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: CustomButton(
                  text: _currentReview != null
                      ? 'Update Review'
                      : 'Save Review',
                  onPressed: _isSaving ? null : _saveReview,
                  isLoading: _isSaving,
                  backgroundColor: AppColors.success,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCriteriaCard(ReviewCriteria criteria) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    criteria.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  'Max: ${criteria.maxMarks.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              criteria.description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomTextField(
                    controller: _marksControllers[criteria.id],
                    label: 'Marks',
                    hint: '0 - ${criteria.maxMarks.toStringAsFixed(0)}',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: CustomTextField(
                    controller: _commentsControllers[criteria.id],
                    label: 'Comments',
                    hint: 'Enter feedback (optional)',
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
