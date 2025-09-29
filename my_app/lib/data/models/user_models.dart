import 'package:equatable/equatable.dart';

/// User role enumeration matching backend schema
enum UserRole { admin, coordinator, faculty }

/// Extension for UserRole
extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.coordinator:
        return 'Panel Coordinator';
      case UserRole.faculty:
        return 'Faculty';
    }
  }

  String get value {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.coordinator:
        return 'coordinator';
      case UserRole.faculty:
        return 'faculty';
    }
  }

  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'coordinator':
        return UserRole.coordinator;
      case 'faculty':
        return UserRole.faculty;
      default:
        throw ArgumentError('Invalid user role: $value');
    }
  }

  bool get isAdmin => this == UserRole.admin;
  bool get isCoordinator => this == UserRole.coordinator;
  bool get isFaculty => this == UserRole.faculty;

  // Admin has full control over system administration
  bool get canManageUsers => isAdmin;
  bool get canCreatePanels => isAdmin;
  bool get canAssignStudents => isAdmin;
  bool get canAssignPanels => isAdmin;
  bool get canManageSystem => isAdmin;

  // Panel Coordinator supervises evaluation panels
  bool get canSuperviseEvaluations => isCoordinator;
  bool get canMonitorPanels => isCoordinator;
  bool get canViewPanelReports => isCoordinator;

  // Faculty evaluates student projects
  bool get canEvaluate => isFaculty;
  bool get canViewStudentProjects => isFaculty;

  // General permissions
  bool get canViewReports => isAdmin || isCoordinator || isFaculty;

  /// Get role-specific description of responsibilities
  String get roleDescription {
    switch (this) {
      case UserRole.admin:
        return 'System Administrator - Manages panels, assigns students, and configures system';
      case UserRole.coordinator:
        return 'Panel Coordinator - Supervises evaluation panels and monitors progress';
      case UserRole.faculty:
        return 'Faculty Member - Evaluates student projects and provides feedback';
    }
  }

  /// Get main capabilities for this role
  List<String> get mainCapabilities {
    switch (this) {
      case UserRole.admin:
        return [
          'Create and manage evaluation panels',
          'Assign students to panels',
          'Assign panels to faculty',
          'Manage user accounts',
          'System configuration',
        ];
      case UserRole.coordinator:
        return [
          'Supervise evaluation processes',
          'Monitor panel progress',
          'View evaluation reports',
          'Coordinate with faculty',
        ];
      case UserRole.faculty:
        return [
          'Evaluate student projects',
          'Provide feedback and grades',
          'View assigned students',
          'Submit evaluation forms',
        ];
    }
  }
}

/// User model matching backend schema
class UserModel extends Equatable {
  final String id;
  final String email;
  final String password; // Hashed password from backend
  final String name;
  final UserRole role;
  final String department;
  final bool isActive;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    required this.department,
    this.isActive = true,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      password:
          json['password'] as String? ??
          '', // Password won't be returned from API usually
      name: json['name'] as String,
      role: UserRoleExtension.fromString(json['role'] as String),
      department: json['department'] as String,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'role': role.value,
      'department': department,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
    UserRole? role,
    String? department,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      role: role ?? this.role,
      department: department ?? this.department,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    password,
    name,
    role,
    department,
    isActive,
    createdAt,
  ];
}

/// Login request model
class LoginRequest extends Equatable {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      rememberMe: json['remember_me'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'remember_me': rememberMe};
  }

  @override
  List<Object?> get props => [email, password, rememberMe];
}

/// Login response model
class LoginResponse extends Equatable {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final DateTime expiresAt;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.expiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user': user.toJson(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, user, expiresAt];
}

/// Register request model
class RegisterRequest extends Equatable {
  final String email;
  final String password;
  final String name;
  final UserRole role;
  final String? department;
  final String? phoneNumber;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    this.department,
    this.phoneNumber,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      role: UserRoleExtension.fromString(json['role'] as String),
      department: json['department'] as String?,
      phoneNumber: json['phone_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'role': role.value,
      'department': department,
      'phone_number': phoneNumber,
    };
  }

  @override
  List<Object?> get props => [
    email,
    password,
    name,
    role,
    department,
    phoneNumber,
  ];
}

/// Update user request model
class UpdateUserRequest extends Equatable {
  final String? name;
  final String? department;
  final String? phoneNumber;
  final String? profileImageUrl;
  final bool? isActive;

  const UpdateUserRequest({
    this.name,
    this.department,
    this.phoneNumber,
    this.profileImageUrl,
    this.isActive,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) {
    return UpdateUserRequest(
      name: json['name'] as String?,
      department: json['department'] as String?,
      phoneNumber: json['phone_number'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      isActive: json['is_active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'department': department,
      'phone_number': phoneNumber,
      'profile_image_url': profileImageUrl,
      'is_active': isActive,
    };
  }

  @override
  List<Object?> get props => [
    name,
    department,
    phoneNumber,
    profileImageUrl,
    isActive,
  ];
}
