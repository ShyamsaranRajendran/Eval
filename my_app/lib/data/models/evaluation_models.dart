import 'package:equatable/equatable.dart';

/// Evaluation model matching backend schema
class EvaluationModel extends Equatable {
  final String id;
  final String reviewPhaseId;
  final String panelId;
  final String evaluatorId;
  final String studentId;
  final String criteriaId;
  final int marksAwarded;
  final String comments;
  final DateTime submittedAt;
  final bool isFinalized;

  const EvaluationModel({
    required this.id,
    required this.reviewPhaseId,
    required this.panelId,
    required this.evaluatorId,
    required this.studentId,
    required this.criteriaId,
    required this.marksAwarded,
    required this.comments,
    required this.submittedAt,
    this.isFinalized = false,
  });

  factory EvaluationModel.fromJson(Map<String, dynamic> json) {
    return EvaluationModel(
      id: json['id'] as String,
      reviewPhaseId: json['reviewPhaseId'] as String,
      panelId: json['panelId'] as String,
      evaluatorId: json['evaluatorId'] as String,
      studentId: json['studentId'] as String,
      criteriaId: json['criteriaId'] as String,
      marksAwarded: json['marksAwarded'] as int,
      comments: json['comments'] as String? ?? '',
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      isFinalized: json['isFinalized'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reviewPhaseId': reviewPhaseId,
      'panelId': panelId,
      'evaluatorId': evaluatorId,
      'studentId': studentId,
      'criteriaId': criteriaId,
      'marksAwarded': marksAwarded,
      'comments': comments,
      'submittedAt': submittedAt.toIso8601String(),
      'isFinalized': isFinalized,
    };
  }

  EvaluationModel copyWith({
    String? id,
    String? reviewPhaseId,
    String? panelId,
    String? evaluatorId,
    String? studentId,
    String? criteriaId,
    int? marksAwarded,
    String? comments,
    DateTime? submittedAt,
    bool? isFinalized,
  }) {
    return EvaluationModel(
      id: id ?? this.id,
      reviewPhaseId: reviewPhaseId ?? this.reviewPhaseId,
      panelId: panelId ?? this.panelId,
      evaluatorId: evaluatorId ?? this.evaluatorId,
      studentId: studentId ?? this.studentId,
      criteriaId: criteriaId ?? this.criteriaId,
      marksAwarded: marksAwarded ?? this.marksAwarded,
      comments: comments ?? this.comments,
      submittedAt: submittedAt ?? this.submittedAt,
      isFinalized: isFinalized ?? this.isFinalized,
    );
  }

  @override
  List<Object?> get props => [
    id,
    reviewPhaseId,
    panelId,
    evaluatorId,
    studentId,
    criteriaId,
    marksAwarded,
    comments,
    submittedAt,
    isFinalized,
  ];
}
