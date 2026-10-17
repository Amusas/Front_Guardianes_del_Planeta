enum UserRole {
  GUARDIAN,
  CHILD,
}

enum UserStatus {
  ACTIVE,
  INACTIVE,
  SUSPENDED,
}

class UserRegisterRequest {
  final String username;
  final String password;
  final UserRole role;

  UserRegisterRequest({
    required this.username,
    required this.password,
    this.role = UserRole.GUARDIAN,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'role': role.name,
      };
}

class UserLoginRequest {
  final String username;
  final String password;

  UserLoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}

class UserResponseDto {
  final int id;
  final String username;
  final UserRole role;
  final UserStatus status;
  final DateTime createdAt;

  UserResponseDto({
    required this.id,
    required this.username,
    required this.role,
    required this.status,
    required this.createdAt,
  });

  factory UserResponseDto.fromJson(Map<String, dynamic> json) {
    return UserResponseDto(
      id: json['id'] as int,
      username: json['username'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.CHILD,
      ),
      status: UserStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => UserStatus.ACTIVE,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class AuthResponseDto {
  final String token;
  final String tokenType;
  final String username;
  final UserRole role;
  final int userId;
  final int expiresInMs;

  AuthResponseDto({
    required this.token,
    required this.tokenType,
    required this.username,
    required this.role,
    required this.userId,
    required this.expiresInMs,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      token: json['token'] as String,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      username: json['username'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.CHILD,
      ),
      userId: json['userId'] as int,
      expiresInMs: json['expiresInMs'] as int? ?? 3600000,
    );
  }
}

class ErrorResponseDto {
  final int statusCode;
  final String error;
  final String message;
  final String? path;
  final DateTime? timestamp;
  final List<String>? details;

  ErrorResponseDto({
    required this.statusCode,
    required this.error,
    required this.message,
    this.path,
    this.timestamp,
    this.details,
  });

  factory ErrorResponseDto.fromJson(Map<String, dynamic> json) {
    return ErrorResponseDto(
      statusCode: json['statusCode'] as int? ?? 500,
      error: json['error'] as String? ?? 'Unknown',
      message: json['message'] as String? ?? 'Ha ocurrido un error inesperado',
      path: json['path'] as String?,
      timestamp: json['timestamp'] != null ? DateTime.tryParse(json['timestamp']) : null,
      details: (json['details'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}
