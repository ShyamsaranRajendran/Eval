import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../services/api_service.dart';

class PanelsScreen extends StatefulWidget {
  const PanelsScreen({super.key});

  @override
  State<PanelsScreen> createState() => _PanelsScreenState();
}

class _PanelsScreenState extends State<PanelsScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _panels = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPanels();
  }

  Future<void> _loadPanels() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final panels = await _apiService.getPanels();
      setState(() {
        _panels = panels;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading panels: $e'),
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
        title: const Text(AppStrings.panels),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _panels.isEmpty
          ? const Center(
              child: Text(
                AppStrings.noData,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _panels.length,
              itemBuilder: (context, index) {
                final panel = _panels[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text(panel['name'] ?? 'Panel ${index + 1}'),
                    subtitle: Text(panel['description'] ?? 'No description'),
                    leading: const Icon(Icons.dashboard),
                    trailing: Text(
                      panel['status'] ?? 'Active',
                      style: TextStyle(
                        color: panel['status'] == 'Active'
                            ? AppColors.success
                            : AppColors.warning,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // TODO: Navigate to panel details
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new panel
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add panel feature coming soon')),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
