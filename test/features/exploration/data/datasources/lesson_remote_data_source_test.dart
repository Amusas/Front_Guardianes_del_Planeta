import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:guardianes_del_planeta/core/network/api_client.dart';
import 'package:guardianes_del_planeta/features/exploration/data/datasources/lesson_remote_data_source.dart';

class MockApiClient extends Mock implements ApiClient {}
class MockDio extends Mock implements Dio {}

void main() {
  late MockApiClient mockApiClient;
  late MockDio mockDio;
  late LessonRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockApiClient();
    mockDio = MockDio();
    when(() => mockApiClient.dio).thenReturn(mockDio);
    dataSource = LessonRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  group('LessonRemoteDataSourceImpl Tests', () {
    test('getLessonsByEcosystem calls GET /api/v1/ecosystems/{ecosystemId}/lessons and returns sorted models', () async {
      when(() => mockDio.get('/api/v1/ecosystems/1/lessons')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/v1/ecosystems/1/lessons'),
          statusCode: 200,
          data: [
            {
              'id': 2,
              'ecosystemId': 1,
              'title': 'Lección 2',
              'content': 'Contenido 2',
              'orderIndex': 2,
              'xpReward': 50,
              'isActive': true,
            },
            {
              'id': 1,
              'ecosystemId': 1,
              'title': 'Lección 1',
              'content': 'Contenido 1',
              'orderIndex': 1,
              'xpReward': 50,
              'isActive': true,
            },
          ],
        ),
      );

      final result = await dataSource.getLessonsByEcosystem(1);

      expect(result.length, 2);
      expect(result[0].orderIndex, 1);
      expect(result[0].title, 'Lección 1');
      expect(result[1].orderIndex, 2);
      expect(result[1].title, 'Lección 2');
    });

    test('getLessonsByEcosystem throws informative Exception on 404', () async {
      when(() => mockDio.get('/api/v1/ecosystems/99/lessons')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/ecosystems/99/lessons'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/v1/ecosystems/99/lessons'),
            statusCode: 404,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => dataSource.getLessonsByEcosystem(99),
        throwsA(predicate((e) => e.toString().contains('No se encontraron lecciones registradas'))),
      );
    });
  });
}
