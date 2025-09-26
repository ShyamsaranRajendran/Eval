import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../widgets/expansion_tile_widget.dart';

class PanelDetailScreen extends StatefulWidget {
  const PanelDetailScreen({super.key});

  @override
  State<PanelDetailScreen> createState() => _PanelDetailScreenState();
}

class _PanelDetailScreenState extends State<PanelDetailScreen> {
  Map<String, dynamic>? _panel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get panel data from navigation arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      _panel = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_panel == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Panel Details'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
        ),
        body: const Center(child: Text('No panel data available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_panel!['name'] ?? AppStrings.panelDetails),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Edit panel
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit panel feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Panel Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Panel Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Name', _panel!['name'] ?? 'N/A'),
                    _buildInfoRow(
                      'Description',
                      _panel!['description'] ?? 'N/A',
                    ),
                    _buildInfoRow('Status', _panel!['status'] ?? 'Pending'),
                    _buildInfoRow('Due Date', _panel!['due_date'] ?? 'Not set'),
                    _buildInfoRow('Priority', _panel!['priority'] ?? 'Normal'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tasks Section
            CustomExpansionTile(
              title: 'Tasks',
              subtitle: '${(_panel!['tasks'] as List?)?.length ?? 0} items',
              icon: Icons.task,
              children: _buildTasksList(),
            ),
            const SizedBox(height: 16),

            // Team Members Section
            CustomExpansionTile(
              title: 'Team Members',
              subtitle: '${(_panel!['members'] as List?)?.length ?? 0} members',
              icon: Icons.group,
              children: _buildMembersList(),
            ),
            const SizedBox(height: 16),

            // Comments Section
            CustomExpansionTile(
              title: 'Comments',
              subtitle:
                  '${(_panel!['comments'] as List?)?.length ?? 0} comments',
              icon: Icons.comment,
              children: _buildCommentsList(),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.rate_review),
                    label: const Text(AppStrings.submitReview),
                    onPressed: () {
                      _showReviewDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.history),
                    label: const Text('View History'),
                    onPressed: () {
                      // TODO: Show history
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTasksList() {
    final tasks =
        (_panel!['tasks'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    if (tasks.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('No tasks available'),
        ),
      ];
    }

    return tasks.map((task) {
      return ListTile(
        leading: Icon(
          task['completed'] == true
              ? Icons.check_circle
              : Icons.circle_outlined,
          color: task['completed'] == true ? AppColors.success : AppColors.grey,
        ),
        title: Text(task['title'] ?? 'Untitled Task'),
        subtitle: Text(task['description'] ?? 'No description'),
        onTap: () {
          // TODO: Handle task tap
        },
      );
    }).toList();
  }

  List<Widget> _buildMembersList() {
    final members =
        (_panel!['members'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    if (members.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('No team members assigned'),
        ),
      ];
    }

    return members.map((member) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text(
            (member['name'] ?? member['username'] ?? 'U')[0].toUpperCase(),
            style: const TextStyle(color: AppColors.white),
          ),
        ),
        title: Text(member['name'] ?? member['username'] ?? 'Unknown'),
        subtitle: Text(member['role'] ?? 'Team Member'),
      );
    }).toList();
  }

  List<Widget> _buildCommentsList() {
    final comments =
        (_panel!['comments'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    if (comments.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('No comments yet'),
        ),
      ];
    }

    return comments.map((comment) {
      return ListTile(
        leading: const Icon(Icons.comment),
        title: Text(comment['author'] ?? 'Anonymous'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(comment['content'] ?? 'No content'),
            const SizedBox(height: 4),
            Text(
              comment['timestamp'] ?? 'Unknown time',
              style: const TextStyle(fontSize: 12, color: AppColors.textHint),
            ),
          ],
        ),
        isThreeLine: true,
      );
    }).toList();
  }

  void _showReviewDialog() {
    final reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.submitReview),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: reviewController,
              decoration: const InputDecoration(
                labelText: 'Review Comments',
                hintText: 'Enter your review...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
              // TODO: Submit review
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Review submitted successfully')),
              );
            },
            child: const Text(AppStrings.submitReview),
          ),
        ],
      ),
    );
  }
}
