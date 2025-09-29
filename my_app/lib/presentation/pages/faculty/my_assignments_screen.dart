import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/student_panel_models.dart';

class MyAssignmentsScreen extends ConsumerStatefulWidget {
  const MyAssignmentsScreen({super.key});

  @override
  ConsumerState<MyAssignmentsScreen> createState() =>
      _MyAssignmentsScreenState();
}

class _MyAssignmentsScreenState extends ConsumerState<MyAssignmentsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  List<PanelModel> _panels = [];
  List<PanelModel> _filteredPanels = [];
  String _searchQuery = '';
  String _selectedPhaseFilter = 'All';

  final List<String> _reviewPhases = [
    'All',
    'Proposal Defense',
    'Mid-term Evaluation',
    'Final Defense',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAssignments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAssignments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data for faculty assignments
      _panels = [
        PanelModel(
          id: 'panel1',
          name: 'Computer Science - Final Defense Panel A',
          location: 'Room 301, CS Building',
          reviewPhaseId: 'phase_final_defense',
          coordinatorId: 'coordinator1',
          capacity: 10,
          currentCount: 8,
        ),
        PanelModel(
          id: 'panel2',
          name: 'Information Technology - Mid-term Panel B',
          location: 'Room 205, IT Building',
          reviewPhaseId: 'phase_mid_term',
          coordinatorId: 'coordinator2',
          capacity: 8,
          currentCount: 6,
        ),
        PanelModel(
          id: 'panel3',
          name: 'Computer Science - Proposal Defense Panel C',
          location: 'Seminar Hall 1',
          reviewPhaseId: 'phase_proposal_defense',
          coordinatorId: 'coordinator3',
          capacity: 12,
          currentCount: 10,
        ),
        PanelModel(
          id: 'panel4',
          name: 'Electronics Engineering - Final Defense Panel D',
          location: 'Lab 201, EE Building',
          reviewPhaseId: 'phase_final_defense',
          coordinatorId: 'coordinator4',
          capacity: 6,
          currentCount: 5,
        ),
      ];

      _filteredPanels = _panels;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading assignments: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _filterPanels() {
    setState(() {
      _filteredPanels = _panels.where((panel) {
        final matchesSearch =
            _searchQuery.isEmpty ||
            panel.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            panel.location.toLowerCase().contains(_searchQuery.toLowerCase());

        final matchesPhase =
            _selectedPhaseFilter == 'All' ||
            _getPhaseNameFromId(panel.reviewPhaseId) == _selectedPhaseFilter;

        return matchesSearch && matchesPhase;
      }).toList();
    });
  }

  String _getPhaseNameFromId(String phaseId) {
    switch (phaseId) {
      case 'phase_proposal_defense':
        return 'Proposal Defense';
      case 'phase_mid_term':
        return 'Mid-term Evaluation';
      case 'phase_final_defense':
        return 'Final Defense';
      default:
        return 'Unknown';
    }
  }

  String _getPanelStatus(PanelModel panel) {
    if (panel.currentCount >= panel.capacity) {
      return 'Full';
    } else if (panel.currentCount > 0) {
      return 'Active';
    } else {
      return 'Empty';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return AppColors.success;
      case 'Full':
        return AppColors.warning;
      case 'Empty':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Assignments'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAssignments,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'All Panels'),
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search and Filter Section
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    children: [
                      // Search Bar
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search panels...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                          _filterPanels();
                        },
                      ),
                      const SizedBox(height: 16),
                      // Filter Row
                      Row(
                        children: [
                          const Text(
                            'Phase: ',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Expanded(
                            child: DropdownButton<String>(
                              value: _selectedPhaseFilter,
                              isExpanded: true,
                              items: _reviewPhases.map((phase) {
                                return DropdownMenuItem(
                                  value: phase,
                                  child: Text(phase),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedPhaseFilter = value!;
                                });
                                _filterPanels();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Statistics Row
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Panels',
                          _panels.length.toString(),
                          Icons.dashboard,
                          AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Total Students',
                          _panels
                              .fold(0, (sum, panel) => sum + panel.currentCount)
                              .toString(),
                          Icons.people,
                          AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Active Panels',
                          _panels
                              .where((p) => p.currentCount > 0)
                              .length
                              .toString(),
                          Icons.play_circle,
                          AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),

                // Panels List
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPanelsList(_filteredPanels),
                      _buildPanelsList(
                        _filteredPanels
                            .where((p) => p.currentCount > 0)
                            .toList(),
                      ),
                      _buildPanelsList(
                        _filteredPanels
                            .where((p) => p.currentCount >= p.capacity)
                            .toList(),
                      ),
                    ],
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanelsList(List<PanelModel> panels) {
    if (panels.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No panels found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try adjusting your search or filter criteria',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: panels.length,
      itemBuilder: (context, index) {
        final panel = panels[index];
        return _buildPanelCard(panel);
      },
    );
  }

  Widget _buildPanelCard(PanelModel panel) {
    final status = _getPanelStatus(panel);
    final statusColor = _getStatusColor(status);
    final phase = _getPhaseNameFromId(panel.reviewPhaseId);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _showPanelDetails(panel),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      panel.name,
                      style: const TextStyle(
                        fontSize: 16,
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
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Details
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      panel.location,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.category, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(phase, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 12),

              // Capacity Bar
              Row(
                children: [
                  Text(
                    'Capacity: ${panel.currentCount}/${panel.capacity}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Text(
                    '${((panel.currentCount / panel.capacity) * 100).toInt()}%',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: panel.currentCount / panel.capacity,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
              const SizedBox(height: 12),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showPanelDetails(panel),
                      icon: const Icon(Icons.info, size: 16),
                      label: const Text('View Details'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _startEvaluation(panel),
                      icon: const Icon(Icons.rate_review, size: 16),
                      label: const Text('Evaluate'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPanelDetails(PanelModel panel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(panel.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Location', panel.location),
            _buildDetailRow('Phase', _getPhaseNameFromId(panel.reviewPhaseId)),
            _buildDetailRow(
              'Capacity',
              '${panel.currentCount}/${panel.capacity}',
            ),
            _buildDetailRow('Status', _getPanelStatus(panel)),
            _buildDetailRow('Coordinator ID', panel.coordinatorId),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startEvaluation(panel);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Start Evaluation'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _startEvaluation(PanelModel panel) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting evaluation for ${panel.name}'),
        backgroundColor: AppColors.success,
      ),
    );
    // TODO: Implement navigation to evaluation screen
  }
}
