import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../services/api_service.dart';
import '../../models/user_model.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final ApiService _apiService = ApiService();
  List<UserModel> _users = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final users = await _apiService.getUsers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading users: $e'),
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
        title: const Text(AppStrings.users),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
          ? const Center(
              child: Text(
                AppStrings.noData,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text(user.fullName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.email),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: user.isAdmin
                                ? AppColors.primary
                                : AppColors.secondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user.role.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    leading: CircleAvatar(
                      backgroundColor: user.isActive
                          ? AppColors.success
                          : AppColors.error,
                      child: Text(
                        user.fullName.isNotEmpty
                            ? user.fullName[0].toUpperCase()
                            : user.username[0].toUpperCase(),
                        style: const TextStyle(color: AppColors.white),
                      ),
                    ),
                    trailing: Icon(
                      user.isActive ? Icons.check_circle : Icons.block,
                      color: user.isActive
                          ? AppColors.success
                          : AppColors.error,
                    ),
                    onTap: () {
                      // TODO: Navigate to user details
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new user
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add user feature coming soon')),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
