import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/auth/data/models/auth_models.dart';

void main() {
  group('Auth Models Tests', () {
    test('UserRegisterRequest toJson', () {
      final request = UserRegisterRequest(username: 'test', password: 'password');
      final json = request.toJson();
      expect(json['username'], 'test');
      expect(json['password'], 'password');
      expect(json['role'], 'GUARDIAN');
    });

    test('UserLoginRequest toJson', () {
      final request = UserLoginRequest(username: 'test', password: 'password');
      final json = request.toJson();
      expect(json['username'], 'test');
      expect(json['password'], 'password');
    });

    test('UserResponseDto fromJson', () {
      final json = {
        'id': 1,
        'username': 'test',
        'role': 'GUARDIAN',
        'status': 'ACTIVE',
        'createdAt': '2026-10-08T10:30:00'
      };
      final dto = UserResponseDto.fromJson(json);
      expect(dto.id, 1);
      expect(dto.username, 'test');
      expect(dto.role, UserRole.GUARDIAN);
      expect(dto.status, UserStatus.ACTIVE);
      expect(dto.createdAt, DateTime.parse('2026-10-08T10:30:00'));
    });

    test('AuthResponseDto fromJson', () {
      final json = {
        'token': 'jwt_token',
        'tokenType': 'Bearer',
        'username': 'test',
        'role': 'GUARDIAN',
        'userId': 1,
        'expiresInMs': 3600000
      };
      final dto = AuthResponseDto.fromJson(json);
      expect(dto.token, 'jwt_token');
      expect(dto.tokenType, 'Bearer');
      expect(dto.username, 'test');
      expect(dto.role, UserRole.GUARDIAN);
      expect(dto.userId, 1);
      expect(dto.expiresInMs, 3600000);
    });

    test('ErrorResponseDto fromJson', () {
      final json = {
        'statusCode': 400,
        'error': 'Bad Request',
        'message': 'Invalid data',
      };
      final dto = ErrorResponseDto.fromJson(json);
      expect(dto.statusCode, 400);
      expect(dto.error, 'Bad Request');
      expect(dto.message, 'Invalid data');
      expect(dto.path, isNull);
    });
  });
}
