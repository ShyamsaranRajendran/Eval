import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../services/api_service.dart';

class BatchesScreen extends StatefulWidget {
  const BatchesScreen({super.key});

  @override
  State<BatchesScreen> createState() => _BatchesScreenState();
}

class _BatchesScreenState extends State<BatchesScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _batches = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBatches();
  }

  Future<void> _loadBatches() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final batches = await _apiService.getBatches();
      setState(() {
        _batches = batches;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading batches: $e'),
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
        title: const Text(AppStrings.batches),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _batches.isEmpty
          ? const Center(
              child: Text(
                AppStrings.noData,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _batches.length,
              itemBuilder: (context, index) {
                final batch = _batches[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text(batch['name'] ?? 'Batch ${index + 1}'),
                    subtitle: Text(batch['description'] ?? 'No description'),
                    leading: const Icon(Icons.batch_prediction),
                    onTap: () {
                      // TODO: Navigate to batch details
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new batch
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add batch feature coming soon')),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
