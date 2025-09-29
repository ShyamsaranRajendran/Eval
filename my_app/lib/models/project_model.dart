import '../data/models/student_panel_models.dart';

class ProjectModel {
  final String id;
  final String title;
  final String? description;
  final String batchId;
  final String supervisorId;
  final String supervisorName;
  final List<StudentModel> students;
  final String? panelId;
  final String
  status; // 'assigned', 'in_progress', 'submitted', 'reviewed', 'completed'
  final DateTime? submissionDate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  ProjectModel({
    required this.id,
    required this.title,
    this.description,
    required this.batchId,
    required this.supervisorId,
    required this.supervisorName,
    this.students = const [],
    this.panelId,
    this.status = 'assigned',
    this.submissionDate,
    required this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      batchId: json['batch_id'] ?? json['batchId'] ?? '',
      supervisorId: json['supervisor_id'] ?? json['supervisorId'] ?? '',
      supervisorName: json['supervisor_name'] ?? json['supervisorName'] ?? '',
      students:
          (json['students'] as List?)
              ?.map((s) => StudentModel.fromJson(s))
              .toList() ??
          [],
      panelId: json['panel_id'] ?? json['panelId'],
      status: json['status'] ?? 'assigned',
      submissionDate:
          json['submission_date'] != null || json['submissionDate'] != null
          ? DateTime.parse(json['submission_date'] ?? json['submissionDate'])
          : null,
      createdAt: DateTime.parse(
        json['created_at'] ??
            json['createdAt'] ??
            DateTime.now().toIso8601String(),
      ),
      updatedAt: json['updated_at'] != null || json['updatedAt'] != null
          ? DateTime.parse(json['updated_at'] ?? json['updatedAt'])
          : null,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'batch_id': batchId,
      'supervisor_id': supervisorId,
      'supervisor_name': supervisorName,
      'students': students.map((s) => s.toJson()).toList(),
      'panel_id': panelId,
      'status': status,
      'submission_date': submissionDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  int get studentCount => students.length;

  bool get isAssigned => status == 'assigned';
  bool get isInProgress => status == 'in_progress';
  bool get isSubmitted => status == 'submitted';
  bool get isReviewed => status == 'reviewed';
  bool get isCompleted => status == 'completed';

  String get teamMembers {
    if (students.isEmpty) return 'No students assigned';
    return students.map((s) => '${s.name} (${s.registerNo})').join(', ');
  }

  ProjectModel copyWith({
    String? id,
    String? title,
    String? description,
    String? batchId,
    String? supervisorId,
    String? supervisorName,
    List<StudentModel>? students,
    String? panelId,
    String? status,
    DateTime? submissionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      batchId: batchId ?? this.batchId,
      supervisorId: supervisorId ?? this.supervisorId,
      supervisorName: supervisorName ?? this.supervisorName,
      students: students ?? this.students,
      panelId: panelId ?? this.panelId,
      status: status ?? this.status,
      submissionDate: submissionDate ?? this.submissionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'ProjectModel{id: $id, title: $title, students: ${students.length}}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProjectModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
