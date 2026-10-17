import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/core/network/api_client.dart';
import 'package:guardianes_del_planeta/core/storage/secure_token_storage.dart';
import 'package:guardianes_del_planeta/features/activity/data/datasources/activity_remote_data_source.dart';
import 'package:guardianes_del_planeta/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:guardianes_del_planeta/features/auth/data/models/auth_models.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/data/mappers/guardian_dashboard_mapper.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/data/models/child_profile_model.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/data/models/guardian_child_dashboard_model.dart';

class _FakeTokenStorage extends SecureTokenStorage {
  String? _token;

  @override
  Future<String?> getToken() async => _token;

  @override
  Future<void> clearSession() async => _token = null;
}

class _MockAdapter implements HttpClientAdapter {
  final ResponseBody Function(RequestOptions options) handler;
  _MockAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SecureTokenStorage & ApiClient Tests (Happy and Fallback Paths)', () {
    test('SecureTokenStorage saves, reads and clears session using fallback when platform channel unavailable', () async {
      final storage = SecureTokenStorage();
      await storage.saveSession(
        token: 'jwt_123',
        userId: '10',
        username: 'mateo',
        role: 'CHILD',
      );
      expect(await storage.getToken(), 'jwt_123');
      final session = await storage.getSessionData();
      expect(session['username'], 'mateo');
      expect(session['role'], 'CHILD');

      await storage.clearSession();
      expect(await storage.getToken(), isNull);
    });
  });

  group('ActivityRemoteDataSourceImpl Tests (Happy and Sad Paths)', () {
    test('getActivitiesByLessonId returns sorted remote activities on 200', () async {
      final client = ApiClient(tokenStorage: _FakeTokenStorage());
      client.dio.httpClientAdapter = _MockAdapter((options) {
        return ResponseBody.fromString(
          '[{"id":2,"lessonId":1,"type":"TRUE_FALSE","title":"A2","configurationJson":"{}","xpReward":10,"orderIndex":2},'
          '{"id":1,"lessonId":1,"type":"MULTIPLE_CHOICE","title":"A1","configurationJson":"{}","xpReward":10,"orderIndex":1}]',
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final ds = ActivityRemoteDataSourceImpl(apiClient: client);
      final list = await ds.getActivitiesByLessonId(1);
      expect(list.length, 2);
      expect(list.first.id, 1);
    });

    test('getActivitiesByLessonId returns 5 fallback activities when server returns empty list or error (Sad Path)', () async {
      final client = ApiClient(tokenStorage: _FakeTokenStorage());
      client.dio.httpClientAdapter = _MockAdapter((options) {
        return ResponseBody.fromString('[]', 200, headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        });
      });

      final ds = ActivityRemoteDataSourceImpl(apiClient: client);
      final fallback = await ds.getActivitiesByLessonId(1);
      expect(fallback.length, 5);

      // Simulate 500 error -> also returns fallback
      client.dio.httpClientAdapter = _MockAdapter((options) {
        return ResponseBody.fromString('{"message":"Server error"}', 500, headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        });
      });
      final fallbackOnError = await ds.getActivitiesByLessonId(1);
      expect(fallbackOnError.length, 5);
    });

    test('submitAttempt returns response on 200 and throws formatted error on 400 (Happy & Sad Paths)', () async {
      final client = ApiClient(tokenStorage: _FakeTokenStorage());
      client.dio.httpClientAdapter = _MockAdapter((options) {
        return ResponseBody.fromString(
          '{"id":10,"childId":1,"activityId":5,"attemptNumber":1,"isCorrect":true,"xpAwarded":15,"newTotalXp":115,"currentLevel":1,"leveledUp":false,"lessonCompleted":false}',
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final ds = ActivityRemoteDataSourceImpl(apiClient: client);
      final res = await ds.submitAttempt(5, {'selected': 1});
      expect(res.isCorrect, isTrue);
      expect(res.xpAwarded, 15);

      // Sad path: 400 Bad Request
      client.dio.httpClientAdapter = _MockAdapter((options) {
        return ResponseBody.fromString(
          '{"statusCode":400,"error":"Bad Request","message":"Respuesta inválida"}',
          400,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      expect(() => ds.submitAttempt(5, {}), throwsException);
    });
  });

  group('AuthRemoteDataSource Tests (Happy and Sad Paths)', () {
    test('registerGuardian and login handle 201/200 and 409/401 errors', () async {
      final client = ApiClient(tokenStorage: _FakeTokenStorage());
      final authDs = AuthRemoteDataSource(apiClient: client);

      // Happy path register 201
      client.dio.httpClientAdapter = _MockAdapter((options) {
        return ResponseBody.fromString(
          '{"id":1,"username":"guardian1","role":"GUARDIAN","status":"ACTIVE","createdAt":"2026-10-16T10:00:00"}',
          201,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });
      final reg = await authDs.registerGuardian(
        UserRegisterRequest(username: 'guardian1', password: 'password123', role: UserRole.GUARDIAN),
      );
      expect(reg.username, 'guardian1');

      // Sad path register 409 Conflict
      client.dio.httpClientAdapter = _MockAdapter((options) {
        return ResponseBody.fromString('{"message":"Conflict"}', 409, headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        });
      });
      expect(
        () => authDs.registerGuardian(
          UserRegisterRequest(username: 'guardian1', password: 'password123', role: UserRole.GUARDIAN),
        ),
        throwsException,
      );

      // Happy path login 200
      client.dio.httpClientAdapter = _MockAdapter((options) {
        return ResponseBody.fromString(
          '{"token":"jwt.token","tokenType":"Bearer","userId":1,"username":"guardian1","role":"GUARDIAN","expiresInMs":3600000}',
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });
      final loginRes = await authDs.login(UserLoginRequest(username: 'guardian1', password: 'password123'));
      expect(loginRes.token, 'jwt.token');

      // Sad path login 401 Unauthorized
      client.dio.httpClientAdapter = _MockAdapter((options) {
        return ResponseBody.fromString('{"message":"Unauthorized"}', 401, headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        });
      });
      expect(
        () => authDs.login(UserLoginRequest(username: 'guardian1', password: 'wrong')),
        throwsException,
      );
    });
  });

  group('GuardianDashboardMapper Tests', () {
    test('Maps ChildProfileModel and GuardianChildDashboardModel to domain entities accurately', () {
      final profileModel = ChildProfileModel.fromJson({
        'id': 1,
        'userId': 2,
        'name': 'Mateo',
        'dateOfBirth': '2016-05-10',
        'age': 10,
        'totalXp': 350,
        'levelId': 1,
        'streakCount': 4,
        'createdAt': '2026-10-01T10:00:00',
        'updatedAt': '2026-10-16T10:00:00',
      });
      final profileEntity = GuardianDashboardMapper.toChildProfileEntity(profileModel);
      expect(profileEntity.name, 'Mateo');
      expect(profileEntity.totalXp, 350);

      final dashModel = GuardianChildDashboardModel.fromJson({
        'childId': 1,
        'name': 'Mateo',
        'username': 'mateo_eco',
        'dateOfBirth': '2016-05-10',
        'age': 10,
        'totalXp': 350,
        'levelNumber': 1,
        'levelName': 'Semilla Guardiana',
        'currentLevelRequiredXp': 0,
        'nextLevelRequiredXp': 500,
        'nextLevelName': 'Explorador del Agua',
        'levelProgressPercentage': 70.0,
        'completedLessonsCount': 3,
        'totalLessonsCount': 8,
        'totalAttemptsCount': 15,
        'correctAttemptsCount': 12,
        'accuracyPercentage': 80.0,
        'currentStreak': 4,
        'unlockedAchievementsCount': 1,
        'totalAchievementsCount': 7,
        'achievements': [
          {
            'id': 1,
            'title': 'Primer Paso',
            'description': 'Desc',
            'badgeKey': 'FIRST_STEP',
            'unlockedAt': '2026-10-15T10:00:00',
          }
        ],
        'ecosystemProgress': [
          {
            'ecosystemId': 1,
            'code': 'BOSQUE_ANDINO',
            'name': 'Bosque Andino',
            'completedLessons': 3,
            'totalLessons': 8,
            'progressPercentage': 37.5,
          }
        ],
        'xpHistory': [
          {
            'id': 10,
            'amount': 20,
            'type': 'ACTIVITY',
            'description': 'Actividad completada',
            'createdAt': '2026-10-15T10:00:00',
          }
        ],
        'recentActivities': [
          {
            'title': 'Oso de anteojos',
            'description': 'Lección 1',
            'type': 'MULTIPLE_CHOICE',
            'xpAwarded': 20,
            'timestamp': '2026-10-15T10:00:00',
            'isSuccess': true,
          }
        ],
      });

      final dashEntity = GuardianDashboardMapper.toDashboardEntity(dashModel);
      expect(dashEntity.name, 'Mateo');
      expect(dashEntity.achievements.length, 1);
      expect(dashEntity.ecosystemProgress.length, 1);
      expect(dashEntity.xpHistory.length, 1);
      expect(dashEntity.recentActivities.length, 1);
    });
  });
}
