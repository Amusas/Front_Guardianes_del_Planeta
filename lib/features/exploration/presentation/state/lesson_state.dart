import '../../domain/entities/lesson.dart';
import '../../domain/models/lesson_node_model.dart';

enum LessonStatus {
  initial,
  loading,
  success,
  empty,
  error,
}

class LessonState {
  final LessonStatus status;
  final List<Lesson> lessons;
  final List<LessonNodeModel> nodes;
  final String? errorMessage;
  final int? currentEcosystemId;

  const LessonState({
    this.status = LessonStatus.initial,
    this.lessons = const [],
    this.nodes = const [],
    this.errorMessage,
    this.currentEcosystemId,
  });

  bool get isInitial => status == LessonStatus.initial;
  bool get isLoading => status == LessonStatus.loading;
  bool get isSuccess => status == LessonStatus.success;
  bool get isEmpty => status == LessonStatus.empty;
  bool get isError => status == LessonStatus.error;

  LessonState copyWith({
    LessonStatus? status,
    List<Lesson>? lessons,
    List<LessonNodeModel>? nodes,
    String? errorMessage,
    int? currentEcosystemId,
  }) {
    return LessonState(
      status: status ?? this.status,
      lessons: lessons ?? this.lessons,
      nodes: nodes ?? this.nodes,
      errorMessage: errorMessage ?? this.errorMessage,
      currentEcosystemId: currentEcosystemId ?? this.currentEcosystemId,
    );
  }
}
