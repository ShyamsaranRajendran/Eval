class ReviewModel {
  final String id;
  final String projectId;
  final String reviewerId;
  final String reviewerName;
  final int reviewNumber; // 1 for first review, 2 for second review, etc.
  final Map<String, double> marks; // subject/criteria -> marks
  final Map<String, String> comments; // subject/criteria -> comments
  final double totalScore;
  final double maxScore;
  final String status; // 'pending', 'in_progress', 'completed'
  final DateTime? reviewDate;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ReviewModel({
    required this.id,
    required this.projectId,
    required this.reviewerId,
    required this.reviewerName,
    required this.reviewNumber,
    this.marks = const {},
    this.comments = const {},
    this.totalScore = 0.0,
    this.maxScore = 100.0,
    this.status = 'pending',
    this.reviewDate,
    required this.createdAt,
    this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      projectId: json['project_id'] ?? json['projectId'] ?? '',
      reviewerId: json['reviewer_id'] ?? json['reviewerId'] ?? '',
      reviewerName: json['reviewer_name'] ?? json['reviewerName'] ?? '',
      reviewNumber: json['review_number'] ?? json['reviewNumber'] ?? 1,
      marks: Map<String, double>.from(json['marks'] ?? {}),
      comments: Map<String, String>.from(json['comments'] ?? {}),
      totalScore: (json['total_score'] ?? json['totalScore'] ?? 0.0).toDouble(),
      maxScore: (json['max_score'] ?? json['maxScore'] ?? 100.0).toDouble(),
      status: json['status'] ?? 'pending',
      reviewDate: json['review_date'] != null || json['reviewDate'] != null
          ? DateTime.parse(json['review_date'] ?? json['reviewDate'])
          : null,
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
      'project_id': projectId,
      'reviewer_id': reviewerId,
      'reviewer_name': reviewerName,
      'review_number': reviewNumber,
      'marks': marks,
      'comments': comments,
      'total_score': totalScore,
      'max_score': maxScore,
      'status': status,
      'review_date': reviewDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  double get percentage {
    if (maxScore == 0) return 0.0;
    return (totalScore / maxScore) * 100;
  }

  String get grade {
    final percent = percentage;
    if (percent >= 90) return 'A+';
    if (percent >= 80) return 'A';
    if (percent >= 70) return 'B+';
    if (percent >= 60) return 'B';
    if (percent >= 50) return 'C';
    return 'F';
  }

  bool get isPending => status == 'pending';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';

  String get reviewTypeDisplay {
    switch (reviewNumber) {
      case 1:
        return 'First Review';
      case 2:
        return 'Second Review';
      case 3:
        return 'Final Review';
      default:
        return 'Review $reviewNumber';
    }
  }

  ReviewModel copyWith({
    String? id,
    String? projectId,
    String? reviewerId,
    String? reviewerName,
    int? reviewNumber,
    Map<String, double>? marks,
    Map<String, String>? comments,
    double? totalScore,
    double? maxScore,
    String? status,
    DateTime? reviewDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      reviewerId: reviewerId ?? this.reviewerId,
      reviewerName: reviewerName ?? this.reviewerName,
      reviewNumber: reviewNumber ?? this.reviewNumber,
      marks: marks ?? this.marks,
      comments: comments ?? this.comments,
      totalScore: totalScore ?? this.totalScore,
      maxScore: maxScore ?? this.maxScore,
      status: status ?? this.status,
      reviewDate: reviewDate ?? this.reviewDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ReviewModel{id: $id, projectId: $projectId, reviewNumber: $reviewNumber}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReviewModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Review criteria model for standardized evaluation
class ReviewCriteria {
  final String id;
  final String name;
  final String description;
  final double maxMarks;
  final double weightage;
  final bool isRequired;

  const ReviewCriteria({
    required this.id,
    required this.name,
    required this.description,
    required this.maxMarks,
    this.weightage = 1.0,
    this.isRequired = true,
  });

  factory ReviewCriteria.fromJson(Map<String, dynamic> json) {
    return ReviewCriteria(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      maxMarks: (json['max_marks'] ?? json['maxMarks'] ?? 0.0).toDouble(),
      weightage: (json['weightage'] ?? 1.0).toDouble(),
      isRequired: json['is_required'] ?? json['isRequired'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'max_marks': maxMarks,
      'weightage': weightage,
      'is_required': isRequired,
    };
  }

  static List<ReviewCriteria> defaultCriteria = [
    const ReviewCriteria(
      id: 'technical_content',
      name: 'Technical Content',
      description: 'Quality and depth of technical implementation',
      maxMarks: 25.0,
    ),
    const ReviewCriteria(
      id: 'innovation',
      name: 'Innovation & Creativity',
      description: 'Novelty and creative approach to problem solving',
      maxMarks: 20.0,
    ),
    const ReviewCriteria(
      id: 'presentation',
      name: 'Presentation',
      description: 'Quality of presentation and communication skills',
      maxMarks: 20.0,
    ),
    const ReviewCriteria(
      id: 'documentation',
      name: 'Documentation',
      description: 'Quality and completeness of project documentation',
      maxMarks: 15.0,
    ),
    const ReviewCriteria(
      id: 'project_management',
      name: 'Project Management',
      description: 'Planning, execution, and timeline management',
      maxMarks: 10.0,
    ),
    const ReviewCriteria(
      id: 'team_work',
      name: 'Team Work',
      description: 'Collaboration and individual contributions',
      maxMarks: 10.0,
    ),
  ];
}
