import 'package:flutter/foundation.dart';
import '../../domain/models/activity_model.dart';
import '../../domain/models/activity_attempt_model.dart';
import '../../domain/usecases/get_activities_by_lesson_use_case.dart';
import '../../domain/usecases/submit_activity_attempt_use_case.dart';

enum ActivityStatus { initial, loading, loaded, error, completed }

class ActivityController extends ChangeNotifier {
  final GetActivitiesByLessonUseCase _getActivitiesByLessonUseCase;
  final SubmitActivityAttemptUseCase? _submitActivityAttemptUseCase;

  ActivityController({
    required GetActivitiesByLessonUseCase getActivitiesByLessonUseCase,
    SubmitActivityAttemptUseCase? submitActivityAttemptUseCase,
  })  : _getActivitiesByLessonUseCase = getActivitiesByLessonUseCase,
        _submitActivityAttemptUseCase = submitActivityAttemptUseCase;

  ActivityStatus _status = ActivityStatus.initial;
  List<ActivityModel> _activities = [];
  int _currentIndex = 0;
  dynamic _currentAnswer;
  bool _isAnswerChecked = false;
  bool? _isAnswerCorrect;
  bool _isSubmitting = false;
  int _totalXpEarned = 0;
  int _completedActivitiesCount = 0;
  int _skippedActivitiesCount = 0;
  String? _errorMessage;
  ActivityAttemptResponseModel? _lastAttemptResult;

  // Getters
  ActivityStatus get status => _status;
  List<ActivityModel> get activities => _activities;
  int get currentIndex => _currentIndex;
  dynamic get currentAnswer => _currentAnswer;
  bool get isAnswerChecked => _isAnswerChecked;
  bool? get isAnswerCorrect => _isAnswerCorrect;
  bool get isSubmitting => _isSubmitting;
  int get totalXpEarned => _totalXpEarned;
  int get completedActivitiesCount => _completedActivitiesCount;
  int get skippedActivitiesCount => _skippedActivitiesCount;
  String? get errorMessage => _errorMessage;
  ActivityAttemptResponseModel? get lastAttemptResult => _lastAttemptResult;

  int get totalActivities => _activities.length;

  ActivityModel? get currentActivity {
    if (_activities.isNotEmpty && _currentIndex >= 0 && _currentIndex < _activities.length) {
      return _activities[_currentIndex];
    }
    return null;
  }

  bool get isLastActivity => _activities.isNotEmpty && _currentIndex == _activities.length - 1;

  double get progressRatio {
    if (_activities.isEmpty) return 0.0;
    return (_currentIndex + 1) / _activities.length;
  }

  bool get canCheck {
    if (_isSubmitting) return false;
    if (_isAnswerChecked && _isAnswerCorrect == true) return false;
    if (_currentAnswer == null) return false;
    if (_currentAnswer is String && (_currentAnswer as String).trim().isEmpty) return false;
    if (_currentAnswer is Map && (_currentAnswer as Map).isEmpty) return false;
    if (_currentAnswer is List && (_currentAnswer as List).isEmpty) return false;
    return true;
  }

  Future<void> loadActivities(int lessonId) async {
    _status = ActivityStatus.loading;
    _errorMessage = null;
    _currentIndex = 0;
    _currentAnswer = null;
    _isAnswerChecked = false;
    _isAnswerCorrect = null;
    _isSubmitting = false;
    _totalXpEarned = 0;
    _completedActivitiesCount = 0;
    _skippedActivitiesCount = 0;
    _lastAttemptResult = null;
    notifyListeners();

    try {
      final result = await _getActivitiesByLessonUseCase(lessonId);
      _activities = result;
      _status = _activities.isNotEmpty ? ActivityStatus.loaded : ActivityStatus.error;
      if (_activities.isEmpty) {
        _errorMessage = 'No se encontraron actividades disponibles para esta lección.';
      }
    } catch (e) {
      _status = ActivityStatus.error;
      _errorMessage = 'Ocurrió un error al cargar las actividades: ${e.toString()}';
    }
    notifyListeners();
  }

  void setAnswer(dynamic answer) {
    if (_isSubmitting) return;
    if (_isAnswerChecked && _isAnswerCorrect == true) return;
    _currentAnswer = answer;
    _isAnswerChecked = false;
    _isAnswerCorrect = null;
    notifyListeners();
  }

  Future<bool> checkAnswer() async {
    final activity = currentActivity;
    if (activity == null || _currentAnswer == null || _isSubmitting) return false;

    _isSubmitting = true;
    notifyListeners();

    bool isCorrect = false;
    int xpWon = activity.xpReward;

    try {
      final submitUseCase = _submitActivityAttemptUseCase;
      if (submitUseCase != null) {
        final payload = activity.buildBackendAttemptPayload(_currentAnswer);
        final attemptResponse = await submitUseCase(activity.id, payload);
        _lastAttemptResult = attemptResponse;
        isCorrect = attemptResponse.isCorrect;
        xpWon = attemptResponse.xpAwarded > 0 ? attemptResponse.xpAwarded : activity.xpReward;
      } else {
        isCorrect = activity.evaluateAnswer(_currentAnswer);
      }
    } catch (e) {
      debugPrint('Error enviando intento de actividad al backend: $e. Evaluando con motor local.');
      isCorrect = activity.evaluateAnswer(_currentAnswer);
      _lastAttemptResult = ActivityAttemptResponseModel.fromLocalEvaluation(
        isCorrect: isCorrect,
        xpReward: activity.xpReward,
      );
    } finally {
      _isSubmitting = false;
    }

    _isAnswerChecked = true;
    _isAnswerCorrect = isCorrect;

    if (isCorrect) {
      _totalXpEarned += xpWon;
      _completedActivitiesCount++;
    }

    notifyListeners();
    return isCorrect;
  }

  void retryCurrentActivity() {
    _currentAnswer = null;
    _isAnswerChecked = false;
    _isAnswerCorrect = null;
    _lastAttemptResult = null;
    notifyListeners();
  }

  void nextActivity() {
    if (isLastActivity) {
      _status = ActivityStatus.completed;
    } else {
      _currentIndex++;
      _currentAnswer = null;
      _isAnswerChecked = false;
      _isAnswerCorrect = null;
      _lastAttemptResult = null;
    }
    notifyListeners();
  }

  /// Saltear la actividad actual y avanzar inmediatamente
  void skipActivity() {
    _skippedActivitiesCount++;
    if (isLastActivity) {
      _status = ActivityStatus.completed;
    } else {
      _currentIndex++;
      _currentAnswer = null;
      _isAnswerChecked = false;
      _isAnswerCorrect = null;
      _lastAttemptResult = null;
    }
    notifyListeners();
  }

  void reset() {
    _status = ActivityStatus.initial;
    _activities = [];
    _currentIndex = 0;
    _currentAnswer = null;
    _isAnswerChecked = false;
    _isAnswerCorrect = null;
    _isSubmitting = false;
    _totalXpEarned = 0;
    _completedActivitiesCount = 0;
    _skippedActivitiesCount = 0;
    _errorMessage = null;
    _lastAttemptResult = null;
    notifyListeners();
  }
}
