import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/entities/lesson.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/repositories/lesson_repository.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/usecases/complete_lesson_use_case.dart';

class MockLessonRepository implements LessonRepository {
  int? completedLessonId;
  bool shouldThrow = false;

  @override
  Future<List<Lesson>> getLessonsByEcosystem(int ecosystemId) async => [];

  @override
  Future<void> completeLesson(int lessonId) async {
    if (shouldThrow) {
      throw Exception('Error al completar lección');
    }
    completedLessonId = lessonId;
  }

  @override
  Future<List<int>> getCompletedLessonIds() async => [];
}

void main() {
  late MockLessonRepository repository;
  late CompleteLessonUseCase useCase;

  setUp(() {
    repository = MockLessonRepository();
    useCase = CompleteLessonUseCase(repository);
  });

  group('CompleteLessonUseCase Tests', () {
    test('successfully calls repository completeLesson with given lessonId', () async {
      await useCase(22);
      expect(repository.completedLessonId, 22);
    });

    test('rethrows exception when repository fails', () async {
      repository.shouldThrow = true;
      expect(() => useCase(22), throwsA(isA<Exception>()));
    });
  });
}
