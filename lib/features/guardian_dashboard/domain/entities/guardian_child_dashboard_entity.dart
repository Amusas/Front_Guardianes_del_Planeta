class ChildAchievementSummary {
  final int id;
  final String title;
  final String description;
  final String? badgeKey;
  final DateTime? unlockedAt;

  const ChildAchievementSummary({
    required this.id,
    required this.title,
    required this.description,
    this.badgeKey,
    this.unlockedAt,
  });
}

class EcosystemProgress {
  final int ecosystemId;
  final String code;
  final String name;
  final int completedLessons;
  final int totalLessons;
  final double progressPercentage;

  const EcosystemProgress({
    required this.ecosystemId,
    required this.code,
    required this.name,
    required this.completedLessons,
    required this.totalLessons,
    required this.progressPercentage,
  });
}

class XpHistoryItem {
  final int id;
  final int amount;
  final String type;
  final String description;
  final DateTime? createdAt;

  const XpHistoryItem({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    this.createdAt,
  });
}

class RecentActivity {
  final String title;
  final String description;
  final String type;
  final int xpAwarded;
  final DateTime? timestamp;
  final bool isSuccess;

  const RecentActivity({
    required this.title,
    required this.description,
    required this.type,
    required this.xpAwarded,
    this.timestamp,
    required this.isSuccess,
  });
}

class GuardianChildDashboardEntity {
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
  final List<ChildAchievementSummary> achievements;
  final List<EcosystemProgress> ecosystemProgress;
  final List<XpHistoryItem> xpHistory;
  final List<RecentActivity> recentActivities;

  const GuardianChildDashboardEntity({
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
}
