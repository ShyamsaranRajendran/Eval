import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../services/api_service.dart';
import '../../models/review_model.dart';

class TeamReviewScreen extends StatefulWidget {
  const TeamReviewScreen({super.key});

  @override
  State<TeamReviewScreen> createState() => _TeamReviewScreenState();
}

class _TeamReviewScreenState extends State<TeamReviewScreen> {
  final ApiService _apiService = ApiService();
  List<ReviewModel> _teamReviews = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTeamReviews();
  }

  Future<void> _loadTeamReviews() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final reviews = await _apiService.getTeamReviews();
      setState(() {
        _teamReviews = reviews;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading team reviews: $e'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.teamReview),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _teamReviews.isEmpty
          ? const Center(
              child: Text(
                AppStrings.noData,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _teamReviews.length,
              itemBuilder: (context, index) {
                final review = _teamReviews[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(review.status),
                      child: Icon(
                        _getStatusIcon(review.status),
                        color: AppColors.white,
                      ),
                    ),
                    title: Text('Review #${review.reviewNumber}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reviewer: ${review.reviewerName}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Score: ${review.totalScore}/${review.maxScore}',
                          style: TextStyle(
                            color: AppColors.warning,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(review.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        review.status,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Review Details:',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text('Project ID: ${review.projectId}'),
                            const SizedBox(height: 4),
                            Text('Status: ${review.status}'),
                            if (review.reviewDate != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Review Date: ${review.reviewDate!.toString().split(' ')[0]}',
                              ),
                            ],
                            const SizedBox(height: 16),

                            // Comments section
                            if (review.comments.isNotEmpty) ...[
                              Text(
                                'Comments:',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              ...review.comments.entries
                                  .map(
                                    (entry) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        '${entry.key}: ${entry.value}',
                                      ),
                                    ),
                                  )
                                  .toList(),
                              const SizedBox(height: 16),
                            ],

                            // Action buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.rate_review),
                                    label: const Text('Edit Review'),
                                    onPressed: () => _editReview(review),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: const Icon(Icons.info),
                                    label: const Text('View Details'),
                                    onPressed: () => _viewDetails(review),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Create new team review
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create review feature coming soon')),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return AppColors.success;
      case 'in_progress':
      case 'in progress':
        return AppColors.warning;
      case 'pending':
      default:
        return AppColors.info;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'in_progress':
      case 'in progress':
        return Icons.hourglass_bottom;
      case 'pending':
      default:
        return Icons.pending;
    }
  }

  void _editReview(ReviewModel review) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Edit review #${review.reviewNumber} feature coming soon',
        ),
      ),
    );
  }

  void _viewDetails(ReviewModel review) {
    // TODO: Navigate to detailed review screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'View details for review #${review.reviewNumber} feature coming soon',
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('View details feature coming soon')),
    );
  }
}
