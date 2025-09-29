import 'package:equatable/equatable.dart';

/// Student model matching backend schema
class StudentModel extends Equatable {
  final String id;
  final String registerNo; // Unique registration number
  final String name;
  final String projectTitle;
  final String supervisor;
  final String email;
  final String phone;

  const StudentModel({
    required this.id,
    required this.registerNo,
    required this.name,
    required this.projectTitle,
    required this.supervisor,
    required this.email,
    required this.phone,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String,
      registerNo: json['registerNo'] as String,
      name: json['name'] as String,
      projectTitle: json['projectTitle'] as String,
      supervisor: json['supervisor'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registerNo': registerNo,
      'name': name,
      'projectTitle': projectTitle,
      'supervisor': supervisor,
      'email': email,
      'phone': phone,
    };
  }

  StudentModel copyWith({
    String? id,
    String? registerNo,
    String? name,
    String? projectTitle,
    String? supervisor,
    String? email,
    String? phone,
  }) {
    return StudentModel(
      id: id ?? this.id,
      registerNo: registerNo ?? this.registerNo,
      name: name ?? this.name,
      projectTitle: projectTitle ?? this.projectTitle,
      supervisor: supervisor ?? this.supervisor,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [
    id,
    registerNo,
    name,
    projectTitle,
    supervisor,
    email,
    phone,
  ];
}

/// Panel model matching backend schema
class PanelModel extends Equatable {
  final String id;
  final String name;
  final String location;
  final String reviewPhaseId;
  final String coordinatorId;
  final int capacity;
  final int currentCount;

  const PanelModel({
    required this.id,
    required this.name,
    required this.location,
    required this.reviewPhaseId,
    required this.coordinatorId,
    required this.capacity,
    this.currentCount = 0,
  });

  factory PanelModel.fromJson(Map<String, dynamic> json) {
    return PanelModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      reviewPhaseId: json['reviewPhaseId'] as String,
      coordinatorId: json['coordinatorId'] as String,
      capacity: json['capacity'] as int,
      currentCount: json['currentCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'reviewPhaseId': reviewPhaseId,
      'coordinatorId': coordinatorId,
      'capacity': capacity,
      'currentCount': currentCount,
    };
  }

  PanelModel copyWith({
    String? id,
    String? name,
    String? location,
    String? reviewPhaseId,
    String? coordinatorId,
    int? capacity,
    int? currentCount,
  }) {
    return PanelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      reviewPhaseId: reviewPhaseId ?? this.reviewPhaseId,
      coordinatorId: coordinatorId ?? this.coordinatorId,
      capacity: capacity ?? this.capacity,
      currentCount: currentCount ?? this.currentCount,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    location,
    reviewPhaseId,
    coordinatorId,
    capacity,
    currentCount,
  ];
}
