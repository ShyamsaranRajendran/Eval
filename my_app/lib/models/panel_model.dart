import 'project_model.dart';

class PanelModel {
  final String id;
  final String name;
  final String venue;
  final String coordinatorId;
  final String coordinatorName;
  final String facultyCoordinator;
  final String studentCoordinator;
  final String? studentCoordinatorPhone;
  final List<String> panelMembers;
  final List<ProjectModel> projects;
  final DateTime reviewDate;
  final String status; // 'scheduled', 'in_progress', 'completed'
  final DateTime createdAt;
  final DateTime? updatedAt;

  PanelModel({
    required this.id,
    required this.name,
    required this.venue,
    required this.coordinatorId,
    required this.coordinatorName,
    required this.facultyCoordinator,
    required this.studentCoordinator,
    this.studentCoordinatorPhone,
    this.panelMembers = const [],
    this.projects = const [],
    required this.reviewDate,
    this.status = 'scheduled',
    required this.createdAt,
    this.updatedAt,
  });

  factory PanelModel.fromJson(Map<String, dynamic> json) {
    return PanelModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      venue: json['venue'] ?? '',
      coordinatorId: json['coordinator_id'] ?? json['coordinatorId'] ?? '',
      coordinatorName:
          json['coordinator_name'] ?? json['coordinatorName'] ?? '',
      facultyCoordinator:
          json['faculty_coordinator'] ?? json['facultyCoordinator'] ?? '',
      studentCoordinator:
          json['student_coordinator'] ?? json['studentCoordinator'] ?? '',
      studentCoordinatorPhone:
          json['student_coordinator_phone'] ?? json['studentCoordinatorPhone'],
      panelMembers: (json['panel_members'] as List?)?.cast<String>() ?? [],
      projects:
          (json['projects'] as List?)
              ?.map((p) => ProjectModel.fromJson(p))
              .toList() ??
          [],
      reviewDate: DateTime.parse(
        json['review_date'] ??
            json['reviewDate'] ??
            DateTime.now().toIso8601String(),
      ),
      status: json['status'] ?? 'scheduled',
      createdAt: DateTime.parse(
        json['created_at'] ??
            json['createdAt'] ??
            DateTime.now().toIso8601String(),
      ),
      updatedAt: json['updated_at'] != null || json['updatedAt'] != null
          ? DateTime.parse(json['updated_at'] ?? json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'venue': venue,
      'coordinator_id': coordinatorId,
      'coordinator_name': coordinatorName,
      'faculty_coordinator': facultyCoordinator,
      'student_coordinator': studentCoordinator,
      'student_coordinator_phone': studentCoordinatorPhone,
      'panel_members': panelMembers,
      'projects': projects.map((p) => p.toJson()).toList(),
      'review_date': reviewDate.toIso8601String(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  int get totalProjects => projects.length;

  int get completedReviews =>
      projects.where((p) => p.isReviewed || p.isCompleted).length;

  double get completionPercentage {
    if (totalProjects == 0) return 0.0;
    return (completedReviews / totalProjects) * 100;
  }

  bool get isScheduled => status == 'scheduled';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';

  int get totalStudents =>
      projects.fold(0, (sum, project) => sum + project.studentCount);

  String get panelMembersDisplay => panelMembers.join(', ');

  PanelModel copyWith({
    String? id,
    String? name,
    String? venue,
    String? coordinatorId,
    String? coordinatorName,
    String? facultyCoordinator,
    String? studentCoordinator,
    String? studentCoordinatorPhone,
    List<String>? panelMembers,
    List<ProjectModel>? projects,
    DateTime? reviewDate,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PanelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      venue: venue ?? this.venue,
      coordinatorId: coordinatorId ?? this.coordinatorId,
      coordinatorName: coordinatorName ?? this.coordinatorName,
      facultyCoordinator: facultyCoordinator ?? this.facultyCoordinator,
      studentCoordinator: studentCoordinator ?? this.studentCoordinator,
      studentCoordinatorPhone:
          studentCoordinatorPhone ?? this.studentCoordinatorPhone,
      panelMembers: panelMembers ?? this.panelMembers,
      projects: projects ?? this.projects,
      reviewDate: reviewDate ?? this.reviewDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'PanelModel{id: $id, name: $name, venue: $venue}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PanelModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
