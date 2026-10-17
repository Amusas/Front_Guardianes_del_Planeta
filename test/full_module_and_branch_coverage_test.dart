import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:guardianes_del_planeta/core/config/api_config.dart';
import 'package:guardianes_del_planeta/core/logging/app_logger.dart';
import 'package:guardianes_del_planeta/core/network/api_client.dart';
import 'package:guardianes_del_planeta/core/storage/secure_token_storage.dart';
import 'package:guardianes_del_planeta/features/activity/data/datasources/activity_remote_data_source.dart';
import 'package:guardianes_del_planeta/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:guardianes_del_planeta/features/activity/domain/models/activity_attempt_model.dart';
import 'package:guardianes_del_planeta/features/activity/domain/models/activity_model.dart';
import 'package:guardianes_del_planeta/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:guardianes_del_planeta/features/auth/data/models/auth_models.dart';
import 'package:guardianes_del_planeta/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:guardianes_del_planeta/features/ecosystems/data/datasources/ecosystem_remote_data_source.dart';
import 'package:guardianes_del_planeta/features/ecosystems/domain/entities/ecosystem.dart';
import 'package:guardianes_del_planeta/features/exploration/data/datasources/lesson_remote_data_source.dart';
import 'package:guardianes_del_planeta/features/exploration/data/models/lesson_response_model.dart';
import 'package:guardianes_del_planeta/features/exploration/data/repositories/lesson_repository_impl.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/entities/lesson.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/data/datasources/guardian_dashboard_remote_data_source.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/data/models/child_profile_model.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/data/models/register_child_request_model.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/data/repositories/guardian_dashboard_repository_impl.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/domain/usecases/get_guardian_child_dashboard_use_case.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/domain/usecases/get_guardian_children_use_case.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/domain/usecases/register_child_for_guardian_use_case.dart';
import 'package:guardianes_del_planeta/features/profile/data/datasources/child_profile_remote_data_source.dart';
import 'package:guardianes_del_planeta/features/profile/data/models/child_achievement_response_model.dart';
import 'package:guardianes_del_planeta/features/profile/data/models/child_profile_response_model.dart';
import 'package:guardianes_del_planeta/features/profile/data/repositories/child_profile_repository_impl.dart';
import 'package:guardianes_del_planeta/features/profile/domain/usecases/get_all_achievements_use_case.dart';
import 'package:guardianes_del_planeta/features/profile/domain/usecases/get_my_child_achievements_use_case.dart';
import 'package:guardianes_del_planeta/features/profile/domain/usecases/get_my_child_profile_use_case.dart';

class MockDio extends Mock implements Dio {}

class MockApiClient extends Mock implements ApiClient {}

class MockSecureTokenStorage extends Mock implements SecureTokenStorage {}

