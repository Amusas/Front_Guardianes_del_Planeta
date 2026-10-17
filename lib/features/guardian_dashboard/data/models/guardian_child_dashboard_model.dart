class ChildAchievementSummaryModel {
  final int id;
  final String title;
  final String description;
  final String? badgeKey;
  final DateTime? unlockedAt;

  const ChildAchievementSummaryModel({
    required this.id,
    required this.title,
    required this.description,
    this.badgeKey,
    this.unlockedAt,
  });

  factory ChildAchievementSummaryModel.fromJson(Map<String, dynamic> json) {
    return ChildAchievementSummaryModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? 'Logro',
      description: json['description'] as String? ?? '',
      badgeKey: json['badgeKey'] as String?,
      unlockedAt: json['unlockedAt'] != null ? DateTime.tryParse(json['unlockedAt'].toString()) : null,
    );
  }
}

class EcosystemProgressModel {
  final int ecosystemId;
  final String code;
  final String name;
  final int completedLessons;
  final int totalLessons;
  final double progressPercentage;

  const EcosystemProgressModel({
    required this.ecosystemId,
    required this.code,
    required this.name,
    required this.completedLessons,
    required this.totalLessons,
    required this.progressPercentage,
  });

  factory EcosystemProgressModel.fromJson(Map<String, dynamic> json) {
    return EcosystemProgressModel(
      ecosystemId: (json['ecosystemId'] as num).toInt(),
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      completedLessons: (json['completedLessons'] as num?)?.toInt() ?? 0,
      totalLessons: (json['totalLessons'] as num?)?.toInt() ?? 0,
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class XpHistoryItemModel {
  final int id;
  final int amount;
  final String type;
  final String description;
  final DateTime? createdAt;

  const XpHistoryItemModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    this.createdAt,
  });

  factory XpHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return XpHistoryItemModel(
      id: (json['id'] as num).toInt(),
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? 'ACTIVITY',
      description: json['description'] as String? ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
    );
  }
}

class RecentActivityModel {
  final String title;
  final String description;
  final String type;
  final int xpAwarded;
  final DateTime? timestamp;
  final bool isSuccess;

  const RecentActivityModel({
    required this.title,
    required this.description,
    required this.type,
    required this.xpAwarded,
    this.timestamp,
    required this.isSuccess,
  });

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      title: json['title'] as String? ?? 'Actividad',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? 'ACTIVITY',
      xpAwarded: (json['xpAwarded'] as num?)?.toInt() ?? 0,
      timestamp: json['timestamp'] != null ? DateTime.tryParse(json['timestamp'].toString()) : null,
      isSuccess: json['isSuccess'] as bool? ?? true,
    );
  }
}

class GuardianChildDashboardModel {
  final int childId;
  final String name;
  final String username;
  final DateTime? dateOfBirth;
  final int? age;
  final int totalXp;
  final int levelNumber;
  final String levelName;
  final int currentLevelRequiredXp;
  final int? nextLevelRequiredXp;
  final String? nextLevelName;
  final double levelProgressPercentage;
  final int completedLessonsCount;
  final int totalLessonsCount;
  final int totalAttemptsCount;
  final int correctAttemptsCount;
  final double accuracyPercentage;
  final int currentStreak;
  final int unlockedAchievementsCount;
  final int totalAchievementsCount;
  final List<ChildAchievementSummaryModel> achievements;
  final List<EcosystemProgressModel> ecosystemProgress;
  final List<XpHistoryItemModel> xpHistory;
  final List<RecentActivityModel> recentActivities;

  const GuardianChildDashboardModel({
    required this.childId,
    required this.name,
    required this.username,
    this.dateOfBirth,
    this.age,
    required this.totalXp,
    required this.levelNumber,
    required this.levelName,
    required this.currentLevelRequiredXp,
    this.nextLevelRequiredXp,
    this.nextLevelName,
    required this.levelProgressPercentage,
    required this.completedLessonsCount,
    required this.totalLessonsCount,
    required this.totalAttemptsCount,
    required this.correctAttemptsCount,
    required this.accuracyPercentage,
    required this.currentStreak,
    required this.unlockedAchievementsCount,
    required this.totalAchievementsCount,
    required this.achievements,
    required this.ecosystemProgress,
    required this.xpHistory,
    required this.recentActivities,
  });

  factory GuardianChildDashboardModel.fromJson(Map<String, dynamic> json) {
    return GuardianChildDashboardModel(
      childId: (json['childId'] as num).toInt(),
      name: json['name'] as String? ?? 'Explorador',
      username: json['username'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.tryParse(json['dateOfBirth'].toString()) : null,
      age: (json['age'] as num?)?.toInt(),
      totalXp: (json['totalXp'] as num?)?.toInt() ?? 0,
      levelNumber: (json['levelNumber'] as num?)?.toInt() ?? 1,
      levelName: json['levelName'] as String? ?? 'Semilla Guardiana',
      currentLevelRequiredXp: (json['currentLevelRequiredXp'] as num?)?.toInt() ?? 0,
      nextLevelRequiredXp: (json['nextLevelRequiredXp'] as num?)?.toInt(),
      nextLevelName: json['nextLevelName'] as String?,
      levelProgressPercentage: (json['levelProgressPercentage'] as num?)?.toDouble() ?? 0.0,
      completedLessonsCount: (json['completedLessonsCount'] as num?)?.toInt() ?? 0,
      totalLessonsCount: (json['totalLessonsCount'] as num?)?.toInt() ?? 0,
      totalAttemptsCount: (json['totalAttemptsCount'] as num?)?.toInt() ?? 0,
      correctAttemptsCount: (json['correctAttemptsCount'] as num?)?.toInt() ?? 0,
      accuracyPercentage: (json['accuracyPercentage'] as num?)?.toDouble() ?? 0.0,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      unlockedAchievementsCount: (json['unlockedAchievementsCount'] as num?)?.toInt() ?? 0,
      totalAchievementsCount: (json['totalAchievementsCount'] as num?)?.toInt() ?? 0,
      achievements: (json['achievements'] as List?)
              ?.map((e) => ChildAchievementSummaryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      ecosystemProgress: (json['ecosystemProgress'] as List?)
              ?.map((e) => EcosystemProgressModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      xpHistory: (json['xpHistory'] as List?)
              ?.map((e) => XpHistoryItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      recentActivities: (json['recentActivities'] as List?)
              ?.map((e) => RecentActivityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
