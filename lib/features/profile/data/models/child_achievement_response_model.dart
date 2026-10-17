import '../../domain/entities/child_achievement_entity.dart';

class ChildAchievementResponseModel {
  final int id;
  final String code;
  final String title;
  final String description;
  final String conditionType;
  final int conditionValue;
  final String visualKey;
  final bool isActive;
  final DateTime? unlockedAt;

  const ChildAchievementResponseModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.conditionType,
    required this.conditionValue,
    required this.visualKey,
    this.isActive = true,
    this.unlockedAt,
  });

  factory ChildAchievementResponseModel.fromJson(Map<String, dynamic> json) {
    return ChildAchievementResponseModel(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      conditionType: json['conditionType'] as String? ?? '',
      conditionValue: (json['conditionValue'] as num?)?.toInt() ?? 0,
      visualKey: json['visualKey'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      unlockedAt: json['unlockedAt'] != null ? DateTime.tryParse(json['unlockedAt'].toString()) : null,
    );
  }

  ChildAchievementEntity toEntity({bool isUnlocked = false}) {
    return ChildAchievementEntity(
      id: id,
      code: code,
      title: title,
      description: description,
      conditionType: conditionType,
      conditionValue: conditionValue,
      visualKey: visualKey,
      isActive: isActive,
      isUnlocked: isUnlocked,
      unlockedAt: unlockedAt,
    );
  }
}