void main() {
  late MockDio mockDio;
  late MockApiClient mockApiClient;

  setUp(() {
    mockDio = MockDio();
    mockApiClient = MockApiClient();
    when(() => mockApiClient.dio).thenReturn(mockDio);
  });

  group('Core Utilities (AppLogger, ApiConfig, ApiClient)', () {
    test('AppLogger inicializa y registra todos los niveles de severidad', () {
      AppLogger.init();
      AppLogger.debug('Debug msg');
      AppLogger.info('Info msg');
      AppLogger.warning('Warning msg');
      AppLogger.error('Error msg', Exception('err'), StackTrace.current);
      expect(ApiConfig.baseUrl, isNotEmpty);
    });

    test('ApiClient configura opciones e interceptores correctamente', () {
      final mockStorage = MockSecureTokenStorage();
      final client = ApiClient(tokenStorage: mockStorage);
      expect(client.dio, isNotNull);
    });
  });

  group('Domain Models, Entities & DTOs Full Branch Coverage', () {
    test('Lesson, Ecosystem y LessonResponseModel igualdad, hashCode y serialización', () {
      const l1 = Lesson(
        id: 1,
        ecosystemId: 2,
        title: 'L1',
        content: 'C1',
        orderIndex: 1,
        xpReward: 50,
        isActive: true,
      );
      const l2 = Lesson(
        id: 1,
        ecosystemId: 2,
        title: 'L1',
        content: 'C1',
        orderIndex: 1,
        xpReward: 50,
        isActive: true,
      );
      expect(l1, equals(l2));
      expect(l1.hashCode, equals(l2.hashCode));

      const e1 = Ecosystem(id: 1, code: 'PARAMO', name: 'Páramo', description: 'D');
      const e2 = Ecosystem(id: 1, code: 'PARAMO', name: 'Páramo', description: 'D');
      expect(e1, equals(e2));
      expect(e1.hashCode, equals(e2.hashCode));

      final lrm1 = LessonResponseModel.fromJson({
        'id': 1,
        'ecosystemId': 2,
        'title': 'T',
        'content': 'C',
        'orderIndex': 1,
        'xpReward': 40,
        'isActive': true,
      });
      final lrm2 = LessonResponseModel.fromJson(lrm1.toJson());
      expect(lrm1, equals(lrm2));
      expect(lrm1.hashCode, equals(lrm2.hashCode));
    });

    test('ChildProfileModel, ChildProfileResponseModel y ChildAchievementResponseModel serialización', () {
      final json = {
        'id': 1,
        'userId': 2,
        'name': 'Mateo',
        'dateOfBirth': '2017-05-10',
        'age': 9,
        'totalXp': 150,
        'levelId': 2,
        'streakCount': 4,
        'createdAt': '2026-01-01T00:00:00Z',
        'updatedAt': '2026-01-02T00:00:00Z',
      };
      final cpm = ChildProfileModel.fromJson(json);
      expect(cpm.toJson()['name'], 'Mateo');

      final cprm = ChildProfileResponseModel.fromJson(json);
      expect(cprm.toEntity().name, 'Mateo');

      final carm = ChildAchievementResponseModel.fromJson({
        'id': 10,
        'code': 'FIRST',
        'title': 'Primer Logro',
        'description': 'Desc',
        'conditionType': 'FIRST_ACTIVITY',
        'conditionValue': 1,
        'visualKey': 'KEY',
        'isActive': true,
        'unlockedAt': '2026-01-01T00:00:00Z',
      });
      expect(carm.toEntity(isUnlocked: true).isUnlocked, isTrue);
    });

    test('ActivityModel todos los getters, tipos, evaluación local y payload para Backend', () {
      for (final t in ['MULTIPLE_CHOICE', 'TRUE_FALSE', 'CLASSIFICATION', 'ORDERING', 'DRAG_AND_DROP', 'UNKNOWN']) {
        final actType = ActivityType.fromString(t);
        expect(actType.displayName, isNotEmpty);
      }

      // 1. Multiple Choice con opciones Map y evaluación por índice y texto
      final mc = ActivityModel.fromJson({
        'id': 1,
        'lessonId': 1,
        'type': 'MULTIPLE_CHOICE',
        'title': 'MC',
        'configurationJson': '{"statement":"Enunciado","difficulty":"Fácil","options":[{"name":"Op1"},{"text":"Op2"},"Op3"],"correctOption":1,"correctAnswer":"Op2"}',
      });
      expect(mc.questionOrInstruction, 'Enunciado');
      expect(mc.hint, contains('Nivel: Fácil'));
      expect(mc.stringOptions, ['Op1', 'Op2', 'Op3']);
      expect(mc.toJson()['id'], 1);
      expect(mc.evaluateAnswer(null), isFalse);
      expect(mc.evaluateAnswer(1), isTrue);
      expect(mc.evaluateAnswer('Op2'), isTrue);
      expect(mc.buildBackendAttemptPayload(1)['answer'], 'Op2');
      expect(mc.buildBackendAttemptPayload('Op2')['option'], 1);

      // Multiple Choice con solo correctAnswer y solo correctOption
      final mcOnlyAns = ActivityModel.fromJson({
        'id': 2,
        'lessonId': 1,
        'type': 'MULTIPLE_CHOICE',
        'title': 'MC2',
        'config': {'prompt': 'Prompt', 'options': ['A', 'B'], 'correctAnswer': 'B'},
      });
      expect(mcOnlyAns.questionOrInstruction, 'Prompt');
      expect(mcOnlyAns.evaluateAnswer(1), isTrue);

      final mcOnlyOpt = ActivityModel.fromJson({
        'id': 3,
        'lessonId': 1,
        'type': 'TRUE_FALSE',
        'title': '',
        'config': {'instructions': 'Inst', 'correctOption': 0},
      });
      expect(mcOnlyOpt.questionOrInstruction, 'Inst');
      expect(mcOnlyOpt.stringOptions, ['Verdadero', 'Falso']);
      expect(mcOnlyOpt.evaluateAnswer('Verdadero'), isTrue);

      // 2. Classification
      final cls = ActivityModel.fromJson({
        'id': 4,
        'lessonId': 1,
        'type': 'CLASSIFICATION',
        'title': '',
        'config': {
          'instruction': 'Clasifica',
          'categories': [
            {'id': 'c1', 'name': 'Cat1'},
            'c2'
          ],
          'items': [
            {'id': 'i1', 'name': 'Item1'},
            'i2'
          ],
          'correctAnswers': {'i1': 'c1'}
        },
      });
      expect(cls.questionOrInstruction, 'Clasifica');
      expect(cls.classificationCategories.length, 2);
      expect(cls.classificationItems.length, 2);
      expect(cls.evaluateAnswer({'i1': 'c1'}), isTrue);
      expect(cls.evaluateAnswer({'i1': 'c2'}), isFalse);
      expect(cls.evaluateAnswer('invalid'), isFalse);
      expect(cls.buildBackendAttemptPayload({'i1': 'c1'})['answers'], isNotNull);

      // 3. Ordering
      final ord = ActivityModel.fromJson({
        'id': 5,
        'lessonId': 1,
        'type': 'ORDERING',
        'title': '',
        'config': {
          'steps': ['Paso 1', 'Paso 2'],
          'correctSequence': [0, '1'],
        },
      });
      expect(ord.questionOrInstruction, 'Completa la actividad ambiental');
      expect(ord.orderingSteps.length, 2);
      expect(ord.orderingCorrectSequence, [0, 1]);
      expect(ord.evaluateAnswer([0, 1]), isTrue);
      expect(ord.evaluateAnswer([1, 0]), isFalse);
      expect(ord.evaluateAnswer([0]), isFalse);
      expect(ord.evaluateAnswer('invalid'), isFalse);
      expect(ord.buildBackendAttemptPayload(['0', 1])['sequence'], [0, 1]);

      // 4. Drag and Drop & Unknown
      final dnd = ActivityModel.fromJson({
        'id': 6,
        'lessonId': 1,
        'type': 'DRAG_AND_DROP',
        'title': 'DnD',
        'config': {
          'targets': ['z1'],
          'elements': ['e1'],
          'correctAnswers': {'e1': 'z1'},
        },
      });
      expect(dnd.dragTargets.length, 1);
      expect(dnd.dragElements.length, 1);
      expect(dnd.evaluateAnswer({'e1': 'z1'}), isTrue);
      expect(dnd.evaluateAnswer({'e1': 'z2'}), isFalse);
      expect(dnd.evaluateAnswer('invalid'), isFalse);

      final unk = ActivityModel.fromJson({'id': 7, 'type': 'UNKNOWN', 'configurationJson': '"{\\"a\\":1}"'});
      expect(unk.evaluateAnswer('any'), isTrue);
      expect(unk.buildBackendAttemptPayload(null)['answer'], 'COMPLETED');

      // ActivityAttemptResponseModel
      final attemptResp = ActivityAttemptResponseModel.fromJson({});
      expect(attemptResp.isCorrect, isFalse);
      expect(attemptResp.attemptNumber, 1);
    });
  });

  group('Remote DataSources, Repositories & UseCases (Caminos Felices y Tristes)', () {
    test('LessonRemoteDataSourceImpl, LessonRepositoryImpl: éxito y errores HTTP/Dio', () async {
      final ds = LessonRemoteDataSourceImpl(apiClient: mockApiClient);
      final repo = LessonRepositoryImpl(remoteDataSource: ds);

      // getLessonsByEcosystem 200 OK
      when(() => mockDio.get('/api/v1/ecosystems/1/lessons')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: [
            {'id': 2, 'ecosystemId': 1, 'title': 'L2', 'content': 'C', 'orderIndex': 2, 'xpReward': 50, 'isActive': true},
            {'id': 1, 'ecosystemId': 1, 'title': 'L1', 'content': 'C', 'orderIndex': 1, 'xpReward': 50, 'isActive': true},
          ],
        ),
      );
      final lessons = await repo.getLessonsByEcosystem(1);
      expect(lessons.first.id, 1);

      // completeLesson 200 OK & getCompletedLessonIds 200 OK
      when(() => mockDio.post('/api/v1/lessons/1/complete')).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(path: ''), statusCode: 200),
      );
      await repo.completeLesson(1);

      when(() => mockDio.get('/api/v1/lessons/progress/me')).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(path: ''), statusCode: 200, data: [1, 2]),
      );
      expect(await repo.getCompletedLessonIds(), [1, 2]);

      // Caminos tristes: 401, 403, 404, timeout, connectionError
      for (final status in [401, 403, 404, 500]) {
        when(() => mockDio.get('/api/v1/ecosystems/1/lessons')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: status,
              data: {'statusCode': status, 'error': 'Err', 'message': 'Error $status', 'path': '/p'},
            ),
          ),
        );
        expect(() => repo.getLessonsByEcosystem(1), throwsException);
      }

      when(() => mockDio.post('/api/v1/lessons/1/complete')).thenThrow(
        DioException(requestOptions: RequestOptions(path: ''), type: DioExceptionType.connectionTimeout),
      );
      expect(() => repo.completeLesson(1), throwsException);

      when(() => mockDio.post('/api/v1/lessons/1/complete')).thenThrow(
        DioException(requestOptions: RequestOptions(path: ''), type: DioExceptionType.connectionError),
      );
      expect(() => repo.completeLesson(1), throwsException);
    });

    test('EcosystemRemoteDataSourceImpl: getActiveEcosystems, getEcosystemById, getEcosystemByCode y errores', () async {
      final ds = EcosystemRemoteDataSourceImpl(apiClient: mockApiClient);

      when(() => mockDio.get('/api/v1/ecosystems')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: [
            {'id': 1, 'code': 'PARAMO', 'name': 'Páramo', 'description': 'D', 'requiredLevelId': 1, 'mascotKey': 'OSO', 'isActive': true}
          ],
        ),
      );
      expect((await ds.getActiveEcosystems()).length, 1);

      when(() => mockDio.get('/api/v1/ecosystems/1')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {'id': 1, 'code': 'PARAMO', 'name': 'Páramo', 'description': 'D', 'isActive': true},
        ),
      );
      expect((await ds.getEcosystemById(1)).code, 'PARAMO');

      when(() => mockDio.get('/api/v1/ecosystems/code/PARAMO')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {'id': 1, 'code': 'PARAMO', 'name': 'Páramo', 'description': 'D', 'isActive': true},
        ),
      );
      expect((await ds.getEcosystemByCode('PARAMO')).id, 1);

      // Caminos tristes: 401, 403, 404, 500, timeout, connectionError
      for (final status in [401, 403, 404, 500]) {
        when(() => mockDio.get('/api/v1/ecosystems/1')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: status,
              data: {'statusCode': status, 'error': 'E', 'message': 'M', 'path': '/'},
            ),
          ),
        );
        expect(() => ds.getEcosystemById(1), throwsException);
      }

      when(() => mockDio.get('/api/v1/ecosystems/code/PARAMO')).thenThrow(
        DioException(requestOptions: RequestOptions(path: ''), type: DioExceptionType.connectionTimeout),
      );
      expect(() => ds.getEcosystemByCode('PARAMO'), throwsException);

      when(() => mockDio.get('/api/v1/ecosystems/code/PARAMO')).thenThrow(
        DioException(requestOptions: RequestOptions(path: ''), type: DioExceptionType.connectionError),
      );
      expect(() => ds.getEcosystemByCode('PARAMO'), throwsException);
    });

    test('ChildProfileRemoteDataSourceImpl, ChildProfileRepositoryImpl y UseCases de Perfil', () async {
      final ds = ChildProfileRemoteDataSourceImpl(apiClient: mockApiClient);
      final repo = ChildProfileRepositoryImpl(remoteDataSource: ds);
      final profileUC = GetMyChildProfileUseCase(repo);
      final allAchUC = GetAllAchievementsUseCase(repo);
      final myAchUC = GetMyChildAchievementsUseCase(repo);

      when(() => mockDio.get('/api/v1/children/me')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {'id': 1, 'name': 'Mateo', 'totalXp': 120, 'streakCount': 3},
        ),
      );
      expect((await profileUC.execute()).name, 'Mateo');

      when(() => mockDio.get('/api/v1/achievements')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: [
            {'id': 1, 'code': 'A1', 'title': 'T1', 'description': 'D', 'conditionType': 'FIRST', 'conditionValue': 1, 'visualKey': 'K'}
          ],
        ),
      );
      expect((await allAchUC.execute()).length, 1);

      when(() => mockDio.get('/api/v1/children/me/achievements')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: [
            {'id': 1, 'code': 'A1', 'title': 'T1', 'description': 'D', 'conditionType': 'FIRST', 'conditionValue': 1, 'visualKey': 'K'}
          ],
        ),
      );
      expect((await myAchUC.execute()).first.isUnlocked, isTrue);

      // Caminos tristes
      when(() => mockDio.get('/api/v1/children/me')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(requestOptions: RequestOptions(path: ''), statusCode: 404, data: {'message': 'No encontrado'}),
        ),
      );
      expect(() => profileUC.execute(), throwsException);

      when(() => mockDio.get('/api/v1/achievements')).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );
      expect(await allAchUC.execute(), isEmpty);

      when(() => mockDio.get('/api/v1/children/me/achievements')).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );
      expect(await myAchUC.execute(), isEmpty);
    });

    test('GuardianDashboardRemoteDataSourceImpl, GuardianDashboardRepositoryImpl y UseCases de Dashboard', () async {
      final ds = GuardianDashboardRemoteDataSourceImpl(apiClient: mockApiClient);
      final repo = GuardianDashboardRepositoryImpl(remoteDataSource: ds);
      final childrenUC = GetGuardianChildrenUseCase(repo);
      final registerUC = RegisterChildForGuardianUseCase(repo);
      final dashUC = GetGuardianChildDashboardUseCase(repo);

      when(() => mockDio.get('/api/v1/guardians/me/children')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: [
            {'id': 1, 'name': 'Mateo', 'totalXp': 100, 'streakCount': 2}
          ],
        ),
      );
      expect((await childrenUC()).length, 1);

      final regReq = RegisterChildRequestModel(
        username: 'mateo_g',
        password: 'Password123!',
        name: 'Mateo',
        dateOfBirth: DateTime(2017, 5, 10),
      );
      when(() => mockDio.post('/api/v1/guardians/me/children', data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 201,
          data: {'id': 1, 'name': 'Mateo', 'totalXp': 0, 'streakCount': 0},
        ),
      );
      expect((await registerUC(regReq)).name, 'Mateo');

      when(() => mockDio.get('/api/v1/guardians/me/children/1/dashboard')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {
            'childId': 1,
            'name': 'Mateo',
            'username': 'mateo_g',
            'totalXp': 100,
            'currentLevelNumber': 1,
            'levelName': 'Semilla',
            'currentLevelXp': 0,
            'levelProgressPercentage': 50.0,
            'completedLessonsCount': 2,
            'totalLessonsCount': 10,
            'totalAttemptsCount': 4,
            'correctAttemptsCount': 3,
            'accuracyPercentage': 75.0,
            'currentStreak': 2,
            'unlockedAchievementsCount': 1,
            'totalAchievementsCount': 10,
            'unlockedAchievements': [],
            'ecosystemProgress': [],
            'xpHistory': [],
            'recentActivities': [],
          },
        ),
      );
      expect((await dashUC(1)).name, 'Mateo');

      // Caminos tristes: 409 en registro, 403 y 404 en dashboard, timeout, connectionError, 401
      when(() => mockDio.post('/api/v1/guardians/me/children', data: any(named: 'data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(requestOptions: RequestOptions(path: ''), statusCode: 409),
        ),
      );
      expect(() => registerUC(regReq), throwsException);

      for (final status in [401, 403, 404, 500]) {
        when(() => mockDio.get('/api/v1/guardians/me/children/1/dashboard')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(requestOptions: RequestOptions(path: ''), statusCode: status, data: {'message': 'Err'}),
          ),
        );
        expect(() => dashUC(1), throwsException);
      }

      when(() => mockDio.get('/api/v1/guardians/me/children')).thenThrow(
        DioException(requestOptions: RequestOptions(path: ''), type: DioExceptionType.connectionTimeout),
      );
      expect(() => childrenUC(), throwsException);

      when(() => mockDio.get('/api/v1/guardians/me/children')).thenThrow(
        DioException(requestOptions: RequestOptions(path: ''), type: DioExceptionType.connectionError),
      );
      expect(() => childrenUC(), throwsException);
    });

    test('ActivityRepositoryImpl y AuthRepositoryImpl delegan correctamente a sus DataSources', () async {
      final actDs = ActivityRemoteDataSourceImpl(apiClient: mockApiClient);
      final actRepo = ActivityRepositoryImpl(remoteDataSource: actDs);

      when(() => mockDio.get('/api/v1/lessons/1/activities')).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(path: ''), statusCode: 200, data: []),
      );
      expect(await actRepo.getActivitiesByLessonId(1), isNotEmpty);

      when(() => mockDio.post('/api/v1/activities/1/attempts', data: any(named: 'data'))).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(path: ''), statusCode: 200, data: {'isCorrect': true}),
      );
      expect((await actRepo.submitAttempt(1, {'answer': 1})).isCorrect, isTrue);

      final authDs = AuthRemoteDataSource(apiClient: mockApiClient);
      final authRepo = AuthRepositoryImpl(remoteDataSource: authDs);

      when(() => mockDio.post('/auth/v1/user', data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 201,
          data: {
            'id': 1,
            'username': 'guard1',
            'role': 'GUARDIAN',
            'status': 'ACTIVE',
            'createdAt': '2026-01-01T00:00:00Z',
          },
        ),
      );
      expect((await authRepo.registerGuardian('guard1', 'Pass123!')).username, 'guard1');

      when(() => mockDio.post('/auth/v1/login', data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {
            'token': 'jwt',
            'tokenType': 'Bearer',
            'expiresInMs': 3600000,
            'userId': 1,
            'username': 'guard1',
            'role': 'GUARDIAN',
          },
        ),
      );
      expect((await authRepo.login('guard1', 'Pass123!')).token, 'jwt');

      when(() => mockDio.post('/auth/v1/login', data: any(named: 'data'))).thenThrow(
        DioException(requestOptions: RequestOptions(path: ''), type: DioExceptionType.connectionTimeout),
      );
      expect(() => authRepo.login('guard1', 'Pass123!'), throwsException);

      when(() => mockDio.post('/auth/v1/login', data: any(named: 'data'))).thenThrow(
        DioException(requestOptions: RequestOptions(path: ''), type: DioExceptionType.connectionError),
      );
      expect(() => authRepo.login('guard1', 'Pass123!'), throwsException);
    });
  });
}
