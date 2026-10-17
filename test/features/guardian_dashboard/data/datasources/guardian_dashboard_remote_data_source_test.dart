import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:guardianes_del_planeta/core/network/api_client.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/data/datasources/guardian_dashboard_remote_data_source.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/data/models/register_child_request_model.dart';

class MockApiClient extends Mock implements ApiClient {}
class MockDio extends Mock implements Dio {}

void main() {
  late MockApiClient mockApiClient;
  late MockDio mockDio;
  late GuardianDashboardRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockApiClient();
    mockDio = MockDio();
    when(() => mockApiClient.dio).thenReturn(mockDio);
    dataSource = GuardianDashboardRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  group('GuardianDashboardRemoteDataSource Tests', () {
    test('getChildren returns list of children on 200', () async {
      when(() => mockDio.get('/api/v1/guardians/me/children')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/v1/guardians/me/children'),
          statusCode: 200,
          data: [
            {
              'id': 1,
              'userId': 2,
              'name': 'Sofía',
              'dateOfBirth': '2016-04-10',
              'age': 8,
              'totalXp': 300,
              'levelId': 1,
              'streakCount': 2,
            }
          ],
        ),
      );

      final children = await dataSource.getChildren();

      expect(children.length, 1);
      expect(children.first.name, 'Sofía');
      expect(children.first.totalXp, 300);
    });

    test('getChildren returns empty list when guardian has no children', () async {
      when(() => mockDio.get('/api/v1/guardians/me/children')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/v1/guardians/me/children'),
          statusCode: 200,
          data: [],
        ),
      );

      final children = await dataSource.getChildren();
      expect(children, isEmpty);
    });

    test('getChildren throws unauthorized session error on 401', () async {
      when(() => mockDio.get('/api/v1/guardians/me/children')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/guardians/me/children'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/v1/guardians/me/children'),
            statusCode: 401,
          ),
        ),
      );

      expect(() => dataSource.getChildren(), throwsA(isA<Exception>()));
    });

    test('getChildDashboard returns dashboard model on 200', () async {
      when(() => mockDio.get('/api/v1/guardians/me/children/1/dashboard')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/v1/guardians/me/children/1/dashboard'),
          statusCode: 200,
          data: {
            'childId': 1,
            'name': 'Sofía',
            'username': 'sofia123',
            'dateOfBirth': '2016-04-10',
            'age': 8,
            'totalXp': 750,
            'levelNumber': 2,
            'levelName': 'Explorador del Agua',
            'currentLevelRequiredXp': 500,
            'nextLevelRequiredXp': 1000,
            'nextLevelName': 'Guardián de los Mares',
            'levelProgressPercentage': 50.0,
            'completedLessonsCount': 4,
            'totalLessonsCount': 12,
            'totalAttemptsCount': 10,
            'correctAttemptsCount': 9,
            'accuracyPercentage': 90.0,
            'currentStreak': 3,
            'unlockedAchievementsCount': 2,
            'totalAchievementsCount': 6,
            'achievements': [],
            'ecosystemProgress': [],
            'xpHistory': [],
            'recentActivities': [],
          },
        ),
      );

      final dashboard = await dataSource.getChildDashboard(1);

      expect(dashboard.name, 'Sofía');
      expect(dashboard.accuracyPercentage, 90.0);
      expect(dashboard.levelName, 'Explorador del Agua');
      expect(dashboard.completedLessonsCount, 4);
    });

    test('getChildDashboard throws forbidden access error on 403', () async {
      when(() => mockDio.get('/api/v1/guardians/me/children/99/dashboard')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/guardians/me/children/99/dashboard'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/v1/guardians/me/children/99/dashboard'),
            statusCode: 403,
            data: {'message': 'No tienes autorización'},
          ),
        ),
      );

      expect(() => dataSource.getChildDashboard(99), throwsA(isA<Exception>()));
    });

    test('registerChild returns ChildProfileModel on 201', () async {
      final request = RegisterChildRequestModel(
        username: 'juanito123',
        password: 'password123',
        name: 'Juanito',
        dateOfBirth: DateTime(2016, 5, 10),
      );

      when(() => mockDio.post(
            '/api/v1/guardians/me/children',
            data: any(named: 'data'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/v1/guardians/me/children'),
          statusCode: 201,
          data: {
            'id': 5,
            'userId': 6,
            'name': 'Juanito',
            'dateOfBirth': '2016-05-10',
            'age': 8,
            'totalXp': 0,
            'levelId': 1,
            'streakCount': 0,
          },
        ),
      );

      final result = await dataSource.registerChild(request);

      expect(result.id, 5);
      expect(result.name, 'Juanito');
      expect(result.totalXp, 0);
    });

    test('registerChild throws duplicate username error on 409', () async {
      final request = RegisterChildRequestModel(
        username: 'yaExiste',
        password: 'password123',
        name: 'Juanito',
        dateOfBirth: DateTime(2016, 5, 10),
      );

      when(() => mockDio.post(
            '/api/v1/guardians/me/children',
            data: any(named: 'data'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/guardians/me/children'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/v1/guardians/me/children'),
            statusCode: 409,
          ),
        ),
      );

      expect(
        () => dataSource.registerChild(request),
        throwsA(predicate((e) => e.toString().contains('ya está registrado'))),
      );
    });
  });
}
