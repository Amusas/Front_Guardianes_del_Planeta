import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/entities/lesson.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/repositories/lesson_repository.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/usecases/get_child_completed_lessons_use_case.dart';

class MockLessonRepository implements LessonRepository {
  List<int> completedIdsToReturn = [];
  bool shouldThrow = false;

  @override
  Future<List<Lesson>> getLessonsByEcosystem(int ecosystemId) async => [];

  @override
  Future<void> completeLesson(int lessonId) async {}

  @override
  Future<List<int>> getCompletedLessonIds() async {
    if (shouldThrow) {
      throw Exception('Error al obtener lecciones completadas');
    }
    return completedIdsToReturn;
  }
}

void main() {
  late MockLessonRepository repository;
  late GetChildCompletedLessonsUseCase useCase;

  setUp(() {
    repository = MockLessonRepository();
    useCase = GetChildCompletedLessonsUseCase(repository);
  });

  group('GetChildCompletedLessonsUseCase Tests', () {
    test('returns list of completed lesson IDs from repository', () async {
      repository.completedIdsToReturn = [22, 23];
      final result = await useCase();
      expect(result, [22, 23]);
    });

    test('rethrows exception when repository fails', () async {
      repository.shouldThrow = true;
      expect(() => useCase(), throwsA(isA<Exception>()));
    });
  });
}
