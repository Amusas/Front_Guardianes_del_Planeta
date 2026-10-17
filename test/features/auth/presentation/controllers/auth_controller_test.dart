import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:guardianes_del_planeta/features/auth/domain/repositories/auth_repository.dart';
import 'package:guardianes_del_planeta/core/storage/secure_token_storage.dart';
import 'package:guardianes_del_planeta/features/auth/presentation/controllers/auth_controller.dart';
import 'package:guardianes_del_planeta/features/auth/data/models/auth_models.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockSecureTokenStorage extends Mock implements SecureTokenStorage {}

void main() {
  late AuthController controller;
  late MockAuthRepository mockRepo;
  late MockSecureTokenStorage mockStorage;

  setUp(() {
    mockRepo = MockAuthRepository();
    mockStorage = MockSecureTokenStorage();
    controller = AuthController(repository: mockRepo, tokenStorage: mockStorage);
  });

  group('AuthController Tests', () {
    test('checkSession with valid token sets authenticated and role', () async {
      when(() => mockStorage.getSessionData()).thenAnswer((_) async => {
            'token': 'valid_token',
            'role': 'GUARDIAN',
            'userId': '1',
            'username': 'guardian_user',
          });
      when(() => mockStorage.getToken()).thenAnswer((_) async => 'valid_token');

      await controller.checkSession();

      expect(controller.authState, AuthState.authenticated);
      expect(controller.userRole, UserRole.GUARDIAN);
    });

    test('checkSession without token sets unauthenticated', () async {
      when(() => mockStorage.getSessionData()).thenAnswer((_) async => {});
      when(() => mockStorage.getToken()).thenAnswer((_) async => null);

      await controller.checkSession();

      expect(controller.authState, AuthState.unauthenticated);
      expect(controller.userRole, isNull);
    });

    test('login with GUARDIAN role is successful and sets GUARDIAN role', () async {
      when(() => mockRepo.login('test_guardian', 'password')).thenAnswer(
        (_) async => AuthResponseDto(
          token: 'token_guardian',
          tokenType: 'Bearer',
          username: 'test_guardian',
          role: UserRole.GUARDIAN,
          userId: 1,
          expiresInMs: 3600,
        ),
      );
      when(() => mockStorage.saveSession(
            token: 'token_guardian',
            userId: '1',
            username: 'test_guardian',
            role: 'GUARDIAN',
          )).thenAnswer((_) async {});

      final result = await controller.login('test_guardian', 'password');

      expect(result, true);
      expect(controller.authState, AuthState.authenticated);
      expect(controller.userRole, UserRole.GUARDIAN);
    });

    test('login with CHILD role is successful and sets CHILD role', () async {
      when(() => mockRepo.login('test_child', 'password')).thenAnswer(
        (_) async => AuthResponseDto(
          token: 'token_child',
          tokenType: 'Bearer',
          username: 'test_child',
          role: UserRole.CHILD,
          userId: 2,
          expiresInMs: 3600,
        ),
      );
      when(() => mockStorage.saveSession(
            token: 'token_child',
            userId: '2',
            username: 'test_child',
            role: 'CHILD',
          )).thenAnswer((_) async {});

      final result = await controller.login('test_child', 'password');

      expect(result, true);
      expect(controller.authState, AuthState.authenticated);
      expect(controller.userRole, UserRole.CHILD);
    });

    test('logout clears session and sets unauthenticated', () async {
      when(() => mockStorage.clearSession()).thenAnswer((_) async {});

      await controller.logout();

      expect(controller.authState, AuthState.unauthenticated);
      expect(controller.userRole, isNull);
      verify(() => mockStorage.clearSession()).called(1);
    });

    test('login failure sets error message', () async {
      when(() => mockRepo.login('test', 'password')).thenThrow(Exception('Bad credentials'));

      final result = await controller.login('test', 'password');
      expect(result, false);
      expect(controller.errorMessage, 'Bad credentials');
    });
  });
}
