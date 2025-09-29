import 'package:equatable/equatable.dart';

/// Review Phase model matching backend schema
class ReviewPhaseModel extends Equatable {
  final String id;
  final String name; // e.g., "Review I"
  final int order;
  final String academicYear;
  final bool isActive;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  const ReviewPhaseModel({
    required this.id,
    required this.name,
    required this.order,
    required this.academicYear,
    this.isActive = false,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  factory ReviewPhaseModel.fromJson(Map<String, dynamic> json) {
    return ReviewPhaseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      order: json['order'] as int,
      academicYear: json['academicYear'] as String,
      isActive: json['isActive'] as bool? ?? false,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'order': order,
      'academicYear': academicYear,
      'isActive': isActive,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ReviewPhaseModel copyWith({
    String? id,
    String? name,
    int? order,
    String? academicYear,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
  }) {
    return ReviewPhaseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      academicYear: academicYear ?? this.academicYear,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    order,
    academicYear,
    isActive,
    startDate,
    endDate,
    createdAt,
  ];
}

/// Evaluation Criteria model matching backend schema
class EvaluationCriteriaModel extends Equatable {
  final String id;
  final String reviewPhaseId;
  final String name;
  final String description;
  final int maxMarks;
  final double weightage;
  final int order;

  const EvaluationCriteriaModel({
    required this.id,
    required this.reviewPhaseId,
    required this.name,
    required this.description,
    required this.maxMarks,
    required this.weightage,
    required this.order,
  });

  factory EvaluationCriteriaModel.fromJson(Map<String, dynamic> json) {
    return EvaluationCriteriaModel(
      id: json['id'] as String,
      reviewPhaseId: json['reviewPhaseId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      maxMarks: json['maxMarks'] as int,
      weightage: (json['weightage'] as num).toDouble(),
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reviewPhaseId': reviewPhaseId,
      'name': name,
      'description': description,
      'maxMarks': maxMarks,
      'weightage': weightage,
      'order': order,
    };
  }

  EvaluationCriteriaModel copyWith({
    String? id,
    String? reviewPhaseId,
    String? name,
    String? description,
    int? maxMarks,
    double? weightage,
    int? order,
  }) {
    return EvaluationCriteriaModel(
      id: id ?? this.id,
      reviewPhaseId: reviewPhaseId ?? this.reviewPhaseId,
      name: name ?? this.name,
      description: description ?? this.description,
      maxMarks: maxMarks ?? this.maxMarks,
      weightage: weightage ?? this.weightage,
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [
    id,
    reviewPhaseId,
    name,
    description,
    maxMarks,
    weightage,
    order,
  ];
}
