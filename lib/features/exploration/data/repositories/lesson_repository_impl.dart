import '../../domain/entities/lesson.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../datasources/lesson_remote_data_source.dart';
import '../mappers/lesson_mapper.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonRemoteDataSource _remoteDataSource;

  LessonRepositoryImpl({required LessonRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Lesson>> getLessonsByEcosystem(int ecosystemId) async {
    final dtos = await _remoteDataSource.getLessonsByEcosystem(ecosystemId);
    return LessonMapper.toDomainList(dtos);
  }

  @override
  Future<void> completeLesson(int lessonId) {
    return _remoteDataSource.completeLesson(lessonId);
  }

  @override
  Future<List<int>> getCompletedLessonIds() {
    return _remoteDataSource.getCompletedLessonIds();
  }
}
