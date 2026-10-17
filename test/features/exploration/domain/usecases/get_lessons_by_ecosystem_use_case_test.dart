import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/entities/lesson.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/repositories/lesson_repository.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/usecases/get_lessons_by_ecosystem_use_case.dart';

class MockLessonRepository implements LessonRepository {
  List<Lesson> lessons = [];
  bool shouldThrow = false;

  @override
  Future<List<Lesson>> getLessonsByEcosystem(int ecosystemId) async {
    if (shouldThrow) {
      throw Exception('Fallo en repositorio');
    }
    return lessons;
  }

  @override
  Future<void> completeLesson(int lessonId) async {}

  @override
  Future<List<int>> getCompletedLessonIds() async => [];
}

void main() {
  late MockLessonRepository mockRepository;
  late GetLessonsByEcosystemUseCase useCase;

  setUp(() {
    mockRepository = MockLessonRepository();
    useCase = GetLessonsByEcosystemUseCase(mockRepository);
  });

  group('GetLessonsByEcosystemUseCase Tests', () {
    test('calls repository with correct ecosystemId and returns lessons', () async {
      mockRepository.lessons = [
        const Lesson(
          id: 1,
          ecosystemId: 3,
          title: 'Fauna Marina',
          content: 'Aprende sobre ballenas y delfines.',
          orderIndex: 1,
          xpReward: 80,
          isActive: true,
        ),
      ];

      final result = await useCase(3);

      expect(result.length, 1);
      expect(result.first.title, 'Fauna Marina');
      expect(result.first.ecosystemId, 3);
    });

    test('rethrows exception when repository fails', () async {
      mockRepository.shouldThrow = true;

      expect(() => useCase(1), throwsA(isA<Exception>()));
    });
  });
}
