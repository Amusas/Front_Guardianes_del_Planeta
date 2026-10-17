import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/exploration/data/datasources/lesson_remote_data_source.dart';
import 'package:guardianes_del_planeta/features/exploration/data/models/lesson_response_model.dart';
import 'package:guardianes_del_planeta/features/exploration/data/repositories/lesson_repository_impl.dart';

class MockLessonRemoteDataSource implements LessonRemoteDataSource {
  bool shouldThrow = false;
  List<LessonResponseModel> mockData = [];

  @override
  Future<List<LessonResponseModel>> getLessonsByEcosystem(int ecosystemId) async {
    if (shouldThrow) {
      throw Exception('Error al conectar con la API de lecciones');
    }
    return mockData;
  }

  @override
  Future<void> completeLesson(int lessonId) async {
    if (shouldThrow) {
      throw Exception('Error al completar la lección');
    }
  }

  @override
  Future<List<int>> getCompletedLessonIds() async {
    if (shouldThrow) {
      throw Exception('Error al obtener progreso');
    }
    return [1];
  }
}

void main() {
  late MockLessonRemoteDataSource mockRemoteDataSource;
  late LessonRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockLessonRemoteDataSource();
    repository = LessonRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('LessonRepositoryImpl Tests', () {
    test('getLessonsByEcosystem returns domain Lesson list on success', () async {
      mockRemoteDataSource.mockData = [
        const LessonResponseModel(
          id: 1,
          ecosystemId: 1,
          title: 'Lección 1',
          content: 'Contenido 1',
          orderIndex: 1,
          xpReward: 50,
          isActive: true,
        ),
        const LessonResponseModel(
          id: 2,
          ecosystemId: 1,
          title: 'Lección 2',
          content: 'Contenido 2',
          orderIndex: 2,
          xpReward: 75,
          isActive: true,
        ),
      ];

      final result = await repository.getLessonsByEcosystem(1);

      expect(result.length, 2);
      expect(result[0].id, 1);
      expect(result[0].title, 'Lección 1');
      expect(result[1].id, 2);
      expect(result[1].xpReward, 75);
    });

    test('getLessonsByEcosystem propagates exception on failure', () async {
      mockRemoteDataSource.shouldThrow = true;

      expect(
        () => repository.getLessonsByEcosystem(1),
        throwsA(isA<Exception>()),
      );
    });
  });
}
