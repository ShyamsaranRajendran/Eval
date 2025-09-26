import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../services/api_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _reports;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final reports = await _apiService.getReports();
      setState(() {
        _reports = reports;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading reports: $e'),
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
        title: const Text(AppStrings.reports),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reports == null
          ? const Center(
              child: Text(
                AppStrings.noData,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Total Users',
                          _reports!['total_users']?.toString() ?? '0',
                          Icons.people,
                          AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          'Active Panels',
                          _reports!['active_panels']?.toString() ?? '0',
                          Icons.dashboard,
                          AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Total Batches',
                          _reports!['total_batches']?.toString() ?? '0',
                          Icons.batch_prediction,
                          AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          'Completed Reviews',
                          _reports!['completed_reviews']?.toString() ?? '0',
                          Icons.check_circle,
                          AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Recent Activity
                  Text(
                    'Recent Activity',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          (_reports!['recent_activity'] as List?)?.length ?? 0,
                      itemBuilder: (context, index) {
                        final activity =
                            (_reports!['recent_activity'] as List)[index];
                        return ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(activity['action'] ?? 'Unknown action'),
                          subtitle: Text(
                            activity['timestamp'] ?? 'Unknown time',
                          ),
                          trailing: Text(activity['user'] ?? 'Unknown user'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
