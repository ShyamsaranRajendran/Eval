import 'package:equatable/equatable.dart';

/// Review phase status enumeration
enum ReviewPhaseStatus { draft, active, completed, cancelled }

/// Extension for ReviewPhaseStatus
extension ReviewPhaseStatusExtension on ReviewPhaseStatus {
  String get displayName {
    switch (this) {
      case ReviewPhaseStatus.draft:
        return 'Draft';
      case ReviewPhaseStatus.active:
        return 'Active';
      case ReviewPhaseStatus.completed:
        return 'Completed';
      case ReviewPhaseStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get value {
    switch (this) {
      case ReviewPhaseStatus.draft:
        return 'draft';
      case ReviewPhaseStatus.active:
        return 'active';
      case ReviewPhaseStatus.completed:
        return 'completed';
      case ReviewPhaseStatus.cancelled:
        return 'cancelled';
    }
  }

  static ReviewPhaseStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'draft':
        return ReviewPhaseStatus.draft;
      case 'active':
        return ReviewPhaseStatus.active;
      case 'completed':
        return ReviewPhaseStatus.completed;
      case 'cancelled':
        return ReviewPhaseStatus.cancelled;
      default:
        throw ArgumentError('Invalid review phase status: $value');
    }
  }
}

/// Review phase model
class ReviewPhaseModel extends Equatable {
  final String id;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final ReviewPhaseStatus status;
  final int maxScore;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  const ReviewPhaseModel({
    required this.id,
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.maxScore = 100,
    this.isActive = false,
    required this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  factory ReviewPhaseModel.fromJson(Map<String, dynamic> json) {
    return ReviewPhaseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      status: ReviewPhaseStatusExtension.fromString(json['status'] as String),
      maxScore: json['max_score'] as int? ?? 100,
      isActive: json['is_active'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'status': status.value,
      'max_score': maxScore,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  ReviewPhaseModel copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    ReviewPhaseStatus? status,
    int? maxScore,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return ReviewPhaseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      maxScore: maxScore ?? this.maxScore,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    startDate,
    endDate,
    status,
    maxScore,
    isActive,
    createdAt,
    updatedAt,
    metadata,
  ];
}

/// Evaluation criteria model
class EvaluationCriteriaModel extends Equatable {
  final String id;
  final String phaseId;
  final String name;
  final String description;
  final double maxScore;
  final double weight;
  final int order;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const EvaluationCriteriaModel({
    required this.id,
    required this.phaseId,
    required this.name,
    required this.description,
    required this.maxScore,
    this.weight = 1.0,
    this.order = 0,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory EvaluationCriteriaModel.fromJson(Map<String, dynamic> json) {
    return EvaluationCriteriaModel(
      id: json['id'] as String,
      phaseId: json['phase_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      maxScore: (json['max_score'] as num).toDouble(),
      weight: (json['weight'] as num?)?.toDouble() ?? 1.0,
      order: json['order'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phase_id': phaseId,
      'name': name,
      'description': description,
      'max_score': maxScore,
      'weight': weight,
      'order': order,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  EvaluationCriteriaModel copyWith({
    String? id,
    String? phaseId,
    String? name,
    String? description,
    double? maxScore,
    double? weight,
    int? order,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EvaluationCriteriaModel(
      id: id ?? this.id,
      phaseId: phaseId ?? this.phaseId,
      name: name ?? this.name,
      description: description ?? this.description,
      maxScore: maxScore ?? this.maxScore,
      weight: weight ?? this.weight,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    phaseId,
    name,
    description,
    maxScore,
    weight,
    order,
    isActive,
    createdAt,
    updatedAt,
  ];
}

/// Create review phase request model
class CreateReviewPhaseRequest extends Equatable {
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final int maxScore;
  final List<CreateCriteriaRequest> criteria;

  const CreateReviewPhaseRequest({
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
    this.maxScore = 100,
    this.criteria = const [],
  });

  factory CreateReviewPhaseRequest.fromJson(Map<String, dynamic> json) {
    return CreateReviewPhaseRequest(
      name: json['name'] as String,
      description: json['description'] as String?,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      maxScore: json['max_score'] as int? ?? 100,
      criteria:
          (json['criteria'] as List<dynamic>?)
              ?.map(
                (e) =>
                    CreateCriteriaRequest.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'max_score': maxScore,
      'criteria': criteria.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    name,
    description,
    startDate,
    endDate,
    maxScore,
    criteria,
  ];
}

/// Create criteria request model
class CreateCriteriaRequest extends Equatable {
  final String name;
  final String description;
  final double maxScore;
  final double weight;
  final int order;

  const CreateCriteriaRequest({
    required this.name,
    required this.description,
    required this.maxScore,
    this.weight = 1.0,
    this.order = 0,
  });

  factory CreateCriteriaRequest.fromJson(Map<String, dynamic> json) {
    return CreateCriteriaRequest(
      name: json['name'] as String,
      description: json['description'] as String,
      maxScore: (json['max_score'] as num).toDouble(),
      weight: (json['weight'] as num?)?.toDouble() ?? 1.0,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'max_score': maxScore,
      'weight': weight,
      'order': order,
    };
  }

  @override
  List<Object?> get props => [name, description, maxScore, weight, order];
}
