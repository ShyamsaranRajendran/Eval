class UserModel {
  final String id;
  final String email;
  final String username;
  final String? firstName;
  final String? lastName;
  final String role; // 'admin' or 'reviewer'
  final String? profilePicture;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLogin;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
    required this.role,
    this.profilePicture,
    required this.isActive,
    required this.createdAt,
    this.lastLogin,
  });

  // Factory constructor to create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      role: json['role'] ?? 'reviewer',
      profilePicture: json['profile_picture'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'profile_picture': profilePicture,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }

  // Helper method to get full name
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    }
    return username;
  }

  // Helper method to check if user is admin
  bool get isAdmin => role.toLowerCase() == 'admin';

  // Helper method to check if user is reviewer
  bool get isReviewer => role.toLowerCase() == 'reviewer';

  // Create a copy of UserModel with some fields updated
  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    String? role,
    String? profilePicture,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      profilePicture: profilePicture ?? this.profilePicture,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, email: $email, username: $username, role: $role}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Login request model
class LoginRequest {
  final String email;
  final String password;
  final bool rememberMe;

  LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'remember_me': rememberMe};
  }
}

// Login response model
class LoginResponse {
  final UserModel user;
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;

  LoginResponse({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    required this.expiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: UserModel.fromJson(json['user']),
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'],
      expiresAt: DateTime.parse(
        json['expires_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.toIso8601String(),
    };
  }
}
