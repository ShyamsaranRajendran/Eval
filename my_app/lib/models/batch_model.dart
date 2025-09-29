class BatchModel {
  final String id;
  final String name;
  final String department;
  final int year;
  final String? description;
  final bool isActive;
  final DateTime startDate;
  final DateTime? endDate;
  final int totalProjects;
  final int completedProjects;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BatchModel({
    required this.id,
    required this.name,
    required this.department,
    required this.year,
    this.description,
    this.isActive = true,
    required this.startDate,
    this.endDate,
    this.totalProjects = 0,
    this.completedProjects = 0,
    required this.createdAt,
    this.updatedAt,
  });

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    return BatchModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      department: json['department'] ?? 'CSE',
      year: json['year'] ?? DateTime.now().year,
      description: json['description'],
      isActive: json['is_active'] ?? json['isActive'] ?? true,
      startDate: DateTime.parse(
        json['start_date'] ??
            json['startDate'] ??
            DateTime.now().toIso8601String(),
      ),
      endDate: json['end_date'] != null || json['endDate'] != null
          ? DateTime.parse(json['end_date'] ?? json['endDate'])
          : null,
      totalProjects: json['total_projects'] ?? json['totalProjects'] ?? 0,
      completedProjects:
          json['completed_projects'] ?? json['completedProjects'] ?? 0,
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
      'department': department,
      'year': year,
      'description': description,
      'is_active': isActive,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'total_projects': totalProjects,
      'completed_projects': completedProjects,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  double get completionPercentage {
    if (totalProjects == 0) return 0.0;
    return (completedProjects / totalProjects) * 100;
  }

  String get displayName => '$name ($year)';

  bool get isCompleted =>
      completedProjects == totalProjects && totalProjects > 0;

  int get pendingProjects => totalProjects - completedProjects;

  BatchModel copyWith({
    String? id,
    String? name,
    String? department,
    int? year,
    String? description,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    int? totalProjects,
    int? completedProjects,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BatchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      department: department ?? this.department,
      year: year ?? this.year,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalProjects: totalProjects ?? this.totalProjects,
      completedProjects: completedProjects ?? this.completedProjects,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'BatchModel{id: $id, name: $name, year: $year}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BatchModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
