import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/entities/lesson.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/models/lesson_node_model.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/repositories/lesson_repository.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/usecases/complete_lesson_use_case.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/usecases/get_child_completed_lessons_use_case.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/usecases/get_lessons_by_ecosystem_use_case.dart';
import 'package:guardianes_del_planeta/features/exploration/presentation/controllers/lesson_controller.dart';
import 'package:guardianes_del_planeta/features/exploration/presentation/state/lesson_state.dart';

class MockLessonRepository implements LessonRepository {
  List<Lesson> lessons = [];
  bool shouldThrow = false;
  String errorMessage = 'Error al obtener lecciones';
  int? completedLessonId;
  List<int> completedLessonIdsToReturn = [];

  @override
  Future<List<Lesson>> getLessonsByEcosystem(int ecosystemId) async {
    if (shouldThrow) {
      throw Exception(errorMessage);
    }
    return lessons;
  }

  @override
  Future<void> completeLesson(int lessonId) async {
    completedLessonId = lessonId;
  }

  @override
  Future<List<int>> getCompletedLessonIds() async => completedLessonIdsToReturn;
}

void main() {
  late MockLessonRepository mockRepository;
  late GetLessonsByEcosystemUseCase useCase;
  late CompleteLessonUseCase completeLessonUseCase;
  late GetChildCompletedLessonsUseCase getChildCompletedLessonsUseCase;
  late LessonController controller;

  setUp(() {
    mockRepository = MockLessonRepository();
    useCase = GetLessonsByEcosystemUseCase(mockRepository);
    completeLessonUseCase = CompleteLessonUseCase(mockRepository);
    getChildCompletedLessonsUseCase = GetChildCompletedLessonsUseCase(mockRepository);
    controller = LessonController(
      getLessonsByEcosystemUseCase: useCase,
      completeLessonUseCase: completeLessonUseCase,
      getChildCompletedLessonsUseCase: getChildCompletedLessonsUseCase,
    );
  });

  group('LessonController Tests', () {
    test('initial state is initial', () {
      expect(controller.state.status, LessonStatus.initial);
      expect(controller.state.lessons, isEmpty);
      expect(controller.state.nodes, isEmpty);
    });

    test('loadLessons updates state to success with nodes when lessons returned', () async {
      mockRepository.lessons = [
        const Lesson(
          id: 1,
          ecosystemId: 1,
          title: 'Biodiversidad',
          content: 'Cuidado del entorno.',
          orderIndex: 1,
          xpReward: 50,
          isActive: true,
        ),
      ];

      await controller.loadLessons(1);

      expect(controller.state.status, LessonStatus.success);
      expect(controller.state.lessons.length, 1);
      expect(controller.state.nodes.length, 1);
      expect(controller.state.nodes.first.title, 'Biodiversidad');
    });

    test('loadLessons updates state to empty when no lessons found', () async {
      mockRepository.lessons = [];

      await controller.loadLessons(2);

      expect(controller.state.status, LessonStatus.empty);
      expect(controller.state.lessons, isEmpty);
      expect(controller.state.nodes, isEmpty);
    });

    test('loadLessons updates state to error when exception thrown', () async {
      mockRepository.shouldThrow = true;
      mockRepository.errorMessage = 'Fallo de red en el servidor';

      await controller.loadLessons(1);

      expect(controller.state.status, LessonStatus.error);
      expect(controller.state.errorMessage, 'Fallo de red en el servidor');
    });

    test('reset clears the state back to initial', () async {
      mockRepository.lessons = [
        const Lesson(
          id: 1,
          ecosystemId: 1,
          title: 'Test',
          content: 'Test content',
          orderIndex: 1,
          xpReward: 50,
          isActive: true,
        ),
      ];
      await controller.loadLessons(1);
      expect(controller.state.isSuccess, true);

      controller.reset();

      expect(controller.state.isInitial, true);
      expect(controller.state.lessons, isEmpty);
    });

    test('completeLesson marks lesson as completed and unlocks next node as active', () async {
      mockRepository.lessons = [
        const Lesson(
          id: 101,
          ecosystemId: 1,
          title: 'Lección 1',
          content: 'Intro',
          orderIndex: 1,
          xpReward: 20,
          isActive: true,
        ),
        const Lesson(
          id: 102,
          ecosystemId: 1,
          title: 'Lección 2',
          content: 'Avanzado',
          orderIndex: 2,
          xpReward: 30,
          isActive: true,
        ),
      ];

      await controller.loadLessons(1);
      expect(controller.state.nodes[0].state, LessonNodeState.active);
      expect(controller.state.nodes[1].state, LessonNodeState.locked);

      // Complete lesson 101
      controller.completeLesson(101);

      expect(controller.completedLessonIds.contains(101), isTrue);
      expect(controller.state.nodes[0].state, LessonNodeState.completed);
      expect(controller.state.nodes[1].state, LessonNodeState.active);
    });

    test('getProgressForEcosystem calculates exact percentage based on completed lessons', () async {
      mockRepository.lessons = [
        const Lesson(id: 1, ecosystemId: 5, title: 'L1', content: '', orderIndex: 1, xpReward: 10, isActive: true),
        const Lesson(id: 2, ecosystemId: 5, title: 'L2', content: '', orderIndex: 2, xpReward: 10, isActive: true),
        const Lesson(id: 3, ecosystemId: 5, title: 'L3', content: '', orderIndex: 3, xpReward: 10, isActive: true),
        const Lesson(id: 4, ecosystemId: 5, title: 'L4', content: '', orderIndex: 4, xpReward: 10, isActive: true),
      ];

      await controller.preloadLessonsForEcosystem(5);

      // Initially 0 completed -> 0.0 (0%)
      expect(controller.getProgressForEcosystem(5), 0.0);

      // Complete 1 lesson -> 1/4 = 0.25 (25%)
      controller.completeLesson(1);
      expect(controller.getProgressForEcosystem(5), 0.25);

      // Complete 2nd lesson -> 2/4 = 0.50 (50%)
      controller.completeLesson(2);
      expect(controller.getProgressForEcosystem(5), 0.50);

      // Complete all 4 -> 4/4 = 1.0 (100%)
      controller.completeLesson(3);
      controller.completeLesson(4);
      expect(controller.getProgressForEcosystem(5), 1.0);
    });

    test('loadUserProgress populates completedLessonIds and recalculates nodes', () async {
      mockRepository.lessons = [
        const Lesson(id: 1, ecosystemId: 1, title: 'L1', content: '', orderIndex: 1, xpReward: 10, isActive: true),
        const Lesson(id: 2, ecosystemId: 1, title: 'L2', content: '', orderIndex: 2, xpReward: 10, isActive: true),
      ];
      await controller.loadLessons(1);
      expect(controller.state.nodes[0].state, LessonNodeState.active);
      expect(controller.state.nodes[1].state, LessonNodeState.locked);

      mockRepository.completedLessonIdsToReturn = [1];
      await controller.loadUserProgress();

      expect(controller.completedLessonIds.contains(1), isTrue);
      expect(controller.state.nodes[0].state, LessonNodeState.completed);
      expect(controller.state.nodes[1].state, LessonNodeState.active);
    });

    test('completeLesson invokes remote completeLessonUseCase', () async {
      mockRepository.lessons = [
        const Lesson(id: 10, ecosystemId: 1, title: 'L10', content: '', orderIndex: 1, xpReward: 10, isActive: true),
      ];
      await controller.loadLessons(1);

      await controller.completeLesson(10);

      expect(controller.completedLessonIds.contains(10), isTrue);
      expect(mockRepository.completedLessonId, 10);
    });
  });
}
