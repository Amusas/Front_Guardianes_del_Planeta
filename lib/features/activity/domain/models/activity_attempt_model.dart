class ActivityAttemptResponseModel {
  final bool isCorrect;
  final int attemptNumber;
  final int xpAwarded;
  final int totalXp;
  final int? currentLevel;
  final bool levelUp;
  final int? previousLevel;
  final bool activityCompleted;
  final bool lessonCompleted;
  final bool ecosystemCompleted;
  final int streakCount;
  final List<String> xpEvents;
  final List<dynamic> unlockedAchievements;

  const ActivityAttemptResponseModel({
    required this.isCorrect,
    required this.attemptNumber,
    required this.xpAwarded,
    required this.totalXp,
    this.currentLevel,
    required this.levelUp,
    this.previousLevel,
    required this.activityCompleted,
    required this.lessonCompleted,
    required this.ecosystemCompleted,
    required this.streakCount,
    this.xpEvents = const [],
    this.unlockedAchievements = const [],
  });

  factory ActivityAttemptResponseModel.fromJson(Map<String, dynamic> json) {
    return ActivityAttemptResponseModel(
      isCorrect: json['isCorrect'] == true,
      attemptNumber: (json['attemptNumber'] is num) ? (json['attemptNumber'] as num).toInt() : 1,
      xpAwarded: (json['xpAwarded'] is num) ? (json['xpAwarded'] as num).toInt() : 0,
      totalXp: (json['totalXp'] is num) ? (json['totalXp'] as num).toInt() : 0,
      currentLevel: (json['currentLevel'] is num) ? (json['currentLevel'] as num).toInt() : null,
      levelUp: json['levelUp'] == true,
      previousLevel: (json['previousLevel'] is num) ? (json['previousLevel'] as num).toInt() : null,
      activityCompleted: json['activityCompleted'] == true,
      lessonCompleted: json['lessonCompleted'] == true,
      ecosystemCompleted: json['ecosystemCompleted'] == true,
      streakCount: (json['streakCount'] is num) ? (json['streakCount'] as num).toInt() : 0,
      xpEvents: (json['xpEvents'] is List)
          ? (json['xpEvents'] as List).map((e) => e.toString()).toList()
          : const [],
      unlockedAchievements: (json['unlockedAchievements'] is List)
          ? json['unlockedAchievements'] as List
          : const [],
    );
  }

  factory ActivityAttemptResponseModel.fromLocalEvaluation({
    required bool isCorrect,
    required int xpReward,
    int attemptNumber = 1,
  }) {
    return ActivityAttemptResponseModel(
      isCorrect: isCorrect,
      attemptNumber: attemptNumber,
      xpAwarded: isCorrect ? xpReward : 0,
      totalXp: isCorrect ? xpReward : 0,
      currentLevel: 1,
      levelUp: false,
      previousLevel: 1,
      activityCompleted: isCorrect,
      lessonCompleted: false,
      ecosystemCompleted: false,
      streakCount: 1,
      xpEvents: isCorrect ? ['Respuesta correcta: +$xpReward XP'] : const [],
      unlockedAchievements: const [],
    );
  }
}
