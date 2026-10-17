class ChildAchievementEntity {
  final int id;
  final String code;
  final String title;
  final String description;
  final String conditionType;
  final int conditionValue;
  final String visualKey;
  final bool isActive;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const ChildAchievementEntity({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.conditionType,
    required this.conditionValue,
    required this.visualKey,
    this.isActive = true,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  ChildAchievementEntity copyWith({
    int? id,
    String? code,
    String? title,
    String? description,
    String? conditionType,
    int? conditionValue,
    String? visualKey,
    bool? isActive,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return ChildAchievementEntity(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      description: description ?? this.description,
      conditionType: conditionType ?? this.conditionType,
      conditionValue: conditionValue ?? this.conditionValue,
      visualKey: visualKey ?? this.visualKey,
      isActive: isActive ?? this.isActive,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}
