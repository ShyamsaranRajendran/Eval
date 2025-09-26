import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../services/api_service.dart';

class TeamReviewScreen extends StatefulWidget {
  const TeamReviewScreen({super.key});

  @override
  State<TeamReviewScreen> createState() => _TeamReviewScreenState();
}

class _TeamReviewScreenState extends State<TeamReviewScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _teamReviews = [];
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
                      backgroundColor: _getStatusColor(review['status']),
                      child: Icon(
                        _getStatusIcon(review['status']),
                        color: AppColors.white,
                      ),
                    ),
                    title: Text(review['title'] ?? 'Review ${index + 1}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Team: ${review['team_name'] ?? 'Unknown'}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Due: ${review['due_date'] ?? 'Not set'}',
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
                        color: _getStatusColor(review['status']),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        review['status'] ?? 'Pending',
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
                            if (review['description'] != null) ...[
                              Text(
                                'Description:',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(review['description']),
                              const SizedBox(height: 16),
                            ],

                            // Team members
                            if (review['team_members'] != null) ...[
                              Text(
                                'Team Members:',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              ...(_buildTeamMembersList(
                                review['team_members'],
                              )),
                              const SizedBox(height: 16),
                            ],

                            // Action buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.rate_review),
                                    label: const Text('Start Review'),
                                    onPressed: () => _startReview(review),
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

  List<Widget> _buildTeamMembersList(dynamic members) {
    if (members is! List) return [];

    return (members).map((member) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            const Icon(Icons.person, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(member['name'] ?? member['username'] ?? 'Unknown'),
            const SizedBox(width: 8),
            Text(
              '(${member['role'] ?? 'Member'})',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }).toList();
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

  void _startReview(Map<String, dynamic> review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you ready to start reviewing "${review['title']}"?'),
            const SizedBox(height: 8),
            Text(
              'This will mark the review as in progress.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Start review logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Review started successfully')),
              );
            },
            child: const Text('Start Review'),
          ),
        ],
      ),
    );
  }

  void _viewDetails(Map<String, dynamic> review) {
    // TODO: Navigate to detailed review screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('View details feature coming soon')),
    );
  }
}
