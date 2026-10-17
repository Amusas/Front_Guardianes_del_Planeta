import '../models/child_profile_model.dart';
import '../models/guardian_child_dashboard_model.dart';
import '../../domain/entities/child_profile_entity.dart';
import '../../domain/entities/guardian_child_dashboard_entity.dart';

class GuardianDashboardMapper {
  GuardianDashboardMapper._();

  static ChildProfileEntity toChildProfileEntity(ChildProfileModel model) {
    return ChildProfileEntity(
      id: model.id,
      userId: model.userId,
      name: model.name,
      dateOfBirth: model.dateOfBirth,
      age: model.age,
      totalXp: model.totalXp,
      levelId: model.levelId,
      streakCount: model.streakCount,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static GuardianChildDashboardEntity toDashboardEntity(GuardianChildDashboardModel model) {
    return GuardianChildDashboardEntity(
      childId: model.childId,
      name: model.name,
      username: model.username,
      dateOfBirth: model.dateOfBirth,
      age: model.age,
      totalXp: model.totalXp,
      levelNumber: model.levelNumber,
      levelName: model.levelName,
      currentLevelRequiredXp: model.currentLevelRequiredXp,
      nextLevelRequiredXp: model.nextLevelRequiredXp,
      nextLevelName: model.nextLevelName,
      levelProgressPercentage: model.levelProgressPercentage,
      completedLessonsCount: model.completedLessonsCount,
      totalLessonsCount: model.totalLessonsCount,
      totalAttemptsCount: model.totalAttemptsCount,
      correctAttemptsCount: model.correctAttemptsCount,
      accuracyPercentage: model.accuracyPercentage,
      currentStreak: model.currentStreak,
      unlockedAchievementsCount: model.unlockedAchievementsCount,
      totalAchievementsCount: model.totalAchievementsCount,
      achievements: model.achievements
          .map((a) => ChildAchievementSummary(
                id: a.id,
                title: a.title,
                description: a.description,
                badgeKey: a.badgeKey,
                unlockedAt: a.unlockedAt,
              ))
          .toList(),
      ecosystemProgress: model.ecosystemProgress
          .map((e) => EcosystemProgress(
                ecosystemId: e.ecosystemId,
                code: e.code,
                name: e.name,
                completedLessons: e.completedLessons,
                totalLessons: e.totalLessons,
                progressPercentage: e.progressPercentage,
              ))
          .toList(),
      xpHistory: model.xpHistory
          .map((x) => XpHistoryItem(
                id: x.id,
                amount: x.amount,
                type: x.type,
                description: x.description,
                createdAt: x.createdAt,
              ))
          .toList(),
      recentActivities: model.recentActivities
          .map((r) => RecentActivity(
                title: r.title,
                description: r.description,
                type: r.type,
                xpAwarded: r.xpAwarded,
                timestamp: r.timestamp,
                isSuccess: r.isSuccess,
              ))
          .toList(),
    );
  }
}
