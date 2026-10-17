import 'package:flutter/foundation.dart';
import '../../../../core/logging/app_logger.dart';
import '../../data/mappers/lesson_mapper.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/usecases/complete_lesson_use_case.dart';
import '../../domain/usecases/get_child_completed_lessons_use_case.dart';
import '../../domain/usecases/get_lessons_by_ecosystem_use_case.dart';
import '../state/lesson_state.dart';

class LessonController extends ChangeNotifier {
  final GetLessonsByEcosystemUseCase _getLessonsByEcosystemUseCase;
  final CompleteLessonUseCase? _completeLessonUseCase;
  final GetChildCompletedLessonsUseCase? _getChildCompletedLessonsUseCase;

  LessonState _state = const LessonState();
  LessonState get state => _state;

  final Set<int> _completedLessonIds = {};
  Set<int> get completedLessonIds => Set.unmodifiable(_completedLessonIds);

  final Map<int, List<Lesson>> _lessonsByEcosystem = {};
  Map<int, List<Lesson>> get lessonsByEcosystem => Map.unmodifiable(_lessonsByEcosystem);

  final Set<int> _loadingEcosystemIds = {};
  bool _isLoadingProgress = false;
  bool get isLoadingProgress => _isLoadingProgress;

  LessonController({
    required GetLessonsByEcosystemUseCase getLessonsByEcosystemUseCase,
    CompleteLessonUseCase? completeLessonUseCase,
    GetChildCompletedLessonsUseCase? getChildCompletedLessonsUseCase,
  })  : _getLessonsByEcosystemUseCase = getLessonsByEcosystemUseCase,
        _completeLessonUseCase = completeLessonUseCase,
        _getChildCompletedLessonsUseCase = getChildCompletedLessonsUseCase;

  Future<void> loadLessons(
    int ecosystemId, {
    bool forceRefresh = false,
    int completedCount = 0,
    Set<int>? completedLessonIds,
  }) async {
    if (completedLessonIds != null) {
      _completedLessonIds.addAll(completedLessonIds);
    }

    // Evitar recargas duplicadas si ya tenemos datos para este ecosistema
    if (!forceRefresh &&
        _state.currentEcosystemId == ecosystemId &&
        (_state.isSuccess || _state.isLoading)) {
      return;
    }

    _state = _state.copyWith(
      status: LessonStatus.loading,
      errorMessage: null,
      currentEcosystemId: ecosystemId,
    );
    notifyListeners();

    try {
      AppLogger.info('INFO: Cargando lecciones para la ruta del ecosistema $ecosystemId.');
      final lessons = await _getLessonsByEcosystemUseCase(ecosystemId);
      _lessonsByEcosystem[ecosystemId] = lessons;

      if (lessons.isEmpty) {
        AppLogger.warning('WARNING: No se encontraron lecciones para el ecosistema $ecosystemId.');
        _state = _state.copyWith(
          status: LessonStatus.empty,
          lessons: [],
          nodes: [],
        );
      } else {
        final nodes = LessonMapper.toNodeList(
          lessons,
          completedCount: completedCount,
          completedLessonIds: _completedLessonIds,
        );
        AppLogger.info('INFO: Se cargaron exitosamente ${lessons.length} lecciones (nodos) de la ruta.');
        _state = _state.copyWith(
          status: LessonStatus.success,
          lessons: lessons,
          nodes: nodes,
        );
      }
    } catch (e) {
      final message = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : 'Error al conectar con la ruta de exploración.';
      AppLogger.error('ERROR: Falló la carga de lecciones para el ecosistema $ecosystemId.', e);
      _state = _state.copyWith(
        status: LessonStatus.error,
        errorMessage: message,
      );
    } finally {
      notifyListeners();
    }
  }

  /// Precarga lecciones de un ecosistema para calcular porcentajes sin bloquear navegación.
  Future<void> preloadLessonsForEcosystem(int ecosystemId) async {
    if (_lessonsByEcosystem.containsKey(ecosystemId) || _loadingEcosystemIds.contains(ecosystemId)) {
      return;
    }
    _loadingEcosystemIds.add(ecosystemId);
    try {
      final lessons = await _getLessonsByEcosystemUseCase(ecosystemId);
      _lessonsByEcosystem[ecosystemId] = lessons;
      notifyListeners();
    } catch (e) {
      AppLogger.warning('WARNING: No se pudieron precargar lecciones para el ecosistema $ecosystemId.');
    } finally {
      _loadingEcosystemIds.remove(ecosystemId);
    }
  }

  /// Calcula el porcentaje de avance (0.0 a 1.0) para un ecosistema según sus lecciones terminadas.
  double getProgressForEcosystem(int ecosystemId) {
    final lessons = _lessonsByEcosystem[ecosystemId] ??
        (_state.currentEcosystemId == ecosystemId && _state.lessons.isNotEmpty
            ? _state.lessons
            : null);

    if (lessons == null || lessons.isEmpty) {
      return 0.0;
    }

    final total = lessons.length;
    final completed = lessons.where((l) => _completedLessonIds.contains(l.id)).length;
    return total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0;
  }

  /// Carga las lecciones completadas desde el backend para restaurar el progreso persistido.
  Future<void> loadUserProgress({bool forceRefresh = false}) async {
    if (_getChildCompletedLessonsUseCase == null) return;
    if (_isLoadingProgress && !forceRefresh) return;

    _isLoadingProgress = true;
    try {
      AppLogger.info('INFO: Cargando progreso de lecciones del usuario.');
      final completedIds = await _getChildCompletedLessonsUseCase!();
      _completedLessonIds.addAll(completedIds);
      AppLogger.info('INFO: Progreso cargado exitosamente. Lecciones completadas: ${_completedLessonIds.length}');

      // Si ya hay lecciones cargadas en la ruta activa, refrescar sus nodos
      if (_state.lessons.isNotEmpty) {
        final nodes = LessonMapper.toNodeList(
          _state.lessons,
          completedLessonIds: _completedLessonIds,
        );
        _state = _state.copyWith(nodes: nodes);
      }
    } catch (e) {
      AppLogger.error('ERROR: No se pudo cargar el progreso del usuario.', e);
    } finally {
      _isLoadingProgress = false;
      notifyListeners();
    }
  }

  /// Registra una lección como completada, recalculando nodos y desbloqueando el siguiente.
  /// Además persiste la completitud en el backend de forma asíncrona.
  Future<void> completeLesson(int lessonId) async {
    _completedLessonIds.add(lessonId);
    if (_state.lessons.isNotEmpty) {
      final nodes = LessonMapper.toNodeList(
        _state.lessons,
        completedLessonIds: _completedLessonIds,
      );
      _state = _state.copyWith(nodes: nodes);
    }
    notifyListeners();

    if (_completeLessonUseCase != null) {
      try {
        AppLogger.info('INFO: Persistiendo completitud de lección $lessonId en el servidor.');
        await _completeLessonUseCase!(lessonId);
        AppLogger.info('INFO: Lección $lessonId persistida con éxito en el servidor.');
      } catch (e) {
        AppLogger.error('ERROR: Falló el guardado remoto de la lección $lessonId.', e);
      }
    }
  }

  void reset() {
    _state = const LessonState();
    _completedLessonIds.clear();
    _lessonsByEcosystem.clear();
    _loadingEcosystemIds.clear();
    _isLoadingProgress = false;
    notifyListeners();
  }
}
