import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:guardianes_del_planeta/core/network/api_client.dart';
import 'package:guardianes_del_planeta/features/ecosystems/data/datasources/ecosystem_remote_data_source.dart';
import 'package:guardianes_del_planeta/features/ecosystems/data/repositories/ecosystem_repository_impl.dart';

class MockDio extends Mock implements Dio {}
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockDio mockDio;
  late MockApiClient mockApiClient;
  late EcosystemRemoteDataSource remoteDataSource;
  late EcosystemRepositoryImpl repository;

  setUp(() {
    mockDio = MockDio();
    mockApiClient = MockApiClient();
    when(() => mockApiClient.dio).thenReturn(mockDio);

    remoteDataSource = EcosystemRemoteDataSourceImpl(apiClient: mockApiClient);
    repository = EcosystemRepositoryImpl(remoteDataSource: remoteDataSource);
  });

  group('EcosystemRemoteDataSource & RepositoryImpl HTTP Tests', () {
    test('getActiveEcosystems succeeds with 200 and parses list', () async {
      final responseData = [
        {
          'id': 1,
          'code': 'BOSQUE_ANDINO',
          'name': 'Bosque Andino',
          'description': 'Montañas y osos',
          'requiredLevelId': 1,
          'mascotKey': 'oso_anteojos',
          'isActive': true,
        },
        {
          'id': 2,
          'code': 'PARAMO',
          'name': 'Páramo',
          'description': 'Frailejones',
          'requiredLevelId': 2,
          'mascotKey': 'condor',
          'isActive': true,
        }
      ];

      when(() => mockDio.get('/api/v1/ecosystems')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/v1/ecosystems'),
          data: responseData,
          statusCode: 200,
        ),
      );

      final result = await repository.getActiveEcosystems();

      expect(result.length, 2);
      expect(result[0].code, 'BOSQUE_ANDINO');
      expect(result[1].code, 'PARAMO');
      verify(() => mockDio.get('/api/v1/ecosystems')).called(1);
    });

    test('getEcosystemById succeeds with 200', () async {
      final responseData = {
        'id': 3,
        'code': 'OCEANO',
        'name': 'Océano',
        'description': 'Arrecifes',
        'isActive': true,
      };

      when(() => mockDio.get('/api/v1/ecosystems/3')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/v1/ecosystems/3'),
          data: responseData,
          statusCode: 200,
        ),
      );

      final result = await repository.getEcosystemById(3);

      expect(result.id, 3);
      expect(result.code, 'OCEANO');
      verify(() => mockDio.get('/api/v1/ecosystems/3')).called(1);
    });

    test('getEcosystemByCode succeeds with 200', () async {
      final responseData = {
        'id': 4,
        'code': 'SELVA_AMAZONICA',
        'name': 'Selva Amazónica',
        'description': 'Dantas y río',
        'isActive': true,
      };

      when(() => mockDio.get('/api/v1/ecosystems/code/SELVA_AMAZONICA')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/api/v1/ecosystems/code/SELVA_AMAZONICA'),
          data: responseData,
          statusCode: 200,
        ),
      );

      final result = await repository.getEcosystemByCode('SELVA_AMAZONICA');

      expect(result.id, 4);
      expect(result.code, 'SELVA_AMAZONICA');
      verify(() => mockDio.get('/api/v1/ecosystems/code/SELVA_AMAZONICA')).called(1);
    });

    test('handles 401 Unauthorized error with friendly message', () async {
      when(() => mockDio.get('/api/v1/ecosystems')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/ecosystems'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/v1/ecosystems'),
            statusCode: 401,
          ),
        ),
      );

      expect(
        () => repository.getActiveEcosystems(),
        throwsA(predicate((e) => e.toString().contains('Sesión expirada'))),
      );
    });

    test('handles connection timeout error', () async {
      when(() => mockDio.get('/api/v1/ecosystems')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/ecosystems'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        () => repository.getActiveEcosystems(),
        throwsA(predicate((e) => e.toString().contains('Tiempo de conexión agotado'))),
      );
    });
  });
}
