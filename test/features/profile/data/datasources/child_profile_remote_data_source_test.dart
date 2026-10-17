import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:guardianes_del_planeta/core/network/api_client.dart';
import 'package:guardianes_del_planeta/features/profile/data/datasources/child_profile_remote_data_source.dart';

class MockApiClient extends Mock implements ApiClient {}
class MockDio extends Mock implements Dio {}

void main() {
  late MockApiClient mockApiClient;
  late MockDio mockDio;
  late ChildProfileRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockApiClient();
    mockDio = MockDio();
    when(() => mockApiClient.dio).thenReturn(mockDio);
    dataSource = ChildProfileRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  group('ChildProfileRemoteDataSource Tests', () {
    test('getMyProfile returns ChildProfileResponseModel on 200', () async {
      when(() => mockDio.get('/api/v1/children/me')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/v1/children/me'),
          statusCode: 200,
          data: {
            'id': 2,
            'userId': 4,
            'name': 'Juanito',
            'dateOfBirth': '2016-05-10',
            'age': 10,
            'totalXp': 180,
            'levelId': 1,
            'streakCount': 2,
          },
        ),
      );

      final profile = await dataSource.getMyProfile();

      expect(profile.id, 2);
      expect(profile.name, 'Juanito');
      expect(profile.totalXp, 180);
      expect(profile.levelId, 1);
      expect(profile.streakCount, 2);
    });

    test('getMyAchievements returns list on 200', () async {
      when(() => mockDio.get('/api/v1/children/me/achievements')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/v1/children/me/achievements'),
          statusCode: 200,
          data: [
            {
              'id': 2,
              'code': 'FIRST_LESSON',
              'title': 'Primera Lección',
              'description': 'Completar con éxito tu primera lección.',
              'conditionType': 'FIRST_LESSON',
              'conditionValue': 1,
              'visualKey': 'BADGE_FIRST_LESSON',
              'isActive': true,
            }
          ],
        ),
      );

      final achievements = await dataSource.getMyAchievements();

      expect(achievements.length, 1);
      expect(achievements.first.code, 'FIRST_LESSON');
      expect(achievements.first.title, 'Primera Lección');
    });

    test('getMyAchievements handles error gracefully by returning empty list', () async {
      when(() => mockDio.get('/api/v1/children/me/achievements')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/children/me/achievements'),
          error: 'Network failure',
        ),
      );

      final achievements = await dataSource.getMyAchievements();
      expect(achievements, isEmpty);
    });

    test('getAllAchievements returns full list on 200', () async {
      when(() => mockDio.get('/api/v1/achievements')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/v1/achievements'),
          statusCode: 200,
          data: [
            {
              'id': 1,
              'code': 'FIRST_STEP',
              'title': 'Primer Paso',
              'description': 'Completar la primera actividad educativa.',
              'conditionType': 'FIRST_ACTIVITY',
              'conditionValue': 1,
              'visualKey': 'BADGE_FIRST_STEP',
              'isActive': true,
            },
            {
              'id': 2,
              'code': 'FIRST_LESSON',
              'title': 'Primera Lección',
              'description': 'Completar con éxito tu primera lección ambiental.',
              'conditionType': 'FIRST_LESSON',
              'conditionValue': 1,
              'visualKey': 'BADGE_FIRST_LESSON',
              'isActive': true,
            },
          ],
        ),
      );

      final achievements = await dataSource.getAllAchievements();

      expect(achievements.length, 2);
      expect(achievements[0].code, 'FIRST_STEP');
      expect(achievements[1].code, 'FIRST_LESSON');
    });

    test('getAllAchievements handles error gracefully by returning empty list', () async {
      when(() => mockDio.get('/api/v1/achievements')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/achievements'),
          error: 'Network failure',
        ),
      );

      final achievements = await dataSource.getAllAchievements();
      expect(achievements, isEmpty);
    });
  });
}
