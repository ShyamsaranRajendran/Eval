class StudentModel {
  final String id;
  final String name;
  final String rollNo;
  final String email;
  final String? phone;
  final String department;
  final String batch;
  final int year;
  final String? projectId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  StudentModel({
    required this.id,
    required this.name,
    required this.rollNo,
    required this.email,
    this.phone,
    required this.department,
    required this.batch,
    required this.year,
    this.projectId,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      rollNo: json['roll_no'] ?? json['rollNo'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      department: json['department'] ?? 'CSE',
      batch: json['batch'] ?? '',
      year: json['year'] ?? DateTime.now().year,
      projectId: json['project_id'] ?? json['projectId'],
      isActive: json['is_active'] ?? json['isActive'] ?? true,
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
      'roll_no': rollNo,
      'email': email,
      'phone': phone,
      'department': department,
      'batch': batch,
      'year': year,
      'project_id': projectId,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  StudentModel copyWith({
    String? id,
    String? name,
    String? rollNo,
    String? email,
    String? phone,
    String? department,
    String? batch,
    int? year,
    String? projectId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      rollNo: rollNo ?? this.rollNo,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      batch: batch ?? this.batch,
      year: year ?? this.year,
      projectId: projectId ?? this.projectId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'StudentModel{id: $id, name: $name, rollNo: $rollNo}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
